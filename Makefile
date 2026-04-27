.PHONY: shell init sync run test lint format typecheck

# ── ホスト側 ──────────────────────────────────────────────────────────────────
shell:
	docker exec -it be bash -i

# ── コンテナ内（初回セットアップ） ────────────────────────────────────────────
init:
	uv sync

# ── コンテナ内（開発中の日常コマンド） ───────────────────────────────────────
run:
	uv run uvicorn src.main:app --reload

test:
	uv run pytest

lint:
	uv run ruff check src

format:
	uv run ruff format src

typecheck:
	uv run mypy src
