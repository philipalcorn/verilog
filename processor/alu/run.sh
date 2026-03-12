#!/bin/bash

iverilog -g2012 -Wall -o out/sim tb_alu.sv alu.sv 
vvp out/sim
gtkwave out/alu.vcd
