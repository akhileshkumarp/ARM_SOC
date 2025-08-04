// LED/GPIO Peripheral Module
// NIELIT Workshop - Mini Project
// Controls LED outputs based on CPU writes

module led_gpio_peripheral (
    input wire clk,
    input wire reset_n,
    
    // CPU interface
    input wire [15:0] addr,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    input wire write_enable,
    input wire read_enable,
    
    // LED outputs
    output reg [7:0] led_out,
    
    // Status
    output wire ready
);

    // LED/GPIO registers
    reg [7:0] led_data_reg;
    reg [7:0] led_direction_reg;  // 1 = output, 0 = input
    reg [7:0] led_input_reg;      // For reading input pins

    // Register addresses
    localparam LED_DATA_REG = 16'h0000;      // LED data register
    localparam LED_DIR_REG  = 16'h0004;      // LED direction register
    localparam LED_INPUT_REG = 16'h0008;     // LED input register (read-only)

    assign ready = 1'b1;

    // LED output logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            led_data_reg <= 8'h00;
            led_direction_reg <= 8'hFF;    // All pins as output by default
            led_out <= 8'h00;
        end else begin
            // Update LED outputs based on direction and data
            led_out <= led_data_reg & led_direction_reg;
        end
    end

    // CPU register interface
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out <= 32'h00000000;
            led_input_reg <= 8'h00;
        end else begin
            if (read_enable) begin
                case (addr)
                    LED_DATA_REG: begin
                        data_out <= {24'h000000, led_data_reg};
                    end
                    
                    LED_DIR_REG: begin
                        data_out <= {24'h000000, led_direction_reg};
                    end
                    
                    LED_INPUT_REG: begin
                        // In a real implementation, this would read external pins
                        // For simulation, we'll just return the current output
                        data_out <= {24'h000000, led_out};
                    end
                    
                    default: begin
                        data_out <= 32'h00000000;
                    end
                endcase
            end else if (write_enable) begin
                case (addr)
                    LED_DATA_REG: begin
                        led_data_reg <= data_in[7:0];
                    end
                    
                    LED_DIR_REG: begin
                        led_direction_reg <= data_in[7:0];
                    end
                    
                    default: begin
                        // Do nothing for read-only or unsupported addresses
                    end
                endcase
                data_out <= 32'h00000000;
            end else begin
                data_out <= 32'h00000000;
            end
        end
    end

endmodule
