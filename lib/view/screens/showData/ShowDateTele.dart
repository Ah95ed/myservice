import 'package:Al_Zab_township_guide/Models/ConnectTelegram/ConnectTelegram.dart';
import 'package:flutter/material.dart';

class ShowDataTele extends StatefulWidget {
  const ShowDataTele({super.key});

  @override
  State<ShowDataTele> createState() => _ShowDataTeleState();
}

class _ShowDataTeleState extends State<ShowDataTele> {
  late ConnectTelegram tl;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    tl = ConnectTelegram();
    // ConnectTelegram.instance.getUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await tl.getUpdates();
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('Ahmed show data'),
      ),
    );
  }
}
