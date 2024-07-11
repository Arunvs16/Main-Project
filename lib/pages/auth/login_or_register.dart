import 'package:flutter/material.dart';
import 'package:main_project/Providers/auth_page_provider.dart';
import 'package:main_project/pages/auth/login_page.dart';
import 'package:main_project/pages/auth/register_page.dart';
import 'package:provider/provider.dart';

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final authPageProvider = Provider.of<AuthPageProvider>(context);
    return authPageProvider.showLoginPage
        ? LoginPage(onTap: authPageProvider.togglePage)
        : RegisterPage(onTap: authPageProvider.togglePage);
  }
}
