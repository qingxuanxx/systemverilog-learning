module array_packed_unpacked;

// 非合并数组
bit [7:0] unpacked_data [3];
// 合并数组
bit [2:0][7:0] packed_data;

initial begin
// 非合并数组赋值
unpacked_data[0] = 8'hAA;
unpacked_data[1] = 8'hBB;
unpacked_data[2] = 8'hCC;

// 合并数组赋值
packed_data = 24'hD0E0F0;

$display("== 非合并数组 ==");
foreach(unpacked_data[i])
begin
    $display("unpacked_data[%0d] = %h", i, unpacked_data[i]);
    $display("第 0 位：%b", unpacked_data[i][0]);
    $display("高 4 位：%b", unpacked_data[i][7:4]);
end

$display("== 合并数组 ==");
$display("整体值：%h", packed_data);
foreach(packed_data[i])
begin
    $display("packed_data[%0d] = %h", i, packed_data[i]);
    $display("第 7 位：%b", packed_data[i][7]);
end

$finish;

end

endmodule