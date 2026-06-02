module assoc_array;

// 64 位地址索引的内存模型
bit [31:0] mem[bit [63:0]]; // 64 位地址，32 位数据
// 字符串索引的配置表
int config[string];
bit [63:0] addr; // 遍历用的地址变量

initial begin
    // 地址索引关联数组
    // 写入稀疏地址
    mem[64'h0000_0000_1000_0000] = 32'h12345678;
    mem[64'h0000_0000_2000_0000] = 32'h87654321;
    mem[64'h0000_0000_FFFF_0000] = 32'hAAAAAAAA;

    $display("== 内存模型 ==");
    $display("元素个数: %0d", mem.num());

    // first()/next() 遍历
    // bit [63:0] addr;
    if (mem.first(addr)) begin
        do begin
            $display("mem[%h] = %h", addr, mem[addr]);
        end while (mem.next(addr));
    end

    // 删除一个元素
    mem.delete(64'h0000_0000_2000_0000);
    $display("删除之后的元素个数：%0d", mem.num());

    // 字符串索引关联数组
    config["min_addr"] = 32'h0000_0000;
    config["max_addr"] = 32'hFFFF_FFFF;
    config["default_value"] = 32'h1000_0000;

    $display("== 配置表 ==");
    foreach(config[key]) begin
        $display("config[\"%s\"] = %h", key, config[key]);
    end

    // 检查配置是否存在
    if (!config.exists("timeout")) begin
        $display("配置项 'timeout' 不存在，使用默认值: %h", config["default_value"]);
    end

    $finish;

end

endmodule