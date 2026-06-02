module automatic_demo;

initial begin
    $display("== 不加 automatic 的任务 ==");
    fork
        print_num_no_auto(1);
        print_num_no_auto(2);
        print_num_no_auto(3);
    join

    $display("\n== 加 automatic 的任务 ==");
    fork
        print_num_auto(1);
        print_num_auto(2);
        print_num_auto(3);
    join

    $display("\n== 局部变量初始化 ==");
    repeat (3) begin
        count_no_auto();
    end
    repeat (3) begin
        count_auto();
    end
end

// 不加 automatic: 所有调用共享同一份变量
task print_num_no_auto(int num);
    #10;
    $display("num = %0d", num);
endtask : print_num_no_auto

// 加 automatic: 每次调用都有独立的变量
task automatic print_num_auto(int num);
    #10;
    $display("num = %0d", num);
endtask : print_num_auto

// 不加 automatic: 初始化只执行一次
task count_no_auto();
    int count = 0; // 只初始化一次，后续调用会继续使用上次的值
    count++;
    #10;
    $display("count_no_auto = %0d", count);
endtask : count_no_auto

// 加 automatic: 每次调用都会重新初始化
task automatic count_auto();
    int count = 0; // 每次调用都会初始化，互不干扰
    count++;
    #10;
    $display("count_auto = %0d", count);
endtask : count_auto

endmodule