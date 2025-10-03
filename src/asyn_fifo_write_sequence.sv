class asyn_fifo_base_write_sequence extends uvm_sequence #(asyn_fifo_write_sequence_item);

	`uvm_object_utils(asyn_fifo_base_write_sequence)

	function new(string name = "asyn_fifo_base_write_sequence");
		super.new(name);
	endfunction

	virtual task body();
		req = asyn_fifo_write_sequence_item::type_id::create("req");
		wait_for_grant();
		req.randomize();
		send_request(req);
		wait_for_item_done();
	endtask
endclass
//-------------------------------------------------------------------------------------------------------------------
// Write Reset Sequence
//-------------------------------------------------------------------------------------------------------------------
class write_reset_sequence extends uvm_sequence #(asyn_fifo_write_sequence_item); 
		`uvm_object_utils(write_reset_sequence)

		function new(string name = "write_reset_sequence");
			super.new(name);
		endfunction

		virtual task body();
			`uvm_do_with(req,{req.wrst_n == 0;});
		endtask
endclass
