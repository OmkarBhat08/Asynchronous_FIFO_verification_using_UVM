`timescale 1ns/1ns

`include "defines.sv"
`include "asyn_fifo_interfs.sv"
`include "asyn_fifo_pkg.sv"
`include "FIFO.v"
`include "asyn_fifo_assertions.sv"

import uvm_pkg::*;  
import asyn_fifo_pkg::*;
 
module top();
	bit wclk, rclk;

	asyn_fifo_interfs vif(wclk, rclk);

	FIFO DUT(
		        .rdata(vif.rdata), 
		        .wdata(vif.wdata),
		        .wfull(vif.wfull),
		        .rempty(vif.rempty),
		        .winc(vif.winc), 
		        .rinc(vif.rinc), 
		        .wclk(wclk), 
		        .rclk(rclk), 
		        .wrst_n(vif.wrst_n), 
		        .rrst_n(vif.rrst_n)
		    );
	
	bind vif asyn_fifo_assertions ASSERTION (.*);

	always
		#5  wclk = ~wclk;

	always
		#10 rclk = ~rclk;

	initial
	begin
		wclk = 0;
		rclk = 0;
	end

	initial
	begin
		uvm_config_db #(virtual asyn_fifo_interfs)::set(uvm_root::get(),"*","vif",vif);
		$dumpfile("dump.vcd");
		$dumpvars;
	end

	initial
	begin
		run_test("asyn_fifo_base_test");
		//run_test("asyn_fifo_reset_test");
		//run_test("asyn_fifo_inc0_test");
		//run_test("asyn_fifo_normal_test");
		//run_test("asyn_fifo_b2bw_test");
		//run_test("asyn_fifo_full_test");
	end
endmodule
