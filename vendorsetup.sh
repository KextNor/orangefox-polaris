#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2018-2024 The OrangeFox Recovery Project
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
FDEVICE="polaris"

fetch_sdm845_common_repo() {
	local URL=https://gitlab.com/OrangeFox/device/sdm845-common.git;
	local common=device/xiaomi/sdm845-common;
	local branch=fox_12.1;

	if [ ! -d $common ]; then
		echo "Cloning $URL ... to $common";
		git clone $URL -b $branch $common;
	else
		echo "Device common repository: \"$common\" found ...";
	fi
}

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep \"$FDEVICE\")
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep \"$FDEVICE\")
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	# clone the common repo if necessary
	fetch_sdm845_common_repo;

	# pull in the common vendorsetup.sh
	source device/xiaomi/sdm845-common/vendorsetupcommon.sh

	# --- Maintainer Info ---
	export OF_MAINTAINER="ZiLing_Fox"
	export FOX_MAINTAINER_PATCH_VERSION="3"
	# --- End Maintainer Info ---

	# --- Device Fixes ---
	# polaris ships keymaster 4.0 on Android 12+ ROMs; the common tree
	# defaults to the keymaster 3.0 vintf manifest, which breaks FBE
	# decryption (and therefore the app manager).
	export FOX_USE_KEYMASTER_4=1
	# --- End Device Fixes ---

	# --- Default UI Customization ---
	# 默认时区：Asia/Shanghai（东八区，无夏令时）。
	# POSIX 格式里东八区写 CST-8（注意符号是反的：GMT+8 → offset=-8）。
	# OrangeFox 原默认值是 CET-1;CEST,...（中欧），对中国用户显示时间极不准。
	# 格式参考 gui/theme/*/pages/settings.xml 的 <listitem> 示例。
	export OF_DEFAULT_TIMEZONE="CST-8"
	# --- End Default UI Customization ---

	# --- Fox Addons（ZIP 安装器内置补丁）---
	# OF_ENABLE_FRP_ADDON=1：在 OrangeFox ZIP 里加入一个擦除 FRP 分区的补丁。
	# polaris 有独立 frp 分区（约 1.5 MB），所以这个 addon 对它有效。
	# 注意：这是 EXPERIMENTAL 功能，且只在「刷 ROM / 刷 OrangeFox ZIP」流程中出现
	# （Fox Addons 页面），不是 Recovery 运行时的 UI 插件中心。
	# 如果后续发现有副作用，可以把这行改成 0 或删掉。
	export OF_ENABLE_FRP_ADDON=1
	# --- End Fox Addons ---
else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
#
