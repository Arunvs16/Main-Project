import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:main_project/Providers/auth_page_provider.dart';
import 'package:main_project/Providers/firestore_provider.dart';
import 'package:main_project/Providers/pages_provider.dart';
import 'package:main_project/firebase_options.dart';
import 'package:main_project/pages/comment_page.dart';
import 'package:main_project/pages/help/app_info_page.dart';
import 'package:main_project/pages/auth/auth_page.dart';
import 'package:main_project/pages/help/help_page.dart';
import 'package:main_project/pages/main_page.dart';
import 'package:main_project/pages/help/privacy_policy_page.dart';
import 'package:main_project/pages/profile_page.dart';
import 'package:main_project/pages/settings_page.dart';
import 'package:main_project/pages/help/terms_of_services.dart';
import 'package:main_project/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthPageProvider()),
        ChangeNotifierProvider(create: (_) => CommentDataProvider()),
        ChangeNotifierProvider(create: (_) => PostLikeProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => PagesProvider()),
        Provider(create: (_) => UserDataProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/mainpage': (context) => MainPage(),
        '/settings': (context) => SettingsPage(),
        '/profilepage': (context) => ProfilePage(),
        '/helpPage': (context) => HelpPage(),
        '/termsOfServices': (context) => TermsOfServices(),
        '/PrivacyPolicy': (context) => PrivacyPolicyPage(),
        '/appInfo': (context) => AppInfoPage(),
        '/comments': (context) => CommentPage(),
      },
    );
  }
}
