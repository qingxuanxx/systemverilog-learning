module process_statements;

initial begin: main_block // 块标签

int j; // 普通变量声明放在 begin-end 块最前面

// 1.for 循环内部定义变量，作用域仅限于循环体
for (int i = 0; i < 10; i++) begin
    // $write("i = %0d ", i); // $display 会自动换行，$write 不会
    $display("i = %0d", i); 
end
$display("\n"); // 输出换行

// 2.break and continue
$display("== break and continue ==");
for (int i = 0; i <= 10; i ++) begin
    if (i == 5) continue; // 跳过 i=5 的输出
    if (i == 8) break; // 当 i=8 时退出循环
    // $write("i = %0d ", i);
    $display("i = %0d", i);
end
$display("\n"); // 输出换行

// 3.do-while 循环
$display("\n== do-while loop ==");
// int j = 0;
j = 0; // j 的声明在 main_block 块的开头，这里只是赋值
do begin
    // $write("j = %0d ", j);
    $display("j = %0d", j);
    j++;
end while (j < 5);
$display("\n");

$finish;

end 

endmodule
