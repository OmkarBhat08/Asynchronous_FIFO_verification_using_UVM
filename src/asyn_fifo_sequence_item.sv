`include "defines.sv"
`include "uvm_macros.svh"
import uvm_pkg ::*;

class asyn_fifo_sequence_item extends uvm_sequence_item;
	
	// Inputs
	logic [`DSIZE-1:0] wdata;
	logic winc, wrst_n;
	logic rinc, rrst_n;

	// Outputs
	logic [`DSIZE-1:0] rdata;
	logic wfull, rempty;

	`uvm_object_utils_begin(asyn_fifo_sequence_item)
		`uvm_field_int(wrst_n, UVM_BIN | UVM_ALL_ON)
		`uvm_field_int(wdata, UVM_DEC | UVM_ALL_ON)
		`uvm_field_int(winc, UVM_BIN | UVM_ALL_ON)
		`uvm_field_int(rrst_n, UVM_BIN | UVM_ALL_ON)
		`uvm_field_int(rdata, UVM_DEC | UVM_ALL_ON)
		`uvm_field_int(rinc, UVM_BIN | UVM_ALL_ON)
		`uvm_field_int(wfull, UVM_BIN | UVM_ALL_ON)
		`uvm_field_int(rempty, UVM_DEC | UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "asyn_fifo_sequence_item");
		super.new(name);
	endfunction
endclass
