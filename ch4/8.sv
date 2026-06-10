`timescale 1ns/1ps

interface arb_if (input bit clk);

    logic [1:0] req, grant;
    logic rst;

    modport dut (input req, rst, clk, output grant);

    modport tb (input grant, clk, output req, rst);

endinterface : arb_if 

module arb_final (arb_if.dut bus);

    always_ff @(posedge bus.clk or posedge bus.rst)
        if (bus.rst)
            bus.grant <= 0;
        else
            bus.grant <= bus.req;

endmodule : arb_final

program automatic tb_final (arb_if.tb bus);

    int pass_cnt = 0, fail_cnt = 0;

    initial begin
        bus.rst = 1;
        bus.req = 0;

        #20;
        bus.rst = 0;

        repeat (5)
        begin
            @(posedge bus.clk)
            // $urandom_range(max, min);
            // 返回值：一个 32 位无符号整数，范围在 [min, max] 之间
            bus.req = $urandom_range(0, 3);

            @(posedge bus.clk);
            if (bus.grant == bus.req)
                pass_cnt ++;
            else
                fail_cnt ++;
        end

        $display("tb initial 块执行完毕，准备自动退出");
        // 注意：program 块中所有 initial 块执行完后，会自动调用 $finish
    end

    // final 块：在仿真真正结束前（$finish 触发后）执行
    // 适合用来打印最终的测试总结报告
    final begin
        $display("==============================");
        $display("       仿真测试总结报告       ");
        $display("==============================");
        $display("Pass: %0d, Fail: %0d", pass_cnt, fail_cnt);
        if (fail_cnt == 0)
            $display("Result: PASS");
        else
            $display("Result: FAIL");
    end

endprogram : tb_final


module top;

    bit clk;

    initial clk = 0;
    always #5 clk = ~clk;

    arb_if u_if (.clk(clk));
    arb_final u_dut (.bus(u_if));
    tb_final u_tb (.bus(u_if));

    // 顶层不需要写 $finish，program 会自动接管仿真结束

endmodule : top