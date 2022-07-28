#!/bin/bash

# 准备制作全新 uengine-android-image 软件包，进行 root 
#
# 1. 进入临时工作目录
# 2. 安装 squashfs-tools 
# 3. 下载 SuperSU 压缩文件
#   1. 解压 SuperSU 压缩文件
#       将产生 su 文件夹
# 4. 下载 uengine-android-image 软件包
#   1. 解包，提取所有文件
#       将产生 extract 目录
#   2. 解包，提取控制文件
#       将产生 extract/DEBIAN 目录
# 5. 从 uengine-android-image 软件包中
#   1. 提取 android.img 到工作目录
#   2. 使用 unsquashfs 解压 android.img 镜像
#       将产生 squashfs-root 文件夹
#   3. 在 squashfs-root 目录创建存放 SuperSu 的目录结构
# 6. 将 su 文件夹中的文件复制到 squashfs-root 
#   1. 复制 su/x64 中的文件
#   2. 复制 su/common 中的文件
#   3. 其它备份与复制操作
# 7. 制作新镜像与软件包
#   1. 使用 mksquashfs 将 squashfs-root 打包为 android.img
#   2. 将 android.img 复制到 extract 目录的原来位置
#   3. 使用 find 组合命令生成 md5sums
#   4. 使用 dpkg-deb 制作 uengine-android-image
# 8. 清除垃圾文件
#

# 
FC_DEFAULT="\033[0m"
FC_RED="\033[0;31m"
FC_GREEN="\033[0;32m"
# 

# ======== 准备临时工作目录 ========
WORKDIR=`mktemp -d`

echo -e "${FC_GREEN}准备临时工作目录: $WORKDIR${FC_DEFAULT}"
# ======== 进入临时工作目录 ========
echo -e "${FC_GREEN}进入目录 $WORKDIR${FC_DEFAULT}"
cd "$WORKDIR"
xdg-open "$WORKDIR"


# ======== 在临时工作目录开展工作 ========
echo -e "${FC_GREEN}安装 squashfs-tools${FC_DEFAULT}"
sudo apt install squashfs-tools


# ======== 在临时工作目录开展工作 ========
echo -e "${FC_GREEN}下载 SuperSU 压缩文件${FC_DEFAULT}"
if [ ! -f 'SuperSU-v2.82-201705271822.zip' ];then
    # wget http://supersuroot.org/downloads/SuperSU-v2.82-201705271822.zip
    wget "http://101.35.119.41/fileupload/download/5ca2120827c01e21b7a0099dc5e7fd01" -O "SuperSU-v2.82-201705271822.zip"
fi

echo -e "${FC_GREEN}正在解压supersu${FC_DEFAULT}"
unzip SuperSU-v2.82-201705271822.zip -d su

# ======== 处理 uengine-android-image 软件包 ========
echo -e "${FC_GREEN}正在下载 uengine-android-image${FC_DEFAULT}"
apt download uengine-android-image

echo -e "${FC_GREEN}正在解压 uengine-android-image${FC_DEFAULT}"
mkdir -p extract/DEBIAN
dpkg-deb -x uengine-android-image*.deb extract/
dpkg-deb -e uengine-android-image*.deb extract/DEBIAN

# ======== 处理 android.img 镜像 ========
echo -e "${FC_GREEN}正在提取 android.img${FC_DEFAULT}"
cp extract/usr/share/uengine/android.img android.img

echo -e "${FC_GREEN}正在解压android镜像${FC_DEFAULT}"
unsquashfs android.img

# ======== 安装 supersu 内容 ========
echo -e "${FC_GREEN}在 squashfs-root 目录创建存放 SuperSu 的目录结构${FC_DEFAULT}"
mkdir -p ./squashfs-root/system/app/SuperSU
mkdir -p ./squashfs-root/system/bin/.ext/

echo -e "${FC_GREEN}正在将supersu安装到android镜像${FC_DEFAULT}"
cp ./su/common/Superuser.apk                    ./squashfs-root/system/app/SuperSU/SuperSU.apk
cp ./su/common/install-recovery.sh              ./squashfs-root/system/etc/install-recovery.sh
cp ./su/common/install-recovery.sh              ./squashfs-root/system/bin/install-recovery.sh  
cp ./su/x64/su                                  ./squashfs-root/system/xbin/su
cp ./su/x64/su                                  ./squashfs-root/system/bin/.ext/.su
cp ./su/x64/su                                  ./squashfs-root/system/xbin/daemonsu
cp ./su/x64/supolicy                            ./squashfs-root/system/xbin/supolicy
cp ./su/x64/libsupol.so                         ./squashfs-root/system/lib64/libsupol.so
cp ./squashfs-root/system/bin/app_process64     ./squashfs-root/system/bin/app_process_init
cp ./squashfs-root/system/bin/app_process64     ./squashfs-root/system/bin/app_process64_original
cp ./squashfs-root/system/xbin/daemonsu         ./squashfs-root/system/bin/app_process
cp ./squashfs-root/system/xbin/daemonsu         ./squashfs-root/system/bin/app_process64

chmod +x ./squashfs-root/system/app/SuperSU/SuperSU.apk
chmod +x ./squashfs-root/system/etc/install-recovery.sh
chmod +x ./squashfs-root/system/bin/install-recovery.sh
chmod +x ./squashfs-root/system/xbin/su
chmod +x ./squashfs-root/system/bin/.ext/.su
chmod +x ./squashfs-root/system/xbin/daemonsu
chmod +x ./squashfs-root/system/xbin/supolicy
chmod +x ./squashfs-root/system/lib64/libsupol.so
chmod +x ./squashfs-root/system/bin/app_process_init
chmod +x ./squashfs-root/system/bin/app_process64_original
chmod +x ./squashfs-root/system/bin/app_process
chmod +x ./squashfs-root/system/bin/app_process64

# ======== 制作镜像 ========
echo -e "${FC_GREEN}正在打包android镜像${FC_DEFAULT}"
rm android.img
mksquashfs squashfs-root android.img -b 131072 -comp xz -Xbcj ia64

echo -e "${FC_GREEN}将android镜像复制到原来位置${FC_DEFAULT}"
cp android.img extract/usr/share/uengine/android.img

# ======== 准备制作软件包 ========
echo -e "${FC_GREEN}正在生成 md5sums${FC_DEFAULT}"
cd extract
find usr -type f -print0 |xargs -0 md5sum >md5sums
cd ..

echo -e "${FC_GREEN}正在打包 uengine-android-image${FC_DEFAULT}"
mkdir -p build
dpkg-deb -b extract/ build/
cp build/*.deb .

# ======== 将软件包提取到工作目录 ========
echo -e "${FC_GREEN}正在清理垃圾...${FC_DEFAULT}"
rm android.img
rm -rf extract su squashfs-root 
rm SuperSU-v2.82-201705271822.zip
rm -rf build

echo -e "${FC_GREEN}请进入目录 $WORKDIR 安装生成的 deb 包${FC_DEFAULT}"
echo -e "${FC_GREEN}安装 deb 后重启即可生效${FC_DEFAULT}"
ls
