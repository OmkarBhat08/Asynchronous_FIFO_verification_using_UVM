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
//----------------------------------------------------------------------------------------------
class asyn_fifo_reset_test extends uvm_test;
	
	asyn_fifo_env env;	
	`uvm_component_utils(asyn_fifo_reset_test)

	function new(string name = "asyn_fifo_reset_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = asyn_fifo_env::type_id::create("env", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_reset_virtual_sequence virtual_reset_seq;
		super.run_phase(phase);

		phase.raise_objection(this, "Objection Raised");
		virtual_reset_seq = asyn_fifo_reset_virtual_sequence::type_id::create("virtual_reset_seq");	
		virtual_reset_seq.start(env.vir_seqr);
		$display("############################################################################################################################");
		phase.drop_objection(this, "Objection Dropped");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass
//----------------------------------------------------------------------------------------------
class asyn_fifo_inc0_test extends uvm_test;
	
	asyn_fifo_env env;	
	`uvm_component_utils(asyn_fifo_inc0_test)

	function new(string name = "asyn_fifo_inc0_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = asyn_fifo_env::type_id::create("env", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_inc0_virtual_sequence virtual_inc0_seq;
		super.run_phase(phase);

		phase.raise_objection(this, "Objection Raised");
		virtual_inc0_seq = asyn_fifo_inc0_virtual_sequence::type_id::create("virtual_inc0_seq");	
		virtual_inc0_seq.start(env.vir_seqr);
		$display("############################################################################################################################");
		phase.drop_objection(this, "Objection Dropped");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass
//----------------------------------------------------------------------------------------------
class asyn_fifo_normal_test extends uvm_test;
	
	asyn_fifo_env env;	
	`uvm_component_utils(asyn_fifo_normal_test)

	function new(string name = "asyn_fifo_normal_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = asyn_fifo_env::type_id::create("env", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_normal_virtual_sequence virtual_normal_seq;
		super.run_phase(phase);

		phase.raise_objection(this, "Objection Raised");
		virtual_normal_seq = asyn_fifo_normal_virtual_sequence::type_id::create("virtual_normal_seq");	
		virtual_normal_seq.start(env.vir_seqr);
		$display("############################################################################################################################");
		phase.drop_objection(this, "Objection Dropped");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass
//----------------------------------------------------------------------------------------------
class asyn_fifo_b2bw_test extends uvm_test;
	
	asyn_fifo_env env;	
	`uvm_component_utils(asyn_fifo_b2bw_test)

	function new(string name = "asyn_fifo_b2bw_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = asyn_fifo_env::type_id::create("env", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_b2bw_virtual_sequence virtual_b2bw_seq;
		super.run_phase(phase);

		phase.raise_objection(this, "Objection Raised");
		virtual_b2bw_seq = asyn_fifo_b2bw_virtual_sequence::type_id::create("virtual_b2bw_seq");	
		virtual_b2bw_seq.start(env.vir_seqr);
		$display("############################################################################################################################");
		phase.drop_objection(this, "Objection Dropped");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass
//----------------------------------------------------------------------------------------------
class asyn_fifo_full_test extends uvm_test;
	
	asyn_fifo_env env;	
	`uvm_component_utils(asyn_fifo_full_test)

	function new(string name = "asyn_fifo_full_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = asyn_fifo_env::type_id::create("env", this);
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_full_virtual_sequence virtual_full_seq;
		super.run_phase(phase);

		phase.raise_objection(this, "Objection Raised");
		virtual_full_seq = asyn_fifo_full_virtual_sequence::type_id::create("virtual_full_seq");	
		virtual_full_seq.start(env.vir_seqr);
		$display("############################################################################################################################");
		phase.drop_objection(this, "Objection Dropped");
	endtask

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass
