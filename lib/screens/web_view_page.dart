import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';

/// 通用应用内网页页：AppBar 标题 + WebView + 加载指示。
/// 用于打开服务端托管的静态文案页（隐私政策/用户协议等）。
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled) // 静态文案页无 JS 需求
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _loading = false);
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmPage,
      appBar: AppBar(
        title: Text(widget.title, style: AppTextStyle.title),
        backgroundColor: AppColors.warmSurface,
        foregroundColor: AppColors.warmInk,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        scrolledUnderElevation: 2,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
