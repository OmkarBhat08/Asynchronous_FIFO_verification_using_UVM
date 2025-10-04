QUESTA := /home/share/questa.csh
SHELL := /bin/csh

cover:
	source $(QUESTA)
	make clean
	vlog -sv +acc +cover +fcover -l apb_top.log top.sv
	vsim -vopt work.top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll coverage.ucdb; run -all; exit"
	vcover report -html coverage.ucdb -htmldir covReport -details

simulate: compile 
	vsim -c top +UVM_VERBOSITY=UVM_MEDIUM -do "run -all;exit"

compile:
	clear
	clear
	vlog top.sv +incdir+/tools/mentor/questasim_10.6c/questasim/uvm-1.1d/../verilog_src/uvm-1.1d/src

clean:
	rm -rf work/	 
	rm dump.vcd transcript
	clear
	clear
