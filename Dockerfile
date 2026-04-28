# syntax=docker/dockerfile:1

FROM python:3.12-slim AS base

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/venv

WORKDIR /app

COPY pyproject.toml uv.lock* ./

# ── development target ────────────────────────────────────────────────────────
FROM base AS dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    make \
    && rm -rf /var/lib/apt/lists/*

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen

# ── builder (production deps only) ───────────────────────────────────────────
FROM base AS builder

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# ── production ────────────────────────────────────────────────────────────────
FROM python:3.12-slim AS production

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
COPY --from=builder /venv /venv

WORKDIR /app
COPY src/ ./src/

RUN useradd --create-home appuser
USER appuser

ENV PATH="/venv/bin:$PATH"

EXPOSE 8000
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
