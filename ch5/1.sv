class packet;

    bit [31:0] addr;
    bit [7:0] data;

    // 不带参数的构造函数
    function new();
        addr = 32'h0;
        data = 8'h0;
    endfunction : new

    function void display();
        $display("Packet: addr = %0h, data = %0h", addr, data);
    endfunction : display

endclass : packet

module tb;
    initial begin
        packet p1;  // 声明句柄（此时指向 null）
        p1 = new(); // 创建对象实例，p1 现在指向一个 Packet 对象
        p1.addr = 32'hABCD1234;
        p1.display(); 

    end

endmodule : tb
