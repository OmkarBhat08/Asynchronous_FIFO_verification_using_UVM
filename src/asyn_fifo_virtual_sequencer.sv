/*
`include "asyn_fifo_write_sequencer.sv"
`include "asyn_fifo_read_sequencer.sv"
`include "uvm_macros.svh"
import uvm_pkg::*;
*/
	class asyn_fifo_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
	
	asyn_fifo_write_sequencer write_seqr;
	asyn_fifo_read_sequencer read_seqr;

	`uvm_component_utils(asyn_fifo_virtual_sequencer)

	function new(string name = "asyn_fifo_virtual_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass
