// Create a module that impelments an and gate.
//

module top_module
(
	input a, b,
	output out
);

// use an assign to drive the output based on the input. 
assign out = a & b;

endmodule
