/*
`uvm_analysis_imp_decl(_from_write)
`uvm_analysis_imp_decl(_from_read)
*/

class asyn_fifo_scoreboard extends uvm_scoreboard();
	//uvm_analysis_imp_from_write #(asyn_fifo_write_sequence_item, asyn_fifo_scoreboard) write_export;
	//uvm_analysis_imp_from_read #(asyn_fifo_read_sequence_item, asyn_fifo_scoreboard) read_export;
	uvm_tlm_analysis_fifo  #(asyn_fifo_write_sequence_item) tlm_write_fifo;
	uvm_tlm_analysis_fifo  #(asyn_fifo_read_sequence_item) tlm_read_fifo;
	int pass_count, fail_count;

	`uvm_component_utils(asyn_fifo_scoreboard)

	/*
	asyn_fifo_write_sequence_item write_queue[$];
	asyn_fifo_read_sequence_item read_queue[$];
	*/

	function new(string name = "asyn_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		//write_export = new("write_export", this);
		//read_export = new("read_export", this);
		tlm_write_fifo = new("tlm_write_fifo", this);
		tlm_read_fifo = new("tlm_read_fifo", this);
		pass_count = 0;
		fail_count = 0;
	endfunction

	/*
	virtual function void write_from_read(asyn_fifo_read_sequence_item u);
		read_queue.push_back(u);
	endfunction

	virtual function void write_from_write(asyn_fifo_write_sequence_item t);
		write_queue.push_back(t);
	endfunction
	*/

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_write_sequence_item write_packet;
		asyn_fifo_write_sequence_item write_packet_tmp;
		asyn_fifo_read_sequence_item read_packet;
		super.run_phase(phase);
		forever
		begin
			tlm_read_fifo.get(read_packet);
			tlm_write_fifo.get(write_packet);

			/*
			wait((write_queue.size() > 0) && (read_queue.size() > 0));
			begin
				write_packet = write_queue.pop_front();
				read_packet = read_queue.pop_front();
			end
			*/
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
						$display("Read Reset TEST FAILED @ %0t", $time);
						fail_count ++;
					end
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
	endtask
endclass
