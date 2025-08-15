#!/bin/bash

# 実行時にフォルダが指定されているかチェック
if [ -z "$1" ]; then
  echo "エラー: 対象のフォルダが指定されていません。"
  echo "使い方: ./remove_prefix.sh /path/to/your/folder"
  exit 1
fi

# 指定されたフォルダのパスを変数に入れる
TARGET_DIR="$1"

# 指定されたフォルダが存在するかチェック
if [ ! -d "$TARGET_DIR" ]; then
  echo "エラー: 指定されたフォルダが見つかりません: $TARGET_DIR"
  exit 1
fi

echo "フォルダ「$(basename "$TARGET_DIR")」とそのサブフォルダ内のファイルのプレフィックスを削除します..."

# findコマンドで対象フォルダ内のファイルを再帰的に検索し、ループ処理する
find "$TARGET_DIR" -type f | while IFS= read -r FILEPATH
do
  # ファイル名とディレクトリのパスを取得
  DIRNAME=$(dirname "$FILEPATH")
  BASENAME=$(basename "$FILEPATH")

  # ファイル名が 【...】 で始まるかチェック
  if [[ "$BASENAME" == 【*】* ]]; then
    # sedコマンドで 【...】 の部分を削除した新しいファイル名を生成
    NEW_BASENAME=$(echo "$BASENAME" | sed -E 's/^【[^】]+】//')
    
    # ファイル名が空にならないか念のためチェック
    if [ -n "$NEW_BASENAME" ]; then
      # mvコマンドでファイル名を変更
      mv "$FILEPATH" "$DIRNAME/$NEW_BASENAME"
      echo "リネーム: $BASENAME -> $NEW_BASENAME"
    else
      echo "スキップ: $BASENAME （プレフィックス削除後にファイル名が空になるため）"
    fi
  else
    echo "スキップ: $BASENAME （対象のプレフィックスが見つかりません）"
  fi
done

echo "処理が完了しました。🎉"
