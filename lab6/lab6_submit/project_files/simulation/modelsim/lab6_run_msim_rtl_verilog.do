transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/SEXT.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/reg_file.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/logic_nzp.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/HexDriver.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/tristate.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/test_memory.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/SLC3_2.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/register.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/mux.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/Mem2IO.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/ISDU.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/ALU.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/memory_contents.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/datapath.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/slc3.sv}
vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/lab6_toplevel.sv}

vlog -sv -work work +incdir+C:/ECE385/lab6 {C:/ECE385/lab6/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 280 us
