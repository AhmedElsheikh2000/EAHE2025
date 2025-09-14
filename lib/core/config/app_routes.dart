import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../core/widgets/app_nav_bar.dart";
import "../../features/home/home_page.dart";
import "../../features/information/information_page.dart";
import "../../features/program/program_page.dart";
import "../../features/registration/registration_page.dart";
import "../../features/speakers/speakers_page.dart";
import "../../features/about/about_page.dart";
import "../../features/contact/contact_page.dart";

int _indexFor(String path) {
  switch (path) {
    case "/": return 0;
    case "/info": return 1;
    case "/program": return 2;
    case "/registration": return 3;
    case "/speakers": return 4;
    case "/about": return 5;
    case "/contact": return 6;
    default: return 0;
  }
}

class _TabsShell extends StatelessWidget {
  final Widget child;
  final int index;
  const _TabsShell({required this.child, required this.index});

  void _onTap(BuildContext context, int i) {
    switch (i) {
      case 0: context.go("/"); break;
      case 1: context.go("/info"); break;
      case 2: context.go("/program"); break;
      case 3: context.go("/registration"); break;
      case 4: context.go("/speakers"); break;
      case 5: context.go("/about"); break;
      case 6: context.go("/contact"); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EAHE 2025")),
      body: child,
      bottomNavigationBar: AppNavBar(
        currentIndex: index,
        onTap: (i) => _onTap(context, i),
      ),
    );
  }
}

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    ShellRoute(
      builder: (ctx, state, child) =>
          _TabsShell(child: child, index: _indexFor(state.uri.path)),
      routes: [
        GoRoute(path: "/", builder: (ctx, st) => const HomePage()),
        GoRoute(path: "/info", builder: (ctx, st) => const InformationPage()),
        GoRoute(path: "/program", builder: (ctx, st) => const ProgramPage()),
        GoRoute(path: "/registration", builder: (ctx, st) => const RegistrationPage()),
        GoRoute(path: "/speakers", builder: (ctx, st) => const SpeakersPage()),
        GoRoute(path: "/about", builder: (ctx, st) => const AboutPage()), 
        GoRoute(path: "/contact", builder: (ctx, st) => const ContactPage()),
      ],
    ),
  ],
);
