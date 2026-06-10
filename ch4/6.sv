`timescale 1ns/1ps

// $unit 作用域，相当于全局参数
parameter int width = 2;
`define top_path $root.top

interface arb_if (input bit clk);

    logic [width-1:0] req, grant; // 使用全局参数
    logic rst;

    modport dut (input req, rst, clk, output grant);

    modport tb (output req, rst, input clk, grant);

endinterface : arb_if

module arb_implicit (arb_if.dut bus);

    always_ff @(posedge bus.clk or posedge bus.rst)
    begin
        if (bus.rst)
            bus.grant <= 2'b00;
        else
            bus.grant <= bus.req; 
    end

endmodule : arb_implicit

program automatic tb_implicit (arb_if.tb bus);

    initial begin
        bus.rst = 1;
        bus.req = 0;

        #20;
        bus.rst = 0;
        
        @(posedge bus.clk);
        bus.req <= 2'b11;
        
        @(posedge bus.clk);
        $display("Global width = %0d", width);
        // $root 绝对路径：从根目录开始寻址
        $display("Read via $root: grant = %b", `top_path.u_if.grant); // top 模块的 u_if 接口的 grant 变量

        $finish;

    end

endprogram : tb_implicit

module top;

    bit clk;
    logic dummy_sig; // 用于演示隐式连接

    initial clk = 0;
    always #5 clk = ~clk;

    arb_if u_if (.clk(clk));
    // 隐式连接 .* 自动连接同名类型的端口（如clk），
    // 对于 dummy_sig，子模块没有同名端口，所以它被闲置
    arb_implicit u_dut(.*, .bus(u_if));
    tb_implicit  u_tb (.*, .bus(u_if));
    // 接口端口必须显式连接！

endmodule : top