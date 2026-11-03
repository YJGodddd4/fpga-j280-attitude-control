# 构建与运行

以下目录以仓库根为起点。FPGA 参考基线为 Last_Slim_FM025_Heart62s，上位机参考基线为 v9.4；采用其他版本时先对照实际入口和配置。

## Python 与上位机

在仓库根目录打开 PowerShell：

~~~powershell
py -3 -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe -c "import tkinter, serial; print('Python dependencies ready')"
~~~

Python 安装需要包含 Tcl/Tk。若没有 py 命令，可用你确认的 Python 3 可执行文件运行第一条命令；后续统一使用生成的 .venv 解释器。

Pillow 是可选绘图增强，截图及相关绘图测试需要它：

~~~powershell
.\.venv\Scripts\python.exe -m pip install -r requirements-optional.txt
~~~

导入完整 host/ 后，运行根目录 Start_Monitor.cmd。它优先使用本仓库 .venv，其次查找 py -3 或 python，不依赖原电脑的缓存路径。若想直接运行：

~~~powershell
.\.venv\Scripts\python.exe -X utf8 host\monitor\clean_monitor.py
~~~

参考 v9.4 还提供演示与 CSV 回放参数；实际参数以导入版脚本为准：

~~~powershell
.\.venv\Scripts\python.exe -X utf8 host\monitor\clean_monitor.py --demo
.\.venv\Scripts\python.exe -X utf8 host\monitor\clean_monitor.py --replay "你的实际CSV路径"
~~~

在连接设置中选择实际端口；界面原默认 COM7 不代表你的电脑必须使用 COM7。参考参数为 115200、8N1、无流控。新增记录默认写到 host/monitor/records/。

程序只读接收数据，不向板上发控制指令。暂停显示、断开串口和关闭窗口不会停止电机，板上启停按原工程操作。

## FPGA 命令行构建

1. 导入完整 fpga/。
2. 安装支持目标 GW2A 器件的 Gowin EDA，记录实际工具版本。原脚本搜索路径中含 V1.9.12.03，但不能据此认为所有工具版本都已验证。
3. 在 PowerShell 中设置本机真实 gw_sh.exe 路径，进入 fpga/ 根后执行：

~~~powershell
$env:J280_GOWIN_EXE = 'D:\Gowin\Gowin_V1.9.12.03_x64\IDE\bin\gw_sh.exe'
Set-Location fpga
..\.venv\Scripts\python.exe -X utf8 scripts\build_checked.py
~~~

上面的安装位置是示例，请替换为本机存在的路径。若环境变量已设置，脚本会优先使用该路径。当前轨迹生成器只依赖 Python 标准库，构建不需要额外安装 numpy 或 matplotlib。

该脚本会先按 config 重新生成轨迹表，再调用 Gowin，检查时序和构建期间的输入哈希；通过后才更新 bitstream/J280_AllModes_Last_Equivalent62s.fs，并在 reports/ 中写入本次摘要。它不调用下载器，不自动操作板卡。

原 Build_Auto.cmd 使用原电脑的 Python 缓存路径。跨电脑不要仅依赖该旧入口；上面的命令使用同一构建逻辑。

## FPGA GUI 构建

使用 Gowin 打开 fpga/J280_Pendulum.gprj。目标器件为 GW2A-LV55PG484C8/I7，顶层 j280_pendulum_top。

首次导入时，如果 impl/J280_Pendulum_process_config.json 缺失，先从 settings/ 同名模板恢复，再打开 GUI。该设置包含 SSPI 复用相关选项。不要把整个 impl/ 目录当成缓存删除；.gitignore 只排除了其中的综合/布局布线输出。

GUI 直接编译采用当前 RTL 和 ROM，不会代替 Python 配置生成流程。如果修改了轨迹配置，优先使用 build_checked.py 重新生成并构建。

## 固件下载与版本对应

按原板卡说明使用 Gowin Programmer 及对应的下载方式。本补充包不假定你需要 JTAG 临时下载还是 Flash 固化，也未执行下载。

记录源码提交、配置标记、实际构建工具版本和固件 SHA256，保证展示视频、实验 CSV 与所用固件属于同一版本。上传到 Releases 的 .fs 附带这些信息；不要把不同实现目录中的同名固件默认视为同一文件。

## 版本语义

- 参考 FPGA 版 FM 为 0.1–0.25 Hz：30 s 调频周期与120 s完整位置相位周期含义不同。
- 心形为56 s绘制加6 s中心保持，不应写成整条曲线均匀放慢到62 s。
- v9.4 的 known_profiles.py 含 CF=CB045654 识别。上位机包中旧 trajectory_profiles.json 的数值不应替代实际 FPGA 配置作为当前运动参数依据。
- 串口协议、数值缩放和配置标记应参考实际导入的 fpga/config/、RTL 和 host/monitor/known_profiles.py；不要把多个兼容帧随意拼成同一快照。
