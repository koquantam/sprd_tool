##########################################################################
# author: hua.fang
# date: 2015/8/20
# function: read sharkl register
##########################################################################

FUNC_ENABLE=0

READ_PIN=0x1
READ_MODULE_EB=0x2
READ_SLEEP_STATUS=0x4
READ_DDR_FREQ=0x8
READ_XTL_INFO=0x10
READ_PLL_SEL=0X20

if [ -e /system/bin/sh ]; then
	LOOKAT="lookat"
	PRINTF="busybox printf"
	TR="busybox tr"
	AWK="busybox awk"
	SED="busybox sed"
	BASENAME="busybox basename"
	EXPR="busybox expr"
else
	LOOKAT="adb shell lookat"
	PRINTF="printf"
	TR="tr"
	AWK="awk"
	SED="sed"
	BASENAME="basename"
	EXPR="expr"
fi

filename=$($BASENAME $0)

function help() {
	echo "$filename [-h|-a|-p|-m|-s|-d|-x|-l]"
	echo "  -h: help"
	echo "  -a: all"
	echo "  -p: print pinmap"
	echo "  -m: print module eb"
	echo "  -s: print sleep status"
	echo "  -d: print ddr info"
	echo "  -x: print xtl cfg"
	echo "  -l: print pll cfg"
}

if (($#>0)); then
	FUNC_ENABLE=0

	while [ -n "$1" ]; do
		case $1 in
			-h) help ;;
			-a) FUNC_ENABLE=0xffffffff ;;
			-p) FUNC_ENABLE=$(($FUNC_ENABLE|$READ_PIN)) ;;
			-m) FUNC_ENABLE=$(($FUNC_ENABLE|$READ_MODULE_EB)) ;;
			-s) FUNC_ENABLE=$(($FUNC_ENABLE|$READ_SLEEP_STATUS)) ;;
			-d) FUNC_ENABLE=$(($FUNC_ENABLE|$READ_DDR_FREQ)) ;;
			-x) FUNC_ENABLE=$(($FUNC_ENABLE|$READ_XTL_INFO)) ;;
			-l) FUNC_ENABLE=$(($FUNC_ENABLE|$READ_PLL_SEL)) ;;
			*) ;;
		esac
		shift 1
	done
else
	help
	exit
fi

function hex() {
	$PRINTF "0x%08x" $1
}

function hex1() {
	$PRINTF "0x%02x" $1
}

function hex3() {
	$PRINTF "0x%02x" $1
}

function hex4() {
	$PRINTF "0x%02x" $1
}

function hex7() {
	$PRINTF "0x%02x" $1
}

function read_reg() {
	$LOOKAT $(hex $(($1 + $2))) | $SED 's/\r$//'
}

function bin_hex() {
	value=$1
	vshift=$2
	vmask=$3
	echo -n $(`$EXPR hex$vmask` $(($value >> $vshift & $vmask)))
}

function print_bit() {
	reg_val=$1
	reg_bit=$2
	info=$3

	echo -n "[$reg_bit]"
	case `bin_hex $reg_val $reg_bit 1` in
		0x00) echo " //$info" ;;
		0x01) echo " $info" ;;
	esac
}

if (($READ_PIN & $FUNC_ENABLE)); then
echo "===============================  pinmap config  ================================="
function get_pin_name() {
	pin_add=$1

	case $pin_add in
		0x402a0000) echo -n "PIN_CTRL_REG0" ;;
		0x402a0004) echo -n "PIN_CTRL_REG1" ;;
		0x402a0008) echo -n "PIN_CTRL_REG2" ;;
		0x402a000c) echo -n "PIN_CTRL_REG3" ;;
		0x402a0010) echo -n "PIN_CTRL_REG4" ;;
		0x402a0014) echo -n "PIN_CTRL_REG5" ;;
		0x402a0018) echo -n "Reserved " ;;
		0x402a001c) echo -n "Reserved " ;;
		0x402a0020) echo -n "RFSDA0" ;;
		0x402a0024) echo -n "RFSCK0" ;;
		0x402a0028) echo -n "RFSEN0" ;;
		0x402a002c) echo -n "RFSDA1" ;;
		0x402a0030) echo -n "RFSCK1" ;;
		0x402a0034) echo -n "RFSEN1" ;;
		0x402a0038) echo -n "RFCTL15" ;;
		0x402a003c) echo -n "RFCTL16" ;;
		0x402a0040) echo -n "RFCTL17" ;;
		0x402a0044) echo -n "RFCTL18" ;;
		0x402a0048) echo -n "RFCTL19" ;;
		0x402a004c) echo -n "RFCTL20" ;;
		0x402a0050) echo -n "RFCTL21" ;;
		0x402a0054) echo -n "RFCTL22" ;;
		0x402a0058) echo -n "RFCTL23" ;;
		0x402a005c) echo -n "RFCTL24" ;;
		0x402a0060) echo -n "RFCTL25" ;;
		0x402a0064) echo -n "RFCTL26" ;;
		0x402a0068) echo -n "RFCTL0" ;;
		0x402a006c) echo -n "RFCTL1" ;;
		0x402a0070) echo -n "RFCTL2" ;;
		0x402a0074) echo -n "RFCTL3" ;;
		0x402a0078) echo -n "RFCTL4" ;;
		0x402a007c) echo -n "RFCTL5" ;;
		0x402a0080) echo -n "RFCTL6" ;;
		0x402a0084) echo -n "RFCTL7" ;;
		0x402a0088) echo -n "RFCTL8" ;;
		0x402a008c) echo -n "RFCTL9" ;;
		0x402a0090) echo -n "RFCTL10" ;;
		0x402a0094) echo -n "RFCTL11" ;;
		0x402a0098) echo -n "RFCTL12" ;;
		0x402a009c) echo -n "RFCTL13" ;;
		0x402a00a0) echo -n "RFCTL14" ;;
		0x402a00a4) echo -n "RFCTL27" ;;
		0x402a00a8) echo -n "XTL_EN" ;;
		0x402a00ac) echo -n "RFFE_SCK0" ;;
		0x402a00b0) echo -n "RFFE_SDA0" ;;
		0x402a00b4) echo -n "RFCTL28" ;;
		0x402a00b8) echo -n "RFCTL29" ;;
		0x402a00bc) echo -n "SIMCLK0" ;;
		0x402a00c0) echo -n "SIMDA0" ;;
		0x402a00c4) echo -n "SIMRST0" ;;
		0x402a00c8) echo -n "SIMCLK1" ;;
		0x402a00cc) echo -n "SIMDA1" ;;
		0x402a00d0) echo -n "SIMRST1" ;;
		0x402a00d4) echo -n "SIMCLK2" ;;
		0x402a00d8) echo -n "SIMDA2" ;;
		0x402a00dc) echo -n "SIMRST2" ;;
		0x402a00e0) echo -n "SD0_D3" ;;
		0x402a00e4) echo -n "SD0_D2" ;;
		0x402a00e8) echo -n "SD0_CMD" ;;
		0x402a00ec) echo -n "SD0_D0" ;;
		0x402a00f0) echo -n "SD0_D1" ;;
		0x402a00f4) echo -n "SD0_CLK0" ;;
		0x402a00f8) echo -n "SD1_CLK" ;;
		0x402a00fc) echo -n "SD1_CMD" ;;
		0x402a0100) echo -n "SD1_D0" ;;
		0x402a0104) echo -n "SD1_D1" ;;
		0x402a0108) echo -n "SD1_D2" ;;
		0x402a010c) echo -n "SD1_D3" ;;
		0x402a0110) echo -n "IIS0DI" ;;
		0x402a0114) echo -n "IIS0DO" ;;
		0x402a0118) echo -n "IIS0CLK" ;;
		0x402a011c) echo -n "IIS0LRCK" ;;
		0x402a0120) echo -n "U0TXD" ;;
		0x402a0124) echo -n "U0RXD" ;;
		0x402a0128) echo -n "U0CTS" ;;
		0x402a012c) echo -n "U0RTS" ;;
		0x402a0130) echo -n "PTEST" ;;
		0x402a0134) echo -n "ANA_INT" ;;
		0x402a0138) echo -n "EXT_RST_B" ;;
		0x402a013c) echo -n "CHIP_SLEEP" ;;
		0x402a0140) echo -n "XTL_BUF_EN0" ;;
		0x402a0144) echo -n "XTL_BUF_EN1" ;;
		0x402a0148) echo -n "CLK_32K" ;;
		0x402a014c) echo -n "AUD_SCLK" ;;
		0x402a0150) echo -n "AUD_ADD0" ;;
		0x402a0154) echo -n "AUD_ADSYNC" ;;
		0x402a0158) echo -n "AUD_DAD1" ;;
		0x402a015c) echo -n "AUD_DAD0" ;;
		0x402a0160) echo -n "AUD_DASYNC" ;;
		0x402a0164) echo -n "ADI_D" ;;
		0x402a0168) echo -n "ADI_SYNC" ;;
		0x402a016c) echo -n "ADI_SCLK" ;;
		0x402a0170) echo -n "LCM_RSTN" ;;
		0x402a0174) echo -n "DSI_TE" ;;
		0x402a0178) echo -n "MTDO_ARM" ;;
		0x402a017c) echo -n "MTDI_ARM" ;;
		0x402a0180) echo -n "MTCK_ARM" ;;
		0x402a0184) echo -n "MTMS_ARM" ;;
		0x402a0188) echo -n "MTRST_N_ARM" ;;
		0x402a018c) echo -n "DTDO_LTE" ;;
		0x402a0190) echo -n "DTDI_LTE" ;;
		0x402a0194) echo -n "DTCK_LTE" ;;
		0x402a0198) echo -n "DTMS_LTE" ;;
		0x402a019c) echo -n "DRTCK_LTE" ;;
		0x402a01a0) echo -n "NFWPN" ;;
		0x402a01a4) echo -n "NFRB" ;;
		0x402a01a8) echo -n "NFCLE" ;;
		0x402a01ac) echo -n "NFALE" ;;
		0x402a01b0) echo -n "NFREN" ;;
		0x402a01b4) echo -n "NFD4" ;;
		0x402a01b8) echo -n "NFD5" ;;
		0x402a01bc) echo -n "NFD6" ;;
		0x402a01c0) echo -n "NFD7" ;;
		0x402a01c4) echo -n "NFD10" ;;
		0x402a01c8) echo -n "NFD11" ;;
		0x402a01cc) echo -n "NFD14" ;;
		0x402a01d0) echo -n "NFCEN0" ;;
		0x402a01d4) echo -n "NFWEN" ;;
		0x402a01d8) echo -n "NFD0" ;;
		0x402a01dc) echo -n "NFD1" ;;
		0x402a01e0) echo -n "NFD2" ;;
		0x402a01e4) echo -n "NFD3" ;;
		0x402a01e8) echo -n "NFD8" ;;
		0x402a01ec) echo -n "NFD9" ;;
		0x402a01f0) echo -n "NFD12" ;;
		0x402a01f4) echo -n "NFD13" ;;
		0x402a01f8) echo -n "NFD15" ;;
		0x402a01fc) echo -n "CCIRD0" ;;
		0x402a0200) echo -n "CCIRD1" ;;
		0x402a0204) echo -n "CMMCLK" ;;
		0x402a0208) echo -n "CMPCLK" ;;
		0x402a020c) echo -n "CMRST0" ;;
		0x402a0210) echo -n "CMRST1" ;;
		0x402a0214) echo -n "CMPD0" ;;
		0x402a0218) echo -n "CMPD1" ;;
		0x402a021c) echo -n "SCL0" ;;
		0x402a0220) echo -n "SDA0" ;;
		0x402a0224) echo -n "SPI2_CSN" ;;
		0x402a0228) echo -n "SPI2_DO" ;;
		0x402a022c) echo -n "SPI2_DI" ;;
		0x402a0230) echo -n "SPI2_CLK" ;;
		0x402a0234) echo -n "SPI0_CSN" ;;
		0x402a0238) echo -n "SPI0_DO" ;;
		0x402a023c) echo -n "SPI0_DI" ;;
		0x402a0240) echo -n "SPI0_CLK" ;;
		0x402a0244) echo -n "MEMS_MIC_CLK0" ;;
		0x402a0248) echo -n "MEMS_MIC_DATA0" ;;
		0x402a024c) echo -n "MEMS_MIC_CLK1" ;;
		0x402a0250) echo -n "MEMS_MIC_DATA1" ;;
		0x402a0254) echo -n "KEYOUT0" ;;
		0x402a0258) echo -n "KEYOUT1" ;;
		0x402a025c) echo -n "KEYOUT2" ;;
		0x402a0260) echo -n "KEYIN0" ;;
		0x402a0264) echo -n "KEYIN1" ;;
		0x402a0268) echo -n "KEYIN2" ;;
		0x402a026c) echo -n "SCL2" ;;
		0x402a0270) echo -n "SDA2" ;;
		0x402a0274) echo -n "CLK_AUX0" ;;
		0x402a0278) echo -n "IIS1DI" ;;
		0x402a027c) echo -n "IIS1DO" ;;
		0x402a0280) echo -n "IIS1CLK" ;;
		0x402a0284) echo -n "IIS1LRCK" ;;
		0x402a0288) echo -n "TRACECLK" ;;
		0x402a028c) echo -n "TRACECTRL" ;;
		0x402a0290) echo -n "TRACEDAT0" ;;
		0x402a0294) echo -n "TRACEDAT1" ;;
		0x402a0298) echo -n "TRACEDAT2" ;;
		0x402a029c) echo -n "TRACEDAT3" ;;
		0x402a02a0) echo -n "TRACEDAT4" ;;
		0x402a02a4) echo -n "TRACEDAT5" ;;
		0x402a02a8) echo -n "TRACEDAT6" ;;
		0x402a02ac) echo -n "TRACEDAT7" ;;
		0x402a02b0) echo -n "EXTINT0" ;;
		0x402a02b4) echo -n "EXTINT1" ;;
		0x402a02b8) echo -n "SCL3" ;;
		0x402a02bc) echo -n "SDA3" ;;
		0x402a02c0) echo -n "U1TXD" ;;
		0x402a02c4) echo -n "U1RXD" ;;
		0x402a02c8) echo -n "U2TXD" ;;
		0x402a02cc) echo -n "U2RXD" ;;
		0x402a02d0) echo -n "U3TXD" ;;
		0x402a02d4) echo -n "U3RXD" ;;
		0x402a02d8) echo -n "U3CTS" ;;
		0x402a02dc) echo -n "U3RTS" ;;
		0x402a02e0) echo -n "U4TXD" ;;
		0x402a02e4) echo -n "U4RXD" ;;
	esac
}

function print_pin_bit() {
	reg_val=$1
	reg_bit=$2
	info=$3

	case `bin_hex $reg_val $reg_bit 1` in
		0x00) echo -n "" ;;
		0x01) echo -n "$info " ;;
	esac
}

function print_pin_info() {
	reg_val=$1
	reg_bit=$2
	info1=$3
	info2=$4
	info3=$5
	info4=$6

	case `bin_hex $reg_val $reg_bit 3` in
		0x00) echo -n "$info1 " ;;
		0x01) echo -n "$info2 " ;;
		0x02) echo -n "$info3 " ;;
		0x03) echo -n "$info4 " ;;
	esac
}

function print_pin_drv() {
	reg_val=$1
	reg_bit=$2

	drv=$(echo -n $($PRINTF "%d" $(($reg_val >> $reg_bit & 0xf))))
	echo -n "DS($drv) "
}

function print_sel_info() {
	reg_val=$1
	reg_bit=$2
	reg_mask=$3
	src=$4
	arr=($5)

	echo -n "$src=>"
	index=$($PRINTF "%d" $(($reg_val >> $reg_bit & $reg_mask)))
	echo -n "${arr[$index]} "
}

function print_normal_pin() {
	pin_add=$1
	pin_val=$2

	pin_name=$(get_pin_name $pin_add)

	echo -n "$pin_name : $pin_add($pin_val) :  "
	print_pin_info $pin_val 4 "AF(0)" "AF(1)" "AF(2)" "AF(3)"					### function
	print_pin_drv $pin_val 19						### driver strength
	print_pin_bit $pin_val 12 "wpus"				### pull up
	print_pin_info $pin_val 6 "func_nul" "func_wpd" "func_wpu" "func_err"		### weakly pull up or down
	print_pin_info $pin_val 2 "slp_nul" "slp_wpd" "slp_wpu" "slp_err"			### sleep weakly pull up or down
	print_pin_info $pin_val 0 "slp_z" "slp_oe" "slp_ie" "slp_derr"				### sleep input or output
	print_pin_bit $pin_val 13 "slp_AP"				### sleep with
	print_pin_bit $pin_val 14 "slp_CP0"
	print_pin_bit $pin_val 15 "slp_CP1"
	print_pin_bit $pin_val 16 "slp_VCP0"
	print_pin_bit $pin_val 17 "slp_VCP1"
	echo ""
}

function print_reg0_pin() {
	pin_add=$1
	pin_val=$2

	pin_name=$(get_pin_name $pin_add)

	echo -n "$pin_name : $pin_add($pin_val) :  "
	print_sel_info $pin_val 28 1 "WIFI_COEXIST" "MEMS_MIC_CLK0 TRACEDAT07"
	print_sel_info $pin_val 27 1 "ORP_URXD" "U1RXD U2RXD"
	print_pin_bit $pin_val 15 "wpd_nf1pd"
	print_pin_bit $pin_val 14 "wpd_nf0pd"
	print_pin_bit $pin_val 13 "wpd_adpd"
	print_pin_bit $pin_val 12 "wpd_io_2_1pd"
	print_pin_bit $pin_val 11 "wpd_iopd"
	print_pin_bit $pin_val 10 "wpd_sim2pd"
	print_pin_bit $pin_val 9 "wpd_sim1pd"
	print_pin_bit $pin_val 8 "wpd_sim0pd"
	print_pin_bit $pin_val 7 "wpd_sdpd"
	print_pin_bit $pin_val 6 "wpd_campd"
	echo ""
}

function print_reg1_pin() {
	pin_add=$1
	pin_val=$2

	pin_name=$(get_pin_name $pin_add)

	echo -n "$pin_name : $pin_add($pin_val) :  "
	print_sel_info $pin_val 3 1 "U4RXD" "U4RXD SDA3"
	echo ""
}

function print_reg2_pin() {
	pin_add=$1
	pin_val=$2

	pin_name=$(get_pin_name $pin_add)

	echo -n "$pin_name : $pin_add($pin_val) :  "
	print_sel_info $pin_val 25 3 "SIM2" "AP_SIM0 CP0_SIM2 CP1_SIM2"
	print_sel_info $pin_val 23 3 "SIM1" "CP1_SIM1 CP0_SIM1 AP_SIM0"
	print_sel_info $pin_val 21 3 "SIM0" "CP0_SIM0 CP1_SIM0 AP_SIM0"
	print_sel_info $pin_val 18 7 "UART4" "AP_UART4 CP0_UART0 CP0_UART1 CP0_UART2 CP0_UART3"
	print_sel_info $pin_val 15 7 "UART3" "AP_UART3 CP0_UART0 CP0_UART1 CP0_UART2 CP0_UART3 ARM7_UART0"
	print_sel_info $pin_val 11 15 "UART2" "AP_UART2 AP_UART1 AP_UART0 AP_UART3 AP_UART4 CP0_UART0 CP0_UART1 CP0_UART2 CP0_UART3 CP1_UART0 CP1_UART1 ARM7_UART0"
	print_sel_info $pin_val 7 15 "UART1" "AP_UART1 AP_UART0 AP_UART2 AP_UART3 AP_UART4 CP0_UART0 CP0_UART1 CP0_UART2 CP0_UART3 CP1_UART0 CP1_UART1 ARM7_UART0"
	print_sel_info $pin_val 4 7 "UART0" "AP_UART0 CP0_UART0 CP1_UART0 ARM7_UART0"
	print_pin_bit $pin_val 3 "uart24_loop_sel"
	print_pin_bit $pin_val 2 "uart23_loop_sel"
	print_pin_bit $pin_val 1 "uart14_loop_sel"
	print_pin_bit $pin_val 0 "uart13_loop_sel"
	echo ""
}

function print_reg3_pin() {
	pin_add=$1
	pin_val=$2

	pin_name=$(get_pin_name $pin_add)

	echo -n "$pin_name : $pin_add($pin_val) :  "
	print_sel_info $pin_val 31 1 "Watch_dog_reset" "CA7 AP"
	print_sel_info $pin_val 15 7 "IIS3" "AP_IIS3 CP0_IIS3 CP1_IIS3 CP2_IIS VBC_IIS0 VBC_IIS1"
	print_sel_info $pin_val 12 7 "IIS2" "AP_IIS2 CP0_IIS2 CP1_IIS2 VBC_IIS0 VBC_IIS1"
	print_sel_info $pin_val 9 7 "IIS1" "AP_IIS1 CP0_IIS1 CP1_IIS1 VBC_IIS0 VBC_IIS1"
	print_sel_info $pin_val 6 7 "IIS0" "AP_IIS0 CP0_IIS0 CP1_IIS0 VBC_IIS0 VBC_IIS1"
	print_pin_bit $pin_val 5 "Iis23_loop_sel"
	print_pin_bit $pin_val 4 "Iis13_loop_sel"
	print_pin_bit $pin_val 3 "uart24_loop_sel"
	print_pin_bit $pin_val 2 "iis03_loop_sel"
	print_pin_bit $pin_val 1 "iis02_loop_sel"
	print_pin_bit $pin_val 0 "iis01_loop_sel"
	echo ""
}

function print_reg4_pin() {
	pin_add=$1
	pin_val=$2

	pin_name=$(get_pin_name $pin_add)

	echo -n "$pin_name : $pin_add($pin_val) :  "
	print_sel_info $pin_val 27 1 "MCSI1_DN1" "ccir_vs GPIO179"
	print_sel_info $pin_val 26 1 "MCSI1_DP1" "ccir_hs GPIO178"
	print_sel_info $pin_val 25 1 "MCSI1_DN0" "ccir_d[6] GPIO177"
	print_sel_info $pin_val 24 1 "MCSI1_DP0" "ccir_d[6] GPIO176"
	print_sel_info $pin_val 23 1 "MCSI1_CLKN" "ccir_d[5] GPIO175"
	print_sel_info $pin_val 22 1 "MCSI1_CLKP" "ccir_d[4] GPIO174"
	print_sel_info $pin_val 21 1 "MCSI0_DN3" "ccir_d[3] GPIO173"
	print_sel_info $pin_val 20 1 "MCSI0_DP3" "ccir_d[2] GPIO172"

	print_sel_info $pin_val 6 1 "VSD1" "3.0v 1.8v"
	print_sel_info $pin_val 5 1 "VSD" "3.0v 1.8v"
	print_sel_info $pin_val 4 1 "VSIM2" "3.0v 1.8v"
	print_sel_info $pin_val 3 1 "VSIM1" "3.0v 1.8v"
	print_sel_info $pin_val 2 1 "VSIM0" "3.0v 1.8v"
	print_sel_info $pin_val 1 1 "VIO_2_1" "3.0v 1.8v"
	print_sel_info $pin_val 0 1 "VIO" "3.0v 1.8v"
	echo ""
}

function print_reg5_pin() {
	pin_add=$1
	pin_val=$2

	pin_name=$(get_pin_name $pin_add)

	echo -n "$pin_name : $pin_add($pin_val) :  "
	print_sel_info $pin_val 0 1 "Debug_mode" "disable enable"
	echo ""
}

$LOOKAT -l186 0x402a0000 | while read LINE
do
#	if [[ "$LINE" =~ "0x" ]]; then
	is_hex=$(echo $LINE | $AWK '/0x/{print 1}')
	if [[ $is_hex ]]; then
		pin_add=$(echo $LINE | $AWK '{print $1}' | $SED 's/\r$//');
		pin_val=$(echo $LINE | $AWK '{print $3}' | $SED 's/\r$//');
		if [[ "$pin_add" == "0x402a0000" ]]; then
			print_reg0_pin $pin_add $pin_val
		elif [[ "$pin_add" == "0x402a0004" ]]; then
			print_reg1_pin $pin_add $pin_val
		elif [[ "$pin_add" == "0x402a0008" ]]; then
			print_reg2_pin $pin_add $pin_val
		elif [[ "$pin_add" == "0x402a000c" ]]; then
			print_reg3_pin $pin_add $pin_val
		elif [[ "$pin_add" == "0x402a0010" ]]; then
			print_reg4_pin $pin_add $pin_val
		elif [[ "$pin_add" == "0x402a0014" ]]; then
			print_reg5_pin $pin_add $pin_val
		elif [[ "$pin_add" < "0x402a0020" ]]; then
			echo "$(get_pin_name $pin_add) : $pin_add($pin_val)"
		else
			print_normal_pin $pin_add $pin_val
		fi
	fi
done
echo "=================================================================================="
echo " "
fi


if (($READ_MODULE_EB & $FUNC_ENABLE)); then
echo "===============================  module eb list ================================="
##### AHB_EB
val=$(read_reg 0x20e00000 0x00)
echo "=== AHB_EB(0x20e00000 : $val) ==="

print_bit $val 23 "ZIPMTX_EB"
print_bit $val 22 "LVDS_EB"
print_bit $val 21 "ZIPDEC_EB"
print_bit $val 20 "ZIPENC_EB"
print_bit $val 19 "NANDC_ECC_EB"
print_bit $val 18 "NANDC_2X_EB"
print_bit $val 17 "NANDC_EB"
print_bit $val 16 "BUSMON2_EB"
print_bit $val 15 "BUSMON1_EB"
print_bit $val 14 "BUSMON0_EB"
print_bit $val 13 "SPINLOCK_EB"
#print_bit $val 12 "GPS_EB"
print_bit $val 11 "EMMC_EB"
print_bit $val 10 "SDIO2_EB"
print_bit $val 9 "SDIO1_EB"
print_bit $val 8 "SDIO0_EB"
print_bit $val 7 "DRM_EB"
print_bit $val 6 "NFC_EB"
print_bit $val 5 "DMA_EB"
print_bit $val 4 "OTG_EB"
print_bit $val 3 "GSP_EB"
print_bit $val 2 "HSIC_EB"
print_bit $val 1 "DISPC_EB"
print_bit $val 0 "DSI_EB"
echo " "

##### APB_EB
val=$(read_reg 0x71300000 0x0)
echo "=== APB_EB(0x71300000 : $val) ==="

print_bit $val 22 "INTC3_EB"
print_bit $val 21 "INTC2_EB"
print_bit $val 20 "INTC1_EB"
print_bit $val 19 "INTC0_EB"
print_bit $val 18 "CKG_EB"
print_bit $val 17 "UART4_EB"
print_bit $val 16 "UART3_EB"
print_bit $val 15 "UART2_EB"
print_bit $val 14 "UART1_EB"
print_bit $val 13 "UART0_EB"
print_bit $val 12 "I2C4_EB"
print_bit $val 11 "I2C3_EB"
print_bit $val 10 "I2C2_EB"
print_bit $val 9 "I2C1_EB"
print_bit $val 8 "I2C0_EB"
print_bit $val 7 "SPI2_EB"
print_bit $val 6 "SPI1_EB"
print_bit $val 5 "SPI0_EB"
print_bit $val 4 "IIS3_EB"
print_bit $val 3 "IIS2_EB"
print_bit $val 2 "IIS1_EB"
print_bit $val 1 "IIS0_EB"
print_bit $val 0 "SIM0_EB"
echo " "

##### AON_APB_EB0
val=$(read_reg 0x402e0000 0x0)
echo "=== AON_APB_EB0(0x402e0000 : $val) ==="

print_bit $val 31 "I2C_EB"
print_bit $val 30 "CA7_DAP_EB"
print_bit $val 29 "CA7_TS1_EB"
print_bit $val 28 "CA7_TS0_EB"
print_bit $val 27 "GPU_EB"
print_bit $val 26 "CKG_EB"
print_bit $val 25 "MM_EB"
print_bit $val 24 "AP_WDG_EB"
print_bit $val 23 "MSPI_EB"
print_bit $val 22 "SPLK_EB"
print_bit $val 21 "IPI_EB"
print_bit $val 20 "PIN_EB"
print_bit $val 19 "VBC_EB"
print_bit $val 18 "AUD_EB"
print_bit $val 17 "AUDIF_EB"
print_bit $val 16 "ADI_EB"
print_bit $val 15 "INTC_EB"
print_bit $val 14 "EIC_EB"
print_bit $val 13 "EFUSE_EB"
print_bit $val 12 "AP_TMR0_EB"
print_bit $val 11 "AON_TMR_EB"
print_bit $val 10 "AP_SYST_EB"
print_bit $val 9 "AON_SYST_EB"
print_bit $val 8 "KPD_EB"
print_bit $val 7 "PWM3_EB"
print_bit $val 6 "PWM2_EB"
print_bit $val 5 "PWM1_EB"
print_bit $val 4 "PWM0_EB"
print_bit $val 3 "GPIO_EB"
print_bit $val 2 "TPC_EB"
print_bit $val 1 "FM_EB"
print_bit $val 0 "ADC_EB"
echo " "

##### AON_APB_EB1
val=$(read_reg 0x402e0000 0x4)
echo "=== AON_APB_EB1(0x402e0004 : $val) ==="

print_bit $val 27 "ORP_JTAG_EB"
print_bit $val 26 "CA5_TS0_EB"
print_bit $val 25 "DEF_EB"
print_bit $val 24 "LVDS_PLL_DIV_EN"
print_bit $val 23 "ARM7_JTAG_EB"
print_bit $val 22 "AON_DMA_EB"
print_bit $val 21 "MBOX_EB"
print_bit $val 20 "DJTAG_EB"
print_bit $val 19 "RTC4M1_CAL_EB"
print_bit $val 18 "RTC4M0_CAL_EB"
print_bit $val 17 "MDAR_EB"
print_bit $val 16 "LVDS_TCXO_EB"
print_bit $val 15 "LVDS_TRX_EB"
print_bit $val 14 "CA5_DAP_EB"
print_bit $val 13 "GSP_EMC_EB"
print_bit $val 12 "ZIP_EMC_EB"
print_bit $val 11 "DISP_EMC_EB"
print_bit $val 10 "AP_TMR2_EB"
print_bit $val 9 "AP_TMR1_EB"
print_bit $val 8 "CA7_WDG_EB"
#print_bit $val 7 "AVS1_EB"
print_bit $val 6 "AVS_EB"
print_bit $val 5 "PROBE_EB"
print_bit $val 4 "AUX2_EB"
print_bit $val 3 "AUX1_EB"
print_bit $val 2 "AUX0_EB"
print_bit $val 1 "THM_EB"
print_bit $val 0 "PMU_EB"
echo " "

echo "=================================================================================="
echo " "
fi

if (( $READ_SLEEP_STATUS & $FUNC_ENABLE )); then
function print_pwr_status_info() {
	reg_val=$1
	reg_bit=$2
	src=$3
	reg_mask=0xf
	arr=(WAKEUP POWER_ON_SEQ POWER_ON RST_ASSERT RST_GAP RESTORE ISO_OFF SHUTDOWN ACTIVE STANDBY ISO_ON SAVE_ST SAVE_GAP POWER_OFF BISR_RST BISR_PROC)

	echo -n "$src: "
	index=$($PRINTF "%d" $(($reg_val >> $reg_bit & $reg_mask)))
	echo "${arr[$index]} "
}

function print_sleep_status_info() {
	reg_val=$1
	reg_bit=$2
	src=$3
	reg_mask=0xf
	arr=(DEEP_SLEEP XTL_WAIT XTLBUF_WAIT DEEP_SLEEP_XTLON PLL_PWR_WAIT WAKEUP WAKEUP_LOCK NULL NULL NULL NULL NULL NULL NULL NULL NULL)

	echo -n "$src: "
	index=$($PRINTF "%d" $(($reg_val >> $reg_bit & $reg_mask)))
	echo "${arr[$index]} "
}

echo "===============================  sleep status  ================================="
##### CP_SLP_STATUS_DBG0
val=$(read_reg 0x402b0000 0xb4)
echo "=== CP_SLP_STATUS_DBG0(0x402b00b4 : $val) ==="

print_bit $val 15 "tmr_autopd_xtl_2g"
print_bit $val 14 "tmr_autopd_xtl_3g_w"
print_bit $val 13 "clk_ecc_en"
print_bit $val 12 "clk_qbc_en"
print_bit $val 11 "dsp_stop"
print_bit $val 10 "wsys_stop"
print_bit $val 9 "dsp_peri_stop"
print_bit $val 8 "mcu_peri_stop"
print_bit $val 7 "mcu_sys_stop"
print_bit $val 6 "mcu_deep_stop"
print_bit $val 5 "dsp_mahb_sleep_en"
print_bit $val 4 "ashb_dsptoarm_valid"
print_bit $val 3 "mcu_stop"
print_bit $val 2 "ahb_stop"
print_bit $val 1 "mtx_stop"
print_bit $val 0 "arm_stop"
echo " "

##### PWR_STATUS0_DBG
val=$(read_reg 0x402b0000 0xbc)
echo "=== PWR_STATUS0_DBG(0x402b00bc : $val) ==="

print_pwr_status_info $val 28 "PD_MM_TOP_STATE"
print_pwr_status_info $val 24 "PD_GPU_TOP_STATE"
print_pwr_status_info $val 20 "PD_AP_SYS_STATE"
print_pwr_status_info $val 16 "PD_CA7_C3_STATE"
print_pwr_status_info $val 12 "PD_CA7_C2_STATE"
print_pwr_status_info $val 8 "PD_CA7_C1_STATE"
print_pwr_status_info $val 4 "PD_CA7_C0_STATE"
print_pwr_status_info $val 0 "PD_CA7_TOP_STATE"
echo " "

##### PWR_STATUS1_DBG
val=$(read_reg 0x402b0000 0xc0)
echo "=== PWR_STATUS1_DBG(0x402b00c0 : $val) ==="

print_pwr_status_info $val 28 "PD_CP0_CEVA_1_STATE"
print_pwr_status_info $val 24 "PD_CP0_CEVA_0_STATE"
print_pwr_status_info $val 20 "PD_CP0_GSM_0_STATE"
print_pwr_status_info $val 16 "PD_CP0_GSM_1_STATE"
print_pwr_status_info $val 12 "PD_CP0_HU3GE_STATE"
print_pwr_status_info $val 8 "PD_CP0_ARM9_1_STATE"
print_pwr_status_info $val 4 "PD_CP0_ARM9_0_STATE"
print_pwr_status_info $val 0 "PD_CP0_TD_STATE"
echo " "

##### PWR_STATUS2_DBG
val=$(read_reg 0x402b0000 0xc4)
echo "=== PWR_STATUS2_DBG(0x402b00c4 : $val) ==="

#print_pwr_status_info $val 28 "PD_CP0_CEVA_1_STATE"
print_pwr_status_info $val 24 "PD_PUB_SYS_STATE"
print_pwr_status_info $val 20 "PD_CP1_COMWRAP_STATE"
print_pwr_status_info $val 16 "PD_CP1_LTE_P2_STATE"
print_pwr_status_info $val 12 "PD_CP1_LTE_P1_STATE"
print_pwr_status_info $val 8 "PD_CP1_CEVA_STATE"
print_pwr_status_info $val 4 "PD_CP1_CA5_STATE"
#print_pwr_status_info $val 0 "PD_CP0_TD_STATE"
echo " "

##### SLEEP_CTRL
val=$(read_reg 0x402b0000 0xcc)
echo "=== SLEEP_CTRL(0x402b00cc : $val) ==="

print_bit $val 28 "VCP1_FORCE_LIGHT_SLEEP"
print_bit $val 27 "VCP0_FORCE_LIGHT_SLEEP"
print_bit $val 26 "CP1_FORCE_LIGHT_SLEEP"
print_bit $val 25 "CP0_FORCE_LIGHT_SLEEP"
print_bit $val 24 "AP_FORCE_LIGHT_SLEEP"
print_bit $val 21 "ARM7_FORCE_DEEP_SLEEP"
print_bit $val 20 "VCP1_FORCE_DEEP_SLEEP"
print_bit $val 19 "VCP0_FORCE_DEEP_SLEEP"
print_bit $val 18 "CP1_FORCE_DEEP_SLEEP"
print_bit $val 17 "CP0_FORCE_DEEP_SLEEP"
print_bit $val 16 "AP_FORCE_DEEP_SLEEP"
print_bit $val 12 "VCP1_LIGHT_SLEEP"
print_bit $val 11 "VCP0_LIGHT_SLEEP"
print_bit $val 10 "CP1_LIGHT_SLEEP"
print_bit $val 9 "CP0_LIGHT_SLEEP"
print_bit $val 8 "AP_LIGHT_SLEEP"
print_bit $val 4 "VCP1_DEEP_SLEEP"
print_bit $val 3 "VCP0_DEEP_SLEEP"
print_bit $val 2 "CP1_DEEP_SLEEP"
print_bit $val 1 "CP0_DEEP_SLEEP"
print_bit $val 0 "AP_DEEP_SLEEP"
echo " "

##### SLEEP_STATUS
val=$(read_reg 0x402b0000 0xd4)
echo "=== SLEEP_STATUS(0x402b00d4 : $val) ==="

print_sleep_status_info $val 20 "ARM7_SLP_STATUS"
print_sleep_status_info $val 16 "VCP1_SLP_STATUS"
print_sleep_status_info $val 12 "VCP0_SLP_STATUS"
print_sleep_status_info $val 8 "CP1_SLP_STATUS"
print_sleep_status_info $val 4 "CP0_SLP_STATUS"
print_sleep_status_info $val 0 "AP_SLP_STATUS"
echo " "


echo "=================================================================================="
echo " "
fi

if (($READ_DDR_FREQ & $FUNC_ENABLE)); then
echo "===============================  DDR freq  ================================="

# function read_DDR_freq() {
# 	REG_AON_CLK_EMC_CFG=$($LOOKAT 0x402d0058|$TR -d '\r')
# 	REG_AON_APB_DPLL_CFG1=$($LOOKAT 0x402e004c|$TR -d '\r')
# 	REG_AON_APB_DPLL_CFG2=$($LOOKAT 0x402e0050|$TR -d '\r')
# 
# 	clk_emc_sel=$(($REG_AON_CLK_EMC_CFG & 7))
# 	clk_emc_div=$(($REG_AON_CLK_EMC_CFG >> 8 & 0x7))
# 	dpll_refin=$((($REG_AON_APB_DPLL_CFG1 >> 18) & 0x3))
# 	dpll_nint=$((($REG_AON_APB_DPLL_CFG2 >> 24) & 0x3f))
# 	dpll_kint=$(($REG_AON_APB_DPLL_CFG2 & 0xfffff))
# 
# 	ddr_freq=0
# 	ddr_pll="TWPLL"
# 
# 	if ((clk_emc_sel<7)); then
# 		case $clk_emc_sel in
# 			0) clk_src=26 ;;
# 			1) clk_src=192 ;;
# 			2) clk_src=307 ;;
# 			3) clk_src=384 ;;
# 			4) clk_src=512 ;;
# 			5) clk_src=614 ;;
# 			6) clk_src=768 ;;
# 			*) clk_src=0 ;;
# 		esac
# 	else
# 		case $dpll_refin in
# 			0) refin=2 ;;
# 			1) refin=4 ;;
# 			2) refin=13 ;;
# 			3) refin=26 ;;
# 			*) refin=0 ;;
# 		esac
# 
# 		clk_src=$(($refin*$dpll_nint+$refin*$dpll_kint/1024/1024))
# 		ddr_pll="DPLL"
# 	fi
# 
# 	ddr_freq=$(($clk_src/(1+$clk_emc_div)/2))
# 
# 	echo "REG_AON_CLK_EMC_CFG: $REG_AON_CLK_EMC_CFG"
# 	echo "REG_AON_APB_DPLL_CFG1: $REG_AON_APB_DPLL_CFG1"
# 	echo "REG_AON_APB_DPLL_CFG2: $REG_AON_APB_DPLL_CFG2"
# 	echo "----"
# 	echo "freq: $ddr_freq"
# 	echo "PLL: $ddr_pll"
# }

function read_DDR_freq() {
	DDR_CFG_REG=$($LOOKAT 0x30000100|$TR -d '\r')
	ddr_freq=0

	case $DDR_CFG_REG in
		0x0e0a0d09) ddr_freq=192 ;;
		0x0f141a11) ddr_freq=384 ;;
		0x0f141b12) ddr_freq=400 ;;
		0x12192216) ddr_freq=500 ;;
		0x141b2418) ddr_freq=533 ;;
		0x141e291b) ddr_freq=600 ;;
		0x16202b1d) ddr_freq=640 ;;
		0x17222d1e) ddr_freq=667 ;;
		*) ddr_freq=0 ;;
	esac

	echo "0x30000100 : $DDR_CFG_REG"
	echo "freq: $ddr_freq"
}

read_DDR_freq

echo "=================================================================================="
echo " "
fi

if (($READ_XTL_INFO & $FUNC_ENABLE)); then
echo "===============================  xtl cfg  ================================="
##### XTL0_REL_CFG
val=$(read_reg 0x402b0000 0x80)
echo "=== XTL0_REL_CFG(0x402b0080 : $val) ==="

print_bit $val 5 "XTL0_ARM7_SEL"
print_bit $val 4 "XTL0_VCP1_SEL"
print_bit $val 3 "XTL0_VCP0_SEL"
print_bit $val 2 "XTL0_CP1_SEL"
print_bit $val 1 "XTL0_CP0_SEL"
print_bit $val 0 "XTL0_AP_SEL"
echo " "

##### XTL1_REL_CFG
val=$(read_reg 0x402b0000 0x84)
echo "=== XTL1_REL_CFG(0x402b0084 : $val) ==="

print_bit $val 5 "XTL1_ARM7_SEL"
print_bit $val 4 "XTL1_VCP1_SEL"
print_bit $val 3 "XTL1_VCP0_SEL"
print_bit $val 2 "XTL1_CP1_SEL"
print_bit $val 1 "XTL1_CP0_SEL"
print_bit $val 0 "XTL1_AP_SEL"
echo " "

##### XTLBUF0_REL_CFG
val=$(read_reg 0x402b0000 0x8c)
echo "=== XTLBUF0_REL_CFG(0x402b008c : $val) ==="

print_bit $val 5 "XTLBUF0_ARM7_SEL"
print_bit $val 4 "XTLBUF0_VCP1_SEL"
print_bit $val 3 "XTLBUF0_VCP0_SEL"
print_bit $val 2 "XTLBUF0_CP1_SEL"
print_bit $val 1 "XTLBUF0_CP0_SEL"
print_bit $val 0 "XTLBUF0_AP_SEL"
echo " "

##### XTLBUF1_REL_CFG
val=$(read_reg 0x402b0000 0x90)
echo "=== XTLBUF1_REL_CFG(0x402b0090 : $val) ==="

print_bit $val 5 "XTLBUF1_ARM7_SEL"
print_bit $val 4 "XTLBUF1_VCP1_SEL"
print_bit $val 3 "XTLBUF1_VCP0_SEL"
print_bit $val 2 "XTLBUF1_CP1_SEL"
print_bit $val 1 "XTLBUF1_CP0_SEL"
print_bit $val 0 "XTLBUF1_AP_SEL"
echo " "

echo "=================================================================================="
echo " "
fi

if (($READ_PLL_SEL & $FUNC_ENABLE)); then
echo "===============================  pll cfg  ================================="
##### MPLL_REL_CFG
val=$(read_reg 0x402b0000 0x94)
echo "=== MPLL_REL_CFG(0x402b0094 : $val) ==="

print_bit $val 8 "MPLL_REF_SEL"
print_bit $val 5 "MPLL_ARM7_SEL"
print_bit $val 4 "MPLL_VCP1_SEL"
print_bit $val 3 "MPLL_VCP0_SEL"
print_bit $val 2 "MPLL_CP1_SEL"
print_bit $val 1 "MPLL_CP0_SEL"
print_bit $val 0 "MPLL_AP_SEL"
echo " "

##### DPLL_REL_CFG
val=$(read_reg 0x402b0000 0x98)
echo "=== DPLL_REL_CFG(0x402b0098 : $val) ==="

print_bit $val 8 "DPLL_REF_SEL"
print_bit $val 5 "DPLL_ARM7_SEL"
print_bit $val 4 "DPLL_VCP1_SEL"
print_bit $val 3 "DPLL_VCP0_SEL"
print_bit $val 2 "DPLL_CP1_SEL"
print_bit $val 1 "DPLL_CP0_SEL"
print_bit $val 0 "DPLL_AP_SEL"
echo " "

##### LTEPLL_REL_CFG
val=$(read_reg 0x402b0000 0x9c)
echo "=== LTEPLL_REL_CFG(0x402b009c : $val) ==="

print_bit $val 8 "LTEPLL_REF_SEL"
print_bit $val 5 "LTEPLL_ARM7_SEL"
print_bit $val 4 "LTEPLL_VCP1_SEL"
print_bit $val 3 "LTEPLL_VCP0_SEL"
print_bit $val 2 "LTEPLL_CP1_SEL"
print_bit $val 1 "LTEPLL_CP0_SEL"
print_bit $val 0 "LTEPLL_AP_SEL"
echo " "

##### TWPLL_REL_CFG
val=$(read_reg 0x402b0000 0xa0)
echo "=== TWPLL_REL_CFG(0x402b00a0 : $val) ==="

print_bit $val 8 "TWPLL_REF_SEL"
print_bit $val 5 "TWPLL_ARM7_SEL"
print_bit $val 4 "TWPLL_VCP1_SEL"
print_bit $val 3 "TWPLL_VCP0_SEL"
print_bit $val 2 "TWPLL_CP1_SEL"
print_bit $val 1 "TWPLL_CP0_SEL"
print_bit $val 0 "TWPLL_AP_SEL"
echo " "

##### LVDSDIS_PLL_REL_CFG
val=$(read_reg 0x402b0000 0xa4)
echo "=== LVDSDIS_PLL_REL_CFG(0x402b00a4 : $val) ==="

print_bit $val 8 "LVDSDIS_PLL_REF_SEL"
print_bit $val 5 "LVDSDIS_PLL_ARM7_SEL"
print_bit $val 4 "LVDSDIS_PLL_VCP1_SEL"
print_bit $val 3 "LVDSDIS_PLL_VCP0_SEL"
print_bit $val 2 "LVDSDIS_PLL_CP1_SEL"
print_bit $val 1 "LVDSDIS_PLL_CP0_SEL"
print_bit $val 0 "LVDSDIS_PLL_AP_SEL"
echo " "

echo "=================================================================================="
echo " "
fi


