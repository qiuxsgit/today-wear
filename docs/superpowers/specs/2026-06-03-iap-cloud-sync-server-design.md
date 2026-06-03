# 服务端设计：账号 + 穿搭数据 API + 云同步

> 状态：设计阶段 | 日期：2026-06-03

## 一、功能概述

为 Today Wear App 提供后端服务，支撑用户邮箱注册登录、穿搭数据 CRUD、OSS 图片存储、以及订阅状态验证。

### 核心原则

- **不信任客户端**：所有写操作必须验证 JWT 身份
- **订阅状态由服务端向 RevenueCat 核实**，不依赖客户端上报
- **图片不经过服务器**，客户端直传阿里云 OSS
- **服务端为数据源**，客户端本地 SQLite 为离线缓存

---

## 二、技术选型建议

| 层面 | 推荐方案 | 备选 |
|------|----------|------|
| 语言/框架 | Go + Gin | Python FastAPI / Node Express |
| 数据库 | PostgreSQL | MySQL 8.0 |
| 缓存 | Redis（JWT 黑名单、限流） | 可省略 MVP 阶段 |
| OSS | 阿里云 OSS + STS | — |
| 邮件服务 | 阿里云邮件推送 | Resend / SendGrid |
| 部署 | 阿里云 ECS + Docker | — |

---

## 三、数据库表（服务端）

### 3.1 users

```sql
CREATE TABLE users (
    id          BIGSERIAL PRIMARY KEY,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,           -- bcrypt hash
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);
```

### 3.2 refresh_tokens

```sql
CREATE TABLE refresh_tokens (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token       VARCHAR(512) NOT NULL UNIQUE,
    expires_at  TIMESTAMP NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
```

### 3.3 outfits

```sql
CREATE TABLE outfits (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date        BIGINT NOT NULL,                -- Unix 时间戳（毫秒）
    description TEXT NOT NULL DEFAULT '',
    is_deleted  SMALLINT NOT NULL DEFAULT 0,    -- 软删除
    created_at  BIGINT NOT NULL,                -- 客户端传入的原始时间戳
    updated_at  BIGINT NOT NULL,
    synced_at   TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_outfits_user_date ON outfits(user_id, date DESC);
CREATE INDEX idx_outfits_user_synced ON outfits(user_id, synced_at);
```

### 3.4 tags

```sql
CREATE TABLE tags (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name        VARCHAR(100) NOT NULL,
    color       VARCHAR(7) NOT NULL DEFAULT '#E8F5E9',  -- hex
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, name)
);
CREATE INDEX idx_tags_user_id ON tags(user_id);
```

### 3.5 outfit_tags

```sql
CREATE TABLE outfit_tags (
    id          BIGSERIAL PRIMARY KEY,
    outfit_id   BIGINT NOT NULL REFERENCES outfits(id) ON DELETE CASCADE,
    tag_id      BIGINT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(outfit_id, tag_id)
);
CREATE INDEX idx_outfit_tags_outfit ON outfit_tags(outfit_id);
CREATE INDEX idx_outfit_tags_tag ON outfit_tags(tag_id);
```

### 3.6 outfit_images

```sql
CREATE TABLE outfit_images (
    id            BIGSERIAL PRIMARY KEY,
    outfit_id     BIGINT NOT NULL REFERENCES outfits(id) ON DELETE CASCADE,
    oss_key       VARCHAR(512) NOT NULL,          -- OSS object key
    oss_url       VARCHAR(1024) NOT NULL,         -- 完整访问 URL
    display_order INT NOT NULL DEFAULT 0,
    created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_outfit_images_outfit ON outfit_images(outfit_id);
```

---

## 四、API 设计

### 4.1 认证 API

#### `POST /api/v1/auth/register`

```json
// Request
{ "email": "user@example.com", "password": "min8chars" }

// Response 201
{
  "user": { "id": 1, "email": "user@example.com" },
  "access_token": "eyJ...",
  "refresh_token": "rT_abc123...",
  "expires_in": 900
}
```

#### `POST /api/v1/auth/login`

```json
// Request
{ "email": "user@example.com", "password": "min8chars" }

// Response 200
{
  "user": { "id": 1, "email": "user@example.com" },
  "access_token": "eyJ...",
  "refresh_token": "rT_abc123...",
  "expires_in": 900
}
```

#### `POST /api/v1/auth/refresh`

```json
// Request
{ "refresh_token": "rT_abc123..." }

// Response 200
{
  "access_token": "eyJ...",
  "refresh_token": "rT_new...",
  "expires_in": 900
}
```

#### `POST /api/v1/auth/logout`

```json
// Header: Authorization: Bearer <access_token>
// Request: {}
// Response: 204
```

---

### 4.2 穿搭 API（均需 Authorization Header）

#### `GET /api/v1/outfits`

查询参数：
- `cursor` — 分页游标（上次返回的 `next_cursor`）
- `limit` — 每页条数，默认 20，最大 100
- `since` — Unix 时间戳，只返回此时间之后更新的记录（增量同步用）

```json
// Response 200
{
  "data": [
    {
      "id": 42,
      "date": 1704067200000,
      "description": "今日通勤穿搭",
      "tags": [
        { "id": 10, "name": "通勤", "color": "#E8F5E9" }
      ],
      "images": [
        { "id": 100, "oss_url": "https://...", "order": 0 },
        { "id": 101, "oss_url": "https://...", "order": 1 }
      ],
      "created_at": 1704067200000,
      "updated_at": 1704153600000
    }
  ],
  "next_cursor": "base64encodedcursor",
  "has_more": true
}
```

#### `POST /api/v1/outfits`

```json
// Request
{
  "date": 1704067200000,
  "description": "今日通勤穿搭",
  "tags": [
    { "name": "通勤", "color": "#E8F5E9" }       // 按名称去重创建
  ],
  "images": [
    { "oss_key": "outfits/1/20260103_abc.jpg", "oss_url": "https://...", "order": 0 }
  ],
  "created_at": 1704067200000                   // 客户端原始时间戳
}

// Response 201
{ "id": 42, "tag_ids": { "通勤": 10 }, "image_ids": [100, 101] }
```

#### `PUT /api/v1/outfits/:id`

```json
// Request（全量替换）
{
  "date": 1704067200000,
  "description": "更新后的描述",
  "tags": [...],         // 全量替换
  "images": [...],       // 全量替换
  "updated_at": 1704153600000
}

// Response 200
{ "id": 42, "tag_ids": {...}, "image_ids": [...] }
```

#### `DELETE /api/v1/outfits/:id`

```json
// Response 204（软删除）
```

---

### 4.3 同步 API

#### `POST /api/v1/sync/upload`

批量上传（用于首次同步或离线恢复后同步）。

```json
// Request
{
  "outfits": [
    {
      "client_id": 1,                              // 客户端本地 ID（用于回填映射）
      "date": 1704067200000,
      "description": "...",
      "tags": [...],
      "images": [...],
      "created_at": 1704067200000,
      "updated_at": 1704067200000
    }
  ],
  "tags": [
    { "client_id": 5, "name": "通勤", "color": "#E8F5E9" }
  ]
}

// Response 200
{
  "id_mappings": {
    "outfits": { "local_1": 42, "local_2": 43 },
    "tags": { "local_5": 10 },
    "images": { "local_10": 100, "local_11": 101 }
  }
}
```

此接口专门用于客户端回填 `serverId`：客户端拿到 `id_mappings` 后更新本地 SQLite，将 `serverId` 写入对应记录，同时标记 `isSynced=1`。

#### `GET /api/v1/sync/status`

返回服务端数据版本信息，用于客户端判断是否需要拉取。

```json
// Response 200
{
  "outfit_count": 150,
  "last_updated_at": 1704153600000
}
```

---

### 4.4 图片上传（客户端直传 OSS）

#### `POST /api/v1/media/upload-token`

返回阿里云 OSS STS 临时凭证，客户端用此凭证直传图片到 OSS。

```json
// Response 200
{
  "access_key_id": "STS.xxx",
  "access_key_secret": "xxx",
  "security_token": "xxx",
  "region": "oss-cn-hangzhou",
  "bucket": "today-wear",
  "expiration": "2026-06-03T10:00:00Z",
  "base_path": "outfits/1/"           // 此用户的上传路径前缀
}
```

客户端直传流程：
1. 请求 `upload-token` 获取 STS 临时凭证
2. 用阿里云 OSS SDK 直传图片到 `{base_path}{uuid}.jpg`
3. 上传成功后，将 `oss_key` 和 `oss_url` 随 `POST /outfits` 一起提交

---

### 4.5 标签 API

#### `GET /api/v1/tags`

```json
// Response 200
{
  "data": [
    { "id": 10, "name": "通勤", "color": "#E8F5E9", "outfit_count": 12 }
  ]
}
```

---

## 五、订阅验证

### 不与 RevenueCat SDK 交互

服务端**不直接调用 RevenueCat SDK**，而是通过**客户端传递收据 → 服务端调用 RevenueCat REST API 验证**的方式。

```
客户端完成购买
  → RevenueCat SDK 返回 receipt
  → 客户端将 receipt 发送给服务端
  → 服务端 POST https://api.revenuecat.com/v1/receipts 验证
  → 服务端存储订阅到期时间
  → 后续每次同步请求，服务端检查 is_premium 状态
```

### 用户表扩展

```sql
ALTER TABLE users ADD COLUMN is_premium BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE users ADD COLUMN premium_expires_at TIMESTAMP;
ALTER TABLE users ADD COLUMN rc_original_transaction_id VARCHAR(255);
```

### 同步权限检查中间件

所有 `/api/v1/outfits/*` 和 `/api/v1/sync/*` 请求在进入 handler 前校验：

```go
func PremiumRequired() gin.HandlerFunc {
    return func(c *gin.Context) {
        user := GetCurrentUser(c)
        if !user.IsPremium {
            c.JSON(402, gin.H{"error": "premium_required"})
            c.Abort()
            return
        }
        c.Next()
    }
}
```

返回 HTTP 402 Payment Required，客户端收到后展示订阅引导页。

---

## 六、错误码

| HTTP Status | Code | 说明 |
|-------------|------|------|
| 400 | `invalid_request` | 请求参数错误 |
| 401 | `unauthorized` | Token 无效或过期 |
| 402 | `premium_required` | 需要订阅（免费用户调了同步 API） |
| 404 | `not_found` | 资源不存在 |
| 409 | `email_exists` | 邮箱已注册 |
| 429 | `rate_limited` | 请求频率过高 |
| 500 | `internal_error` | 服务器内部错误 |

所有错误响应统一格式：
```json
{
  "error": {
    "code": "premium_required",
    "message": "此功能需要付费订阅"
  }
}
```

---

## 七、部署架构

```
                    ┌──────────────┐
                    │  Nginx       │
                    │  (HTTPS/SSL) │
                    └──────┬───────┘
                           │
                    ┌──────┴───────┐
                    │  Go API      │
                    │  (Docker)    │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         ┌────┴────┐  ┌───┴────┐  ┌───┴────────┐
         │PostgreSQL│  │ Redis  │  │ RevenueCat │
         │         │  │(可选)  │  │ REST API   │
         └─────────┘  └────────┘  └────────────┘
```

- Docker Compose 一键部署
- PostgreSQL 本地实例即可（数据量小）
- 后续可扩展到阿里云 RDS + Redis

---

## 八、建表脚本（MVP 最小可用）

```sql
-- 001_init.sql
CREATE TABLE users (
    id          BIGSERIAL PRIMARY KEY,
    email       VARCHAR(255) NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,
    is_premium  BOOLEAN NOT NULL DEFAULT FALSE,
    premium_expires_at TIMESTAMP,
    rc_original_transaction_id VARCHAR(255),
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE refresh_tokens (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token       VARCHAR(512) NOT NULL UNIQUE,
    expires_at  TIMESTAMP NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE outfits (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    date        BIGINT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    is_deleted  SMALLINT NOT NULL DEFAULT 0,
    created_at  BIGINT NOT NULL,
    updated_at  BIGINT NOT NULL,
    synced_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE tags (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name        VARCHAR(100) NOT NULL,
    color       VARCHAR(7) NOT NULL DEFAULT '#E8F5E9',
    created_at  TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, name)
);

CREATE TABLE outfit_tags (
    id          BIGSERIAL PRIMARY KEY,
    outfit_id   BIGINT NOT NULL REFERENCES outfits(id) ON DELETE CASCADE,
    tag_id      BIGINT NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
    UNIQUE(outfit_id, tag_id)
);

CREATE TABLE outfit_images (
    id            BIGSERIAL PRIMARY KEY,
    outfit_id     BIGINT NOT NULL REFERENCES outfits(id) ON DELETE CASCADE,
    oss_key       VARCHAR(512) NOT NULL,
    oss_url       VARCHAR(1024) NOT NULL,
    display_order INT NOT NULL DEFAULT 0,
    created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_outfits_user_date ON outfits(user_id, date DESC);
CREATE INDEX idx_outfits_user_synced ON outfits(user_id, synced_at);
CREATE INDEX idx_tags_user_id ON tags(user_id);
CREATE INDEX idx_outfit_tags_outfit ON outfit_tags(outfit_id);
CREATE INDEX idx_outfit_tags_tag ON outfit_tags(tag_id);
CREATE INDEX idx_outfit_images_outfit ON outfit_images(outfit_id);
CREATE INDEX idx_refresh_tokens_user_id ON refresh_tokens(user_id);
```
