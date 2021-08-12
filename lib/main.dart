import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:milk_man_app/ui/pages/auth/admin_login_page.dart';
import 'package:milk_man_app/ui/pages/auth/providers/auth_view_model_provider.dart';

import 'ui/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final auth = watch(authViewModelProvider);
    return MaterialApp(
      title: 'Milk Man App',
      theme: ThemeData(
        tabBarTheme: TabBarTheme(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey
        ),
        primarySwatch: Colors.blue,
      ),
      home: auth.user != null ? HomePage() : AdminLoginPage(),
    );
  }
}
