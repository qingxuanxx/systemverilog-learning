`timescale 1ns/1ps

interface arb_if (input bit clk);

    logic [1:0] req, grant;
    logic rst;

    // 定义时钟块：规定同步信号在时钟沿附近的驱动/采样规则
    clocking cb @(posedge clk);

        default input #1step output #1ns; // 输入提前采样，输出延后驱动
        // 给 tb 用的，所以是 reg 输出，grant 输入
        output req;
        input grant;

    endclocking : cb

    modport dut (input req, rst, clk, output grant);

    // 异步信号 rst 不要放进 clocking block 里面
    modport tb (clocking cb, output rst);

endinterface : arb_if

// dut
module arb_cb (arb_if.dut bus);

    always_ff @(posedge bus.clk or posedge bus.rst)
    begin
        if (bus.rst)
            bus.grant <= 2'b00;
        else
            bus.grant <= bus.req; 
    end

endmodule : arb_cb

// tb
program automatic tb_cb (arb_if.tb bus);

    initial begin
        bus.rst = 1; // 异步信号，阻塞赋值（=），立刻生效
        bus.cb.req <= 0; // 同步信号，非阻塞赋值（<=）

        #20;
        bus.rst = 0; // 撤销复位信号
        
        @(bus.cb); // 等待时钟块事件
        bus.cb.req <= 2'b10;

        @(bus.cb); // DUT 在这个周期采到 req=2'b10，并更新 grant
        @(bus.cb); // TB 在这个周期才能通过 input #1step 采到更新后的 grant
        if (bus.cb.grant != 2'b10)
            $error("FAIL");
        else    
            $display("PASS");

        $finish;

    end

endprogram : tb_cb

module top;

    bit clk;

    initial clk = 0;
    always #5 clk = ~clk;

    arb_if u_if (.clk(clk));
    arb_cb u_dut (u_if);
    tb_cb u_tb (u_if);

endmodule : top