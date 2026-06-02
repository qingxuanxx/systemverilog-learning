module struct_stream;

typedef struct packed {
    bit [47:0] dst_mac; // 目的 MAC 地址
    bit [47:0] src_mac; // 源 MAC 地址
    bit [15:0] eth_type; // 以太网类型
} eth_header_t; // 以太网帧头结构(共 14 字节)

eth_header_t tx_header, rx_header; // 发送和接收的帧头
byte byte_stream[];

initial begin
    // 初始化发送帧头
    tx_header.dst_mac = 48'h00_11_22_33_44_55;
    tx_header.src_mac = 48'hAA_BB_CC_DD_EE_FF;
    tx_header.eth_type = 16'h0800; // IPv4

    // 1. 将结构体转换为字节流
    byte_stream = {>>{tx_header}};
    $display("将结构体打包成字节流：%p", byte_stream);

    // 2. 将字节流解包回结构体 
    rx_header = {>>{byte_stream}};
    $display("将字节流解包回结构体：%p", rx_header);
    $display("目的 MAC 地址：%h", rx_header.dst_mac);
    $display("源 MAC 地址：%h", rx_header.src_mac);
    $display("以太网类型：%h", rx_header.eth_type);

    // 3. 小端序打包演示
    byte_stream = {<<{tx_header}};
    $display("小端序打包成字节流：%p", byte_stream);

    $finish;

end

endmodule
