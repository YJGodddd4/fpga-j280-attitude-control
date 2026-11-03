# FPGA-J280 姿态控制与轨迹规划系统

基于高云 GW2A FPGA 的 J280 旋转倒立摆项目，将传感器采集、编码器解码、串级 PID、轨迹规划、电机 PWM 和串口遥测集成在同一硬件时序体系中，并配套 Python 上位机。

**当前状态：仓库初始化材料。源码、原理图、实物图和实验数据由维护者导入。** 本文参数以 Last_Slim_FM025_Heart62s 工程和 v9.4 上位机资料为参考；若采用其他版本，应同步修改说明。

## 功能

- 摆杆角度内环与旋臂位置外环串级控制。
- 相对位置任务，以及 AM、FM、心形轨迹模式。
- ADC、正交编码器、PWM、轨迹发布和 UART 并行运行。
- 上位机提供实时波形、时基/幅值调节、CSV 记录与离线回放。

参考工程使用 GW2A-LV55PG484C8/I7，顶层为 j280_pendulum_top，主时钟 50 MHz。参考节拍为角度环 5 ms、位置环 50 ms、轨迹发布 10 ms、PWM 20 kHz；50 MHz 不代表 PID 更新频率。

| 规范化拨码模式 | 功能 | 参考默认设置 |
|---|---|---|
| 00 | 相对位置任务 | 由板上按键编辑并启动 |
| 01 | AM | 半幅 30°，载波周期 3.5 s，包络周期 31.5 s |
| 10 | FM | 半幅 30°，0.1–0.25 Hz；调频周期 30 s，完整位置相位周期 120 s |
| 11 | 心形 | 最大绝对偏移 56°；56 s 绘制＋6 s 中心保持，共 62 s |

以上模式号是程序归一化后的逻辑值；物理拨码为低有效，接线及操作以导入工程的约束、原说明为准。

## 目录

~~~text
.
├─ README.md
├─ .gitignore
├─ .gitattributes
├─ requirements.txt
├─ requirements-optional.txt
├─ Start_Monitor.cmd
├─ fpga/                     完整 FPGA 工程，内部相对路径不变
├─ host/                     完整上位机包，保留 monitor/config/tests 的相邻关系
├─ hardware/                 原理图、接线图、器件清单
├─ assets/                   精选实物图、结构图、演示入口
├─ data/                     选定实验数据及工况说明
└─ docs/                     导入、构建、硬件、验证和参考文献说明
~~~

不要只复制 Verilog 文件。FPGA 工程还需要约束、轨迹 ROM、配置、生成脚本和工程设置。上位机也不能只复制 clean_monitor.py，必须保留同伴模块及其 config 目录。

## 开始使用

1. 按[上传与导入清单](docs/UPLOAD_CHECKLIST.md)放入源码。
2. 按[构建与运行说明](docs/BUILD_AND_RUN.md)准备 Python、Gowin 和上位机。
3. 核对[硬件与引脚说明](docs/HARDWARE.md)，再按原工程的上板流程操作。
4. 使用[验证记录表](docs/VERIFICATION.md)记录本版编译、仿真和实测结果。

上位机依赖可在仓库根目录安装：

~~~powershell
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
~~~

导入完整上位机后，双击根目录 Start_Monitor.cmd；或运行：

~~~powershell
.\.venv\Scripts\python.exe -X utf8 host\monitor\clean_monitor.py
~~~

如需截图和可选绘图增强，再安装 requirements-optional.txt。tkinter 属于 Python 的 Tcl/Tk 组件，不作为 pip 包安装。

上位机默认端口仅是界面初值，请选择本机实际串口。参考通信参数为 115200、8N1、无流控。监测程序只接收数据；暂停显示、关闭或断开监测都不会停止板上装置。

## 展示、数据与验证

- [展示素材说明](assets/README.md)
- [实验数据说明](data/README.md)
- [硬件资料说明](hardware/README.md)
- [项目报告参考文献](docs/REFERENCES.md)

仿真、综合时序通过与机械实测通过分别记录。初始化补充包没有重新运行 FPGA 编译、仿真或硬件测试，不能作为实测通过证据。当前发布状态和具体指标应以维护者补入的同版报告、固件哈希和实验记录为准。

维护者/团队名称、演示链接、实际开发软件版本和项目许可方式由团队补充。
