class Packet;
    int id;
    
    function new(int i);
        id = i;
    endfunction : new

endclass : Packet

// 没有 ref
function void create_wrong(Packet p);
    p = new(1); // 只是修改了局部变量 p，外部的句柄还是 null
endfunction : create_wrong

// 有 ref
function void create_right(ref Packet p);
    p = new(2); // 修改了外部传入的句柄
endfunction : create_right

module tb;

    initial begin
        Packet p1, p2;

        create_wrong(p1);
        if (p1 == null)
            $display("p1 is still null");

        create_right(p2);
        if (p2 != null)
            $display("p2 created successfully, id = %0d", p2.id);

        begin
            // 垃圾回收
            Packet p3 = new(3); // 创建对象 A

            p3 = new(4); // 创建对象 B，此时对象 A 没有任何句柄指向它，自动被回收

            p3 = null; // 对象 B 也失去了引用，没有任何句柄指向它，自动被回收

            $display("Memory automatically managed by SV Garbage Collector");
        end
        
    end

endmodule : tb