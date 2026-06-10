`timescale 1ns/1ps

interface arb_if(input bit clk);

    logic [1:0] req, grant;
    logic rst;

    // modport：定义不同视角的信号方向
    // dut 视角：req/rst 是输入，grant 是输出
    modport dut (input req, rst, clk, output grant);
    // tb 视角：req/rst 是输出，grant 是输入
    modport tb (output req, rst, input grant, clk);

endinterface : arb_if

module arb_prog (arb_if.dut bus);

    // dut 在 active 区域执行
    always_ff @(posedge bus.clk or posedge bus.rst)
    begin
        if (bus.rst)
            bus.grant <= 2'b00;
        else 
            bus.grant <= bus.req;

        // 打印 dut 执行时的时间和 grant 的新值
        $display("[%0t] dut (active 区): grant 更新为 %b", 
                 $time, bus.grant);

    end

endmodule : arb_prog

// 使用 program automatic 代替 module 编写 TB
program automatic tb_prog(arb_if.tb bus);

    initial begin
        bus.rst = 1;
        bus.req = 0;
        #20 bus.rst = 0;

        @(posedge bus.clk); 
        bus.req = 2'b11;

        // 在时钟沿到来的时候，tb 在 reactive 区域执行
        @(posedge bus.clk); 
        // 此时读到的是时钟沿到来前的"旧值" (00)，
        // 避免了读到 DUT 刚写入的新值 (11)
        $display("[%0t] tb (Reactive区): 读取到 grant 为 %b", 
                 $time, bus.grant);

        $finish;

    end

endprogram : tb_prog
// program 块有一些限制（例如不能包含 always 块，不能实例化 module 等）
// 可以使用 module + clocking block 的组合来代替 program
// 因为 clocking block 也能提供类似的同步和防竞争机制，且灵活性更高

module top;

    bit clk;

    initial clk = 0;
    always #5 clk = ~clk;

    arb_if u_if(.clk(clk));
    arb_prog u_dut(u_if);
    tb_prog  u_tb(u_if);

endmodule : top