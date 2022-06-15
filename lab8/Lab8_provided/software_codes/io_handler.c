//io_handler.c
#include "io_handler.h"
#include <stdio.h>

void IO_init(void)
{
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}


/*****************************************************************************/
/**
 *
 * This function reads data from the memory
 *
 * @param    Address is the address/data of the register HPI_ADDR/HPI_DATA.
 * @param	 Data is the address/data to be written into register HPI_ADDR/HPI_DATA.
 * @return   None
 *
 * @note     None
 *
 ******************************************************************************/
void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	*otg_hpi_address = Address;
	*otg_hpi_data = Data;
	*otg_hpi_cs = 0;
	*otg_hpi_w = 0;

	// reset
	*otg_hpi_cs = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
}



/*****************************************************************************/
/**
 *
 * This function reads data from the memory
 *
 * @param    Address is the address of the register HPI_DATA.
 * 
 * @return   The data read from the specified address
 *
 * @note     None
 *
 ******************************************************************************/
alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	//printf("%x\n",temp);
	*otg_hpi_address = Address;
	*otg_hpi_cs = 0;
	*otg_hpi_r = 0;
	temp = *otg_hpi_data;

	// reset
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_address = 0;

	return temp;
}
