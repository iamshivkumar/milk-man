import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'ui/pages/auth/admin_login_page.dart';
import 'ui/pages/auth/providers/auth_view_model_provider.dart';
import 'ui/pages/home/home_page.dart';
import 'ui/pages/profile/providers/profile_provider.dart';
import 'ui/widgets/loading.dart';

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
          unselectedLabelColor: Colors.grey,
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: auth.user != null
          ? Builder(builder: (context) {
              final profileStream = watch(profileProvider);
              return profileStream.when(
                data: (profile) => HomePage(),
                loading: () => Scaffold(
                  body: Loading(),
                ),
                error: (e, s) => Scaffold(
                  body: Text(e.toString()),
                ),
              );
            })
          : LoginPage(),
    );
  }
}
