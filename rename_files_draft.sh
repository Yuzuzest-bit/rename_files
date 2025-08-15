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

echo "フォルダ「$(basename "$TARGET_DIR")」とそのサブフォルダ内のファイルを処理します..."

# findコマンドで対象フォルダ内のファイルを再帰的に検索し、ループ処理する
find "$TARGET_DIR" -type f | while IFS= read -r FILEPATH
do
  # ファイル名とディレクトリのパスを取得
  DIRNAME=$(dirname "$FILEPATH")
  BASENAME=$(basename "$FILEPATH")

  # ファイル名の先頭にプレフィックスがまだ付いていないかチェック
  if [[ "$BASENAME" != "$PREFIX"* ]]; then
    # mvコマンドでファイル名を変更
    mv "$FILEPATH" "$DIRNAME/${PREFIX}${BASENAME}"
    echo "リネーム: $BASENAME -> ${PREFIX}${BASENAME}"
  else
    echo "スキップ: $BASENAME （既にプレフィックスが付いています）"
  fi
done

echo "処理が完了しました。🎉"
