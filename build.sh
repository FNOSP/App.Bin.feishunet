#!/usr/bin/env bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

# 不传参就默认打两份
[ $# -eq 0 ] && TARGETS="x86 arm" || TARGETS="$1"

[ -z "$fnversion" ] && { echo "ERROR: 环境变量 fnversion 未设置！" >&2; exit 1; }

for ARCH in $TARGETS; do
  case "$ARCH" in
    x86|amd64) ARCH="x86";  BIN_URL="http://192.168.3.104:8888/buckets/feishunet/Linux-amd64/feishunet" ;;
    arm|arm64) ARCH="arm";  BIN_URL="http://192.168.3.104:8888/buckets/feishunet/Linux-aarch64/feishunet" ;;
    *) echo "未知架构: $ARCH"; exit 1 ;;
  esac

  echo "========== 开始打包 $ARCH =========="
  mkdir -p app/bin

  # 1. 拉二进制
  BIN_PATH="app/bin/feishunet"
  curl -fsSL "$BIN_URL" -o "$BIN_PATH"
  chmod +x "$BIN_PATH"

  # 2. 去 CR 并替换 version / platform
  sed -i 's/\r$//' manifest
  sed -Ei "s/^(version=).*/\1\"$fnversion\"/"     manifest
  sed -Ei "s/^(platform=).*/\1\"$ARCH\"/"        manifest

  # 3. 清理旧包
  rm -f app.tgz "feishunet-${ARCH}.fpk"

  # 4. 打 app.tgz
  tar -czf app.tgz --transform='s,^app/,,' app/ui app/bin

  # 5. 打最终 fpk
  tar --exclude='app' -czf "feishunet-${ARCH}.fpk" *

  ls -lh "feishunet-${ARCH}.fpk" app.tgz
  md5sum "feishunet-${ARCH}.fpk"
  echo
done

echo ">>> 全部完成！"
