# UEngine 安卓容器 root 计划


1. 执行 `./root-uengine.sh` 即可开始获取制作临时软件包
    ```sh
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
    ```