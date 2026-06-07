class packet;

    bit [31:0] addr;

    // 静态变量：属于类本身，所有对象共享这一变量
    static int pkt_count = 0;

    function new();
        // 每次创建新对象，计数器 + 1
        pkt_count ++;
    endfunction : new

    // 静态方法：只能访问静态变量（pkt_count），不能访问普通的成员变量（addr）
    static function int get_count();
        return pkt_count;
    endfunction : get_count

endclass : packet

module tb;

    initial begin
        
        packet p1, p2;

        // 还没有创建对象的时候，就可以通过类名访问静态变量or方法
        $display("Initial count: %0d", packet::get_count());

        p1 = new();
        p2 = new();

        // 推荐这种写法，通过类名访问
        $display("After new: %0d", packet::pkt_count);

        // 不推荐下面这种写法，容易让人误会 pkt_count 是对象独有的属性
        $display("Via handle: %0d", p1.pkt_count);
    end

endmodule : tb
