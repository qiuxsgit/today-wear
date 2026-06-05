# 业务规则

## 静态页（隐私政策/用户协议）

打开服务端静态页（WebViewPage）必须传当前语言与主题色，页面随 app 配色：

✅ `ApiConfig.staticPageUrl('legal', key, lang: lang, bg: _hex6(tt.page), fg: _hex6(tt.ink))`

bg/fg 为 6 位 hex（不带 #），服务端两者同时合法才生效，否则回落
白底黑字 + 深色自适应。契约详见 `today-wear-server/docs/api.md` → 静态页。
