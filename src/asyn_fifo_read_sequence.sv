/*
`include "uvm_macros.svh"
`include "asyn_fifo_sequence_item.sv"
import uvm_pkg ::*;
*/

class asyn_fifo_base_read_sequence extends uvm_sequence #(asyn_fifo_read_sequence_item);

	`uvm_object_utils(asyn_fifo_base_read_sequence)

	function new(string name = "asyn_fifo_base_read_sequence");
		super.new(name);
	endfunction

	virtual task body();
		req = asyn_fifo_read_sequence_item::type_id::create("req");
		wait_for_grant();
		req.randomize();
		send_request(req);
		wait_for_item_done();
	endtask
endclass
