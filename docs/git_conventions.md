# Git 規約

## ブランチ戦略

`main` ブランチを常にデプロイ可能な状態に保つ。作業は必ずフィーチャーブランチで行い、PR を通じてマージする。

## ブランチ命名規則

```
{type}/{issue-number}-{kebab-case-description}
```

| type | 用途 |
|------|------|
| `feature` | 新機能・機能追加 |
| `fix` | バグ修正 |
| `hotfix` | 本番環境の緊急修正 |
| `chore` | ビルド・CI・依存更新など |
| `docs` | ドキュメント修正 |
| `refactor` | リファクタリング |

例:
```
feature/7-add-documents-for-claudecode
fix/12-fix-task-not-found-error
chore/5-update-dependencies
```

## コミットメッセージ

```
{type}: {日本語の概要}
```

| type | 用途 |
|------|------|
| `add` | 新機能・ファイル追加 |
| `fix` | バグ修正 |
| `update` | 既存機能の改修 |
| `remove` | 削除 |
| `refactor` | リファクタリング（動作変更なし） |
| `test` | テスト追加・修正 |
| `docs` | ドキュメント |
| `chore` | ビルド・CI・依存更新 |

例:
```
add: タスク作成エンドポイントの実装
fix: JWT トークン期限切れ時の 500 エラーを修正
test: タスク CRUD の統合テストを追加
```

## Issue 種別

| ラベル | テンプレート | 用途 |
|--------|------------|------|
| `epic` | Epic | 大きな機能のまとまり |
| `story` | Story | ユーザーストーリー単位の機能開発 |
| `task` | Task | Story を実現する具体的な作業 |
| `chore` | Chore | 非機能改善（CI、依存更新など） |
| `hotfix` | Hotfix | 本番環境の緊急バグ修正 |

## Pull Request

- PR テンプレート（`.github/pull_request_template.md`）に従って記載する
- `closes #{issue-number}` で関連 Issue を紐付ける
- セルフレビュー後にレビュー依頼する
- チェックリストを全項目確認してから PR を作成する

## マージ

- `main` への直接 push は禁止
- PR は必ず 1 名以上のレビュー承認を得てからマージする
- マージ前に CI（型チェック・リント・テスト）が全て通っていることを確認する
