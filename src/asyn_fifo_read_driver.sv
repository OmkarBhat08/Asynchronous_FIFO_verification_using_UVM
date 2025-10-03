/*
`include "uvm_macros.svh"
`include "asyn_fifo_sequence_item.sv"
import uvm_pkg ::*; 
*/

class asyn_fifo_read_driver extends uvm_driver #(asyn_fifo_read_sequence_item);

	asyn_fifo_read_sequence_item seq;
	virtual asyn_fifo_interfs vif;
	
	`uvm_component_utils(asyn_fifo_read_driver)

	function new(string name = "asyn_fifo_read_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual asyn_fifo_interfs)::get(this, "","vif",vif))
			`uvm_fatal(get_type_name(), "Not set at top");
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask

	virtual task drive();
		//repeat(1) @(posedge vif.read_driver_cb);
		$display("---------------------------Read Driver @ %0t---------------------------",$time);
		vif.rrst_n <= req.rrst_n;
		vif.rinc <= req.rinc;
		$display("rrst\t|\t%b",req.rrst_n);
		$display("rinc\t|\t%b",req.rinc);
		repeat(1) @(posedge vif.read_driver_cb);
	endtask
endclass
