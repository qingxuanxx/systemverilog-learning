module time_demo;

    timeunit 1ns; // 定义时间单位为 1 纳秒
    timeprecision 1ps; // 定义时间精度为 1 皮秒

initial begin
    // 格式化时间打印
    $timeformat(-9, 3, "ns", 8);

    $display("@%t: 开始仿真", $realtime);

    #1.5ns;

    $display("@%t: 延时 1.5ns", $realtime);

    #200ps;
    $display("@%t: 延时 200ps", $realtime);

    // $time vs $realtime
    $display("$time = %0t, $realtime = %0t", $time, $realtime);

    $finish;
end

endmodule