/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/


#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"


// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}


unsigned int RotWord(unsigned int *word)
{
	unsigned int temp1 = (*word & 0xFF000000)>>24;
	unsigned int temp2 = (*word & 0x00FFFFFF)<<8;
	return temp1 | temp2;
}


/** SubWord
 * @param word is a int which is  4 bytes long. (4 char)
 * we need to convert it into u_char such that we can use S_box
 */
unsigned int SubWord(unsigned int word)
{
	unsigned char uc_word[4];	// I do not know if it will work
	unsigned char out[4];
	for (int i = 0; i < 4; i++) {
		uc_word[i] = (unsigned char)(word>>((3-i)*8) & 0x000000FF);
		out[i] = aes_sbox[(int)uc_word[i]];
	}
	return (unsigned int)(out[0]<<24 | out[1]<<16 | out[2]<<8 | out[3]);
}


/** KeyExpansion
 * @param key is a 4*4 #column-major matrix#. Total 16 bytes
 * @param w is a 4 * 11 * 4bytes unsigned int array. 11 = 1 + Nb
 * @param Nk is the number of 32-bit word (4 bytes) in key. Nk is 4
 */
void KeyExpansion(unsigned char* key, unsigned int* w, unsigned int Nk)
{
	for (unsigned int i = 0; i < Nk; i++) {
		w[i] = (unsigned int)(key[i]<<24) | (key[i+4]<<16) | (key[i+8]<<8) | (key[i+12]);
	}
	unsigned int i = Nk;
	while (i < 4*11) {
		unsigned int temp = w[i-1];
		if (i%Nk == 0)
			temp = SubWord(RotWord(&temp)) ^ Rcon[i/Nk];
		w[i] = w[i-Nk] ^ temp;
		i++;
	}
}

/** AddRoundKey
 *  @param state is a 4*4 column-major u_char matrix (length = 16)
 *  @param round_key is a 16 bytes unsigned int array (length = 4).
 */
void AddRoundKey(unsigned char *state, unsigned int *round_key)
{
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			state[4*i+j] = state[4*i+j] ^ ((round_key[j]>>((3-i)*8)) & 0xFF);
		}
	}
}

/** SubBytes
 *  @param state is a 4*4 column-major u_char matrix (length = 16)
 */
void SubBytes(unsigned char *state)
{
	for (int i = 0; i < 16; i++) {
		state[i] = aes_sbox[(int)state[i]];
	}
}

/** ShiftRows
 *  @param state is a 4*4 column-major u_char matrix (length = 16)
 */
void ShiftRows(unsigned char *state)
{
	for (int i = 1; i < 4; i++) {	// the row 0 does not need to be rotated
		unsigned char *row = &state[4*i];
		unsigned char temp;
		for (int j = 0; j < i; j++) {
			temp = row[0];
			row[0] = row[1];
			row[1] = row[2];
			row[2] = row[3];
			row[3] = temp;
		}
	}
}


/** xtimes
 *  @param a is a 1 bytes u_char 
 */
unsigned char xtimes(unsigned char a)
{
	return ((a & 0x80) == 0x80) ? ((a<<1)^0x1b):(a<<1);
}

/** MixColumns
 *  @param state is a 4*4 column-major u_char matrix (length = 16)
 */
void MixColumns(unsigned char *state)
{
	for (int i = 0; i < 4; i++) {
		unsigned char b[4];
		unsigned char a[4];
		for (int j = 0; j < 4; j++) 
			a[j] = state[i+4*j];
		b[0] = xtimes(a[0]) ^ (xtimes(a[1])^a[1]) ^ a[2] ^ a[3];
		b[1] = a[0] ^ xtimes(a[1]) ^ (xtimes(a[2])^a[2]) ^ a[3];
		b[2] = a[0] ^ a[1] ^ xtimes(a[2]) ^ (xtimes(a[3])^a[3]);
		b[3] = (xtimes(a[0])^a[0]) ^ a[1] ^ a[2] ^ xtimes(a[3]);
		for (int j = 0; j < 4; j++) 
			state[i+4*j] = b[j];
	}
}



/** encrypt
 *  Perform AES encryption in software.
 *
 *  @param msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *  @param   key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  @param  msg_enc - Pointer to 4x 32-bit int array (length = 4) that contains the encrypted message
 *  @param  key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
	unsigned char state[4*4];		// 4*4 column-major matrix (16 bytes)
	unsigned char Exp_Key[4*4];		// 4*4 column-major matrix (16 bytes)
	unsigned int w[4*11];			// 4 * 11 * 4bytes unsigned int array

	// First convert ascii msg and key into Hex and stored as column-major
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			state[i+4*j] = charsToHex(msg_ascii[(j+4*i)*2], msg_ascii[(j+4*i)*2+1]);
			Exp_Key[i+4*j] = charsToHex(key_ascii[(j+4*i)*2], key_ascii[(j+4*i)*2+1]);
		}
	}
	// generate w, the key schedule
	KeyExpansion(Exp_Key, w, 4);
	
	// loop
	AddRoundKey(state, w);
	for (int round = 1; round < 10; round++) {
		SubBytes(state);
		ShiftRows(state);
		MixColumns(state);
		AddRoundKey(state, w+4*round);
	}
	SubBytes(state);
	ShiftRows(state);
	AddRoundKey(state, w+40);

	// convert the column-major state and key into output array
	for (int i = 0; i < 4; i++) {	// the output is array with length 4
		msg_enc[i] = state[i]<<24 | state[i+4]<<16 | state[i+8]<<8 | state[i+12];
		key[i] = Exp_Key[i]<<24 | Exp_Key[i+4]<<16 | Exp_Key[i+8]<<8 | Exp_Key[i+12];
	}
	



}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
