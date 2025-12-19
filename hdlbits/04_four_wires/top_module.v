// Create a module with 3 inputs and 4 outputs that behaves like wires that makes these connections:
//
// a -> w
// b -> x
// b -> y
// c -> z
//
//

// It is noteworthy that "assign" statements are CONTINUOUS ASSIGNMENTS: the
// order that you put them does not matter. They describe CONNECTIONS between
// things, not copying a value from one location to another. 
//

// One of the reasons this works is that inputs and outputs are actually wires
// themselves. 
//
// "input wire a" and "input a" mean the same thing. 
//
// So the assign statements do not create wires themselves, they just create
// connections between already existing wires.
//

module top_module
(
	input a, b, b,
	output w, x, y, z
);

assign w = a;
assign x = b;
assign y = b;
assign z = c;



endmodule

