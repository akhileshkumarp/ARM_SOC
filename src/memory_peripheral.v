// Memory Peripheral Module (255x32 Single Port RAM)
// NIELIT Workshop - Mini Project
// Implements single port RAM with 255 locations of 32-bit data

module memory_peripheral (
    input wire clk,
    input wire reset_n,
    
    // CPU interface
    input wire [15:0] addr,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    input wire write_enable,
    input wire read_enable,
    
    // Status
    output wire ready
);

    // Single Port RAM - 255 locations x 32 bits
    reg [31:0] ram_memory [0:254];
    reg [7:0] ram_addr;
    integer i;  // Moved declaration to module level
    
    assign ready = 1'b1;

    // Address mapping (word-aligned addressing)
    always @(*) begin
        ram_addr = addr[9:2];  // Word-aligned addressing (divide by 4)
        if (ram_addr >= 8'd255) begin
            ram_addr = 8'd254;  // Clamp to maximum address
        end
    end

    // RAM read/write operations
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out <= 32'h00000000;
            // Initialize RAM to zero
            for (i = 0; i < 255; i = i + 1) begin
                ram_memory[i] <= 32'h00000000;
            end
        end else begin
            if (write_enable) begin
                // Write operation
                ram_memory[ram_addr] <= data_in;
                data_out <= 32'h00000000;  // Write doesn't return data
            end else if (read_enable) begin
                // Read operation
                data_out <= ram_memory[ram_addr];
            end else begin
                data_out <= 32'h00000000;
            end
        end
    end

    // Debug: Allow inspection of first few memory locations
    wire [31:0] mem_loc_0 = ram_memory[0];
    wire [31:0] mem_loc_1 = ram_memory[1];
    wire [31:0] mem_loc_2 = ram_memory[2];
    wire [31:0] mem_loc_3 = ram_memory[3];

endmodule
