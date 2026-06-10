`timescale 1ns/1ps

interface arb_if (input bit clk);

    logic req, ack, rst;

    clocking cb @(posedge clk);

        // 给 tb 用的
        output req;
        input ack;

    endclocking : cb

    modport dut (input req, rst, clk, output ack);
    modport tb (clocking cb, output rst);
    modport mon (input req, ack, rst, clk); // moniter 只读

    // 并发断言：req 拉高后，1-3个周期内必须出现 ack
    property p_req_ack;

        @(posedge clk)
            disable iff (rst) // 核心规范：复位期间必须禁用断言

        // 只要 req 变高了，那么在接下来1-3个时钟周期里，ack 必须至少变高一次
        req |-> ##[1:3] ack;  
        // |->：这是一个特殊的箭头，叫重叠蕴含操作符。
        // 它的意思是：“如果前面的条件发生了，那么后面的事情必须发生”
        // ## 表示延时多少个时钟周期
        // [1:3] 表示一个范围：1 到 3 个周期
        // ack：表示 ack 信号必须为高

    endproperty : p_req_ack

    // 将断言直接绑定在接口上，所有使用该接口的 DUT 都会自动受保护
    a_req_ack: assert property(p_req_ack) // 启动我们在上面定义的 p_req_ack 规则进行实时监控
        else $error ("SVA Fail: req has no ack!"); 

endinterface : arb_if 

// dut
module dut_sva (arb_if.dut bus);

    logic [1:0] cnt;
    always_ff @(posedge bus.clk or posedge bus.rst)
    begin
        if (bus.rst)
        begin
            bus.ack <= 0;
            cnt <= 0;
        end
        else if (bus.req)
        begin
            bus.ack <= 0;
            cnt <= 2;
        end
        else if (cnt > 0)
        begin
            cnt <= cnt - 1;
            if (cnt == 1)
                bus.ack <= 1; 
        end
        else
            bus.ack <= 0;
    end

endmodule : dut_sva

// moniter
module moniter(arb_if.mon bus);

    always @(posedge bus.clk)
        if (!bus.rst)
            $display("[%0t] moniter: req = %b, ack = %b", 
                     $time, bus.req, bus.ack);

endmodule : moniter

// tb
program automatic tb_sva (arb_if.tb bus);

    initial begin
        bus.rst = 1;
        bus.cb.req <= 0;

        #20;
        bus.rst = 0;

        @(bus.cb);
        bus.cb.req <= 1; // 触发断言
        repeat (5) @(bus.cb);

        // @(bus.cb);
        // bus.cb.req <= 1; // req 拉高 1 个周期

        // @(bus.cb);
        // bus.cb.req <= 0; // 关键：拉低 req，让 DUT 进入 cnt 倒计时

        // repeat (5) @(bus.cb);

        $finish;

    end

endprogram : tb_sva

module top;

    bit clk;

    initial clk = 0;
    always #5 clk = ~clk;

    // 实例化
    arb_if u_if (.clk(clk));
    dut_sva u_dut(.bus(u_if));
    tb_sva u_tb(.bus(u_if));
    moniter u_mon(.bus(u_if));

endmodule : top