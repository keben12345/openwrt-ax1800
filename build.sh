#!/bin/bash
set -e

OPENWRT_VERSION="$1"
TARGET="$2"

if [ -z "$OPENWRT_VERSION" ] || [ -z "$TARGET" ]; then
    echo "Usage: $0 <openwrt_version> <target>"
    echo "Example: $0 v22.03.5 ath79/tiny/tplink_tl-wr720n-v3-16m"
    exit 1
fi

echo "Build target: $TARGET, OpenWrt version: $OPENWRT_VERSION"

# 创建输出目录
mkdir -p bin

# 进入 OpenWrt 源码
cd openwrt

# 检出指定版本
git fetch --tags
git checkout "$OPENWRT_VERSION"

# 清理旧配置
make distclean || true

# 复制配置
if [ ! -f "../targets/${TARGET}.sh" ]; then
    echo "[targets/${TARGET}.sh] not found!"
    exit 1
fi
cd ..
bash ./config.sh "$TARGET"

cd openwrt

# 更新 feeds
./scripts/feeds update -a
./scripts/feeds install -a

# 编译
echo "Start building firmware..."
make -j$(nproc) V=s

# 将生成的固件复制到 bin/
echo "Copy firmware to ../bin/"
find bin/targets/ -type f \( -name "*-squashfs-factory.bin" -o -name "*-squashfs-sysupgrade.bin" \) -exec cp -f {} ../bin/ \;

cd ..

echo "Build completed! Firmware files are in ./bin/"
ls -l bin/
