import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String currentLanguageCode;
  final ValueChanged<String> onLanguageSelected;

  const LanguageSelector({
    super.key,
    required this.currentLanguageCode,
    required this.onLanguageSelected,
  });

  static const List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English (United States)', 'flag': '🇺🇸'},
    {'code': 'es', 'name': 'Español (Spanish)', 'flag': '🇪🇸'},
    {'code': 'fr', 'name': 'Français (French)', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'Deutsch (German)', 'flag': '🇩🇪'},
    {'code': 'ja', 'name': '日本語 (Japanese)', 'flag': '🇯🇵'},
    {'code': 'zh', 'name': '中文 (Simplified Chinese)', 'flag': '🇨🇳'},
    {'code': 'hi', 'name': 'हिन्दी (Hindi)', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _languages.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final lang = _languages[index];
        final isSelected = lang['code'] == currentLanguageCode;

        return ListTile(
          leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
          title: Text(
            lang['name']!,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
          onTap: () => onLanguageSelected(lang['code']!),
        );
      },
    );
  }
}
