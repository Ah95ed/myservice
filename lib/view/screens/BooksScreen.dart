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

import '../../Services/book_links.dart';
import '../../provider/PdfViewerProvider.dart';
import 'PdfViewerScreen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);
  static const String route = '/BooksScreen';

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with SingleTickerProviderStateMixin {
  bool loading = true;
  String? error;

  List<Map<String, String>> items = [];

  late final AnimationController _introController;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    items = _normalizeBookArgs(args);
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('لا توجد كتب متاحة حالياً')),
      );
    }

    final titleAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOutCubic,
    );

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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ColorUsed.DarkGreen,
                  ),
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
                      child: FadeTransition(
                        opacity: titleAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.15),
                            end: Offset.zero,
                          ).animate(titleAnimation),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text(
                                'الكتب المدرسية',
                                style: TextStyle(
                                  color: AppTheme.notWhite,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'اختر كتابك، ثم افتحه مباشرة او نزله على جهازك.',
                                style: TextStyle(
                                  color: AppTheme.notWhite,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _InfoPill(
                                    label: 'عدد الكتب',
                                    value: items.length.toString(),
                                  ),
                                  const _InfoPill(
                                    label: 'تنظيم',
                                    value: 'مرتب',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final book = items;
                    final name = (book[index]['name'] ?? '').toString();
                    final resolvedUrl = _resolveBookUrl(
                      (book[index]['url'] ?? '').toString(),
                    );
                    final start = (index * 0.06).clamp(0.0, 0.6);
                    final itemAnimation = CurvedAnimation(
                      parent: _introController,
                      curve: Interval(start, 1.0, curve: Curves.easeOutCubic),
                    );
                    return FadeTransition(
                      opacity: itemAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(itemAnimation),
                        child: _BookCard(
                          title: name,
                          url: resolvedUrl,
                          onOpen: () async {
                            final suggestedName =
                                name.replaceAll(' ', '_') +
                                _extensionFromUrl(resolvedUrl);
                            log('message===$resolvedUrl');
                            final dir =
                                await getApplicationDocumentsDirectory();
                            final path = p.join(dir.path, suggestedName);
                            final file = File(path);

                            if (await file.exists()) {
                              managerScreen(
                                PdfViewerScreen.route,
                                context,
                                object: PdfViewerData(
                                  filePath: path,
                                  title: name,
                                  remoteUrl: resolvedUrl,
                                ),
                              );
                              return;
                            }
                            downloadByUrl(context, resolvedUrl, name).then((s) {
                              managerScreen(
                                PdfViewerScreen.route,
                                context,
                                object: PdfViewerData(
                                  filePath: path,
                                  title: name,
                                  remoteUrl: resolvedUrl,
                                ),
                              );
                            });
                          },
                          onDownload: () async {
                            await downloadAndOpenByUrl(
                              context,
                              resolvedUrl,
                              name,
                            );
                          },
                        ),
                      ),
                    );
                  }, childCount: items.length),
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
    final extension = _extensionFromUrl(url).replaceAll('.', '').toUpperCase();
    final badgeText = extension.isEmpty ? 'FILE' : extension;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(12),
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
                height: 86,
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
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: AppTheme.notWhite,
                        size: 48,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.notWhite.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.notWhite.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: AppTheme.notWhite,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
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

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;

  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.notWhite.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.notWhite.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.notWhite,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.notWhite,
              fontSize: 11,
              fontWeight: FontWeight.w700,
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

const _r2BaseUrl = 'https://pub-3fc8cfe1b1a84a7987f583891bf0e2c5.r2.dev';
const _r2BooksPrefix = 'Books/';

String _resolveBookUrl(String rawUrl) {
  final value = rawUrl.trim();
  if (value.isEmpty) {
    return value;
  }
  final lower = value.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return value;
  }
  final cleaned = value.startsWith('/') ? value.substring(1) : value;
  final prefix = _r2BooksPrefix;
  final normalized = cleaned.toLowerCase().startsWith(prefix.toLowerCase())
      ? cleaned
      : '$prefix$cleaned';
  return '$_r2BaseUrl/$normalized';
}

List<Map<String, String>> _normalizeBookArgs(Object? args) {
  if (args is String && args.isNotEmpty) {
    return bookLinksFor(args);
  }

  final List<Map<String, String>> result = [];
  if (args is List) {
    for (final item in args) {
      if (item is Map) {
        final name = (item['name'] ?? item['title'] ?? '').toString();
        final url = (item['url'] ?? item['fileUrl'] ?? item['urlBook'] ?? '')
            .toString();
        if (name.isEmpty && url.isEmpty) {
          continue;
        }
        result.add({'name': name, 'url': url});
      }
    }
  }
  return result;
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
