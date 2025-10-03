`uvm_analysis_imp_decl(_write_cg)
`uvm_analysis_imp_decl(_read_cg)

class asyn_fifo_subscriber extends uvm_component;

  uvm_analysis_imp_write_cg #(asyn_fifo_write_sequence_item, asyn_fifo_subscriber) aport_write;
  uvm_analysis_imp_read_cg #(asyn_fifo_read_sequence_item, asyn_fifo_subscriber) aport_read;

	asyn_fifo_write_sequence_item write_trans; 
	asyn_fifo_read_sequence_item read_trans; 
  real inp_cov, out_cov;

  `uvm_component_utils(asyn_fifo_subscriber)

  covergroup input_cov;
    write_reset: coverpoint write_trans.wrst_n;
    read_reset: coverpoint read_trans.rrst_n;
    wr_ptr_inc: coverpoint write_trans.winc;
    rd_ptr_inc: coverpoint read_trans.rinc;
		write_data: coverpoint write_trans.wdata {
													option.auto_bin_max = 4;
			                    }
  endgroup

  covergroup output_cov;
    fifo_full: coverpoint write_trans.wfull;
    fifo_empty: coverpoint read_trans.rempty;
		read_data: coverpoint read_trans.rdata{
													option.auto_bin_max = 4;
			                    }
  endgroup

  function new(string name = "asyn_fifo_subscriber", uvm_component parent = null);
    super.new(name, parent);
    input_cov = new();
    output_cov = new();
    aport_write = new("aport_write", this);
    aport_read = new("aport_read", this);
  endfunction

  function void write_write_cg(asyn_fifo_write_sequence_item t);
    write_trans = t;
    input_cov.sample();
  endfunction

  function void write_read_cg(asyn_fifo_read_sequence_item t);
    read_trans = t;
    output_cov.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    inp_cov = input_cov.get_coverage();
    out_cov = output_cov.get_coverage();
  endfunction
 
	function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("[Input]: Coverage --> %0.2f", inp_cov), UVM_MEDIUM);
    `uvm_info(get_type_name(), $sformatf("[Output]: Coverage --> %0.2f", out_cov), UVM_MEDIUM);
  endfunction
endclass
