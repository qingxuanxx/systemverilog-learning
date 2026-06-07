class packet;

    // public : 任何地方都可以访问
    bit [31:0] addr;

    // protected : 仅本类以及子类可以访问
    protected bit [15:0] crc;

    // local : 仅本类内部可以访问
    local string str;

    function new();
        str = "INIT";
    endfunction : new

    // 提供一个 public 接口来修改 protected/local 变量
    function void set_data(bit [7:0] d);
        // 内部可以随便访问 protected/local 变量
        crc = d ^ 16'hFFFF;
        str = "DATA_SET";
    endfunction : set_data

    // 不能直接写 p.crc，而要写 get_crc() 函数
    // 这是因为 crc 是 protected 成员，外部无法直接访问
    // 而使用 get_crc() 函数，在 class 内部可以随便调用
    function bit [15:0] get_crc();
        return crc;
    endfunction : get_crc

endclass : packet

module tb;

    initial begin
        
        packet p = new();

        p.addr = 32'hABCD;

        // p.crc = 8'hAA; 不行，crc 是 protected
        p.set_data(8'hAA); // 通过 public 方法修改内部状态

        $display("CRC : %0h", p.get_crc());

    end

endmodule