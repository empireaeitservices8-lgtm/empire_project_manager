import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set luxury immersive system navigation and status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: NGColors.obsidian,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const EmpireProjectManagerApp());
}

class EmpireProjectManagerApp extends StatefulWidget {
  const EmpireProjectManagerApp({super.key});

  @override
  State<EmpireProjectManagerApp> createState() =>
      _EmpireProjectManagerAppState();
}

class _EmpireProjectManagerAppState extends State<EmpireProjectManagerApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(
      state: _appState,
      child: MaterialApp(
        title: 'Empire Project Manager',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
