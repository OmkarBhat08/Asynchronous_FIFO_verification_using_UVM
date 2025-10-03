class asyn_fifo_read_sequencer extends uvm_sequencer #(asyn_fifo_read_sequence_item);
	`uvm_component_utils(asyn_fifo_read_sequencer)

	function new(string name = "asyn_fifo_read_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction

endclass
