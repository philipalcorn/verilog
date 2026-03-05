`timescale 1ns/1ps

module tb_alu;

   logic [31:0] a, b;
   logic [3:0]  alu_op;
   logic [31:0] result;
   logic        zero;

   localparam logic [3:0]
       ALU_ADD  = 4'd0,
       ALU_SUB  = 4'd1,
       ALU_AND  = 4'd2,
       ALU_OR   = 4'd3,
       ALU_XOR  = 4'd4,
       ALU_SLL  = 4'd5,
       ALU_SRL  = 4'd6,
       ALU_SRA  = 4'd7,
       ALU_SLT  = 4'd8,
       ALU_SLTU = 4'd9;

   // DUT (module name is alu)
   alu dut (
       .a(a),
       .b(b),
       .alu_op(alu_op),
       .result(result),
       .zero(zero)
   );

   // ------------------------------------------------------------
   // Golden model: compute expected ALU output from a/b/op
   // (matches your ALU design where shamt = b[4:0])
   // ------------------------------------------------------------
   function automatic [31:0] alu_model(
       input [31:0] a_in,
       input [31:0] b_in,
       input [3:0]  op_in
   );
       logic [4:0] shamt;
       begin
           shamt = b_in[4:0];
           case (op_in)
               ALU_ADD:  alu_model = a_in + b_in;
               ALU_SUB:  alu_model = a_in - b_in;
               ALU_AND:  alu_model = a_in & b_in;
               ALU_OR:   alu_model = a_in | b_in;
               ALU_XOR:  alu_model = a_in ^ b_in;
               ALU_SLL:  alu_model = a_in << shamt;
               ALU_SRL:  alu_model = a_in >> shamt;
               ALU_SRA:  alu_model = $signed(a_in) >>> shamt;
               ALU_SLT:  alu_model = ($signed(a_in) < $signed(b_in)) ? 32'd1 : 32'd0;
               ALU_SLTU: alu_model = (a_in < b_in) ? 32'd1 : 32'd0;
               default:  alu_model = 32'd0;
           endcase
       end
   endfunction

   // Your original directed check (kept)
   task check;
       input [31:0]  exp;
       input [127:0] name;
       begin
           #1;
           if (result !== exp) begin
               $display("FAIL %0s  a=%h b=%h op=%0d got=%h exp=%h",
                        name, a, b, alu_op, result, exp);
               $finish;
           end
           if (zero !== (exp == 0)) begin
               $display("FAIL ZERO %0s got_zero=%b exp_zero=%b",
                        name, zero, (exp == 0));
               $finish;
           end
           $display("PASS %0s result=%h zero=%b", name, result, zero);
       end
   endtask

   // New: automatic check that uses the golden model
   task check_model;
       input [127:0] name;
       logic [31:0] exp;
       begin
           exp = alu_model(a, b, alu_op);
           check(exp, name);
       end
   endtask

   integer i;

   initial begin
       $dumpfile("out/alu.vcd");
       $dumpvars(0, tb_alu);

       // ----------------
       // Directed tests
       // ----------------
       a = 32'd10; b = 32'd7; alu_op = ALU_ADD;
       check_model("ADD");

       a = 32'd123; b = 32'd123; alu_op = ALU_SUB;
       check_model("SUBeq");

       a = 32'hAA00_F0F0; b = 32'h0F0F_00FF; alu_op = ALU_AND;
       check_model("AND");

       a = 32'hAA00_F0F0; b = 32'h0F0F_00FF; alu_op = ALU_OR;
       check_model("OR");

       a = 32'hAA00_F0F0; b = 32'h0F0F_00FF; alu_op = ALU_XOR;
       check_model("XOR");

       a = 32'h0000_0001; b = 32'd8; alu_op = ALU_SLL;
       check_model("SLL");

       a = 32'h8000_0000; b = 32'd1; alu_op = ALU_SRL;
       check_model("SRL");

       a = 32'h8000_0000; b = 32'd1; alu_op = ALU_SRA;
       check_model("SRA");

       a = 32'hFFFF_FFFF; b = 32'd1; alu_op = ALU_SLT;
       check_model("SLT");

       a = 32'hFFFF_FFFF; b = 32'd1; alu_op = ALU_SLTU;
       check_model("SLTU");

       // ----------------
       // Randomized tests
       // ----------------
       for (i = 0; i < 2000; i = i + 1) begin
           a = $random;
           b = $random;
           alu_op = $random % 10;
           check_model("RND");
       end

       $display("ALL TESTS PASSED (directed + random)");
       #5 $finish;
   end

endmodule
