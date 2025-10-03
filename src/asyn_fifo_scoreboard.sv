
class asyn_fifo_scoreboard extends uvm_scoreboard();

	int pass_count, fail_count;

	uvm_tlm_analysis_fifo  #(asyn_fifo_write_sequence_item) tlm_write_fifo;
	uvm_tlm_analysis_fifo  #(asyn_fifo_read_sequence_item) tlm_read_fifo;

	`uvm_component_utils(asyn_fifo_scoreboard)

	function new(string name = "asyn_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		tlm_write_fifo = new("tlm_write_fifo", this);
		tlm_read_fifo = new("tlm_read_fifo", this);
		pass_count = 0;
		fail_count = 0;
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_write_sequence_item write_packet;
		asyn_fifo_read_sequence_item read_packet;
		super.run_phase(phase);
		forever
		begin
			tlm_write_fifo.get(write_packet);
			tlm_read_fifo.get(read_packet);
			$display("---------------------------------------Scoreboard @%0t ---------------------------------------", $time);
			write_packet.print();
			read_packet.print();
/*
			// Writing or reading
			if(write_packet.PRESETn == 0)
			begin
				$display("------------------------------------------------------------------------------");
				$display("                PRESETn is applied                            ");
				$display("apb_read_data_out = %0d | read_packet.PSLVERR = %0d",packet2.apb_read_data_out, packet2.PSLVERR);

				if(read_packet.apb_read_data_out == 'b0 && packet2.PSLVERR == 0)
				begin
					$display("PRESETn has set outputs to 0");
					$display("                TEST PASSED @ %0t                             ", $time);
					pass_count ++;
				end
				else
				begin
					$display("PRESETn has not set outputs to 0");
					$display("                TEST FAILED @ %0t                                ",$time);
					fail_count ++;
				end
				$display("------------------------------------------------------------------------------");
			end
			else
			begin
      	if(write_packet.READ_WRITE == 0)  // Write
				begin
					if(~write_packet.transfer)
						$display("----------------APB is disabled | transfer is 0-----------------------------");
					$display("Writing %0d to memory address %0d", write_packet.apb_write_data, write_packet.apb_write_paddr);
					mem[write_packet.apb_write_paddr] = write_packet.apb_write_data;
				end
				else  //Read and compare
				begin
					if(~write_packet.transfer)
						$display("----------------APB is disabled | transfer is 0-----------------------------");

					if(read_packet.apb_read_data_out === mem[write_packet.apb_read_paddr])
					begin
						$display("------------------------------------------------------------------------------");
						$display("                TEST PASSED @ %0t                             ", $time);
						$display("------------------------------------------------------------------------------");
						pass_count ++;
					end
					else
					begin
						$display("------------------------------------------------------------------------------");
						$display("                TEST FAILED @ %0t                                ",$time);
						$display("------------------------------------------------------------------------------");
						fail_count ++;
					end
				end
			end
			*/
			$display("PASS count = %0d | FAIL count = %0d",pass_count, fail_count);
			$display("############################################################################################################################");
		end
	endtask
endclass
