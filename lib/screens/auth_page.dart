import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../services/session_service.dart';
import '../theme/app_theme_tokens.dart';
import '../widgets/app_toast.dart';

/// 登录 / 注册页
///
/// 同一页切换登录与注册。成功后 `Navigator.pop(true)`，由调用方触发首次同步。
class AuthPage extends StatefulWidget {
  /// true = 默认进入注册模式
  final bool startWithRegister;

  const AuthPage({super.key, this.startWithRegister = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _isRegister = widget.startWithRegister;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validEmail(String s) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_validEmail(email)) {
      AppToast.warning('请输入有效的邮箱地址');
      return;
    }
    if (password.length < 8) {
      AppToast.warning('密码至少 8 位');
      return;
    }

    setState(() => _submitting = true);
    try {
      if (_isRegister) {
        await SessionService.instance.register(email, password);
      } else {
        await SessionService.instance.login(email, password);
      }
      if (!mounted) return;
      AppToast.success(_isRegister ? '注册成功' : '登录成功');
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (mounted) AppToast.error(e.message);
    } catch (e) {
      if (mounted) AppToast.error('操作失败，请稍后重试');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return Scaffold(
      backgroundColor: tt.page,
      appBar: AppBar(
        backgroundColor: tt.page,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(_isRegister ? '注册账号' : '登录',
            style: TextStyle(color: tt.ink, fontWeight: FontWeight.w800, fontSize: 18)),
        iconTheme: IconThemeData(color: tt.ink),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              _isRegister ? '创建账号以开启云同步' : '登录以同步你的穿搭',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: tt.ink),
            ),
            const SizedBox(height: 8),
            Text(
              '云同步为可选功能，不登录也能离线使用全部记录功能。',
              style: TextStyle(fontSize: 13, color: tt.muted, height: 1.4),
            ),
            const SizedBox(height: 24),
            _buildField(
              tt,
              controller: _emailController,
              label: '邮箱',
              hint: 'you@example.com',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildField(
              tt,
              controller: _passwordController,
              label: '密码',
              hint: '至少 8 位',
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: tt.muted, size: 20),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: 28),
            _buildPrimaryButton(tt),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: _submitting
                    ? null
                    : () => setState(() => _isRegister = !_isRegister),
                child: Text(
                  _isRegister ? '已有账号？去登录' : '还没有账号？去注册',
                  style: TextStyle(color: tt.ink, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    AppThemeTokens tt, {
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tt.muted)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          enabled: !_submitting,
          style: TextStyle(color: tt.ink, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: tt.muted),
            filled: true,
            fillColor: tt.surface,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: tt.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: tt.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: tt.ink, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(AppThemeTokens tt) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _submitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: tt.ink,
          foregroundColor: tt.page,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _submitting
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: tt.page),
              )
            : Text(_isRegister ? '注册' : '登录',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
