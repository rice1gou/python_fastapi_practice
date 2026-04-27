# コーディング規約

## アーキテクチャ

3層アーキテクチャを採用する。

```
Router（エンドポイント定義）
  └── Service（ビジネスロジック）
        └── Repository（DB アクセス）
```

- Router にビジネスロジックを書かない
- Service に DB アクセスロジックを書かない
- 例外の HTTP 変換は個別エンドポイントで行わず、例外ハンドラに集約する

## 関数設計

- 1関数は単一の責務を持つ（目安: 20行以内）
- 計算ロジックと副作用（I/O、DB 操作）を分離する
- 外部依存は `Protocol` で定義し、実装と疎結合にする
- `async def` 内でブロッキング I/O を呼ばない

## 型アノテーション

- 全関数の引数・戻り値に型アノテーションを付ける
- 関数間のデータ受け渡しには Pydantic モデルを使う
- `Any` を使う場合は理由コメントを付ける

```python
# 良い例
async def get_task(task_id: int, db: AsyncSession) -> TaskResponse:
    ...

# 悪い例
async def get_task(task_id, db):
    ...
```

## エラー処理

- カスタム Error クラスを定義して使う
- エラーにはデバッグ用の context を含める
- 例外変換では `from e` を使ってチェーンを保持する
- 例外を握りつぶさない

```python
# 良い例
class TaskNotFoundError(AppError):
    def __init__(self, task_id: int) -> None:
        super().__init__(f"task not found", context={"task_id": task_id})

try:
    result = await repository.find(task_id)
except DBError as e:
    raise TaskNotFoundError(task_id) from e
```

## ログ

- `logging.getLogger(__name__)` でロガーを取得する
- JSON 形式で出力する（structlog 等を使用）
- ログに機密情報（パスワード、トークン）を含めない
- event の命名は `{処理名}_{結果}` 形式にする（例: `task_created`, `auth_failed`）

```python
logger = logging.getLogger(__name__)

logger.info("task_created", extra={"task_id": task.id, "user_id": user.id})
```

## 設定値

- 設定値は環境変数経由で取得する
- `pydantic-settings` の `BaseSettings` を継承した `Settings` クラスに集約する
- マジックナンバーは定数化し、理由コメントを付ける

## FastAPI / OpenAPI

- エンドポイントには `summary`・`response_model`・`responses` を定義する
- Pydantic の全フィールドに `description` を付ける

```python
@router.post(
    "/tasks",
    summary="タスクを作成する",
    response_model=TaskResponse,
    responses={401: {"model": ErrorResponse}, 422: {"model": ErrorResponse}},
)
async def create_task(...) -> TaskResponse:
    ...
```

## テスト

- テスト関数名は `test_{対象}_{条件}_{期待結果}` 形式にする
- `datetime.now()` / `uuid()` をテスト内で直接呼ばない（固定値か mock を使う）
- Arrange / Act / Assert の構造で書く

```python
async def test_create_task_with_valid_input_returns_created_task():
    # Arrange
    payload = TaskCreateRequest(title="買い物", done=False)

    # Act
    result = await service.create_task(payload, user_id=1)

    # Assert
    assert result.title == "買い物"
```

## 依存管理

- パッケージ管理には `uv` を使う
- 依存関係は `pyproject.toml` で管理する
- 開発用依存は `[dependency-groups]` に分ける
