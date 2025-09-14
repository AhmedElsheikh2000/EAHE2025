import "package:flutter/material.dart";
import "core/theme/app_theme.dart";
import "core/config/app_routes.dart";
import "core/config/app_strings.dart";
import "package:flutter_localizations/flutter_localizations.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EAHEApp());
}

class EAHEApp extends StatelessWidget {
  const EAHEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: S.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
      supportedLocales: const [Locale("en"), Locale("ar")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
