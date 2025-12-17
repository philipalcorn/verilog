`timescale 1ns/1ps

module tb; // no input or output ports
	wire tb_zero; // create a wire inside the testbench

	top_module device(
		.zero(tb_zero)
	);

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars(0, tb);
	end

	initial begin
		#1; // delay 1 ns for signals to settle

		if (tb_zero !== 1'b0)  // 1 bit binary number of value zero 
		begin
			$display("FAIL: zero = %b, expected 0", tb_zero);
			$finish;
		end

		$display("PASS");
		$finish;
	end

endmodule
