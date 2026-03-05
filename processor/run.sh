#!/bin/bash

iverilog -g2012 -Wall -o out/sim alu/tb_alu.sv alu/alu.sv
vvp out/sim
gtkwave out/alu.vcd
