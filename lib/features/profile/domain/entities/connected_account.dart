import 'package:equatable/equatable.dart';

/// Domain entity representing SSO Connected Account links.
class ConnectedAccount extends Equatable {
  final String provider; // GOOGLE, APPLE, GITHUB, MICROSOFT
  final String accountName;
  final bool isConnected;
  final DateTime? linkedAt;

  const ConnectedAccount({
    required this.provider,
    required this.accountName,
    required this.isConnected,
    this.linkedAt,
  });

  @override
  List<Object?> get props => [provider, accountName, isConnected, linkedAt];
}
