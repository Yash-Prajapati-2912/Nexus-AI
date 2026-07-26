import 'package:flutter/material.dart';
import '../widgets/about_card.dart';

class OpenSourceLicensesPage extends StatelessWidget {
  const OpenSourceLicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Source Credits'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          AboutCard(
            title: 'Flutter Framework',
            content: 'BSD 3-Clause License\nCopyright 2014 The Flutter Authors.',
          ),
          AboutCard(
            title: 'flutter_bloc & bloc',
            content: 'MIT License\nCopyright (c) 2018 Felix Angelov.',
          ),
          AboutCard(
            title: 'Dio HTTP Client',
            content: 'MIT License\nCopyright (c) 2018 FlutterChina.',
          ),
          AboutCard(
            title: 'GetIt & Injectable',
            content: 'MIT License\nCopyright (c) 2019 Thomas Burkhart.',
          ),
          AboutCard(
            title: 'GoRouter',
            content: 'BSD 3-Clause License\nCopyright 2013 The Flutter Authors.',
          ),
        ],
      ),
    );
  }
}
