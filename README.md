> [!IMPORTANT]
> **刷入之前，请务必先阅读下方的「刷入与测试」教程。**
>
> **维护者：ZiLing_Fox** —— 遇到任何问题千万要提 [Issue](https://github.com/KextNor/orangefox-polaris/issues/new?template=bug_report.yml) 告诉开发者，不然就没法修 bug 了 xwx

# OrangeFox Recovery R12 for Xiaomi Mi MIX 2S (polaris)

非官方（Unofficial）的 OrangeFox Recovery R12 构建，设备树 + GitHub Actions 自动编译。

- 源码基线：OrangeFox `fox_12.1`（`FOX_INTERNAL_RELEASE = R12.0`）
- 版本号：`R12.0_1`
- 维护者：ZiLing_Fox

---

## 一、刷入与测试（先看这里）

### 1. 下载

到 [Releases](https://github.com/KextNor/orangefox-polaris/releases) 下载最新的：

- `OrangeFox-R12.0_1-Unofficial-polaris.img` —— 用 fastboot 刷
- `OrangeFox-R12.0_1-Unofficial-polaris.zip` —— 在已有 Recovery 里刷

解压/下载后建议用附带的 `.md5` 校验一下完整性。

### 2. 前置检查

```bash
fastboot devices                     # 能看到设备
fastboot getvar unlocked             # 必须返回 yes，否则先解锁 bootloader
```

### 3. 方式 A：fastboot 刷入（推荐）

```bash
fastboot erase recovery
fastboot flash recovery OrangeFox-R12.0_1-Unofficial-polaris.img
fastboot reboot recovery
```

### 4. 方式 B：刷 zip（已有 Recovery 时最稳）

把 `.zip` 拷进手机，在现有 Recovery 里直接选它安装。

### 5. 方式 C：临时启动（不进分区，用来验证镜像是否正常）

```bash
fastboot boot OrangeFox-R12.0_1-Unofficial-polaris.img
```

临时进入后，可在 Recovery 内 → **安装 → 安装镜像 → 选择 `recovery.img` → 目标分区选 Recovery**，把镜像写进分区。

> `fastboot boot` 只是临时加载，重启后不会保留。

### 6. 进入 Recovery

关机状态下按住 **电源键 + 音量上键**，出现小米 Logo 后松开。

### 7. 常见问题

| 现象 | 说明 / 处理 |
|------|-------------|
| 卡在 `sending 'recovery'` | 换 USB 2.0 口、原装线，或改用方式 C |
| 刷入成功但按键进不去、黑屏重启 | 用方式 C 临时启动后，在 Recovery 内刷入镜像 |
| 能进 Recovery 但看不到内部存储 | `/data` 未能解密。本构建基于 `fox_12.1`，对 Android 15（如 LineageOS 22.x）的 FBE 可能不兼容 |
| 刷完重启又变成官方 Recovery | MIUI/HyperOS 会还原 recovery，刷完请立即进入并刷一次 OrangeFox zip |

### 8. 回退

保留一份官方 R11.1 的 zip/img，出问题时用同样的方式刷回即可。

---

## 二、版本信息

| 项目 | 值 |
|------|-----|
| 发行版本 | R12.0_1 |
| 构建类型 | Unofficial |
| 源码分支 | fox_12.1 |
| 维护者 | ZiLing_Fox |

`FixN-` 前缀只是 GitHub Release 的发布序号，不影响 Recovery 内部显示的版本号。

---

## 三、设备规格

| Device | Xiaomi Mi MIX 2S |
|--------|------------------|
| SoC | Qualcomm SDM845 Snapdragon 845 |
| CPU | 8x Qualcomm Kryo 385 up to 2.8GHz |
| GPU | Adreno 630 |
| Memory | 6GB / 8GB RAM (LPDDR4X) |
| Storage | 64GB / 128GB / 256GB UFS 2.1 |
| Battery | 3400 mAh Li-Po |
| Display | 2160 x 1080 (18:9), 5.99 inch |

---

## 四、如何编译

### 使用 GitHub Actions

1. 向 `main` 分支推送提交（会自动触发），或在 **Actions** 页面手动 `Run workflow`
2. 等待完成（约 45 分钟）
3. 构建成功后会自动创建 Release，同时产物也可在 **Artifacts** 下载

### 本地编译

```bash
# 同步 OrangeFox 源码
mkdir ~/OrangeFox_sync && cd ~/OrangeFox_sync
git clone https://gitlab.com/OrangeFox/sync.git
cd sync
./orangefox_sync.sh --branch 12.1 --path ~/fox_12.1

# 放置设备树（vendorsetup.sh 会自动克隆 sdm845-common）
cd ~/fox_12.1
git clone https://gitlab.com/OrangeFox/device/polaris.git -b fox_12.1 device/xiaomi/polaris

# 编译
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=polaris
export LC_ALL="C"
source build/envsetup.sh
lunch twrp_polaris-eng
mka adbd recoveryimage
```

产物位于 `out/target/product/polaris/`。

### 可选构建变量

- 动态分区：`export FOX_USE_DYNAMIC_PARTITIONS=1`
- Keymaster 4.0：`export FOX_USE_KEYMASTER_4=1`

---

## 五、Credits

- [OrangeFox Recovery Project](https://gitlab.com/OrangeFox)
- 官方设备树：[polaris](https://gitlab.com/OrangeFox/device/polaris)、[sdm845-common](https://gitlab.com/OrangeFox/device/sdm845-common)

## 六、License

GPL v3
