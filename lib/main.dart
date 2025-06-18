import 'package:flutter/material.dart';
import 'package:flutter_application_1/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ztsvilejodpqendallnk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp0c3ZpbGVqb2RwcWVuZGFsbG5rIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQzMzUyNDgsImV4cCI6MjA1OTkxMTI0OH0.udZnagkYfgZky-dWHgU9bs7rZYkgKhBGhVU4Oy8d0OY',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          home: splashscreen(), // or HomeScreen if integrated
        );
      },
    );
  }
}
