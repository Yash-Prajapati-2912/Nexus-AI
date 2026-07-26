import 'package:flutter/material.dart';

class FavouriteFilesPage extends StatelessWidget {
  const FavouriteFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Files')),
      body: const Center(child: Text('Starred & Favourite files')),
    );
  }
}
