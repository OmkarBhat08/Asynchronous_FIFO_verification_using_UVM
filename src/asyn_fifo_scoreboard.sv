`uvm_analysis_imp_decl(_from_write)
`uvm_analysis_imp_decl(_from_read)

class asyn_fifo_scoreboard extends uvm_scoreboard();

	//bit [7:0] mem [512:0];
	int pass_count, fail_count;
	uvm_analysis_imp_from_write #(asyn_fifo_write_sequence_item, asyn_fifo_scoreboard) write_export;
	uvm_analysis_imp_from_read #(asyn_fifo_read_sequence_item, asyn_fifo_scoreboard) read_export;

	asyn_fifo_write_sequence_item write_queue[$];
	asyn_fifo_read_sequence_item read_queue[$];

	`uvm_component_utils(asyn_fifo_scoreboard)

	function new(string name = "asyn_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		write_export = new("inputs_export", this);
		read_export = new("outputs_export", this);
		pass_count = 0;
		fail_count = 0;
	endfunction

	virtual function void write_from_write(asyn_fifo_write_sequence_item t);
		`uvm_info(get_type_name,"Scoreboard received write packet", UVM_NONE);
		write_queue.push_back(t);
	endfunction

	virtual function void write_from_read(asyn_fifo_read_sequence_item u);
		`uvm_info(get_type_name,"Scoreboard received Read packet", UVM_NONE);
		read_queue.push_back(u);
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_write_sequence_item write_packet;
		asyn_fifo_read_sequence_item read_packet;
		super.run_phase(phase);
		forever
		begin
			wait((write_queue.size() > 0) && (read_queue.size() > 0));
			begin
				write_packet = write_queue.pop_front();
				read_packet = read_queue.pop_front();
			end
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
