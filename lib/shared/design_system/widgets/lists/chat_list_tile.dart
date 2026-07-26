import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final String senderName;
  final String lastMessage;
  final String time;
  final String? avatarUrl;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
    required this.senderName,
    required this.lastMessage,
    required this.time,
    this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
        child: avatarUrl == null ? Text(senderName[0]) : null,
      ),
      title: Text(senderName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(time, style: Theme.of(context).textTheme.labelSmall),
      onTap: onTap,
    );
  }
}
