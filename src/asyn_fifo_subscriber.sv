`uvm_analysis_imp_decl(_write_cg)
`uvm_analysis_imp_decl(_read_cg)

class asyn_fifo_subscriber extends uvm_component;

  uvm_analysis_imp_write_cg #(asyn_fifo_write_sequence_item, asyn_fifo_subscriber) aport_write;
  uvm_analysis_imp_read_cg #(asyn_fifo_read_sequence_item, asyn_fifo_subscriber) aport_read;

	asyn_fifo_write_sequence_item write_trans; 
	asyn_fifo_read_sequence_item read_trans; 
  real wr_cov, rd_cov;

  `uvm_component_utils(asyn_fifo_subscriber)

  covergroup write_cov;
    write_reset: coverpoint write_trans.wrst_n;
    wr_ptr_inc: coverpoint write_trans.winc;
		write_data: coverpoint write_trans.wdata{
													option.auto_bin_max = 4;
			                    }
    fifo_full: coverpoint write_trans.wfull;
  endgroup

  covergroup read_cov;
    read_reset: coverpoint read_trans.rrst_n;
    rd_ptr_inc: coverpoint read_trans.rinc;
		read_data: coverpoint read_trans.rdata{
													option.auto_bin_max = 4;
			                    }
    fifo_empty: coverpoint read_trans.rempty;
  endgroup

  function new(string name = "asyn_fifo_subscriber", uvm_component parent = null);
    super.new(name, parent);
    write_cov = new();
    read_cov = new();
    aport_write = new("aport_write", this);
    aport_read = new("aport_read", this);
  endfunction

  function void write_write_cg(asyn_fifo_write_sequence_item t);
    write_trans = t;
    write_cov.sample();
  endfunction

  function void write_read_cg(asyn_fifo_read_sequence_item t);
    read_trans = t;
    read_cov.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    wr_cov = write_cov.get_coverage();
    rd_cov = read_cov.get_coverage();
  endfunction
 
	function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Write Coverage --> %0.2f", wr_cov), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("Read Coverage --> %0.2f", rd_cov), UVM_MEDIUM);
  endfunction
endclass
