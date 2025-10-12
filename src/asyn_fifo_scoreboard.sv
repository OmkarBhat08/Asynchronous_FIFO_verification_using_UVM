`include "defines.sv"

`uvm_analysis_imp_decl(_from_write)
`uvm_analysis_imp_decl(_from_read)

class asyn_fifo_scoreboard extends uvm_scoreboard();

	uvm_analysis_imp_from_write #(asyn_fifo_write_sequence_item, asyn_fifo_scoreboard) write_export;
	uvm_analysis_imp_from_read #(asyn_fifo_read_sequence_item, asyn_fifo_scoreboard) read_export;

	asyn_fifo_write_sequence_item write_queue[$:15];
	asyn_fifo_write_sequence_item write_queue_temp[$:15];
	asyn_fifo_read_sequence_item read_queue[$:15];

	logic [`DSIZE-1:0] wfull_queue[$:15], rempty_queue[$:15];

	asyn_fifo_write_sequence_item prev_write_packet;
	asyn_fifo_read_sequence_item prev_read_packet;

	int pass_count, fail_count, transaction_count, write_count, scoreboard_count;

	`uvm_component_utils(asyn_fifo_scoreboard)

	function new(string name = "asyn_fifo_scoreboard", uvm_component parent = null);
		super.new(name, parent);
		write_export = new("inputs_export", this);
		read_export = new("outputs_export", this);

		prev_write_packet = new();
		prev_read_packet = new();

		pass_count = 0;
		fail_count = 0;
		write_count = 0;
		scoreboard_count = 0;
		transaction_count = 0;
	endfunction

	virtual function void write_from_write(asyn_fifo_write_sequence_item t);
		asyn_fifo_write_sequence_item a = t; 
		`uvm_info(get_type_name,"Scoreboard received write packet", UVM_NONE);
		if(t.winc == 1)
		begin
			if(write_count < 2)
			begin
				write_queue.push_back(a);
				$display("\n\nWDATA received: %0d", a.wdata);
				$display("Incoming write queue");
				foreach(write_queue[i])
					$write("%0d ",write_queue[i].wdata);
				$display();
				write_count = write_count + 1;
			end
			else
				write_count = 0;
		end
	endfunction

	virtual function void write_from_read(asyn_fifo_read_sequence_item u);
		asyn_fifo_read_sequence_item b = u; 
		if(u.rinc == 1)
		begin
			`uvm_info(get_type_name,"Scoreboard received Read packet", UVM_NONE);
			read_queue.push_back(u);
			$display("\n\nRDATA received: %0d", b.rdata);
			$display("Incoming read queue");
			foreach(read_queue[i])
				$write("%0d ",read_queue[i].rdata);
			$display();
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		asyn_fifo_write_sequence_item write_packet;
		asyn_fifo_read_sequence_item read_packet;
	
		super.run_phase(phase);
		forever
		begin
			transaction_count++;
			wait((write_queue.size() > 0) && (read_queue.size() > 0));
			begin
				if(scoreboard_count == 1)
				begin
					read_packet = read_queue.pop_front();
					$display("Not popping write transaction");
				end
				else
				begin
					$display("Before Unique");
					foreach(write_queue[i])
						$write("%0d ",write_queue[i].wdata);
					$display();

					foreach(write_queue[i])
						if(write_queue[i].wdata == write_queue[i+1].wdata)
							 write_packet = write_queue.pop_front();
					// Displaying unique queue
					$display("Unique write queue");
					foreach(write_queue[i])
						$write("%0d ",write_queue[i].wdata);
					$display();
					write_packet = write_queue.pop_front();
					read_packet = read_queue.pop_front();
				end
			end
			/*
			if(write_queue.size() > 0) 
			begin
				write_packet = write_queue.pop_front();
				wfull_queue.push_back(write_packet.wfull);
			end

			if(read_queue.size() > 0) 
			begin
				read_packet = read_queue.pop_front();
				rempty_queue.push_back(read_packet.rempty);
			end
			*/

			if(transaction_count != 1)
			begin
				scoreboard_count ++;
				if(scoreboard_count == 2 && read_packet.rinc == 1 && read_packet.rrst_n ==1)
					$display("Waiting for 1 more cycle, for first transaction");
				else
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
					while(read_queue.size() > 0)
						read_queue.pop_front();
					while(write_queue.size() > 0)
						write_queue.pop_front();
					scoreboard_count = 0;
				end //reset end
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
					while(read_queue.size() > 0)
						read_queue.pop_front();
					while(write_queue.size() > 0)
						write_queue.pop_front();
					scoreboard_count = 0;
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
					if(scoreboard_count > 2)
						scoreboard_count = 0;
			end // for scoreboard_count else
			end
			else
			begin
				$display("Scoreboard Discarding First transaction @%0t", $time);
				while(read_queue.size() > 0)
					read_queue.pop_front();
				while(write_queue.size() > 0)
					write_queue.pop_front();
				scoreboard_count = 0;
			end
			prev_write_packet.copy(write_packet);
			prev_read_packet.copy(read_packet);
		end	// forever end
	endtask
endclass
