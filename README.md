# Photo App（開発メモ）

最小構成のセットアップ手順のみ記載します。

## 必要環境
- Ruby 3.4.6（mise）
- PostgreSQL 14+

## セットアップ
1) ランタイム準備: `mise trust . && mise install`
2) 依存インストール: `bundle install`
3) 環境変数: `cp .env.example .env` → `OAUTH_CLIENT_ID`/`OAUTH_CLIENT_SECRET` を設定
4) DB 作成/初期化: `bin/rails db:setup`（初期ユーザー: `admin / password123`）

## 起動
- `bin/rails s`（または `mise exec -- bin/rails s`）
- http://localhost:3000

## よく使うコマンド
- マイグレーション/シード: `bin/rails db:migrate`, `bin/rails db:seed`
- テスト: `bin/rails test`

## メモ
- `.env` は Git 無視。値は `.env.example` を参照
- 画像は開発環境では `storage/` に保存
 - いまのところ自動テストは未整備です（ディレクトリは用意済み）。