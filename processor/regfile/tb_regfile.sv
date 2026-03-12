`timescale 1ns/1ps

module tb_regfile;
	
	logic clk, write_enable;
	logic[4:0] reg_src_1, reg_src_2, reg_dest;
	logic[31:0] write_data, read_data_1, read_data_2;
	
	localparam XLEN = 32;
	localparam NREG = 32;

	regfile #(
		.XLEN(XLEN),
		.NREG(NREG)
	) dut (
		// .submodule_port(outer_module_port)
		.clk(clk),
		.write_enable(write_enable),
		.reg_src_1(reg_src_1),
		.reg_src_2(reg_src_2),
		.reg_dest(reg_dest),
		.write_data(write_data),
		.read_data_1(read_data_1),
		.read_data_2(read_data_2)
	);

	initial clk = 0;
	always # 5 clk = ~clk;
	

	task automatic check_equal(
		input logic[XLEN-1:0]	actual,
		input logic[XLEN-1:0]	expected,
		input string			msg
	);
	begin 
		if (actual !== expected) begin // ! = = catches Xs as well
			$display("ERROR %s | expected = 0x%08h, got = 0x%08h", msg, expected, actual);
			$fatal;
		end 
		else begin 
			$display("PASS: %s | value = 0x%08h", msg, actual);
		end
	end
	endtask

	initial begin 
		$dumpfile("out/regfile.vcd");
        $dumpvars(0, tb_regfile);

		$display("Starting Regfile Verification");
		// Initialize inputs
        write_enable  = 0;
        reg_src_1 = 0;
        reg_src_2 = 0;
        reg_dest = 0;
        write_data  = 0;
	
		// test one, check if x0 == 0 
		reg_src_1 = 5'd0;
		reg_src_2 = 5'd0; 
		#1 // Delay clock
		check_equal(read_data_1, 32'h0000_0000, "x0 read on port 1 is zero");
		check_equal(read_data_2, 32'h0000_0000, "x0 read on port 2 is zero");

		// test 2, write/read reg 1
		@(negedge clk);
		write_enable = 1;
		reg_dest = 5'd1;
		write_data = 32'h12345678;

		@(posedge clk);
		reg_src_1 = 5'd1;
		#1;
		write_enable = 0;
		check_equal(read_data_1, 32'h12345678, "write/read x1");

		// test 3, write to x2, read both ports 
		@(negedge clk); 
		write_enable = 1;
		reg_dest = 5'd2;
		write_data = 32'hABAB0011;

		@(posedge clk);
		reg_src_1 = 5'd1;
		reg_src_2 = 5'd2;
		#1;
		check_equal(read_data_1, 32'h12345678, "read x1 on port 1");
		check_equal(read_data_2, 32'hABAB0011, "read x2 on port 2");

		write_enable = 0;
		// test 4, attempt to write to x0
		@(negedge clk);
		write_enable=1;
		reg_dest = 5'd0;
		write_data = 32'hFFFF_FFFF;

		@(posedge clk);
		reg_src_1 = 5'd0;
		#1;
		write_enable = 0;
		check_equal(read_data_1, 32'h0000_0000, "check overwrite x0");

		// test 5: overwrite x1:

		@(negedge clk);
		write_enable = 1;
		reg_dest = 5'd1;
		write_data = 32'hFAFA_FEFE;

		@(posedge clk);
		reg_src_1 = 5'd1;
		#1;
		write_enable = 0;
		check_equal(read_data_1, 32'hFAFA_FEFE, "Overwrite x1");

		$display("All Tests Passed.");
		$finish;
	end
endmodule


		

				

