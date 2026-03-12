module regfile #(
    parameter XLEN = 32, // REgister size 
    parameter NREG = 32  // number of registers
)(
    input  logic             clk,
    input  logic             write_enable,	// write enable
    input  logic [4:0]       reg_src_1,		// source register 1
    input  logic [4:0]       reg_src_2,		// source register 2
    input  logic [4:0]       reg_dest,		// destination register
    input  logic [XLEN-1:0]  write_data,    // write data
    output logic [XLEN-1:0]  read_data_1,   // read data 1
    output logic [XLEN-1:0]  read_data_2    // read data 2
);

    // register storage
    logic [XLEN-1:0] registers [NREG-1:0]; 

	// Async reads
	// supply outputs constantly and as fast as possible
    always_comb begin
		// This enforces x0 = 0 always 
        read_data_1 = (reg_src_1 == 5'd0) ? '0 : registers[reg_src_1];
        read_data_2 = (reg_src_2 == 5'd0) ? '0 : registers[reg_src_2]; 
    end
	
	// sync writes
	// Only modify inputs on clk edge
    always_ff @(posedge clk) begin
        if (write_enable && (reg_dest != 5'd0)) // Don't write to x0
            registers[reg_dest] <= write_data;
    end

endmodule
