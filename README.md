# SV Code — VCS + Verdi 学习项目

## 目录结构

```
sv_code/
├── Makefile.template          # 通用 Makefile 模板
├── ch02_data_types/           # 每章一个文件夹
│   ├── 1.sv
│   ├── 2.sv
│   ├── Makefile               # 从模板复制的
│   └── build/                 # 编译生成（clean 后消失）
└── ...
```

## 新建章节

```bash
mkdir ch03_xxx
cp Makefile.template ch03_xxx/Makefile
```

## Makefile 命令

进入对应章节目录后：

| 命令 | 作用 |
|------|------|
| `make` | 编译所有 .sv |
| `make sim_1` | 只编译 1.sv |
| `make run_1` | 运行 1.sim |
| `make wave_1` | 运行仿真 → 自动打开 Verdi |
| `make verdi` | 只看波形（不跑仿真） |
| `make clean` | 清空 build/ |
| `make help` | 查看所有命令 |

## 代码中必须加波形导出

```systemverilog
initial begin
    $fsdbDumpfile("xxx_wave.fsdb");
    $fsdbDumpvars(0, top_module_name);
end
```

## 环境依赖

- VCS V-2023.12-SP2
- Verdi V-2023.12-SP2
- SCL 2021.03（License 自启动）
- VcXsrv（Windows X Server，Verdi 窗口需要）
