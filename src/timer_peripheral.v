// Timer Peripheral Module
// NIELIT Workshop - Mini Project
// Counts from 0x0F down to 0x00 and generates interrupt

module timer_peripheral (
    input wire clk,
    input wire reset_n,
    
    // CPU interface
    input wire [15:0] addr,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    input wire write_enable,
    input wire read_enable,
    
    // Interrupt interface
    output reg interrupt,
    input wire interrupt_ack,
    
    // Status
    output wire ready,
    output wire [7:0] timer_count
);

    // Timer registers
    reg [7:0] count_reg;
    reg [7:0] load_value;
    reg timer_enable;
    reg interrupt_enable;
    reg interrupt_flag;
    reg [15:0] prescaler;
    reg [15:0] prescaler_counter;

    // Register addresses
    localparam TIMER_COUNT_REG = 16'h0000;  // Timer count register
    localparam TIMER_LOAD_REG  = 16'h0004;  // Timer load register  
    localparam TIMER_CTRL_REG  = 16'h0008;  // Timer control register
    localparam TIMER_CLEAR_REG = 16'h000C;  // Timer interrupt clear register
    localparam TIMER_STATUS_REG = 16'h0010; // Timer status register

    assign ready = 1'b1;
    assign timer_count = count_reg;

    // Timer counting logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count_reg <= 8'h0F;           // Start from 0x0F
            load_value <= 8'h0F;
            timer_enable <= 1'b1;         // Auto-enable timer
            interrupt_enable <= 1'b1;     // Auto-enable interrupts
            interrupt_flag <= 1'b0;
            prescaler <= 16'h00FF;        // Prescaler for slower counting
            prescaler_counter <= 16'h0000;
            interrupt <= 1'b0;
        end else begin
            // Prescaler logic for timing control
            if (timer_enable) begin
                if (prescaler_counter >= prescaler) begin
                    prescaler_counter <= 16'h0000;
                    
                    if (count_reg == 8'h00) begin
                        // Timer expired - generate interrupt and reload
                        interrupt_flag <= 1'b1;
                        if (interrupt_enable) begin
                            interrupt <= 1'b1;
                        end
                        count_reg <= load_value; // Reload timer
                    end else begin
                        // Decrement counter
                        count_reg <= count_reg - 1'b1;
                    end
                end else begin
                    prescaler_counter <= prescaler_counter + 1'b1;
                end
            end

            // Clear interrupt on acknowledgment
            if (interrupt_ack) begin
                interrupt <= 1'b0;
                interrupt_flag <= 1'b0;
            end
        end
    end

    // CPU register interface
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            data_out <= 32'h00000000;
        end else begin
            if (read_enable) begin
                case (addr)
                    TIMER_COUNT_REG: begin
                        data_out <= {24'h000000, count_reg};
                    end
                    
                    TIMER_LOAD_REG: begin
                        data_out <= {24'h000000, load_value};
                    end
                    
                    TIMER_CTRL_REG: begin
                        data_out <= {30'h00000000, interrupt_enable, timer_enable};
                    end
                    
                    TIMER_STATUS_REG: begin
                        data_out <= {31'h00000000, interrupt_flag};
                    end
                    
                    default: begin
                        data_out <= 32'h00000000;
                    end
                endcase
            end else if (write_enable) begin
                case (addr)
                    TIMER_LOAD_REG: begin
                        load_value <= data_in[7:0];
                    end
                    
                    TIMER_CTRL_REG: begin
                        timer_enable <= data_in[0];
                        interrupt_enable <= data_in[1];
                    end
                    
                    TIMER_CLEAR_REG: begin
                        if (data_in[0]) begin
                            interrupt <= 1'b0;
                            interrupt_flag <= 1'b0;
                        end
                    end
                    
                    default: begin
                        // Do nothing for unsupported addresses
                    end
                endcase
                data_out <= 32'h00000000;
            end else begin
                data_out <= 32'h00000000;
            end
        end
    end

endmodule
