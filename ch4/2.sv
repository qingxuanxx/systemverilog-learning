`timescale 1ns/1ps

// 定义接口：将相关信号打包
interface arb_if(input bit clk);

    logic [1:0] req, grant;
    logic rst;

    // modport：定义不同视角的信号方向
    // dut 视角：req/rst 是输入，grant 是输出
    modport dut (input req, rst, clk, output grant);
    // tb 视角：req/rst 是输出，grant 是输入
    modport tb (output req, rst, input grant, clk);

endinterface : arb_if

// dut：端口列表直接传入接口，内部通过 bus.xx 来访问
module arb_mod(arb_if.dut bus);

    always_ff @(posedge bus.clk or posedge bus.rst)
    begin
        if (bus.rst)
            bus.grant <= 2'b00;
        else if (bus.req[0])
            bus.grant <= 2'b01;
        else if (bus.req[1])
            bus.grant <= 2'b10;
        else
            bus.grant <= 2'b00; 
    end

endmodule : arb_mod


// tb：使用相同的接口
module tb_mod(arb_if.tb bus);

    initial begin
        bus.rst = 1;
        bus.req = 0;
        #20 bus.rst = 0;

        @(posedge bus.clk); bus.req = 2'b10;
        // DUT 更新 grant 的时机，和 TB 检查 grant 的时机，
        // 撞在了同一个时间点（第 2 个时钟沿）
        @(posedge bus.clk);
        // #1;
        if (bus.grant != 2'b10)
            $error("Fail");
        else
            $display("Pass");

        $finish;

    end

endmodule : tb_mod

// 顶层：只是实例化一次接口，连线很简单
module top;

    bit clk;
    
    initial clk = 0;
    always #5 clk = ~clk;

    arb_if u_if (.clk(clk));
    arb_mod u_dut (u_if); // 将刚才创建的接口 u_if 直接传给它
    tb_mod u_tb (u_if);

endmodule : top 