class asyn_fifo_base_virtual_sequence extends uvm_sequence;
	asyn_fifo_virtual_sequencer vir_seqr;
	asyn_fifo_write_sequencer wr_seqr;
	asyn_fifo_read_sequencer rd_seqr;
	asyn_fifo_base_write_sequence base_write_seq;
	asyn_fifo_base_read_sequence base_read_seq;
	write_reset_sequence rst_write_seq;
	read_reset_sequence rst_read_seq;


	`uvm_object_utils(asyn_fifo_base_virtual_sequence)
	`uvm_declare_p_sequencer(asyn_fifo_virtual_sequencer)

	function new(string name = "asyn_fifo_base_virtual_sequence");
		super.new(name);

		base_write_seq = asyn_fifo_base_write_sequence::type_id::create("base_write_seq");
		base_read_seq = asyn_fifo_base_read_sequence::type_id::create("base_read_seq");
		rst_write_seq = write_reset_sequence::type_id::create("rst_write_seq");
		rst_read_seq = read_reset_sequence::type_id::create("rst_read_seq");
	endfunction

	virtual task body();
		// Reset sequence
		fork
			rst_read_seq.start(p_sequencer.rd_seqr);
			rst_write_seq.start(p_sequencer.wr_seqr);
		join

		// Base sequence
		fork
			base_read_seq.start(p_sequencer.rd_seqr);
			base_write_seq.start(p_sequencer.wr_seqr);
		join

	endtask
endclass

