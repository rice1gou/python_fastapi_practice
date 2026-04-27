# CLAUDE.md

このファイルは Claude Code がこのリポジトリで作業する際のガイドラインです。

## プロジェクト概要

FastAPI を使ったタスク管理 API の学習プロジェクト。JWT 認証・非同期 DB アクセス・3層アーキテクチャを実践する。

## 技術スタック

- **言語**: Python 3.12+
- **フレームワーク**: FastAPI
- **ORM**: SQLAlchemy (async)
- **バリデーション**: Pydantic v2
- **認証**: JWT (python-jose)
- **パッケージ管理**: uv
- **テスト**: pytest + pytest-asyncio
- **型チェック**: mypy
- **リント・フォーマット**: ruff

## アーキテクチャ

3層アーキテクチャを採用している。

```
src/
├── main.py            # FastAPI インスタンス・ルーター登録
├── database.py        # AsyncSession・get_db
├── routers/           # エンドポイント定義（ビジネスロジックを書かない）
├── services/          # ビジネスロジック
├── repositories/      # DB アクセスロジック
├── models/            # SQLAlchemy モデル
├── schemas/           # Pydantic スキーマ
├── errors/            # カスタム例外クラス
└── config.py          # pydantic-settings による設定値管理
```

## 規約

### コーディング規約

[docs/coding_conventions.md](docs/coding_conventions.md) を参照。

要点:
- Router にビジネスロジックを書かない
- 全関数に型アノテーションを付ける
- カスタム Error クラスを使い、例外を握りつぶさない
- `async def` 内でブロッキング I/O を呼ばない
- テスト関数名は `test_{対象}_{条件}_{期待結果}` 形式

### Git 規約

[docs/git_conventions.md](docs/git_conventions.md) を参照。

要点:
- ブランチ名: `{type}/{issue-number}-{kebab-case-description}`
- コミット: `{type}: {日本語の概要}`
- `main` への直接 push 禁止・PR 必須

## よく使うコマンド

```bash
# 依存インストール
uv sync

# アプリ起動
uv run uvicorn src.main:app --reload

# テスト実行
uv run pytest

# 型チェック
uv run mypy src

# リント・フォーマット
uv run ruff check src
uv run ruff format src
```

## コード変更時の注意

- 新しいエンドポイントを追加するときは必ず `response_model` と `responses` を定義する
- 設定値をコード中にハードコードしない（`Settings` クラス経由で取得する）
- テストは Arrange / Act / Assert の構造で書く
- DB アクセスは必ず Repository 層に閉じる
