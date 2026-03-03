import 'package:Al_Zab_township_guide/generated/l10n.dart';
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
      S.current.grade_1_primary,
      S.current.grade_2_primary,
      S.current.grade_3_primary,
      S.current.grade_4_primary,
      S.current.grade_5_primary,
      S.current.grade_6_primary,
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
                object: 'c${grades.indexOf(g) + 1}_Primary',
              );
            },
          ),
        )
        .toList();
  }

  List<Widget> _buildSecondaryGrades(BuildContext context) {
    final grades = [
      S.current.grade_4_secondary,
      S.current.grade_5_secondary,
      S.current.grade_6_secondary,
    ];
    return grades
        .map(
          (grade) => ExpansionTile(
            title: Text(grade),
            children: [
              ListTile(
                title: Text(S.current.scientific),
                onTap: () {
                  managerScreen(
                    BooksScreen.route,
                    context,
                    object: 'c${grades.indexOf(grade) + 4}_Scientific',
                  );
                },
              ),
              ListTile(
                title: Text(S.current.literary),
                onTap: () {
                  managerScreen(
                    BooksScreen.route,
                    context,
                    object: 'c${grades.indexOf(grade) + 4}_Literary',
                  );
                },
              ),
            ],
          ),
        )
        .toList();
  }

  List<Widget> _buildMiddleGrades(BuildContext context) {
    final grades = [
      S.current.grade_1_middle,
      S.current.grade_2_middle,
      S.current.grade_3_middle,
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
                object: 'c${grades.indexOf(g) + 1}_Middle',
              );
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.grades_title), centerTitle: true),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        S.current.primary_stage,
                        style: const TextStyle(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        S.current.middle_stage,
                        style: const TextStyle(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        S.current.secondary_stage,
                        style: const TextStyle(
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
