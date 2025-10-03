/*
`include "uvm_macros.svh"
`include "asyn_fifo_sequence_item.sv"
import uvm_pkg ::*;
*/

class asyn_fifo_read_monitor extends uvm_monitor;

	virtual asyn_fifo_interfs vif;
	asyn_fifo_read_sequence_item read_monitor_sequence_item;
	uvm_analysis_port #(asyn_fifo_read_sequence_item) read_item_port;

	`uvm_component_utils(asyn_fifo_read_monitor)

	function new(string name = "asyn_fifo_read_monitor", uvm_component parent = null);
		super.new(name, parent);
		read_monitor_sequence_item = new();
		read_item_port = new("read_item_port", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual asyn_fifo_interfs)::get(this, "", "vif", vif))
			`uvm_fatal(get_type_name(), "Not set at top");
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
		begin
			repeat(1) @ (posedge vif.read_monitor_cb);
			$display("---------------------------Read Monitor @ %0t---------------------------",$time);
			read_monitor_sequence_item.rempty = vif.rempty;
			read_monitor_sequence_item.rdata = vif.rdata;
			read_monitor_sequence_item.rinc = vif.rinc;
			read_monitor_sequence_item.print();
			read_item_port.write(read_monitor_sequence_item);
			repeat(1) @ (posedge vif.read_monitor_cb);
		end
	endtask
endclass	
