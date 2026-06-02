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

> 2026-06-02 更新
