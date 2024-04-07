import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studenthelp/components/login.dart';
import 'package:studenthelp/components/signup.dart';
import 'package:studenthelp/settings/theme_config.dart';
import 'package:studenthelp/settings/theme_provider.dart';
import 'package:studenthelp/firebase_options.dart';
import 'home_screen.dart';
// import get
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeStateProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    context.read<ThemeStateProvider>().getDarkTheme();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeStateProvider>(builder: (context, theme, child) {
      return GetCupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          primaryColor: Colors.blue,
          brightness: theme.isDarkTheme ? Brightness.dark : Brightness.light,
        ),
        // theme: ThemeConfig.lightTheme,
        // darkTheme: ThemeConfig.darkTheme,
        // themeMode: theme.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        home: HomeScreen(),
        routes: {
          '/signup': (context) => SignUpScreen(),
          '/login': (context) => LoginScreen(),
        },
      );
    });
  }
}
