`include "cpu.v"

`timescale 1ns/100ps

module testbench_cpu();

    // Signals for clock and reset
    reg CLK;
    reg RESET;

    // Instantiate the CPU module
    cpu CPU (CLK, RESET);

    // Add GTKWave signals
    initial begin
        $dumpfile("cpu_simulation.vcd");
        $dumpvars(0, testbench_cpu);
    end

    initial
		begin
			#1500 $finish;//finish the program after 100 time
		end

    // Clock generation
    always begin
        #4 CLK = ~CLK; // Toggle the clock every 5 time units
    end

    // Test sequence
    initial begin
        CLK = 0;
        RESET = 1;
        #1 RESET = 0;
    end
endmodule
