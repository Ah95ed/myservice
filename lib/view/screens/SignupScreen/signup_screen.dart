import 'package:Al_Zab_township_guide/Models/SignupModel/SignupModel.dart';
import 'package:Al_Zab_township_guide/controller/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/generated/l10n.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/screens/OTPScreenEmail.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../LoginScreen/login_screen.dart';

class SignupScreen extends StatefulWidget {
  static const Route = "/SignupScreen";
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: ColorUsed.PrimaryBackground,
          body: Stack(
            children: [
              const _AuthBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _AuthHeader(
                        title: S.current.register_now,
                        subtitle: 'سجّل حساباً جديداً للاستمتاع بكامل الخدمات',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getWidth(6),
                          vertical: getheight(2),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: getheight(1)),
                            _AuthTextField(
                              controller: name,
                              icon: Icons.person_outline,
                              hint: S.current.please_enter_name,
                            ),
                            SizedBox(height: getheight(2)),
                            _AuthTextField(
                              controller: email,
                              icon: Icons.email_outlined,
                              hint: S.current.enter_email,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: getheight(2)),
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
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                            SizedBox(height: getheight(2)),
                            // رابط لدي حساب بالفعل
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: S.current.already_member,
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
                                          LoginScreen.Route,
                                        );
                                      },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: getheight(3)),
                            // زر التسجيل
                            _AuthButton(
                              label: S.current.register_now,
                              onTap: () async {
                                HapticFeedback.lightImpact();
                                provider.startLoading();
                                if (name.text.isEmpty ||
                                    email.text.isEmpty ||
                                    phone.text.isEmpty ||
                                    password.text.isEmpty) {
                                  provider.stopLoading();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(S.current.fields),
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }
                                if (!email.text.contains('@')) {
                                  provider.stopLoading();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ادخل أيميل حقيقي'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  return;
                                }
                                showCirculerProgress(context);
                                await provider.sendCode(
                                  SignupModel(
                                    name: name.text,
                                    email: email.text,
                                    phone: phone.text,
                                    password: password.text,
                                  ),
                                  context,
                                );
                                if (await provider.isSignup) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    OtpScreenEmail.Route,
                                    arguments: false,
                                  );
                                  provider.stopLoading();
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(S.current.fields),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: getheight(3)),
                          ],
                        ),
                      ),
                    ],
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
// Shared Widgets (re-exported from login_screen)
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
            child: SizedBox(
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

// المكوّن القديم SharedAuthTextField — محتفظ به لتجنب أخطاء في ملفات أخرى
class SharedAuthTextField extends StatelessWidget {
  const SharedAuthTextField(
    this.controller,
    this.icon,
    this.hintText,
    this.isPassword,
    this.isEmail, {
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final IconData? icon;
  final String? hintText;
  final bool? isPassword;
  final bool? isEmail;

  @override
  Widget build(BuildContext context) {
    return _AuthTextField(
      controller: controller,
      icon: icon ?? Icons.text_fields,
      hint: hintText ?? '',
      obscureText: isPassword ?? false,
      keyboardType: (isEmail ?? false)
          ? TextInputType.phone
          : TextInputType.text,
    );
  }
}

