// 小类：负责统计
class Statistics;
    time start_time;
    time end_time;

    function void start();
        start_time = $time;
        $display("[%0t] Stats: Transfer started", start_time);
    endfunction : start

    function void stop();
        end_time = $time;
        $display("[%0t] Stats: Transfer finished, duration = %0t", 
                end_time, end_time - start_time);
    endfunction : stop

endclass : Statistics

// 大类：包含小类
class Packet;
    bit [31:0] addr;
    Statistics stats; // 一个句柄，指向 Statistics 对象

    function new();
        addr = 32'h00;
        stats = new(); // 大类的构造函数里面，必须把小类的内部对象也 new 出来
    endfunction : new

    task do_transfer();
        stats.start(); // 调用小类的内部对象的方法

        #100;

        $display("[%0t] Packet: Data payload transferred (addr=0x%0h)", 
                $time, addr);

        #50;

        stats.stop(); // 调用小类的结束方法

    endtask : do_transfer

endclass : Packet

module tb;
    initial begin
        Packet p = new();

        #100;

        p.do_transfer(); // 通过大类的方法调用小类的方法

        #100;

        $finish;
    
    end

endmodule : tb