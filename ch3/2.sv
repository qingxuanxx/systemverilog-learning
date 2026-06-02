// task vs function vs void
module task_function;

typedef enum {IDLE, RUN, STOP} state_e;

initial begin

    int sum;

    // 调用 task（可以耗时）
    $display("@%0t: 调用延时任务", $time);
    delay_ns(10); // 延时 10 个时间单位
    $display("@%0t: 延时任务完成", $time);

    // 调用 function（不能耗时，必须有返回值）
    sum = add(3, 5);
    $display("3 + 5 = %0d", sum);

    // 调用 void 函数（不能耗时，没有返回值，可以被函数调用）
    print_state(IDLE);

    $finish;

end

// task 可以有耗时操作，但是没有返回值
task delay_ns(int n);
    #n; // 延时 n 个时间单位
endtask : delay_ns // 子程序标签，给程序员看的，不是给电脑看的


// function 不能耗时，并且必须有返回值
// function 里不能调用 task（因为 task 能延时，function 不允许延时）
function int add(int a, int b);
    return a + b;
endfunction : add

// function void 没有返回值，不能耗时
// 支持被任务和函数调用
// typedef enum {IDLE, RUN, STOP} state_e;

function void print_state(state_e s);
    $display("当前状态：%0d / %s", s, s.name());
endfunction : print_state

endmodule