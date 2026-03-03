import 'package:Al_Zab_township_guide/Helper/Service/Language/Language.dart';
import 'package:Al_Zab_township_guide/Helper/Service/Language/LanguageController.dart';
import 'package:Al_Zab_township_guide/controller/ForgetPassword/ForgetPasswordProvider.dart';
import 'package:Al_Zab_township_guide/view/Size/SizedApp.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/widget/Dialogandsnakebar/DialogCirculerProgress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  static const Route = '/ForgetPassword';
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgetPasswordProvider>(
      builder: (context, value, child) => Scaffold(
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
                    right: -40,
                    child: _GlowOrb(
                      size: 220,
                      color: ColorUsed.second.withOpacity(0.2),
                    ),
                  ),
                  Positioned(
                    bottom: -100,
                    left: -60,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
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
                          // زر الرجوع
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: SizedBox(
                              height: 60,
                              child: Image.asset('assets/logo/asd.png'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            Translation[Language.forget_password] ??
                                'نسيت كلمة السر',
                            style: TextStyle(
                              color: AppTheme.notWhite,
                              fontSize: setFontSize(22),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور',
                            style: TextStyle(
                              color: AppTheme.notWhite.withOpacity(0.8),
                              fontSize: setFontSize(13),
                            ),
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
                          // حقل البريد الإلكتروني
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
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: ColorUsed.DarkGreen,
                                fontSize: setFontSize(15),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: ColorUsed.primary.withOpacity(0.7),
                                ),
                                hintText: Translation[Language.enter_email],
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
                          SizedBox(height: getheight(3)),
                          // زر الإرسال
                          SizedBox(
                            width: double.infinity,
                            height: getheight(7),
                            child: ElevatedButton(
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                showCirculerProgress(context);
                                await value.sendCode(
                                  _emailController.text,
                                  context,
                                );
                              },
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
                                Translation[Language.send] ?? 'إرسال',
                                style: TextStyle(
                                  fontSize: setFontSize(16),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
