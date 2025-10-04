class asyn_fifo_write_driver extends uvm_driver #(asyn_fifo_write_sequence_item);

	virtual asyn_fifo_interfs vif;
	asyn_fifo_write_sequence_item seq;	
	`uvm_component_utils(asyn_fifo_write_driver)

	function new(string name = "asyn_fifo_write_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual asyn_fifo_interfs)::get(this,"","vif",vif))
			`uvm_fatal(get_type_name(), "Not set at top");
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		repeat(1) @(posedge vif.write_driver_cb);
		forever
		begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask

	virtual task drive();
		$display("---------------------------Write Driver @ %0t---------------------------",$time);
		vif.wrst_n <= req.wrst_n;
		vif.wdata <= req.wdata;
		vif.winc <= req.winc;
		$display("\t\t\twrst\t|\t%b",req.wrst_n);
		$display("\t\t\twdata\t|\t%0d",req.wdata);
		$display("\t\t\twinc\t|\t%b",req.winc);

		repeat(1) @(posedge vif.write_driver_cb);
	endtask
endclass
