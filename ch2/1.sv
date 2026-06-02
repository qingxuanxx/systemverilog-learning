module logic_bit_demo;

// 用logic接受DUT输出
logic [7:0] dut_out;
// 用双状态变量接受（会丢失X/Z）
bit [7:0] data_bad;
// 用四状态变量接受（不会丢失X/Z）
logic [7:0] data_good;

assign data_bad = dut_out; // 可能丢失X/Z
assign data_good = dut_out; // 不会丢失X/Z

initial
begin
    // 生成波形文件
    $fsdbDumpfile("1_wave.fsdb");
    $fsdbDumpvars(0, logic_bit_demo);
end

initial 
begin
    // 模拟DUT输出
    dut_out = 8'b10101010; // 正常值
    #10;
    dut_out = 8'bZZZZZZZZ; // 高阻态
    #10;
    dut_out = 8'bXXXXXXXX; // 不确定态
    #10;
    $finish;
end

// 检测X/Z状态
always @(*) 
begin
    if ($isunknown(data_good))
    begin
        $display("@%0t: [GOOD] Found X/Z in data_good: %b", $time, data_good);
    end
    if ($isunknown(data_bad))
    begin
        $display("@%0t: [BAD] Found X/Z in data_bad: %b", $time, data_bad);
    end
end

endmodule