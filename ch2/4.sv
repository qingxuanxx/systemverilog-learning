module dynamic_array;

int arr[];
int arr_copy[];

initial begin
    // 分配 5 个元素
    arr = new[5];
    foreach(arr[i]) begin
        arr[i] = i + 1; // 初始化元素值
    end
    $display("初始数组：%p, 长度：%0d", arr, arr.size());

    // $display("sum: %d", sum(arr));
    $display("sum: %0d", arr.sum());

    // 扩容到 10 个元素，保留原数据
    arr = new[10](arr);
    for(int i = 5; i < arr.size(); i++) begin
        arr[i] = i + 1; // 初始化新元素值
    end
    $display("扩容后数组：%p, 长度：%0d", arr, arr.size());

    // 复制数组
    // int arr_copy[];
    arr_copy = arr;
    $display("复制数组：%p, 长度：%0d", arr_copy, arr_copy.size());

    // 删除所有元素
    arr.delete();
    $display("删除后数组：%p, 长度：%0d", arr, arr.size());

    $finish;

end

endmodule