import 'package:Al_Zab_township_guide/Models/BookModel.dart';
import 'package:Al_Zab_township_guide/view/routing/routing.dart';
import 'package:Al_Zab_township_guide/view/screens/BooksScreen.dart';
import 'package:flutter/material.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({Key? key}) : super(key: key);
  static const String route = '/GradesScreen';

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> {
  List<Widget> _buildPrimaryGrades(BuildContext context) {
    final grades = [
      'أول ابتدائي',
      'ثاني ابتدائي',
      'ثالث ابتدائي',
      'رابع ابتدائي',
      'خامس ابتدائي',
      'سادس ابتدائي',
    ];
    return grades
        .map(
          (g) => ListTile(
            title: Text(g),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              managerScreen(
                BooksScreen.route,
                context,
                object: books['primary']!['grade${grades.indexOf(g) + 1}']!,
                // object: BooksArgs(
                //   name: 'grade${grades.indexOf(g) + 1}',
                //   data: books['primary']!['grade${grades.indexOf(g) + 1}']!,
                // ),
              );
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildSecondaryGrades(BuildContext context) {
    final grades = ['رابع ثانوي', 'خامس ثانوي', 'سادس ثانوي'];
    return grades
        .map(
          (grade) => ExpansionTile(
            title: Text(grade),
            children: [
              ListTile(title: const Text('علمي'), onTap: () {}),
              ListTile(
                title: const Text('ادبي'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم اختيار: $grade - ادبي')),
                  );
                },
              ),
            ],
          ),
        )
        .toList();
  }

  List<Widget> _buildMiddleGrades(BuildContext context) {
    final grades = ['اول متوسط', 'ثاني متوسط', 'ثالث متوسط'];
    return grades
        .map(
          (g) => ListTile(
            title: Text(g),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('تم اختيار: $g')));
            },
          ),
        )
        .toList();
  }

  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التصنيفات'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'المرحلة الابتدائية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._buildPrimaryGrades(context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'المرحلة المتوسطة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._buildMiddleGrades(context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'الثانوية',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ..._buildSecondaryGrades(context),
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
