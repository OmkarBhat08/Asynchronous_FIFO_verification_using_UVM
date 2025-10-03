/*
`include "uvm_macros.svh"
//`include "asyn_fifo_sequence_item.sv"
import uvm_pkg ::*;
*/

class asyn_fifo_write_monitor extends uvm_monitor;

	virtual asyn_fifo_interfs vif;
	asyn_fifo_write_sequence_item write_monitor_sequence_item;
	uvm_analysis_port #(asyn_fifo_write_sequence_item) write_item_port;

	`uvm_component_utils(asyn_fifo_write_monitor)

	function new(string name = "asyn_fifo_write_monitor", uvm_component parent = null);
		super.new(name, parent);
		write_monitor_sequence_item = new();
		write_item_port = new("write_item_port", this);
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
			repeat(1) @ (posedge vif.write_monitor_cb);
			$display("---------------------------Write Monitor @ %0t---------------------------",$time);
			write_monitor_sequence_item.wfull = vif.wfull;
			write_monitor_sequence_item.wdata = vif.wdata;
			write_monitor_sequence_item.winc = vif.winc;
			write_monitor_sequence_item.print();
			write_item_port.write(write_monitor_sequence_item);
			repeat(1) @ (posedge vif.write_monitor_cb);
		end
	endtask
endclass	
