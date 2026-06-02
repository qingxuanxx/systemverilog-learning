module queue_demo;

int q[$] = {1, 3, 5, 7, 9, 2, 4, 6, 8, 10, 7, 3};
int tq[$];
int idx[$];
int sum_gt5;

// initial begin
//     $fsdbDumpfile("5_wave.fsdb");
//     $fsdbDumpvars(0, queue_demo);
// end

initial begin
    $display("初始队列：%p, 长度：%0d", q, q.size());

    // 1.双端操作
    q.push_front(0);
    q.push_back(11);
    $display("双端操作后队列：%p, 长度：%0d", q, q.size());

    // 2.切片操作
    tq = q[2:5]; // 切片：从索引2到5（包含）
    $display("切片操作后子队列：%p, 长度：%0d", tq, tq.size());

    // 3.数字定位方法
    tq = q.find with (item > 5); // 查找所有大于5的元素
    $display("所有大于 5 的元素: %p", tq);

    tq = q.find_first with (item == 7); // 查找第一个等于7的元素
    $display("第一个等于 7 的元素: %p", tq);

    idx = q.find_index with (item == 7); // 查找所有等于7的元素的索引
    $display("所有等于 7 的元素的索引: %p", idx);

    tq = q.unique(); // 去重
    $display("去重后的队列：%p, 长度：%0d", tq, tq.size());

    $display("最小值: %0d, 最大值: %0d", q.min()[0], q.max()[0]);

    // 4.带条件的 sum
    // sum_gt5 = q.sum with (item > 5);  
    // 只统计大于 5 的元素个数（item > 5 是 1bit 布尔，真 = 1 假 = 0）
    sum_gt5 = q.sum with (item > 5 ? item : 0);
    $display("所有大于 5 的元素的和: %0d", sum_gt5);

    $finish;
end

endmodule