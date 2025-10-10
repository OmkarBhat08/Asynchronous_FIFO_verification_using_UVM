`include "defines.sv"
interface asyn_fifo_interfs(input bit wclk, rclk);
	// Outputs
	logic [`DSIZE-1:0] rdata;
	logic wfull, rempty;

	// Inputs
	logic [`DSIZE-1:0] wdata;
	logic winc, wrst_n;
	logic rinc, rrst_n;

	//always@(wclk, rclk) $display("wptr=%0d,rptr=%0d",DUT.waddr,DUT.raddr);
	clocking write_driver_cb @(posedge wclk);
		default input #0 output #0;
			input wrst_n;
			output wdata;
			output winc;
	endclocking	

	clocking read_driver_cb	@(posedge rclk);
		default input #0 output #0;
			input rrst_n;
			output rinc;
	endclocking	

	clocking write_monitor_cb	@(posedge wclk);
		default input #0 output #0;
			input wfull;
			input wrst_n;
			input wdata;
			input winc;
	endclocking	

	clocking read_monitor_cb @(posedge rclk);
		default input #0 output #0;
			input rdata;
			input rempty;
			input rrst_n;
			input rinc;
	endclocking	

	modport WRITE_DRIVER (clocking write_driver_cb, input wclk);
	modport READ_DRIVER (clocking read_driver_cb, input rclk);
	modport WRITE_MONITOR (clocking write_monitor_cb, input wclk);
	modport READ_MONITOR (clocking read_monitor_cb, input rclk);

endinterface
