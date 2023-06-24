import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/colorsProject.dart';

class CustomSearchDelegate extends SearchDelegate {
  List search = [];

  CustomSearchDelegate({required this.search});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(
            Icons.clear,
            weight: 50.0,
            color: Color.fromARGB(255, 82, 24, 24),
          ),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(
          Icons.arrow_back,
          weight: 22.0,
          color: Color.fromARGB(255, 82, 24, 24),
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    List results = [];
    print(query);
    for (var e in search) {
      if (e.toString().contains(query)) {
        results.add(e);
      }
      // if (e.contains(query)) {
      //   results.add(e);
      // }
    }
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 3.0,
                color: const Color(0xFF5808FB),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(results[index]['name']),
              // onTap: () {
              //   close(context, results[index]['name']);
              // },
              trailing: IconButton(
                icon: const Icon(
                  Icons.call,
                  size: 30.0,
                  color: ColorsProject.colorAppBar,
                ),
                onPressed: () async {
                  close(context, results[index]['number']);
                },
              ),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List results = [];
    for (var e in search) {
      if (e.toString().contains(query)) {
        results.add(e);
      }
    }
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 3.0,
                color: const Color(0xFF5808FB),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                results[index]['name'],
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.call,
                  size: 30.0,
                  color: ColorsProject.colorAppBar,
                ),
                onPressed: () async {
                  _makePhoneCall(results[index]['number']);
                },
              ),
            ),
          );
        });
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('not call ____');
    }
  }
}
