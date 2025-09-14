import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  const AppNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),     // 0
        NavigationDestination(icon: Icon(Icons.info_outline), label: "Info"),      // 1
        NavigationDestination(icon: Icon(Icons.event_note_outlined), label: "Program"), // 2
        NavigationDestination(icon: Icon(Icons.app_registration_outlined), label: "Register"), // 3
        NavigationDestination(icon: Icon(Icons.people_alt_outlined), label: "Speakers"), // 4
        NavigationDestination(icon: Icon(Icons.approval_outlined), label: "About"), // 5
        NavigationDestination(icon: Icon(Icons.contact_mail_outlined), label: "Contact"), // 6
      ],
    );
  }
}
