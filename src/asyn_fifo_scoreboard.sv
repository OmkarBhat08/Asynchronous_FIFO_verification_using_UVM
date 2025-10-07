class asyn_fifo_scoreboard extends uvm_scoreboard();

	uvm_tlm_analysis_fifo  #(asyn_fifo_write_sequence_item) tlm_write_fifo;
	uvm_tlm_analysis_fifo  #(asyn_fifo_read_sequence_item) tlm_read_fifo;

	asyn_fifo_write_sequence_item prev_write_packet;
	asyn_fifo_read_sequence_item prev_read_packet;

	int pass_count, fail_count, transaction_count;

	`uvm_component_utils(asyn_fifo_scoreboard)

	function new(string name = "asyn_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		tlm_write_fifo = new("tlm_write_fifo", this);
		tlm_read_fifo = new("tlm_read_fifo", this);
		pass_count = 0;
		fail_count = 0;
		transaction_count = 0;
		prev_write_packet = new();
		prev_read_packet = new();
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_write_sequence_item write_packet;
		asyn_fifo_read_sequence_item read_packet;
		super.run_phase(phase);
		forever
		begin
			tlm_read_fifo.get(read_packet);
			transaction_count++;
			tlm_write_fifo.get(write_packet);
			if(transaction_count != 1)
			begin
				$display("---------------------------------------Scoreboard @%0t ---------------------------------------", $time);
				$display("\t\t\tField\t\t|\t\tValue");
				$display("--------------------------------------|--------------------------------------");
				$display("\t\t\twrst_n\t\t|\t\t%b",write_packet.wrst_n);
				$display("\t\t\twinc\t\t|\t\t%b",write_packet.winc);
				$display("\t\t\twdata\t\t|\t\t%0d",write_packet.wdata);
				$display("\t\t\twfull\t\t|\t\t%b",write_packet.wfull);
				$display("\t\t\trrst_n\t\t|\t\t%b",read_packet.rrst_n);
				$display("\t\t\trinc\t\t|\t\t%b",read_packet.rinc);
				$display("\t\t\trdata\t\t|\t\t%0d",read_packet.rdata);
				$display("\t\t\trempty\t\t|\t\t%b",read_packet.rempty);

				if((write_packet.wrst_n = 0) || (read_packet.rrst_n == 0))
				begin
					if(write_packet.wrst_n == 0)
					begin
						$display("Write Reset is applied");
						if(write_packet.wfull == 0)
						begin
							$display("Write Reset TEST PASSED @ %0t", $time);
							pass_count ++;
						end
						else
						begin
							$display("Write Reset TEST FAILED @ %0t", $time);
							fail_count ++;
						end
					end
					if(read_packet.rrst_n == 0)
					begin
						$display("Read Reset is applied");
						if(read_packet.rempty == 1 && read_packet.rdata == 0)
						begin
							$display("Read Reset TEST PASSED @ %0t", $time);
							pass_count ++;
						end
						else 
						begin
							if(read_packet.rempty == 0)
								$display("Read Reset TEST FAILED @ %0t because rempty is not set to 1", $time);
							else
								$display("Read Reset TEST FAILED @ %0t because rdata is not cleared", $time);
							fail_count ++;
						end
					end
				end
				else if (write_packet.winc == 0 && read_packet.rinc == 0)
				begin
					if((write_packet.wfull == prev_write_packet.wfull) && (read_packet.rdata == prev_read_packet.rdata) && (read_packet.rempty == prev_read_packet.rempty)) 
					begin
						$display("INC0 TEST PASSED @ %0t", $time);
						pass_count ++;
					end
					else
					begin
						$display("INC0 TEST FAILED @ %0t", $time);
						fail_count ++;
					end
				end
				else
				begin
					if(write_packet.wdata == read_packet.rdata)
					begin
						$display("TEST PASSED @ %0t", $time);
						pass_count ++;
					end
					else
					begin
						$display("TEST FAILED @ %0t", $time);
						fail_count ++;
					end
				end
				$display("PASS count = %0d | FAIL count = %0d",pass_count, fail_count);
			end
			else
				$display("Scoreboard Discarding First transaction @%0t", $time);
			prev_write_packet.copy(write_packet);
			prev_read_packet.copy(read_packet);
		end	// forever end
	endtask
endclass
