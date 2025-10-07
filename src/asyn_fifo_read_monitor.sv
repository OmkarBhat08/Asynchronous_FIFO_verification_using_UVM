class asyn_fifo_read_monitor extends uvm_monitor;

	virtual asyn_fifo_interfs vif;
	asyn_fifo_read_sequence_item read_monitor_sequence_item;
	asyn_fifo_read_sequence_item prev_read_monitor_sequence_item;
	uvm_analysis_port #(asyn_fifo_read_sequence_item) read_item_port;

	`uvm_component_utils(asyn_fifo_read_monitor)

	function new(string name = "asyn_fifo_read_monitor", uvm_component parent = null);
		super.new(name, parent);
		read_monitor_sequence_item = new();
		prev_read_monitor_sequence_item = new();
		read_item_port = new("read_item_port", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual asyn_fifo_interfs)::get(this, "", "vif", vif))
			`uvm_fatal(get_type_name(), "Not set at top");
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		repeat(1) @ (posedge vif.read_monitor_cb);
		forever
		begin
			repeat(1) @ (posedge vif.read_monitor_cb);
			$display("---------------------------Read Monitor @ %0t---------------------------",$time);
			read_monitor_sequence_item.rinc = vif.rinc;
			read_monitor_sequence_item.rrst_n = vif.rrst_n;
			read_monitor_sequence_item.rempty = vif.rempty;
			read_monitor_sequence_item.rdata = vif.rdata;

			$display("\t\t\trrst_n\t|\t%b",read_monitor_sequence_item.rrst_n);
			$display("\t\t\trinc\t|\t%b",read_monitor_sequence_item.rinc);
			$display("\t\t\trempty\t|\t%b",read_monitor_sequence_item.rempty);
			$display("\t\t\trdata\t|\t%0d",read_monitor_sequence_item.rdata);
			read_item_port.write(read_monitor_sequence_item);
			if((prev_read_monitor_sequence_item.rrst_n == 0) && (read_monitor_sequence_item.rempty ==1) && (read_monitor_sequence_item.rinc ==1))
				repeat(2) @ (posedge vif.read_monitor_cb);
			prev_read_monitor_sequence_item.copy(read_monitor_sequence_item);
		end
	endtask
endclass	
