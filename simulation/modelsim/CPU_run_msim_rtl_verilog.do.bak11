transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/divisor.v}
vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/RCAdd.v}
vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/register.v}
vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/Bus.v}
vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/DataPath.v}
vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/multiplier.v}

vlog -vlog01compat -work work +incdir+C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374 {C:/Users/hersz/Desktop/CPU-Design-Project/ELEC374/multiplication_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  multiplication_tb

add wave *
view structure
view signals
run 5000 ns
