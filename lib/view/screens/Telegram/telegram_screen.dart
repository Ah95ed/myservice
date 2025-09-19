import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Helper/Constant/AppConstants.dart';
import '../../../controller/provider/TelegramClassProvider.dart';
import '../../ThemeApp/ColorUsed.dart';

class TelegramScreen extends StatefulWidget {
  const TelegramScreen({Key? key}) : super(key: key);

  @override
  State<TelegramScreen> createState() => _TelegramScreenState();
}

class _TelegramScreenState extends State<TelegramScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TelegramClassProvider>().fetchClasses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'صفوف التليكرام',
          style: TextStyle(
            fontSize: AppConstants.largeFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorUsed.primary,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<TelegramClassProvider>().refreshClasses();
            },
          ),
        ],
      ),
      body: Consumer<TelegramClassProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ColorUsed.primary),
                  ),
                  SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    'جاري تحميل الصفوف...',
                    style: TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    provider.error!,
                    style: const TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.mediumPadding),
                  ElevatedButton.icon(
                    onPressed: () {
                      provider.fetchClasses();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorUsed.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.largePadding,
                        vertical: AppConstants.smallPadding,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (provider.classes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: AppConstants.mediumPadding),
                  Text(
                    'لا توجد صفوف متاحة حالياً',
                    style: TextStyle(
                      fontSize: AppConstants.mediumFontSize,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshClasses(),
            color: ColorUsed.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              itemCount: provider.classes.length,
              itemBuilder: (context, index) {
                final telegramClass = provider.classes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: ColorUsed.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                      ),
                      child: const Icon(
                        Icons.class_,
                        color: ColorUsed.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      telegramClass.name,
                      style: const TextStyle(
                        fontSize: AppConstants.mediumFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'ID: ${telegramClass.id}',
                      style: TextStyle(
                        fontSize: AppConstants.smallFontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                    onTap: () {
                      // يمكن إضافة التنقل إلى تفاصيل الصف هنا
                      _showClassDetails(context, telegramClass);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showClassDetails(BuildContext context, telegramClass) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          telegramClass.name,
          style: const TextStyle(
            fontSize: AppConstants.largeFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('معرف الصف: ${telegramClass.id}'),
            const SizedBox(height: AppConstants.smallPadding),
            const Text('تفاصيل إضافية يمكن إضافتها هنا...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'إغلاق',
              style: TextStyle(color: ColorUsed.primary),
            ),
          ),
        ],
      ),
    );
  }
}