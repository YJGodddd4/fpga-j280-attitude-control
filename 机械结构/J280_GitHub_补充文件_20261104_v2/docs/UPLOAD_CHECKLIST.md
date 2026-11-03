# 首次上传：复制哪些文件

这份补充包只提供建库文件，不包含 FPGA 源码、上位机源码、原理图、实测数据或固件。先把本包内容复制到你自己的 GitHub 本地仓库，再导入下面的现有资料。两个以点开头的文件 .gitignore、.gitattributes 也要一起复制。

## 1. FPGA：保持工程内部布局

将选定版本中 J280_Pendulum.gprj 所在目录的内容放入本仓库 fpga/，形成：

~~~text
fpga/
├─ J280_Pendulum.gprj
├─ rtl/                 包含 Verilog 和全部 ROM .mem 文件
├─ constraints/         j280.cst、j280.sdc
├─ config/              轨迹、语义、协议等 JSON
├─ settings/            可重建 GUI 配置的模板
├─ impl/
│  └─ J280_Pendulum_process_config.json
├─ scripts/             构建、轨迹生成及所需辅助脚本
├─ tests/               当前测试及其基线、向量、夹具
├─ monitor/             原工程内部监测/测试确有依赖时保留
└─ reports/             选定的当前版本验证摘要与时序证据
~~~

必须保留：

- 全部被 .gprj 引用的文件；不要把 rtl/ 或 constraints/ 单独挪到仓库根。
- 三份轨迹 ROM：trajectory_tables_ab.mem、trajectory_tables_sine.mem、trajectory_tables_envelope.mem。
- settings/J280_Pendulum_process_config.json，以及已有的 impl/J280_Pendulum_process_config.json。
- scripts/build_checked.py、build.tcl、generate_trajectory_tables.py、rom_lossless.py 及其实际依赖。
- 测试使用的 equivalence_baseline、.mem、.txt、.json、CSV 等输入。文件名含 baseline 不等于可以删除。
- 当前有效的原工程说明；它们可以与本包的 README 同时保留。

只排除可重建的 impl/gwsynthesis、impl/pnr、Python 缓存、仿真波形、本机 .gprj.user。不要忽略整个 impl/，也不要按扩展名批量删除 .mem、.bin、.json 或 .csv。

本包 .gitattributes 保留原始字节，避免自动改换行后使既有 SHA256 和精确帧夹具失效。若将来决定统一原工程换行，应重新建立相应哈希和验证证据。

## 2. 上位机：整包放进 host/

将上位机解压后最外层的内容放进 host/，保留原来的 monitor/、config/、tests/ 相邻关系：

~~~text
host/
├─ monitor/
│  ├─ clean_monitor.py
│  ├─ unified_monitor.py、unified_protocol.py
│  ├─ clean_widgets.py、scope_controls.py
│  ├─ clean_semantics.py、amfm_semantics.py
│  ├─ known_profiles.py、clean_capture.py
│  ├─ wave_monitor.py 及其他被导入的同伴模块
│  └─ records/         所需回归样例，详见下文
├─ config/             整个目录保留，不与 fpga/config 混用
├─ tests/              保持原脚本与 monitor/config 的相对关系
└─ 原版使用说明与选定验证摘要
~~~

正确入口为 host/monitor/clean_monitor.py。若解压后还有一层同名外包装目录，应进入那一层再复制；不要变成 host/包名/monitor/。

参考 v9.4 回归测试会读取：
host/monitor/records/J280_AllModes_COM7_20261102_143123_811745_492921_unified.csv

.gitignore 已单独放行该样例；其他每次运行生成的 records 内容默认忽略。如果你使用的测试还需要其他样例及配套文件，应逐项放行并保留原路径。精选论文数据另放 data/，不能仅移动文件后就声称原回归脚本仍可运行。

依赖可用根目录 requirements.txt 安装。原包 monitor/lib 中的 pySerial 可由 pip 安装替代；如果保留随包库，连同其原有依赖信息一起保留。原版启动脚本带本机 Python 路径，跨电脑优先使用本包根目录 Start_Monitor.cmd。

## 3. 文档与展示资料

| 放置位置 | 建议上传 |
|---|---|
| hardware/ | 自有原理图、接线图、板卡型号、器件清单；厂商手册优先提供官方链接 |
| assets/ | 1张清晰实物图、1张系统结构图，必要时补少量界面截图 |
| docs/ | 当前构建/运行、操作、验证说明；选定版本的项目报告 |
| data/ | 有工况、版本和单位说明的少量 CSV，以及所需诊断/事件配套文件 |

完整演示视频建议提供播放链接。生成的 .fs 固件及完整运行包适合放 GitHub Releases，并记录对应提交、配置和哈希；它们默认不纳入这份源码首传清单。

不要把所有历史工程 ZIP/RAR、每一版 PPT、软件安装包、整个 Python 环境、整段原始录像和全部录制目录放进首次提交。

## 4. 实际上传

推荐用 GitHub Desktop：检查 Changes 中的文件，填写“初始化 J280 项目源码与文档”，提交后 Push origin。

如果用网页 Add file → Upload files，需要在电脑上先人工筛选；不能期待网页拖拽按 .gitignore 自动过滤。应上传文件和目录本身，便于浏览和比较修改，而不是只上传一个整个工程压缩包。

网页单文件上限为 25 MiB，单次最多100个文件；普通 Git 仓库会阻止超过100 MiB的单文件。大文件另选 LFS 或发布附件。依据：[添加文件](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository)、[大文件说明](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github)。

## 5. 首次提交前补齐

- [ ] 已选定一个实际使用的 FPGA 版本和对应上位机，没有把多版 RTL 混在一起。
- [ ] 已按清单导入源码、ROM、配置和脚本。
- [ ] README 中的团队名称、开发软件实际版本和演示入口已填写。
- [ ] 文档中的模式、周期和硬件型号与实际导入版本一致。
- [ ] 读者能在干净目录中按文档定位工程、准备依赖和执行构建。
- [ ] 验证记录明确区分历史报告、本次重新运行与机械实测。
- [ ] 项目公开/私有状态及是否提供开源许可由团队确定；本补充包未代选 LICENSE。
