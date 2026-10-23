import '../../domain/entities/connected_account.dart';

class ConnectedAccountModel extends ConnectedAccount {
  const ConnectedAccountModel({
    required super.provider,
    required super.accountName,
    required super.isConnected,
    super.linkedAt,
  });

  factory ConnectedAccountModel.fromJson(Map<String, dynamic> json) {
    return ConnectedAccountModel(
      provider: json['provider'] as String? ?? 'GOOGLE',
      accountName: json['accountName'] as String? ?? json['email'] as String? ?? 'user@gmail.com',
      isConnected: json['isConnected'] as bool? ?? false,
      linkedAt: json['linkedAt'] != null ? DateTime.parse(json['linkedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      'accountName': accountName,
      'isConnected': isConnected,
      'linkedAt': linkedAt?.toIso8601String(),
    };
  }
}
