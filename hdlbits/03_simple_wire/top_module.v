module top_module (input in, output out);

	assign out = in; // Assign is a continuous assignment.
					 // happens constantly and not at one time.
					 // so the left side is "driven" by the right side.	

endmodule

