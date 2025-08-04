// Circuit Simulation Lab:19 - Design of FIFO
// 8-bit FIFO Implementation

module fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 8,
    parameter ADDR_WIDTH = 3  // log2(FIFO_DEPTH)
)(
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire fifo_full,
    output wire fifo_empty
);

    // Internal memory array
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
    
    // Pointers
    reg [ADDR_WIDTH:0] wr_ptr;  // Extra bit for full/empty detection
    reg [ADDR_WIDTH:0] rd_ptr;  // Extra bit for full/empty detection
    
    // Status flags
    assign fifo_empty = (wr_ptr == rd_ptr);
    assign fifo_full = ((wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]) && 
                        (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]));
    
    // Write operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !fifo_full) begin
            fifo_mem[wr_ptr[ADDR_WIDTH-1:0]] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end
    
    // Read operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
            data_out <= 0;
        end else if (rd_en && !fifo_empty) begin
            data_out <= fifo_mem[rd_ptr[ADDR_WIDTH-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end
    
    // Initialize memory (for simulation)
    integer i;
    initial begin
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            fifo_mem[i] = 8'h00;
        end
    end

endmodule
