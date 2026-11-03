# 硬件与引脚说明

本文依据 Last_Slim_FM025_Heart62s 参考工程整理，尚未代替实际板卡接线核查。若导入其他板卡/工程版本，应以该版原理图和约束为准。

| 项目 | 参考资料可确认的信息 |
|---|---|
| 对象 | J280 旋转倒立摆 |
| FPGA | GW2A-LV55PG484C8/I7 |
| 顶层 | j280_pendulum_top |
| 系统时钟 | clk_50m，50 MHz；SDC周期20 ns |
| ADC时钟 | 5 MHz，由系统时钟分频 |
| 控制 | 角度5 ms内环、位置50 ms外环 |
| 位置反馈 | 正交编码器；当前参考控制使用 enc2 |
| 输出 | 电机方向、PWM；接口端口以 CST 为准 |
| 遥测 | UART 115200、8N1，无流控 |

## 电平与资料

参考 CST 将按键、拨码和 LED 约束为 LVCMOS15 / 1.5 V，其余本文列出的信号为 LVCMOS33 / 3.3 V。不能把不同电平组直接按同一外部电平接线。具体连接器序号、供电范围、电机驱动与传感器接线需由维护者依据原理图和实物补齐。

建议在 hardware/ 放入自有原理图、接线图和器件清单。不要仅凭 FPGA 封装球位号推断底板连接器脚序。

## 参考引脚表

下表逐项提取自参考工程 constraints/j280.cst 的 IO_LOC 与 IO_PORT；它反映文件声明，未重新测量实物。后续更换约束后应同步更新本表。

| 信号 | FPGA球位 | IO_TYPE | BANK_VCCIO |
|---|---|---|---|
| clk_50m | M19 | LVCMOS33 | 3.3 V |
| rst_n | AB3 | LVCMOS33 | 3.3 V |
| uart_tx | K20 | LVCMOS33 | 3.3 V |
| uart_rx | L20 | LVCMOS33 | 3.3 V |
| adc_clk | G18 | LVCMOS33 | 3.3 V |
| adc_oe_n | H20 | LVCMOS33 | 3.3 V |
| adc_otr | F18 | LVCMOS33 | 3.3 V |
| AN1 | Y17 | LVCMOS33 | 3.3 V |
| AN2 | Y19 | LVCMOS33 | 3.3 V |
| PWMA | Y18 | LVCMOS33 | 3.3 V |
| BN1 | AA17 | LVCMOS33 | 3.3 V |
| BN2 | V15 | LVCMOS33 | 3.3 V |
| PWMB | V14 | LVCMOS33 | 3.3 V |
| enc1_a | Y20 | LVCMOS33 | 3.3 V |
| enc1_b | AA20 | LVCMOS33 | 3.3 V |
| enc2_a | W18 | LVCMOS33 | 3.3 V |
| enc2_b | W17 | LVCMOS33 | 3.3 V |
| key_sw[0] | T18 | LVCMOS15 | 1.5 V |
| key_sw[1] | R18 | LVCMOS15 | 1.5 V |
| key_sw[2] | U20 | LVCMOS15 | 1.5 V |
| key_sw[3] | T20 | LVCMOS15 | 1.5 V |
| dip_sw_n[0] | W20 | LVCMOS15 | 1.5 V |
| dip_sw_n[1] | V20 | LVCMOS15 | 1.5 V |
| led[0] | U18 | LVCMOS15 | 1.5 V |
| led[1] | U19 | LVCMOS15 | 1.5 V |
| led[2] | U17 | LVCMOS15 | 1.5 V |
| led[3] | T17 | LVCMOS15 | 1.5 V |
| adc_data_in[0] | L21 | LVCMOS33 | 3.3 V |
| adc_data_in[1] | M21 | LVCMOS33 | 3.3 V |
| adc_data_in[2] | J20 | LVCMOS33 | 3.3 V |
| adc_data_in[3] | J19 | LVCMOS33 | 3.3 V |
| adc_data_in[4] | D19 | LVCMOS33 | 3.3 V |
| adc_data_in[5] | H18 | LVCMOS33 | 3.3 V |
| adc_data_in[6] | H19 | LVCMOS33 | 3.3 V |
| adc_data_in[7] | G19 | LVCMOS33 | 3.3 V |
| adc_data_in[8] | G17 | LVCMOS33 | 3.3 V |
| adc_data_in[9] | E19 | LVCMOS33 | 3.3 V |

参考 CST SHA256：a101293e5ef77d11da009523138492c3e83f4e7b37c94852208712e7321ab152。

## 上板记录需补充

- 板卡/底板实物型号与版本。
- 电机、驱动、角度传感器和编码器实际型号。
- 每个外部接口的连接器标识、方向和电平。
- 电源与接地方式、机械零位/标定方式。
- 已确认的按键与拨码操作图。

这些信息应由实际原理图和装置确认，不在初始化材料中编造。
