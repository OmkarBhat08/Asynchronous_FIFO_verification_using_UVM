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
//-------------------------------------------------------------------------------------------------------------------
// Read Reset Sequence
//-------------------------------------------------------------------------------------------------------------------
class read_reset_sequence extends uvm_sequence #(asyn_fifo_read_sequence_item); 
		`uvm_object_utils(read_reset_sequence)

		function new(string name = "read_reset_sequence");
			super.new(name);
		endfunction

		virtual task body();
		`uvm_do_with(req,{req.rrst_n == 0;req.rinc == 1;});
		endtask
endclass
//-------------------------------------------------------------------------------------------------------------------
// Low rinc
//-------------------------------------------------------------------------------------------------------------------
class read_rinc0_sequence extends uvm_sequence #(asyn_fifo_read_sequence_item); 
		`uvm_object_utils(read_rinc0_sequence)

		function new(string name = "read_rinc0_sequence");
			super.new(name);
		endfunction

		virtual task body();
		`uvm_do_with(req,{req.rrst_n == 1;req.rinc == 0;});
		endtask
endclass
//-------------------------------------------------------------------------------------------------------------------
// Normal Working
//-------------------------------------------------------------------------------------------------------------------
class read_normal_sequence extends uvm_sequence #(asyn_fifo_read_sequence_item); 
		`uvm_object_utils(read_normal_sequence)

		function new(string name = "read_normal_sequence");
			super.new(name);
		endfunction

		virtual task body();
		`uvm_do_with(req,{req.rrst_n == 1;req.rinc == 1;});
		endtask
endclass
