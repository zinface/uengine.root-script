#!/bin/bash

#  背景色: 40--49
#define FB_BLACK        "\033[40m"
#define FB_RED          "\033[41m"
#define FB_GREEN        "\033[42m"
#define FB_YELLOW       "\033[43m"
#define FB_BLUE         "\033[44m"
#define FB_PURPLE       "\033[45m"
#define FB_DARKGREEN    "\033[46m"
#define FB_WHITE        "\033[47m"

# 字颜色: 30--39
#define FC_DEFAULT      "\033[0m"
#define FC_RED          "\033[0;31m"
#define FC_GREEN        "\033[0;32m"
#define FC_YELLOW       "\033[0;33m"
#define FC_BLUE         "\033[0;34m"
#define FC_PURPLE       "\033[0;35m"
#define FC_DARKGREEN    "\033[0;36m"
#define FC_WHITE        "\033[0;37m"

# 背景色
#define FB               "\033["
#define BC_BLACK        "40"  // 黑
#define BC_RED          "41"  // 红
#define BC_GREEN        "42"  // 绿
#define BC_YELLOW       "43"  // 黄
#define BC_BLUE         "44"  // 蓝
#define BC_PURPLE       "45"  // 紫
#define BC_DARKGREEN    "46"  // 深绿
#define BC_WHITE        "47"  // 白色

# 字体色
#define FC              ";"
#define C_RED           "31m"  // 红
#define C_GREEN         "32m"  // 绿
#define C_YELLOW        "33m"  // 黄
#define C_BLUE          "34m"  // 蓝
#define C_PURPLE        "35m"  // 紫
#define C_DARKGREEN     "36m"  // 深绿
#define C_WHITE         "37m"  // 白色

#define LOG_INFO    FC_GREEN             "I" FC_DEFAULT
#define LOG_DEBUG   FC_BLUE              "D" FC_DEFAULT
#define LOG_WARNING FC_YELLOW            "W" FC_DEFAULT
#define LOG_ERROR   FC_RED               "E" FC_DEFAULT
#define LOG_FATAL   FB BC_GREEN FC C_BLUE "F" FC_DEFAULT

# 
FC_DEFAULT="\033[0m"
FC_RED="\033[0;31m"
FC_GREEN="\033[0;32m"
# 

echo -e "${FC_GREEN} 这是绿色文字 ${FC_DEFAULT}"
echo -e "${FC_RED} 这是红色文字 ${FC_DEFAULT}"