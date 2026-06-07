class packet;

    bit [31:0] addr;
    bit [7:0] data;

    // 带参数的构造函数，并且提供默认值
    // 参数名和成员变量同名，必须使用 this 指针来区分
    function new(bit [31:0] addr = 32'hFFFF, bit [7:0] data = 8'hAA);
        this.addr = addr; // this.addr 指成员变量，右边的 addr 是参数
        this.data = data;
    endfunction : new

    function void display();
        $display("Packet: addr = %0h, data = %0h", addr, data);
    endfunction : display

endclass : packet

module tb;
    initial begin

        packet p1, p2, p3;  // 声明句柄（此时指向 null）
        
        p1 = new(); // 使用默认参数创建对象实例
        p2 = new(32'hABCD); // 只指定 addr，data 使用默认值
        p3 = new(32'h1234, 8'h55); // 同时指定 addr 和 data

        p1.display(); // 输出默认值
        p2.display(); // 输出指定的 addr 和默认的 data
        p3.display(); // 输出指定的 addr 和 data

    end

endmodule : tb