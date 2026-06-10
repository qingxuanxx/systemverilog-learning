# SystemVerilog 学习

VCS + Verdi 环境，Ubuntu 22.04 虚拟机。

## 目录结构

```
sv_code/
├── Makefile.template    # 通用 Makefile，新建章节时复制
├── ch2/                 # 第2章：数据类型
├── ch3/                 # 第3章
├── ch4/                 # 第4章
├── ch5/                 # 第5章
│   ├── 1.sv, 2.sv ...   # 源码
│   ├── Makefile          # 从模板复制的
│   └── build/            # 编译生成（gitignore）
└── ...
```

## 章节内容

### 第2章 — 数据类型

| 文件 | 主题 | 关键知识点 |
|------|------|-----------|
| `1.sv` | `logic` vs `bit` | 四态(`logic`)保留X/Z，双态(`bit`)丢失X/Z；`$isunknown()` 检测 |
| `2.sv` | 关联数组（地址索引） | `foreach` 遍历、`first()`/`next()` 遍历、`delete()` 删除 |
| `3.sv` | 合并数组 vs 非合并数组 | `bit [7:0] unpacked[3]` vs `bit [2:0][7:0] packed` |
| `4.sv` | 动态数组 | `new[]` 分配/扩容、`size()`、`sum()`、`delete()`、复制 |
| `5.sv` | 队列 | `push_front/back`、切片 `[2:5]`、`find with`、`unique()`、`min/max`、`sum with` |
| `6.sv` | 关联数组（字符串/地址索引） | 稀疏内存模型、`exists()` 检查、`first()`/`next()` 遍历、`delete()` |
| `7.sv` | 结构体与流操作符 | `packed struct`、`{>>{}}` 大端打包、`{<<{}}` 小端打包 |
| `8.sv` | 枚举类型 | `typedef enum`、`.next()`、`.prev()`、`.first()`、`.name()` 环形遍历 |

### 第3章 — 过程语句与子程序

| 文件 | 主题 | 关键知识点 |
|------|------|-----------|
| `1.sv` | 过程语句 | `for` 循环声明变量、`break`/`continue`、`do-while`、块标签 |
| `2.sv` | task / function / void | task 可延时无返回值；function 不可延时必须有返回值；void function 两者结合 |
| `3.sv` | 子程序参数传递 | 值传递(复制)、`const ref`(只读引用)、`ref`(可写引用)、默认参数、命名参数 |
| `4.sv` | return 语句 | task 中提前 `return` 避免错误；function 中提前 `return` 返回结果 |
| `5.sv` | automatic | 默认静态存储 vs `automatic` 动态存储；fork-join 中的变量竞争 |
| `6.sv` | 时间与延时 | `timeunit`/`timeprecision`、`$timeformat`、`$realtime` vs `$time` |

### 第4章 — 接口与程序块

| 文件 | 主题 | 关键知识点 |
|------|------|-----------|
| `1.sv` | 传统 module + 竞争冒险 | `always_ff` 仲裁器、module TB 同区域竞争、`#1` 解决方案 |
| `2.sv` | interface + modport | `interface` 封装信号、`modport` 区分 DUT/TB 视角 |
| `3.sv` | interface 封装 task + `#1step` | 接口内定义 task、`import` 导出、`#1step` 解决竞争冒险 |
| `4.sv` | program 块 + reactive 区域 | `program automatic` 编写 TB、reactive 区域避免与 DUT 竞争 |
| `5.sv` | clocking block | `input #1step`/`output #1ns` 采样驱动规则、`@(bus.cb)` 同步事件 |
| `6.sv` | $unit / $root / `.*` 隐式连接 | 全局参数、`$root` 绝对路径寻址、`.*` 隐式端口连接 |
| `7.sv` | SVA 并发断言 | `property`/`assert property`、`|->` 重叠蕴含、`##[1:3]` 延时范围、`disable iff` |

### 第5章 — 类与面向对象

| 文件 | 主题 | 关键知识点 |
|------|------|-----------|
| `1.sv` | 类的基本定义 | `class`、`new()` 构造函数、句柄声明与对象创建 |
| `2.sv` | 带参数的构造函数 | 默认参数值、`this` 指针区分成员变量与参数 |
| `3.sv` | 静态变量与方法 | `static` 成员属于类而非对象、`packet::get_count()` 类名访问 |
| `4.sv` | extern 外部实现 | `extern` 声明原型、类外 `function packet::new()` 实现 |
| `5.sv` | 访问控制 | `public`/`protected`/`local` 三级权限、通过 public 方法访问内部成员 |
| `6.sv` | 类组合 (Composition) | 大类包含小类、构造函数中 `new()` 初始化内部对象 |
| `7.sv` | 深拷贝 vs 浅拷贝 | 句柄赋值只复制引用、自定义 `copy()` 递归复制内部对象 |
| `8.sv` | ref 传递句柄 + 垃圾回收 | `ref` 才能修改外部句柄、SV 自动 GC 回收无引用对象 |
| `9.sv` | pack/unpack 字节流 | `packed struct` 中介、`{>>{}}` 流操作符实现 class ↔ byte[] 转换 |

## 新建章节

```bash
mkdir chX
cp Makefile.template chX/Makefile
```

## Makefile 命令

进入章节目录后：

| 命令 | 作用 |
|------|------|
| `make` | 编译所有 .sv |
| `make sim_1` | 编译 1.sv |
| `make run_1` | 运行仿真 |
| `make wave_1` | 运行 + 打开 Verdi 看波形 |
| `make verdi` | 只看波形（不跑仿真） |
| `make clean` | 清空 build/ |
| `make help` | 查看所有命令 |

## 波形导出

```systemverilog
initial begin
    $fsdbDumpfile("xxx_wave.fsdb");
    $fsdbDumpvars(0, top_module_name);
end
```

## 代码风格

- **上建下测**：class / package / DUT 放在文件上方，module / program (testbench) 放在文件下方

## 已知问题

- `.min()` / `.max()` 需要 VCS `-lca` 标志（Makefile 已加）
- 变量声明必须放在 procedural block 最前面

## 环境

| 工具 | 版本 |
|------|------|
| VCS | V-2023.12-SP2 |
| Verdi | V-2023.12-SP2 |
| SCL | 2021.03 |
| OS | Ubuntu 22.04.5 LTS, VMware 虚拟机 |
| X Server | VcXsrv (Windows) |

> 2026-06-10 更新
