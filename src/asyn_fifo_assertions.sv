program asyn_fifo_assertions(rdata, wfull, rempty, wdata, winc, wclk, wrst_n, rinc, rclk, rrst_n);
	
	input [`DSIZE-1:0] rdata, wdata;
	input wfull, rempty, winc, wclk, wrst_n, rinc, rclk, rrst_n;

	property wrst_check;
		@(posedge wclk) (!wrst_n) |-> !wfull;
	endproperty

	property rrst_check;
		@(posedge rclk) (!rrst_n) |-> (rempty);
	endproperty

	property winc0_check;
		@(posedge wclk) (wrst_n && !winc) |-> wfull == $past(wfull,1);
	endproperty

	property rinc0_check;
		@(posedge rclk) (rrst_n && !rinc) |-> rdata == $past(rdata,1);
	endproperty

	property unknown;
		@(posedge rclk)
			##2 ($isunknown(wrst_n) || $isunknown(rrst_n) || $isunknown(winc) || $isunknown(rinc) || $isunknown(wdata) || $isunknown(rdata) || $isunknown(wfull) || $isunknown(rempty)) == 0 ;
 	endproperty		

	assert property (wrst_check)
		$display("ASSERTION PASS: wfull is 0 when wrst = 0");
	else
		$display("ASSERTION FAIL: wfull is not 0 when wrst = 0");

	assert property (rrst_check)
		$display("ASSERTION PASS: rempty = 1 and rdata = 0 when rrst = 0");
	else
		$display("ASSERTION FAIL: rempty != 1 or rdata != 0 when rrst = 0");

	assert property (winc0_check)
		$display("ASSERTION PASS: wfull is latched when winc = 0");
	else
		$display("ASSERTION FAIL: wfull is not latched when winc = 0");

	assert property (rinc0_check)
		$display("ASSERTION PASS: rdata is latched when rinc = 0");
	else
		$display("ASSERTION FAIL: rdata is not latched when rinc = 0");

	assert property (unknown)
		$display("ASSERTION PASS: No signals are unknown");
	else
		$display("ASSERTION FAIL: Any one signal is unknown");
endprogram
