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

# polaris 的 5.99" IPS 面板物理上限就是 60Hz（2160x1080）。
# common 树里的 120 与硬件不符，会让 GUI 按 8.3ms 计时但实际每帧 16.7ms。
TW_FRAMERATE := 60
#
