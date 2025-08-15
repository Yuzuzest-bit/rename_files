#!/bin/bash

# --- 設定 ---
# ここに追加したいプレフィックス（接頭辞）を記入してください
PREFIX="【ドラフト版1.0.0】"
# ------------

# 実行時にフォルダが指定されているかチェック
if [ -z "$1" ]; then
  echo "エラー: 対象のフォルダが指定されていません。"
  echo "使い方: sh rename_files.sh /path/to/your/folder"
  exit 1
fi

# 指定されたフォルダのパスを変数に入れる
TARGET_DIR="$1"

# 指定されたフォルダが存在するかチェック
if [ ! -d "$TARGET_DIR" ]; then
  echo "エラー: 指定されたフォルダが見つかりません: $TARGET_DIR"
  exit 1
fi

# 指定されたフォルダに移動
cd "$TARGET_DIR"

echo "フォルダ「$(basename "$TARGET_DIR")」内のファイルを処理します..."

# フォルダ内のファイルに対してループ処理
for ITEM in *
do
  if [ -f "$ITEM" ]; then
    if [[ "$ITEM" != "$PREFIX"* ]]; then
      mv "$ITEM" "${PREFIX}${ITEM}"
      echo "リネーム: $ITEM -> ${PREFIX}${ITEM}"
    else
      echo "スキップ: $ITEM"
    fi
  fi
done

echo "処理が完了しました。🎉"
