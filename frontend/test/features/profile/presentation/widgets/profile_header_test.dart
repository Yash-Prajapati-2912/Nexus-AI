import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/features/profile/domain/entities/user_profile.dart';
import 'package:nexus_ai/features/profile/presentation/widgets/profile_header.dart';

void main() {
  const tProfile = UserProfile(
    id: 'u1',
    userId: 'usr1',
    displayName: 'Alex Rivers',
    username: 'alexrivers',
    email: 'alex@stanford.edu',
    bio: 'Computer Science Student',
    timezone: 'PST',
    language: 'en',
    completionPercentage: 90,
  );

  testWidgets('ProfileHeader displays name, username, email, and bio', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileHeader(profile: tProfile),
        ),
      ),
    );

    expect(find.text('Alex Rivers'), findsOneWidget);
    expect(find.text('@alexrivers'), findsOneWidget);
    expect(find.text('Computer Science Student'), findsOneWidget);
    expect(find.text('90% Profile Complete'), findsOneWidget);
  });
}
