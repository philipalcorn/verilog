`timescale 1ns/1ps // delay/precision

module tb; 
	reg tb_input; // we need a reg here to change assignments during the 
			      // inital block
				  // reg does NOT mean hardware register
	wire tb_output;

	top_module dut 
	(
		.in(tb_input),
		.out(tb_output)
	);
	
	initial 
	begin
		$dumpfile("dump.vcd");
		$dumpvars(0, tb);
	end // end setup

	initial 
	begin
		#1;

		// start applying test inputs
		tb_input = 0; #10; 
		if (tb_output !== tb_input) 
		begin
			$display("Mismatch: in=%b, out=%b", tb_input, tb_output);
			$finish;
		end

		tb_input = 1; #10;
		if (tb_output !== tb_input) 
		begin
			$display("Mismatch: in=%b, out=%b", tb_input, tb_output);
			$finish;
		end

		tb_input = 0; #10;
		if (tb_output !== tb_input) 
		begin
			$display("Mismatch: in=%b, out=%b", tb_input, tb_output);
			$finish;
		end

	$display("PASS");
	$finish;

	end // end testing

endmodule
