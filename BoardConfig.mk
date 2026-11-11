#
# Copyright (C) 2022 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
# 	
# 	Please maintain this if you use this script or any part of it
#

# Inherit from common sdm845 BoardConfig
include device/xiaomi/sdm845-common/BoardConfigCommon.mk
#

# 与官方 R11 行为保持一致：
# 1) 不使用 AVB 签名。通用树会用 AOSP 测试密钥给 recovery 签名，
#    与设备 vbmeta 中的密钥不匹配，写进分区后 bootloader 校验失败 -> 黑屏重启。
BOARD_AVB_ENABLE :=
# 2) 不做分区对齐填充。通用树会把镜像 padding 到 67108864 字节（正好等于分区大小），
#    部分 fastboot 在传输"占满分区的镜像"时会卡在 sending。
BOARD_RECOVERYIMAGE_PARTITION_SIZE :=
#
