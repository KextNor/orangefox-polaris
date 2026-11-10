# OrangeFox Recovery R12 for Xiaomi Mi Mix 2S (polaris)

This repository contains the device tree and GitHub Actions workflow for building OrangeFox Recovery R12 for the Xiaomi Mi Mix 2S (codenamed *polaris*).

## Device Specifications

| Device | Xiaomi Mi MIX 2S |
|--------|------------------|
| SoC | Qualcomm SDM845 Snapdragon 845 |
| CPU | 8x Qualcomm Kryo 385 up to 2.8GHz |
| GPU | Adreno 630 |
| Memory | 6GB / 8GB RAM (LPDDR4X) |
| Storage | 64GB / 128GB / 256GB UFS 2.1 |
| Battery | 3400 mAh Li-Po |
| Display | 2160 x 1080 (18:9), 5.99 inch |

## How to Build

### Using GitHub Actions (recommended)

1. Push any commit to the `main` branch, or go to the **Actions** tab and run the workflow manually.
2. Wait for the build to complete (takes ~1-2 hours).
3. Download the compiled recovery image from the **Artifacts** section.

### Building Locally

```bash
# Sync OrangeFox sources
mkdir ~/OrangeFox_sync
cd ~/OrangeFox_sync
git clone https://gitlab.com/OrangeFox/sync.git
cd sync
./orangefox_sync.sh --branch 12.1 --path ~/fox_12.1

# Setup device tree
cd ~/fox_12.1
git clone https://gitlab.com/OrangeFox/device/polaris.git -b fox_12.1 device/xiaomi/polaris
# (vendorsetup.sh will auto-clone sdm845-common)

# Build
export ALLOW_MISSING_DEPENDENCIES=true
export FOX_BUILD_DEVICE=polaris
export LC_ALL="C"
source build/envsetup.sh
lunch twrp_polaris-eng
mka adbd recoveryimage
```

The output will be at `out/target/product/polaris/OrangeFox-unofficial-polaris.img`.

## Build Variants

- **Default**: Standard build for most ROMs
- **Dynamic partitions**: `export FOX_USE_DYNAMIC_PARTITIONS=1` before building
- **Keymaster 4.0**: `export FOX_USE_KEYMASTER_4=1` before building

## Credits

- [OrangeFox Recovery Project](https://gitlab.com/OrangeFox)
- Official device trees: [polaris](https://gitlab.com/OrangeFox/device/polaris) and [sdm845-common](https://gitlab.com/OrangeFox/device/sdm845-common)

## License

This project is licensed under the GPL v3 License.
