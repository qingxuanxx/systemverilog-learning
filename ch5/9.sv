// 这段代码是 AI 写的，不是我手敲的

// 【关键前提】：SV 的流操作符不能直接作用于普通的 class。
// 必须借助 `struct packed` (打包结构体) 作为中间媒介。
typedef struct packed {
    bit [31:0] addr;
    bit [15:0] crc;
    bit [ 7:0] cmd;
} packet_struct_t; // 总共 56 bits

class Packet;
    // 类成员变量 (未打包，独立存在)
    bit [31:0] addr;
    bit [15:0] crc;
    bit [ 7:0] cmd;
    
    // 字节数组 (用于和 DUT 接口交互，假设每次传 8 bits)
    byte payload[]; 

    function new();
        // 56 bits 需要 7 个 byte (56 / 8 = 7)
        payload = new[7]; 
    endfunction

    // 1. Pack (打包)：将对象成员 -> 结构体 -> 字节数组 (使用 >> 从左到右流)
    function void pack();
        packet_struct_t temp_struct;
        // 将类成员赋值给 packed struct
        temp_struct.addr = this.addr;
        temp_struct.crc  = this.crc;
        temp_struct.cmd  = this.cmd;
        
        // 【核心】使用 >> 将结构体按位“流”入字节数组
        // >> 表示从最高位(MSB)开始，依次流向数组的第一个元素(大端模式，符合人类直觉)
        payload = {>> {temp_struct}}; 
    endfunction

    // 2. Unpack (解包)：将字节数组 -> 结构体 -> 对象成员
    function void unpack();
        packet_struct_t temp_struct;
        
        // 【核心】使用 >> 将字节数组“流”回结构体
        {>> {temp_struct}} = payload;
        
        // 将结构体成员还原给类变量
        this.addr = temp_struct.addr;
        this.crc  = temp_struct.crc;
        this.cmd  = temp_struct.cmd;
    endfunction
    
    function void display(string name);
        $display("[%s] addr=%0h, crc=%0h, cmd=%0h", name, addr, crc, cmd);
        $write("[%s] Payload bytes: ", name);
        foreach(payload[i]) $write("%02h ", payload[i]);
        $display("\n");
    endfunction
endclass

module testbench;
    initial begin
        Packet tx_pkt = new();
        Packet rx_pkt = new();
        
        // 1. 发送端：构造对象并打包
        tx_pkt.addr = 32'hDEAD_BEEF;
        tx_pkt.crc  = 16'h1234;
        tx_pkt.cmd  = 8'hAA;
        tx_pkt.pack();
        tx_pkt.display("TX Packed");
        // 预期输出 Payload: DE AD BE EF 12 34 AA (完美的大端顺序！)

        // 2. 接收端：假设从 DUT  monitor 采到了同样的 payload 数组
        rx_pkt.payload = tx_pkt.payload; 
        rx_pkt.unpack();
        rx_pkt.display("RX Unpacked");
        // 预期输出：rx_pkt 的成员变量与 tx_pkt 完全一致
    end
endmodule