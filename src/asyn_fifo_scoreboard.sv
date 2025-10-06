`include "defines.sv"
`uvm_analysis_imp_decl(_from_write)
`uvm_analysis_imp_decl(_from_read)

int empty_count;
int match, mismatch;

class asyn_fifo_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(asyn_fifo_scoreboard)
  uvm_analysis_imp_from_write#(asyn_fifo_write_sequence_item,asyn_fifo_scoreboard) write_export;
  uvm_analysis_imp_from_read#(asyn_fifo_read_sequence_item,asyn_fifo_scoreboard) read_export;

  asyn_fifo_write_sequence_item write_q[$];
  asyn_fifo_read_sequence_item read_q[$];
  asyn_fifo_write_sequence_item w_seq;
  asyn_fifo_read_sequence_item r_seq;

  reg [`DSIZE-1:0] next [1:0];
  reg [`DSIZE-1:0] tmp;

  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_export = new("write_export",this);
    read_export = new("read_export",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

  function void write_from_write(asyn_fifo_write_sequence_item w_seq);
    write_q.push_back(w_seq);
  endfunction

  function void write_from_read(asyn_fifo_read_sequence_item r_seq);
    logic [`DSIZE-1:0] dut_wdata;
    empty_count = write_q.size;
    if(write_q.size() > 0) begin
      get_next(r_seq);
      dut_wdata = write_q.pop_front().wdata;
      if(dut_wdata == next[0]) begin
        $display("------------------------ Pass @%0t ----------------------------\n  Expected Data: %0d Read Data(DUT): %0d",$time, next[0], dut_wdata);
        match++;
      end
      else begin
        $display("------------------------ Fail @%0t ----------------------------\n Expected Data: %0d Does not match DUT Read Data: %0d",$time, next[0], dut_wdata);
        mismatch++;
      end
    end
    $display("\n\n");
  endfunction

  function void get_next(asyn_fifo_read_sequence_item r_seq);
    tmp = next[0];
    next[0] = r_seq.rdata;
    next[1] = tmp;
  endfunction

  task compare_flags();
    if(write_q.size > 2**(`A_SIZE-1)) begin
      `uvm_info("SCOREBOARD", "FIFO IS FULL", UVM_MEDIUM);
    end
    if(empty_count == 1) begin
      `uvm_info("SCOREBOARD", "FIFO IS EMPTY", UVM_MEDIUM);
    end
  endtask

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass:asyn_fifo_scoreboard
