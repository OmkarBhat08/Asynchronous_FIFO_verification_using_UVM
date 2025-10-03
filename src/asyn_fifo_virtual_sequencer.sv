/*
`include "asyn_fifo_write_sequencer.sv"
`include "asyn_fifo_read_sequencer.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;
*/
	class asyn_fifo_virtual_sequencer extends uvm_sequencer;
	
	asyn_fifo_write_sequencer wr_seqr;
	asyn_fifo_read_sequencer rd_seqr;

	`uvm_component_utils(asyn_fifo_virtual_sequencer)

	function new(string name = "asyn_fifo_virtual_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass
