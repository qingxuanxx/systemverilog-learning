module return_statement;

initial begin
    int arr[];
    int idx;

    // 调用任务，错误时提前 return
    $display("== 调用任务，错误时提前 return ==");
    load_array(-5, arr); // 错误长度，任务会提前返回
    load_array(3, arr); // 正确长度

    // 调用函数，找到目标后提前 return
    $display("== 调用函数，找到目标后提前 return ==");
    idx = find_first(arr, 2); // 查找值为 2 的元素

    if (idx != -1) begin
        $display("找到目标元素，索引: %0d", idx);
    end else begin
        $display("没有找到目标元素");
    end

    $finish;

end

// 任务：错误时提前 return
task load_array(input int len, ref int arr[]);
    if (len <= 0) begin
        $display("长度必须大于 0");
        return; // 提前返回，避免继续执行
    end

    // 正常逻辑
    arr = new[len];
    foreach (arr[i]) begin
        arr[i] = i;
    end
    $display("数组加载完成: %p, 长度: %0d", arr, len);

endtask : load_array

// 函数：找到目标后提前 return
function int find_first(const ref int arr[], input int target);
    foreach (arr[i]) begin
        if (arr[i] == target) begin
            return i; // 找到目标，返回索引
        end
    end

    return -1; // 没有找到目标，返回 -1

endfunction : find_first

endmodule