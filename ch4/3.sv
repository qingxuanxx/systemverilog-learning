`timescale 1ns/1ps

interface arb_if (input bit clk);

    logic [1:0] req, grant;
    logic rst;

    // 封装 task：将“发送请求并且检查”的底层操作封装成为 api（给 tb 使用）
    task automatic send_and_check (
        input logic [1:0] r, 
        input logic [1:0] exp
    );

    @(posedge clk);
    req <= r;
    @(posedge clk);
    #1step; // <-- 解决竞争冒险
    if (grant != exp) // !==
        $error("Fail: req=%b, grant=%b, exp=%b", r, grant, exp);
    else
        $display("Pass: req=%b, grant=%b", r, grant);

    endtask : send_and_check

    modport dut (input req, rst, clk, output grant);

    // tb 视角不仅要定义方向，还要 import 接口中的 task
    modport tb (output req, rst, input grant, clk, import send_and_check);

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

// tb：直接调用 api
module tb_mod (arb_if.tb bus);

    initial begin
        bus.rst = 1;
        bus.req = 0;
        #20 bus.rst = 0;

        // 像调用函数一样驱动和检查
        bus.send_and_check(2'b01, 2'b01);
        bus.send_and_check(2'b10, 2'b10);
        bus.send_and_check(2'b11, 2'b01);

        $finish;

    end

endmodule : tb_mod

module top;

    bit clk;
    
    initial clk = 0;
    always #5 clk = ~clk;

    arb_if u_if(.clk(clk));
    arb_mod u_dut(u_if);
    tb_mod u_tb(u_if);

endmodule : top