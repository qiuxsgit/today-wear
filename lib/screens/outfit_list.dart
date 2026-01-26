import 'package:flutter/material.dart';

class OutfitListPage extends StatelessWidget {
  const OutfitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('今日穿什麼')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.checkroom),
            title: Text('2026-01-26'),
            subtitle: Text('白色毛衣 + 牛仔裤'),
          ),
        ],
      ),
    );
  }
}
