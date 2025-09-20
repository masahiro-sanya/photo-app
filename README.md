# Photo App 開発手順 / README

このリポジトリの開発に必要な初期セットアップ、依存関係のインストール、起動・テスト方法をまとめます。

## 要件
- Ruby: `3.4.6`（`mise`/`asdf` 管理）
- Bundler: `2.7.x`
- PostgreSQL: `14+`（開発・テスト用）
- macOS/Linux（Windows の場合は WSL2 推奨）

任意（必要に応じて）:
- Google Chrome（システムテストで利用）

## バージョン管理ツール（mise）
本プロジェクトは `.mise.toml` / `.tool-versions` で Ruby を `3.4.6` に固定しています。

1) リポジトリを信頼登録
- `mise trust .`

2) シェル有効化（恒久設定）
- `~/.zshrc` に以下を追記し、シェルを再起動
- ``eval "$(mise activate zsh)"``

3) 必要ツールのインストール
- `mise install`

以降、`mise` が自動でバージョンを切り替えます。明示的に使う場合は `mise exec -- <cmd>` を付与してください。

## 依存関係のインストール
- `bundle install`

Bundler のバージョン相違がある場合は自動で 2.7 系に切り替わります。

## データベース設定（PostgreSQL）
デフォルトで PostgreSQL を使用します。ローカルに Postgres を用意して、開発用 DB とユーザーを作成してください。

例（macOS/Homebrew）:
- `brew install postgresql`（未導入の場合）
- `brew services start postgresql`

例（ユーザー/DB 作成）:
- `createuser -s $USER`（または `postgres` ユーザーを使用）
- `createdb photo_app_development`
- `createdb photo_app_test`

環境変数（任意）:
- `DATABASE_URL=postgres://postgres:postgres@localhost:5432` のように指定可能です。
  環境に合わせてユーザー名/パスワード/ポートを調整してください。

## 初期化と起動
- DB 初期化: `bin/rails db:setup`（既存なら `bin/rails db:migrate`）
- 開発サーバ起動: `bin/rails s`
- ブラウザで確認: http://localhost:3000

## テスト
- 実行: `bin/rails test`（システムテスト含む場合は Chrome が必要）
- 失敗時のスクリーンショット: `tmp/screenshots` に保存されます（CI でも取得）

## Lint / セキュリティスキャン
- RuboCop: `bin/rubocop`
- Brakeman: `bin/brakeman`
- Importmap 監査（JS 依存）: `bin/importmap audit`

これらの実行ファイルが `bin/` にない場合は、以下で binstub を生成できます:
- `bundle binstubs rubocop brakeman --path=bin`

## CI について
GitHub Actions（`.github/workflows/ci.yml`）で以下を実行します:
- セキュリティスキャン（Brakeman / Importmap）
- Lint（RuboCop）
- テスト（PostgreSQL サービスを起動し、`bin/rails db:test:prepare test test:system` を実行）

CI の Ruby バージョンは `3.4.6` に固定しています。

## トラブルシュート
- `ruby -v` が 3.4.6 にならない
  - シェルで `eval "$(mise activate zsh)"` が有効になっているか確認
  - 一時的には `mise exec -- ruby -v` で確認
- Postgres に接続できない
  - `psql` で接続確認し、ユーザー/DB/ポート/パスワードを見直す
  - 開発用 `DATABASE_URL` を環境に合わせて設定

## 補足
- `.mise.toml` と `.tool-versions` のどちらでも Ruby バージョンを解決できます。
- rbenv を使用しないため `.ruby-version` は管理していません。
