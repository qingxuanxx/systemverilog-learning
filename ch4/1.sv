`timescale 1ns/1ps

// 待测设计（DUT）：简单的 2 路优先级仲裁器

module arb_trad(
    output logic [1:0] grant, // 授权信号
    input logic [1:0] req, // 请求信号
    input logic rst, // 异步复位信号
    input logic clk // 时钟信号
);

    // always_ff：专用于描述时序逻辑（如触发器、寄存器），
    // 强制要求使用时钟沿触发和非阻塞赋值 (<=)
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst)
            grant <= 2'b00;
        else if (req[0])
            grant <= 2'b01; // req[0] 优先级高
        else if (req[1])
            grant <= 2'b10;
        else
            grant <= 2'b00;
    end

endmodule : arb_trad

// 测试平台（TB）：使用普通 module 编写
module tb_trad(
    input logic [1:0] grant, 
    output logic [1:0] req,
    output logic rst,
    input logic clk
);

    initial begin
        rst = 1;
        req = 0;

        #20 rst = 0;
        @(posedge clk); req = 2'b01; // 极易引发竞争冒险
        @(posedge clk);
        // #1; // <--- 等 1ns，让 DUT 的触发器完成翻转（解决竞争冒险）
        if (grant != 2'b01)
            $error("Fail");
        else
            $display("Pass");

        $finish;

    end

endmodule : tb_trad

// 顶层模块
module top;
    logic [1:0] grant, req;
    logic rst;
    // logic clk;
    bit clk; // 时钟只有0/1，用 bit 提升仿真速度

    initial clk = 0;

    always #5 clk = ~clk;

    arb_trad u_dut(
        .grant(grant), 
        .req(req),
        .rst(rst), 
        .clk(clk)
    );

    tb_trad  u_tb(
        .grant(grant), 
        .req(req), 
        .rst(rst), 
        .clk(clk)
    );

endmodule : top