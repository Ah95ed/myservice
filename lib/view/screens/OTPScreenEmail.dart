import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/SignupProvider/SignupProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class OtpScreenEmail extends StatefulWidget {
  static const Route = "/OtpScreen";
  OtpScreenEmail({Key? key}) : super(key: key);

  @override
  State<OtpScreenEmail> createState() => _OtpScreenEmailState();
}

class _OtpScreenEmailState extends State<OtpScreenEmail> {
  late TextEditingController otpNumber = TextEditingController();

  @override
  void dispose() {
    otpNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signup = context.read<SignupProvider>();
    final Object? routeArgs = ModalRoute.of(context)?.settings.arguments;
    final Map<dynamic, dynamic>? argsMap = routeArgs is Map ? routeArgs : null;
    final isForget =
        (routeArgs is bool ? routeArgs : argsMap?['isForget']) == true;
    final email = argsMap?['email']?.toString();

    return Scaffold(
      backgroundColor: ColorUsed.PrimaryBackground,
      body: Stack(
        children: [
          // خلفية موحّدة
          Container(
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
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Header gradient موحّد
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
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
                      children: [
                        // أيقونة الحماية
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user_outlined,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          Translation[Language.confirm_otp] ?? 'تأكيد الرمز',
                          style: TextStyle(
                            color: AppTheme.notWhite,
                            fontSize: setFontSize(22),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          Translation[Language.enter_otp_email] ??
                              'أدخل رمز التحقق المرسل إلى بريدك',
                          style: TextStyle(
                            color: AppTheme.notWhite.withOpacity(0.8),
                            fontSize: setFontSize(13),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getWidth(6),
                      vertical: getheight(3),
                    ),
                    child: Column(
                      children: [
                        // حقل الرمز
                        Container(
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
                            controller: otpNumber,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: ColorUsed.DarkGreen,
                              fontSize: setFontSize(22),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.key_outlined,
                                color: ColorUsed.primary.withOpacity(0.7),
                              ),
                              hintText: '• • • • • •',
                              hintStyle: TextStyle(
                                color: ColorUsed.primary.withOpacity(0.3),
                                fontSize: setFontSize(20),
                                letterSpacing: 6,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: ColorUsed.primary.withOpacity(0.1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: ColorUsed.second,
                                  width: 1.5,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: getheight(4)),
                        // زر التأكيد
                        SizedBox(
                          width: double.infinity,
                          height: getheight(7),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              showCirculerProgress(context);
                              bool isVerified = EmailOTP.verifyOTP(
                                otp: otpNumber.text,
                              );

                              if (!isVerified) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'رمز التحقق غير صحيح أو منتهي الصلاحية',
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (isForget &&
                                  email != null &&
                                  email.isNotEmpty) {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  '/ResetPassword',
                                  arguments: {
                                    'email': email,
                                    'otp': otpNumber.text,
                                  },
                                );
                                return;
                              }

                              try {
                                await signup.saveData(
                                  context,
                                  otp: otpNumber.text,
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(
                              Translation[Language.confirm_otp] ?? 'تأكيد',
                              style: TextStyle(
                                fontSize: setFontSize(16),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorUsed.second,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: ColorUsed.second.withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
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

// المكوّن القديم — محتفظ به للتوافق
class TextFieldCustomEmailOTP extends StatelessWidget {
  const TextFieldCustomEmailOTP(
    this.controller,
    this.icon,
    this.hintText,
    this.isPassword,
    this.isEmail, {
    Key? key,
  }) : super(key: key);

  final TextEditingController? controller;
  final IconData? icon;
  final String? hintText;
  final bool? isPassword;
  final bool? isEmail;

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
        controller: controller!,
        textAlign: TextAlign.center,
        obscureText: isPassword ?? false,
        keyboardType: (isEmail ?? false)
            ? TextInputType.phone
            : TextInputType.text,
        style: TextStyle(color: ColorUsed.DarkGreen, fontSize: setFontSize(15)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ColorUsed.primary.withOpacity(0.7)),
          hintText: hintText,
          hintStyle: TextStyle(
            color: ColorUsed.primary.withOpacity(0.4),
            fontSize: setFontSize(14),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
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
