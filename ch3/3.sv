module subprogram_parameters;

initial begin
    int arr[];
    int sum;

    arr = new[10];
    foreach(arr[i]) begin
        arr[i] = i;
    end

    // 1.值传递
    sum = sum_array_value(arr);
    $display("数组元素的和（值传递）: %0d", sum);

    // 2.const ref 传递
    sum = sum_array_ref(arr);
    $display("数组元素的和（const ref 传递）: %0d", sum);

    // 3.ref 传递（可以修改原数组）
    increment_array(arr, 10); // 每个元素加 10
    $display("数组元素加 10 之后：%p", arr);

    // 4.默认参数
    print_range(arr); // 打印整个数组
    print_range(arr, 2); // 指定 start，end 使用默认值
    print_range(arr, 2, 5); // 指定 start and end 

    // 5.命名参数传递（不用考虑顺序）
    $display("\n== 命名参数传递 ==");
    print_range(.end_idx(7), .arr(arr), .start(3));


    $finish;

end

// 1.值传递: 数组被复制，大数组性能差
function int sum_array_value(input int arr[]);
    int sum = 0;
    foreach (arr[i]) begin
        sum += arr[i];
    end
    return sum;
endfunction : sum_array_value

// 2.const ref 传递: 数组通过引用传递，但不能修改
function int sum_array_ref(const ref int arr[]);
    int sum = 0;
    foreach (arr[i]) begin
        sum += arr[i];
    end
    return sum;
endfunction : sum_array_ref

// 3.ref 传递: 数组通过引用传递，可以修改
function void increment_array(ref int arr[], input int delta);
    foreach (arr[i]) begin
        arr[i] += delta;
    end
endfunction : increment_array

// 4. 默认参数
function void print_range(
    const ref int arr[],
    input int start = 0,
    input int end_idx = -1
);

    if (end_idx == -1)
        end_idx = arr.size() - 1;
    
    $display("arr[%0d:%0d] =", start, end_idx);
    for (int i = start; i <= end_idx; i++) begin
        // $display("%0d", arr[i]);
        $write("%0d ", arr[i]);
    end
    $display();
endfunction : print_range

endmodule