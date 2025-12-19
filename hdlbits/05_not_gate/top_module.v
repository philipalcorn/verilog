// Create a module that implements a not gate.
//
// This circuit is similar to the "wire" problem, with a slight difference.

module top_module
(
	input in,
	output out
);

// We use assign to create a connection.
assign out = ~in;


endmodule
