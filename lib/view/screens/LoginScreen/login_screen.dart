// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Al_Zab_township_guide/controller/provider/LoginProvider/Loginprovider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/ForgetPassword/ForgetPassword.dart';
import 'package:Al_Zab_township_guide/view/screens/SignupScreen/signup_screen.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const Route = 'login screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: ColorUsed.PrimaryBackground,
          body: Stack(
            children: [
              // خلفية الشاشة الرئيسية
              const _AuthBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: getheight(100),
                    child: Column(
                      children: [
                        // Header gradient
                        _AuthHeader(
                          title: S.current.login,
                          subtitle: 'أهلاً بعودتك! سجّل دخولك للمتابعة',
                        ),
                        const SizedBox(height: 16),
                        // Form
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: getWidth(6),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: getheight(3)),
                                _AuthTextField(
                                  controller: phone,
                                  icon: Icons.phone_outlined,
                                  hint: S.current.number_phone,
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(height: getheight(2)),
                                _AuthTextField(
                                  controller: password,
                                  icon: Icons.lock_outline,
                                  hint: S.current.enter_password,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: ColorUsed.primary.withOpacity(0.6),
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                                SizedBox(height: getheight(2)),
                                // روابط نسيت الباسورد / ليس لدي حساب
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: S.current.forget_password,
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: setFontSize(12),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            HapticFeedback.lightImpact();
                                            Navigator.pushReplacementNamed(
                                              context,
                                              ForgetPassword.Route,
                                            );
                                          },
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: S.current.don_t_have_account,
                                        style: TextStyle(
                                          color: ColorUsed.DarkGreen,
                                          fontSize: setFontSize(12),
                                          fontWeight: FontWeight.w600,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            HapticFeedback.lightImpact();
                                            Navigator.pushReplacementNamed(
                                              context,
                                              SignupScreen.Route,
                                            );
                                          },
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // زر تسجيل الدخول
                                _AuthButton(
                                  label: S.current.login,
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    showCirculerProgress(context);
                                    if (phone.text.isEmpty ||
                                        password.text.isEmpty) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(S.current.fields),
                                          duration: const Duration(seconds: 3),
                                        ),
                                      );
                                      return;
                                    }
                                    await provider.login(
                                      context,
                                      phone.text,
                                      password.text,
                                    );
                                  },
                                ),
                                SizedBox(height: getheight(6)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Shared Auth Widgets
// ─────────────────────────────────────────────

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorUsed.PrimaryBackground,
            ColorUsed.PrimaryBackground.withOpacity(0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -40,
            child: _GlowOrb(
              size: 220,
              color: ColorUsed.second.withOpacity(0.2),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: _GlowOrb(
              size: 260,
              color: ColorUsed.primary.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0.0)]),
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _AuthHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorUsed.primary, ColorUsed.DarkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorUsed.DarkGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 70,
              child: Image.asset('assets/logo/asd.png'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: AppTheme.notWhite,
              fontSize: setFontSize(24),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.notWhite.withOpacity(0.8),
              fontSize: setFontSize(13),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const _AuthTextField({
    required this.controller,
    required this.icon,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: ColorUsed.primary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: ColorUsed.DarkGreen, fontSize: setFontSize(15)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorUsed.primary.withOpacity(0.7)),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: TextStyle(
            color: ColorUsed.primary.withOpacity(0.4),
            fontSize: setFontSize(14),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorUsed.primary.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: ColorUsed.second, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _AuthButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getheight(7),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorUsed.second,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: ColorUsed.second.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: setFontSize(16),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
