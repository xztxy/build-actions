#!/bin/bash
# https://github.com/281677160/build-actions
# common Module by 28677160
# matrix.target=${FOLDER_NAME}

ACTIONS_VERSION="2.8.0"

function TIME() {
  case "$1" in
    r) local Color="\033[0;31m";;
    g) local Color="\033[0;32m";;
    y) local Color="\033[0;33m";;
    b) local Color="\033[0;34m";;
    z) local Color="\033[0;35m";;
    l) local Color="\033[0;36m";;
    *) local Color="\033[0;0m";;
  esac
echo -e "\n${Color}${2}\033[0m"
}

function variable() {
local overall="$1"
export "${overall}"
echo "${overall}" >> "${GITHUB_ENV}"
}

function Diy_variable() {
# 读取变量
case "${SOURCE_CODE}" in
COOLSNOWWOLF)
  variable REPO_URL="https://github.com/coolsnowwolf/lede"
  variable SOURCE="Lede"
  variable SOURCE_OWNER="Lean"
  variable LUCI_EDITION="23.05"
  variable DISTRIB_SOURCECODE="lede"
  variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
LIENOL)
  variable REPO_URL="https://github.com/Lienol/openwrt"
  variable SOURCE="Lienol"
  variable SOURCE_OWNER="Lienol"
  variable DISTRIB_SOURCECODE="lienol"
  variable LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
IMMORTALWRT)
  variable REPO_URL="https://github.com/immortalwrt/immortalwrt"
  variable SOURCE="Immortalwrt"
  variable SOURCE_OWNER="ctcgfw"
  variable DISTRIB_SOURCECODE="immortalwrt"
  variable LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
XWRT)
  variable REPO_URL="https://github.com/x-wrt/x-wrt"
  variable SOURCE="Xwrt"
  variable SOURCE_OWNER="ptpt52"
  variable DISTRIB_SOURCECODE="xwrt"
  variable LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
OFFICIAL)
  variable REPO_URL="https://github.com/openwrt/openwrt"
  variable SOURCE="Official"
  variable SOURCE_OWNER="openwrt"
  variable DISTRIB_SOURCECODE="official"
  variable LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
  variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
MT798X)
  if [[ "${REPO_BRANCH}" == "hanwckf-21.02" ]]; then
    echo "hanwckf-21.02"
    variable REPO_URL="https://github.com/hanwckf/immortalwrt-mt798x"
    variable SOURCE="Mt798x"
    variable SOURCE_OWNER="hanwckf"
    variable REPO_BRANCH="openwrt-21.02"
    variable DISTRIB_SOURCECODE="immortalwrt"
    variable LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
    variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
  else
    variable REPO_URL="https://github.com/padavanonly/immortalwrt-mt798x-6.6"
    variable SOURCE="Mt798x"
    variable SOURCE_OWNER="padavanonly"
    if [[ "${REPO_BRANCH}" == "openwrt-24.10-6.6" ]]; then
      variable LUCI_EDITION="24.10"
    elif [[ "${REPO_BRANCH}" == "2410" ]]; then
      variable REPO_BRANCH="openwrt-24.10-6.6"
      variable LUCI_EDITION="24.10"
    else
      variable LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g')"
    fi
    variable DISTRIB_SOURCECODE="immortalwrt"
    variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
  fi
;;
FANCHMWRT)
  variable REPO_URL="https://github.com/fanchmwrt/fanchmwrt"
  variable SOURCE="Fanchmwrt"
  variable SOURCE_OWNER="fanchmwrt"
  variable DISTRIB_SOURCECODE="fanchmwrt"
  variable LUCI_EDITION="$(echo "${REPO_BRANCH}" |sed 's/openwrt-//g' |sed 's/fanchmwrt-//g')"
  variable GENE_PATH="${HOME_PATH}/package/base-files/files/bin/config_generate"
;;
*)
  TIME r "不支持${SOURCE_CODE}此源码，当前只支持COOLSNOWWOLF、LIENOL、IMMORTALWRT、XWRT、OFFICIAL、MT798X、FANCHMWRT"
  exit 1
;;
esac

variable FILES_PATH="${HOME_PATH}/package/base-files/files/etc/shadow"
variable DELETE="${HOME_PATH}/package/base-files/files/etc/deletefile"
variable DEFAULT_PATH="${HOME_PATH}/package/auto-scripts/files/99-first-run"
variable KEEPD_PATH="${HOME_PATH}/package/base-files/files/lib/upgrade/keep.d/base-files-essential"
variable CLEAR_PATH="/tmp/Clear"
variable UPGRADE_DATE="`date -d "$(date +'%Y-%m-%d %H:%M:%S')" +%s`"
variable GUJIAN_DATE="$(date +%m.%d)"
variable LICENSES_DOC="${HOME_PATH}/LICENSES/doc"

# 启动编译时的变量文件
if [[ "${BENDI_VERSION}" == "2" ]]; then
  install -m 0755 /dev/null "${COMPILE_PATH}/relevance/settings.ini"
  VARIABLES=(
  "SOURCE_CODE" "REPO_BRANCH" "CONFIG_FILE"
  "INFORMATION_NOTICE" "UPLOAD_FIRMWARE" "UPLOAD_RELEASE"
  "CACHEWRTBUILD_SWITCH" "UPDATE_FIRMWARE_ONLINE"
  "COMPILATION_INFORMATION" "KEEP_WORKFLOWS" "KEEP_RELEASES"
  )
  for var in "${VARIABLES[@]}"; do
    echo "${var}=${!var}" >> "${COMPILE_PATH}/relevance/settings.ini"
  done

  if [[ "${REPO_URL}" == *"hanwckf"* ]]; then
    sed -i "/REPO_BRANCH/d" "${COMPILE_PATH}/relevance/settings.ini"
    echo "REPO_BRANCH=hanwckf-21.02" >> "${COMPILE_PATH}/relevance/settings.ini"
  fi
fi
}

# 其他函数保持不变...