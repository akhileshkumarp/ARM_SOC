// Simplified ARM Cortex M0 Model
// NIELIT Workshop - Mini Project

module arm_cortex_m0 (
    input wire clk,
    input wire reset_n,
    
    // Memory interface
    output reg [31:0] addr,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    output reg write_enable,
    output reg read_enable,
    
    // Interrupt interface
    input wire interrupt,
    output reg interrupt_ack
);

    // CPU states
    localparam RESET        = 3'b000;
    localparam FETCH        = 3'b001;
    localparam DECODE       = 3'b010;
    localparam EXECUTE      = 3'b011;
    localparam INTERRUPT    = 3'b100;
    localparam INT_SERVICE  = 3'b101;

    reg [2:0] cpu_state;
    reg [2:0] next_state;
    reg [31:0] pc;          // Program counter
    reg [31:0] instruction; // Current instruction
    reg [31:0] registers [0:15]; // Register file
    reg interrupt_pending;
    reg [7:0] delay_counter;
    reg interrupt_serviced;

    // Interrupt service routine addresses
    localparam TIMER_BASE_ADDR = 32'h40000000;
    localparam LED_BASE_ADDR   = 32'h40010000;
    localparam RAM_BASE_ADDR   = 32'h20000000;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            cpu_state <= RESET;
            pc <= 32'h00000000;
            addr <= 32'h00000000;
            data_out <= 32'h00000000;
            write_enable <= 1'b0;
            read_enable <= 1'b0;
            interrupt_ack <= 1'b0;
            interrupt_pending <= 1'b0;
            delay_counter <= 8'h00;
            interrupt_serviced <= 1'b0;
        end else begin
            cpu_state <= next_state;
            
            case (cpu_state)
                RESET: begin
                    pc <= 32'h00000000;
                    write_enable <= 1'b0;
                    read_enable <= 1'b0;
                    interrupt_ack <= 1'b0;
                    interrupt_pending <= 1'b0;
                    delay_counter <= 8'h00;
                end
                
                FETCH: begin
                    // Check for interrupt
                    if (interrupt && !interrupt_serviced) begin
                        interrupt_pending <= 1'b1;
                    end
                    // Normal fetch operation
                    addr <= pc;
                    read_enable <= 1'b1;
                    write_enable <= 1'b0;
                end
                
                DECODE: begin
                    instruction <= data_in;
                    read_enable <= 1'b0;
                    pc <= pc + 4;
                end
                
                EXECUTE: begin
                    // Simple execution - mainly NOP for this demo
                    write_enable <= 1'b0;
                    read_enable <= 1'b0;
                end
                
                INTERRUPT: begin
                    // Acknowledge interrupt
                    interrupt_ack <= 1'b1;
                    interrupt_serviced <= 1'b1;
                    delay_counter <= 8'h00;
                end
                
                INT_SERVICE: begin
                    interrupt_ack <= 1'b0;
                    
                    case (delay_counter)
                        8'h00: begin
                            // Write 0xFF to LED
                            addr <= LED_BASE_ADDR;
                            data_out <= 32'h000000FF;
                            write_enable <= 1'b1;
                            delay_counter <= delay_counter + 1;
                        end
                        
                        8'h01: begin
                            // Write 0x55 to RAM first location
                            addr <= RAM_BASE_ADDR;
                            data_out <= 32'h00000055;
                            write_enable <= 1'b1;
                            delay_counter <= delay_counter + 1;
                        end
                        
                        8'h10: begin // Small delay
                            // Clear LED (write 0x00)
                            addr <= LED_BASE_ADDR;
                            data_out <= 32'h00000000;
                            write_enable <= 1'b1;
                            delay_counter <= delay_counter + 1;
                        end
                        
                        8'h11: begin
                            // Write 0x00 to RAM first location
                            addr <= RAM_BASE_ADDR;
                            data_out <= 32'h00000000;
                            write_enable <= 1'b1;
                            delay_counter <= delay_counter + 1;
                        end
                        
                        8'h12: begin
                            // Clear timer interrupt
                            addr <= TIMER_BASE_ADDR + 4; // Clear register
                            data_out <= 32'h00000001;
                            write_enable <= 1'b1;
                            delay_counter <= delay_counter + 1;
                        end
                        
                        8'h20: begin
                            // Return to normal operation
                            write_enable <= 1'b0;
                            interrupt_serviced <= 1'b0;
                            interrupt_pending <= 1'b0;
                        end
                        
                        default: begin
                            write_enable <= 1'b0;
                            delay_counter <= delay_counter + 1;
                        end
                    endcase
                end
            endcase
        end
    end

    // State machine logic
    always @(*) begin
        case (cpu_state)
            RESET:      next_state = FETCH;
            FETCH:      next_state = interrupt_pending ? INTERRUPT : DECODE;
            DECODE:     next_state = EXECUTE;
            EXECUTE:    next_state = FETCH;
            INTERRUPT:  next_state = INT_SERVICE;
            INT_SERVICE: next_state = (delay_counter >= 8'h20) ? FETCH : INT_SERVICE;
            default:    next_state = RESET;
        endcase
    end

endmodule
