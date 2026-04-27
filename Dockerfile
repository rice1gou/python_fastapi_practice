# syntax=docker/dockerfile:1

FROM python:3.12-slim AS base

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

WORKDIR /app

COPY pyproject.toml uv.lock* ./

# ── development target ────────────────────────────────────────────────────────
FROM base AS dev

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen

# ── builder (production deps only) ───────────────────────────────────────────
FROM base AS builder

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# ── production ────────────────────────────────────────────────────────────────
FROM python:3.12-slim AS production

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
COPY --from=builder /app/.venv /app/.venv

WORKDIR /app
COPY src/ ./src/

RUN useradd --create-home appuser
USER appuser

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
