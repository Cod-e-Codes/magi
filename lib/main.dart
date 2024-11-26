import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_page.dart';
import '../utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Check if running with Wasm
  const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');
  debugPrint('Running with Wasm: $isRunningWithWasm');

  runApp(const MagiApp());
}

class MagiApp extends StatefulWidget {
  const MagiApp({super.key});

  @override
  State<MagiApp> createState() => MagiAppState();

  static MagiAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MagiAppState>();
}

class MagiAppState extends State<MagiApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void setThemeMode(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAGI Ministries',
      theme: appTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      home: const LoginPage(), // Your initial screen
      debugShowCheckedModeBanner: false,
    );
  }
}
