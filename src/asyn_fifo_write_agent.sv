/*
`include "uvm_macros.svh"
`include "asyn_fifo_write_sequencer.sv"
`include "asyn_fifo_write_driver.sv"
`include "asyn_fifo_write_monitor.sv"
import uvm_pkg ::*;
*/

class asyn_fifo_write_agent extends uvm_agent;
	asyn_fifo_write_sequencer seqr;
	asyn_fifo_write_driver drv;
	asyn_fifo_write_monitor mon;

	`uvm_component_utils(asyn_fifo_write_agent)

	function new(string name = "asyn_fifo_write_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction	

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(get_is_active == UVM_ACTIVE)
		begin
			seqr = asyn_fifo_write_sequencer::type_id::create("seqr",this);
			drv = asyn_fifo_write_driver::type_id::create("drv",this);
		end
		mon = asyn_fifo_write_monitor::type_id::create("mon",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(get_is_active == UVM_ACTIVE)
			drv.seq_item_port.connect(seqr.seq_item_export);
	endfunction
endclass
