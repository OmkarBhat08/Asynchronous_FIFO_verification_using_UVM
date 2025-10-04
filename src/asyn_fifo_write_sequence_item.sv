`include "defines.sv"
`include "uvm_macros.svh"
import uvm_pkg ::*;

class asyn_fifo_write_sequence_item extends uvm_sequence_item;
	
	// Inputs
	rand logic [`DSIZE-1:0] wdata;
	rand logic winc;
	rand logic wrst_n;

	// Outputs
	logic wfull;

	`uvm_object_utils_begin(asyn_fifo_write_sequence_item)
		`uvm_field_int(wrst_n, UVM_BIN | UVM_ALL_ON)
		`uvm_field_int(wdata, UVM_DEC | UVM_ALL_ON)
		`uvm_field_int(winc, UVM_BIN | UVM_ALL_ON)
		`uvm_field_int(wfull, UVM_BIN | UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "asyn_fifo_write_sequence_item");
		super.new(name);
	endfunction
endclass
