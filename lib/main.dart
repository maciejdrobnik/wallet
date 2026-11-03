import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'features/subscriptions/presentation/pages/subscriptions_temporary_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const WalletApp());
}

class WalletApp extends StatelessWidget {
  const WalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallet',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const SubscriptionsTemporaryPage(),
    );
  }
}
