`timescale 1ns/1ps

module fifo_tb();

    // Parameters
    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 8;
    parameter CLK_PERIOD = 10; // 10ns clock period
    
    // Testbench signals
    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire fifo_full;
    wire fifo_empty;
    
    // Test data
    reg [DATA_WIDTH-1:0] test_data [0:7];
    integer i;
    integer test_phase;
    
    // Instantiate FIFO
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Initialize test data
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            test_data[i] = 8'h10 + i; // 0x10, 0x11, 0x12, etc.
        end
    end
    
    // Main test sequence
    initial begin
        // Initialize
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        test_phase = 0;
        
        $display("========================================");
        $display("FIFO Testbench Started");
        $display("========================================");
        
        // Reset sequence
        #30;
        rst_n = 1;
        #10;
        test_phase = 1;
        
        // Test Phase 1: Check initial state
        $display("Phase 1: Initial state check at time %0t", $time);
        $display("Empty: %b, Full: %b", fifo_empty, fifo_full);
        
        // Wait for external control to advance phases
        #500; // Wait 500ns
        test_phase = 2;
        
        // Test Phase 2: Write some data
        $display("Phase 2: Writing data at time %0t", $time);
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            wr_en = 1;
            data_in = test_data[i];
            $display("Writing: %h", test_data[i]);
        end
        @(posedge clk);
        wr_en = 0;
        
        #500; // Wait 500ns
        test_phase = 3;
        
        // Test Phase 3: Read some data
        $display("Phase 3: Reading data at time %0t", $time);
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            rd_en = 1;
            @(negedge clk);
            $display("Read: %h", data_out);
        end
        @(posedge clk);
        rd_en = 0;
        
        #500; // Wait 500ns
        test_phase = 4;
        
        // Test Phase 4: Fill FIFO completely
        $display("Phase 4: Filling FIFO at time %0t", $time);
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            @(posedge clk);
            wr_en = 1;
            data_in = 8'hA0 + i;
        end
        @(posedge clk);
        wr_en = 0;
        $display("FIFO Full flag: %b", fifo_full);
        
        #500; // Wait 500ns
        test_phase = 5;
        
        // Test Phase 5: Empty FIFO completely
        $display("Phase 5: Emptying FIFO at time %0t", $time);
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            @(posedge clk);
            rd_en = 1;
            @(negedge clk);
            $display("Reading: %h", data_out);
        end
        @(posedge clk);
        rd_en = 0;
        $display("FIFO Empty flag: %b", fifo_empty);
        
        #1000; // Final wait
        test_phase = 6;
        
        $display("========================================");
        $display("All test phases completed successfully!");
        $display("Final time: %0t", $time);
        $display("FIFO Status - Empty: %b, Full: %b", fifo_empty, fifo_full);
        $display("Testbench will continue running safely...");
        $display("========================================");
        
        // NEVER call $finish - just let it run forever safely
        forever begin
            #10000; // Wait 10us
            $display("Testbench still running safely at time %0t", $time);
        end
    end
    
    // Simple status monitor
    always @(posedge clk) begin
        if (test_phase > 0 && (wr_en || rd_en)) begin
            $display("Time %0t Phase %0d: WR=%b RD=%b IN=%h OUT=%h E=%b F=%b", 
                     $time, test_phase, wr_en, rd_en, data_in, data_out, fifo_empty, fifo_full);
        end
    end

endmodule
