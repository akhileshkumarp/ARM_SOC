// ARM Cortex M0 Based SoC Top Module
// NIELIT Workshop - Mini Project
// Author: Workshop Participant

module soc_top (
    input wire clk,
    input wire reset_n,
    
    // External LED outputs
    output wire [7:0] led_out,
    
    // External signals for debugging
    output wire timer_interrupt,
    output wire [7:0] timer_count,
    output wire [31:0] ram_data_out,
    output wire [7:0] ram_addr_debug
);

    // Internal signals
    wire [31:0] cpu_addr;
    wire [31:0] cpu_data_in;
    wire [31:0] cpu_data_out;
    wire cpu_write_enable;
    wire cpu_read_enable;
    wire cpu_interrupt_ack;
    
    // Peripheral select signals
    wire timer_select;
    wire led_select;
    wire ram_select;
    
    // Timer signals
    wire [31:0] timer_data_out;
    wire timer_ready;
    
    // LED/GPIO signals  
    wire [31:0] led_data_out;
    wire led_ready;
    
    // RAM signals
    wire [31:0] ram_data_out_int;
    wire ram_ready;
    
    // Address decoding
    assign timer_select = (cpu_addr[31:16] == 16'h4000);  // Timer at 0x40000000
    assign led_select   = (cpu_addr[31:16] == 16'h4001);  // LED at 0x40010000  
    assign ram_select   = (cpu_addr[31:16] == 16'h2000);  // RAM at 0x20000000
    
    // Data multiplexing
    assign cpu_data_in = timer_select ? timer_data_out :
                        led_select   ? led_data_out :
                        ram_select   ? ram_data_out_int :
                        32'h00000000;

    // ARM Cortex M0 Processor Instance
    arm_cortex_m0 cpu_inst (
        .clk(clk),
        .reset_n(reset_n),
        .addr(cpu_addr),
        .data_in(cpu_data_in),
        .data_out(cpu_data_out),
        .write_enable(cpu_write_enable),
        .read_enable(cpu_read_enable),
        .interrupt(timer_interrupt),
        .interrupt_ack(cpu_interrupt_ack)
    );

    // Timer Peripheral Instance
    timer_peripheral timer_inst (
        .clk(clk),
        .reset_n(reset_n),
        .addr(cpu_addr[15:0]),
        .data_in(cpu_data_out),
        .data_out(timer_data_out),
        .write_enable(cpu_write_enable & timer_select),
        .read_enable(cpu_read_enable & timer_select),
        .interrupt(timer_interrupt),
        .interrupt_ack(cpu_interrupt_ack),
        .ready(timer_ready),
        .timer_count(timer_count)
    );

    // LED/GPIO Peripheral Instance
    led_gpio_peripheral led_inst (
        .clk(clk),
        .reset_n(reset_n),
        .addr(cpu_addr[15:0]),
        .data_in(cpu_data_out),
        .data_out(led_data_out),
        .write_enable(cpu_write_enable & led_select),
        .read_enable(cpu_read_enable & led_select),
        .led_out(led_out),
        .ready(led_ready)
    );

    // Memory Peripheral Instance (255x32 Single Port RAM)
    memory_peripheral ram_inst (
        .clk(clk),
        .reset_n(reset_n),
        .addr(cpu_addr[15:0]),
        .data_in(cpu_data_out),
        .data_out(ram_data_out_int),
        .write_enable(cpu_write_enable & ram_select),
        .read_enable(cpu_read_enable & ram_select),
        .ready(ram_ready)
    );

    // Debug outputs
    assign ram_data_out = ram_data_out_int;
    assign ram_addr_debug = cpu_addr[7:0];

endmodule
