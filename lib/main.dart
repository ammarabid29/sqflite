import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_app/data/local/db_helper.dart';
import 'package:sqflite_app/pages/home_page.dart';
import 'package:sqflite_app/provider/db_provider.dart';
import 'package:sqflite_app/provider/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => DbProvider(dbHelper: DBHelper.getInstance)),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // DBHelper db = DBHelper.getInstance;

    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: context.watch<ThemeProvider>().getThemeValue()
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
