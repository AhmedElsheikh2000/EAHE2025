import 'package:flutter/material.dart';
import 'package:eahe2025/pages/contact_page.dart';
// استورد بقية الصفحات الحقيقية عندك
// import 'package:eahe2025/pages/home_page.dart';
// import 'package:eahe2025/pages/info_page.dart';
// import 'package:eahe2025/pages/program_page.dart';
// import 'package:eahe2025/pages/register_page.dart';
// import 'package:eahe2025/pages/speakers_page.dart';
// import 'package:eahe2025/pages/about_page.dart';

import 'package:eahe2025/widgets/app_nav_bar.dart'; // مسار AppNavBar بتاعك

// مؤقتًا لو لسه مافيش صفحات، حط Placeholders عشان التجربة:
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage(this.title);
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: Center(child: Text(title))),
      );
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _currentIndex = 0;

  // IMPORTANT: لازم الطول يطابق عدد العناصر في AppNavBar (7 عناصر)
  final _pages = const [
    _PlaceholderPage('Home'),     // HomePage()
    _PlaceholderPage('Info'),     // InfoPage()
    _PlaceholderPage('Program'),  // ProgramPage()
    _PlaceholderPage('Register'), // RegisterPage()
    _PlaceholderPage('Speakers'), // SpeakersPage()
    _PlaceholderPage('About'),    // AboutPage()
    ContactPage(),                // ContactPage()  <<<<<<<<<<<<<
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AppNavBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          // للتأكد إن الزرار شغال:
          debugPrint('Tapped index: $i');
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}
