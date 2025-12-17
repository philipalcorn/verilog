`timescale 1ns/1ps
 // 1ns is the smallest delay, 1ps is the smallest precision
 // So it will simulate down to the ps but intentional delays are only 1ns


 // We need to define a testbench module. 
 // This is just another verilog module with no ports that only exists in
 // simulation.
 // It is more of a "wrapper" that instantiates the design, drives the 
 // inputs, and checks the outputs.
 //
module tb;
	// We are generating a signal INSIDE the testbench.
	wire tb_one; 
	// top_module will drive this signal, and the testbench will observe it.
	//
	// Rule of thumb: outputs of DUT: wire
	//				  inputs of DUT: reg or logic


	// This creates an instance of our design. 
	// this entire block is the instantiation. You need to connect all the 
	// module output ports to another wire. In this case we are connecting the 
	// module's "one" output to our "tb_one" wire.
	
	top_module dut( // top_module is the module name, dut is the instance name
		.one(tb_one)	// drive "tb_one" with output of DUTs "one" output 
		//.portname(signal_name) leftside -> dut port, rightside -> tb signal
	); // the instance can be named anything but dut is conventional




	// Testbench setup
	initial begin
		$dumpfile("dump.vcd");	// Name of Waveform file
		$dumpvars(0, tb);		// 0 - record all levels of hierarchy
								// tb is the starting module
								// so this tb records: tb.one, tb.dut.one
	end




	// core of the testbench. Runs onces starting at t=0.
	initial begin

		#1; // Allow signals to settle
			// #1 means "wait 1 nanosecond" since 1ns is the smallest delay

		if (one !== 1'b1) begin // this is the actual verification
								// It makes sure that the output 
								// is equal to a 1 bit binary number of value
								// 1
			$display("FAIL: one = %b, expected 1", one); // console output
			$finish; // Ends the simulation immediately
		end

		$display("PASS");
		$finish;
	end


endmodule
