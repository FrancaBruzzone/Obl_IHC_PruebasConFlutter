import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';


class MyAppState extends ChangeNotifier {
  
var user = false;

    notifyListeners();

  
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'GreenTrace App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: LoginPage(),
      ),
    );
  }
}