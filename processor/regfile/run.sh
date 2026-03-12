#!/bin/bash

iverilog -g2012 -Wall -o out/sim tb_regfile.sv regfile.sv 
vvp out/sim
gtkwave out/regfile.vcd
