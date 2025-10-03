/*
`include "uvm_macros.svh"
`include "asyn_fifo_virtual_sequencer.sv"
`include "asyn_fifo_write_sequencer.sv"
`include "asyn_fifo_read_sequencer.sv"
`include "asyn_fifo_sequence.sv"
import uvm_pkg ::*;
*/

class asyn_fifo_base_virtual_sequence extends uvm_sequence #(uvm_sequence_item);
	asyn_fifo_virtual_sequencer vir_seqr;
	asyn_fifo_write_sequencer wr_seqr;
	asyn_fifo_read_sequencer rd_seqr;
	asyn_fifo_base_sequence base_seq;

	`uvm_object_utils(asyn_fifo_base_virtual_sequence)

	function new(string name = "asyn_fifo_base_virtual_sequence");
		super.new(name);
	endfunction

	virtual task body();
		base_seq = asyn_fifo_base_sequence::type_id::create("base_seq");
		if(!$cast(vir_seqr,m_sequencer))
			`uvm_fatal(get_full_name(), "Virtual Sequencer pointer cast failed!");
		wr_seqr = vir_seqr.write_seqr;	
		rd_seqr = vir_seqr.read_seqr;	
		fork
			base_seq.start(p_sequencer.wr_seqr);
			base_seq.start(p_sequencer.rd_seqr);
		join
	endtask
endclass
