class Statistics;
    int count;
    
    function new();
        count = 0;
    endfunction : new

    function void copy(Statistics src);
        this.count = src.count; // 递归深拷贝内部对象
        // 递归：Packet 大类 -> Statistics 小类 -> 内部对象 count
    endfunction : copy

endclass : Statistics

class Packet;
    bit [31:0] addr;
    Statistics stats;

    function new();
        stats = new(); // 大类的构造函数里面，必须把小类的内部对象也 new 出来
    endfunction : new

    // 自定义深拷贝方法
    function void copy(Packet src);
        this.addr = src.addr;
        // 不能直接 this.stats = src.stats，这是浅拷贝句柄
        // 必须调用内部对象的 copy 方法（递归调用）
        this.stats.copy(src.stats);
        // 递归：Packet 大类的 src -> Statistics 小类的 stats 
        //                        -> 内部对象的 count
    endfunction : copy

endclass : Packet

module tb;
    initial begin
        Packet p1 = new();

        p1.addr = 32'hABCD;
        p1.stats.count = 11;

        begin
            // 浅拷贝（错误做法）
            Packet p2;
            
            p2 = p1; // 只复制了句柄，指向同一内存
            p2.stats.count = 99;
            
            $display("p1 count after copy: %0d", p1.stats.count);
        end
        
        begin
            // 深拷贝（正确做法）
            Packet p3 = new(); // 先分配新内存
            
            p3.copy(p1); // 再复制数据，而不是句柄
            p3.stats.count = 55;

            // 注意：此时 p1 的值早就被上面的浅拷贝改成 99 了，而不是 11
            $display("p1 count after copy: %0d", p1.stats.count);
        end

    end

endmodule : tb