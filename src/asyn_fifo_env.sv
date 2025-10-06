class asyn_fifo_env extends uvm_env;
	
	asyn_fifo_write_agent wr_agnt;
	asyn_fifo_read_agent rd_agnt;
	asyn_fifo_scoreboard scb;
	asyn_fifo_subscriber subcr;
	asyn_fifo_virtual_sequencer vir_seqr;

	`uvm_component_utils(asyn_fifo_env)

	function new(string name = "asyn_fifo_env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		wr_agnt = asyn_fifo_write_agent::type_id::create("wr_agnt", this);
		rd_agnt = asyn_fifo_read_agent::type_id::create("rd_agnt", this);
		scb = asyn_fifo_scoreboard::type_id::create("scb", this);
		subcr = asyn_fifo_subscriber::type_id::create("subcr", this);
		vir_seqr = asyn_fifo_virtual_sequencer::type_id::create("vir_seqr", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		wr_agnt.mon.write_item_port.connect(scb.write_export);
		//wr_agnt.mon.write_item_port.connect(scb.tlm_write_fifo.analysis_export);
		wr_agnt.mon.write_item_port.connect(subcr.aport_write);
		//rd_agnt.mon.read_item_port.connect(scb.tlm_read_fifo.analysis_export);
		rd_agnt.mon.read_item_port.connect(scb.read_export);
		rd_agnt.mon.read_item_port.connect(subcr.aport_read);
		
		// Virtual Sequencer connect
		vir_seqr.wr_seqr = wr_agnt.seqr;
		vir_seqr.rd_seqr =	rd_agnt.seqr;
	endfunction
endclass
