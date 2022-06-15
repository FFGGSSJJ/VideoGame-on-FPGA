transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/Synchronizers.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/Router.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/Reg_4.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/HexDriver.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/Control.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/compute.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/Register_unit.sv}
vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/Processor.sv}

vlog -sv -work work +incdir+C:/ECE385/lab4/lab4_logic_processor_8bit {C:/ECE385/lab4/lab4_logic_processor_8bit/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
