// create a module that implements a nor gate
//

module top_module
(
	input a, b,
	output out
);

// Assign statments can be as complicated as required so long as they don't
// require sequential logic.
assign out = ~(a | b);

endmodule



