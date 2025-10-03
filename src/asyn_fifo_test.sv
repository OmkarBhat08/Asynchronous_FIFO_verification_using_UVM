class asyn_fifo_base_test extends uvm_test;
	
	asyn_fifo_env env;	
	`uvm_component_utils(asyn_fifo_base_test)

	function new(string name = "asyn_fifo_base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = asyn_fifo_env::type_id::create("env", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_base_virtual_sequence virtual_base_seq;
		super.run_phase(phase);

		phase.raise_objection(this, "Objection Raised");
		virtual_base_seq = asyn_fifo_base_virtual_sequence::type_id::create("virtual_base_seq");	
		virtual_base_seq.start(env.vir_seqr);
		$display("############################################################################################################################");
		phase.drop_objection(this, "Objection Dropped");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass

//---------------------------------------------------------------------------------------------------------
/*
class reset_test extends asyn_fifo_base_test;
	`uvm_component_utils(reset_test)

	function new(string name = "reset_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		reset_sequence seq;
		super.run_phase(phase);
		phase.raise_objection(this, "Objection Raised");

		seq = reset_sequence::type_id::create("seq");	
		seq.start(env.active_agnt.seqr);
		$display("############################################################################################################################");
		phase.drop_objection(this, "Objection Dropped");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass
*/
