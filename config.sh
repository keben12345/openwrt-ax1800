#!/bin/bash
set -e

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi

echo "Configuring target: $TARGET"

# 清空原配置
rm -f openwrt/.config

# 加载设备脚本
if [ ! -f "targets/${TARGET}.sh" ]; then
    echo "[targets/${TARGET}.sh] not found!"
    exit 1
fi
. "targets/${TARGET}.sh"

# 设置时区
sed -i "s|timezone='UTC'|zonename='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|zonename='UTC'|zonename='Asia/Shanghai'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|timezone='GMT0'|timezone='CST-8'|" openwrt/package/base-files/files/bin/config_generate
sed -i "s|log_size='128'|log_size='64'|" openwrt/package/base-files/files/bin/config_generate
