transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/CPU {C:/CPU/RCAdd.v}
vlog -vlog01compat -work work +incdir+C:/CPU {C:/CPU/register.v}
vlog -vlog01compat -work work +incdir+C:/CPU {C:/CPU/Bus.v}
vlog -vlog01compat -work work +incdir+C:/CPU {C:/CPU/DataPath.v}

vlog -vlog01compat -work work +incdir+C:/CPU {C:/CPU/tutorial_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tutorial_tb

add wave *
view structure
view signals
run 500 ns
