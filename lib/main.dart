import 'package:flutter/material.dart';
import 'package:posapp/screens/product_list.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: authService.autoLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.hasData ? ProductListScreen() : LoginScreen();
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
      routes: {
        '/products': (context) => ProductListScreen(),
      },
    );
  }
}