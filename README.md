## 推奨成果物：タスク管理 API

なぜタスク管理か

```
シンプルすぎず・複雑すぎない
├── CRUD が一通り揃う（GET / POST / PUT / DELETE）
├── 認証（JWT）を自然に組み込める
├── ユーザーとタスクの関係でリレーションが学べる
└── 業務システムのAPIと構造が近い
```

3時間のタイムライン

### Phase 1（45分）：環境構築 + プロジェクト骨格

```
Dev Container を立ち上げて、アプリが起動するところまで。
├── .devcontainer/
├── src/
│   ├── main.py        # FastAPI インスタンス・ルーター登録
│   ├── database.py    # AsyncSession・get_db
│   ├── models/
│   │   └── user.py    # SQLAlchemy モデル（Userだけ）
│   └── schemas/
│       └── user.py    # Pydantic スキーマ
└── pyproject.toml     # uv で管理
到達目標： GET /health が返る・uv run pytest が通る
```

### Phase 2（60分）：タスク CRUD + テスト

```
ビジネスロジックを Router → Service → Repository の3層で実装しながらテストも書く。
実装するエンドポイント
├── POST   /tasks          タスク作成
├── GET    /tasks          一覧取得
├── GET    /tasks/{id}     詳細取得
├── PUT    /tasks/{id}     更新
└── DELETE /tasks/{id}     削除
到達目標： 統合テストが全部グリーン
```

### Phase 3（45分）：JWT 認証

```
ログイン・認証済みユーザーだけタスクを操作できる仕組みを Depends で実装。
├── POST /auth/register    ユーザー登録
├── POST /auth/login       JWT トークン発行
└── 全タスク系エンドポイントに Depends(get_current_user) を追加
到達目標： 未認証リクエストが 401 を返すテストが通る
```

### Phase 4（30分）：レビュー・振り返り

```
ここで私にコードを貼ってもらえれば、以下の観点でレビューします。
├── 層の責務は正しく分かれているか
├── 非同期の使い方は適切か
├── Pydantic スキーマの設計
├── テストの網羅性・書き方
└── 改善できる箇所の提案
```

### 最終的な成果物イメージ

```
機能面
├── ユーザー登録・ログイン（JWT認証）
├── タスクの CRUD（認証必須）
└── 自分のタスクだけ見える（認可）

品質面
├── ユニットテスト：Service層のビジネスロジック
├── 統合テスト：APIエンドポイント〜DB
└── 型・リント・フォーマットが CI で通る
```
