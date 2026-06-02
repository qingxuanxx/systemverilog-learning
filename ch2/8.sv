module enum_demo;

// 定义状态机枚举类型
typedef enum {IDLE, START, RUN, STOP} state_e;
state_e current_state; // 当前状态变量
state_e s;

initial begin
    // 初始化状态
    current_state = IDLE;
    $display("初始状态：%0d / %s", current_state, current_state.name());

    // 状态跳转
    current_state = current_state.next(); // 从 IDLE 跳转到 START
    $display("next()之后：%0d / %s", current_state, current_state.name());

    current_state = current_state.next(2); // 从 START 跳转到 STOP (跳过 RUN)
    $display("next(2)之后：%0d / %s", current_state, current_state.name()); 

    current_state = current_state.prev(); // 从 STOP 跳回 RUN
    $display("prev()之后：%0d / %s", current_state, current_state.name());

    // 遍历所有枚举值
    $display("枚举值列表：");
    // state_e s = state_e.first();
    s = s.first();
    do begin
        $display("  %0d / %s", s, s.name());
        s = s.next();
    end while (s != s.first()); // 环形绕回

    $finish;

end

endmodule