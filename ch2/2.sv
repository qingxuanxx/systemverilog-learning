module assoc_addr_demo;
  // 声明：key是64位bit向量（地址），value是64位bit向量（数据）
  bit [63:0] assoc[bit[63:0]];
  bit [63:0] idx = 1; // 初始地址

  // initial begin
  //   // 生成波形文件
  //   $fsdbDumpfile("2_wave.fsdb");
  //   $fsdbDumpvars(0, assoc_addr_demo);
  // end

  initial begin
    // 写入稀疏的地址：1,2,4,8,...,2^63，共64个元素
    repeat(64) begin
      assoc[idx] = idx; // 地址=数据，模拟内存写入
      idx = idx << 1;   // 地址左移1位，下一个地址
    end

    // 1. 用foreach遍历（最简单）
    $display("=== foreach 遍历 ===");
    foreach(assoc[i]) begin
      $display("assoc[%h] = %h", i, assoc[i]);
    end

    // 2. 用first()/next()遍历（书上的方法）
    $display("\n=== first/next 遍历 ===");
    if (assoc.first(idx)) begin
      do begin
        $display("assoc[%h] = %h", idx, assoc[idx]);
      end while (assoc.next(idx));
    end

    // 3. 删除第一个元素
    assoc.first(idx);
    assoc.delete(idx);
    $display("\nAfter delete first element, elements count: %0d", assoc.num());

    $finish;
  end
endmodule