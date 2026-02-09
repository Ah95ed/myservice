import 'dart:developer';
import 'dart:io';

import 'package:Al_Zab_township_guide/view/ThemeApp/ColorUsed.dart';
import 'package:Al_Zab_township_guide/view/ThemeApp/app_theme.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart' show OpenFilex, ResultType;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../provider/PdfViewerProvider.dart';
import 'PdfViewerScreen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);
  static const String route = '/BooksScreen';

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  bool loading = true;
  String? error;

  List args = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as List;
  }

  @override
  Widget build(BuildContext context) {
    if (args.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const _BooksBackground(),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 140,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppTheme.notWhite),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ColorUsed.primary, ColorUsed.DarkGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            'الكتب المدرسية',
                            style: TextStyle(
                              color: AppTheme.notWhite,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'اختر كتابك، ثم افتحه مباشرة او نزله على جهازك.',
                            style: TextStyle(
                              color: AppTheme.notWhite,
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final book = args;
                    return _BookCard(
                      title: book[index]['name'] ?? '',
                      url: book[index]['url'] ?? '',
                      onOpen: () async {
                        final suggestedName =
                            book[index]['name'].replaceAll(' ', '_') +
                            _extensionFromUrl(book[index]['url']);
                        log('message===$suggestedName');
                        final dir = await getApplicationDocumentsDirectory();
                        final path = p.join(dir.path, suggestedName);
                        final file = File(path);

                        if (await file.exists()) {
                          managerScreen(
                            PdfViewerScreen.route,
                            context,
                            object: PdfViewerData(
                              filePath: path,
                              title: book[index]['name'],
                              remoteUrl: book[index]['url'],
                            ),
                          );
                          return;
                        }
                        downloadByUrl(
                          context,
                          book[index]['url'],
                          book[index]['name'],
                        ).then((s) {
                          managerScreen(
                            PdfViewerScreen.route,
                            context,
                            object: PdfViewerData(
                              filePath: path,
                              title: book[index]['name'],
                              remoteUrl: book[index]['url'],
                            ),
                          );
                        });
                      },
                      onDownload: () async {
                        await downloadAndOpenByUrl(
                          context,
                          book[index]['url']!,
                          book[index]['name']!,
                        );
                      },
                    );
                  }, childCount: args.length),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BooksBackground extends StatelessWidget {
  const _BooksBackground();

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
            top: 40,
            right: -60,
            child: _GlowOrb(
              size: 180,
              color: ColorUsed.second.withOpacity(0.25),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -40,
            child: _GlowOrb(
              size: 220,
              color: ColorUsed.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title;
  final String url;
  final VoidCallback onOpen;
  final VoidCallback onDownload;

  const _BookCard({
    required this.title,
    required this.url,
    required this.onOpen,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.nearlyWhite.withOpacity(0.95),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: ColorUsed.primary.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: ColorUsed.DarkGreen.withOpacity(0.12),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      ColorUsed.primary.withOpacity(0.95),
                      ColorUsed.DarkGreen.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppTheme.notWhite,
                  size: 48,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.darkerText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onDownload,
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('تنزيل'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorUsed.DarkGreen,
                          side: BorderSide(color: ColorUsed.DarkGreen),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onOpen,
                        icon: const Icon(Icons.open_in_new_rounded, size: 16),
                        label: const Text('فتح'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorUsed.second,
                          foregroundColor: AppTheme.notWhite,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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

void _openFile(
  BuildContext context,
  String filePath,
  String title,
  ScaffoldMessengerState scaffoldMessenger,
) async {
  if (_extensionFromUrl(filePath).toLowerCase().contains('pdf')) {
    Navigator.pushNamed(
      context,
      PdfViewerScreen.route,
      arguments: PdfViewerData(filePath: filePath, title: title),
    );
  } else {
    final result = await OpenFilex.open(filePath);
    if (result.type != ResultType.done) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('تعذر فتح الملف: ${result.message}')),
      );
    }
  }
}

// 🔧 استخراج الامتداد من الرابط
String _extensionFromUrl(String url) {
  final uri = Uri.parse(url);
  final path = uri.path;
  return p.extension(path);
}

Future<void> downloadAndOpenByUrl(
  BuildContext context,
  String url,
  String title,
) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // 🧩 تجهيز اسم الملف المقترح
    final suggestedName = title.replaceAll(' ', '_') + _extensionFromUrl(url);

    // 📂 تحديد مجلد التطبيق
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, suggestedName);
    final file = File(path);

    // ✅ تحقق إذا الملف موجود أصلاً
    if (await file.exists()) {
      debugPrint('📂 الملف موجود مسبقاً في: $path');
      _openFile(context, file.path, title, scaffoldMessenger);
      return;
    }

    // 🌀 عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // ⬇️ تنزيل الملف
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      Navigator.pop(context);
      throw Exception('فشل في تنزيل الملف: ${response.statusCode}');
    }

    // 💾 حفظ الملف داخل مجلد التطبيق
    await file.writeAsBytes(response.bodyBytes);

    // ✅ إغلاق المؤشر
    Navigator.pop(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('تم تنزيل الملف: ${file.path}')),
    );

    // 📖 فتح الملف بعد التنزيل
    _openFile(context, file.path, title, scaffoldMessenger);
  } catch (e, st) {
    debugPrint('❌ Error downloading file: $e\n$st');
    try {
      Navigator.pop(context);
    } catch (_) {}
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
    );
  }
}

Future<void> downloadByUrl(
  BuildContext context,
  String url,
  String title,
) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  try {
    // 🧩 تجهيز اسم الملف المقترح
    final suggestedName = title.replaceAll(' ', '_') + _extensionFromUrl(url);

    // 📂 تحديد مجلد التطبيق
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, suggestedName);
    final file = File(path);

    // ✅ تحقق إذا الملف موجود أصلاً
    if (await file.exists()) {
      debugPrint('📂 الملف موجود مسبقاً في: $path');
      _openFile(context, file.path, title, scaffoldMessenger);
      return;
    }

    // 🌀 عرض مؤشر التحميل
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // ⬇️ تنزيل الملف
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      Navigator.pop(context);
      throw Exception('فشل في تنزيل الملف: ${response.statusCode}');
    }

    // 💾 حفظ الملف داخل مجلد التطبيق
    await file.writeAsBytes(response.bodyBytes);

    // ✅ إغلاق المؤشر
    Navigator.pop(context);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('تم تنزيل الملف: ${file.path}')),
    );

    // 📖 فتح الملف بعد التنزيل
    // _openFile(context, file.path, title, scaffoldMessenger);
  } catch (e, st) {
    debugPrint('❌ Error downloading file: $e\n$st');
    try {
      Navigator.pop(context);
    } catch (_) {}
    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('حدث خطأ أثناء التنزيل أو الفتح: $e')),
    );
  }
}

// String _extensionFromUrl(String url) {
//   final idx = url.lastIndexOf('.');
//   if (idx == -1) return '.pdf';
//   return url.substring(idx);
// }
