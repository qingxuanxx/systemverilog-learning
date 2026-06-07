class packet;

    bit [31:0] addr;
    
    // 在 class 内部只声明原型，加上 extern
    extern function new(bit [31:0] a);
    extern function void display();
    extern function bit check_addr();

endclass : packet

// 在 class 外部实现具体逻辑

function packet::new(bit [31:0] a);
    addr = a;
endfunction : new

function void packet::display();
    $display("Extern Display: addr = %0h", addr);
endfunction : display

function bit packet::check_addr();
    return (addr != 0);
endfunction : check_addr


module tb;

    initial begin
        
        packet p = new(32'hABCD);
        
        p.display();

        $display("check_addr = %0d", p.check_addr());
    end

endmodule
