# =======================
# EAHE2025 bootstrap script
# =======================

# 1) Dependencies
flutter pub add go_router google_fonts url_launcher shared_preferences

# 2) Create folders
$dirs = @(
  "lib/core/theme",
  "lib/core/config",
  "lib/core/widgets",
  "lib/features/home",
  "lib/features/information",
  "lib/features/program",
  "lib/features/registration",
  "lib/features/speakers",
  "lib/features/about",
  "lib/features/gallery",
  "lib/features/contact",
  "assets/images",
  "assets/data"
)
$dirs | ForEach-Object { if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ | Out-Null } }

# 3) pubspec assets ensure
$pub = Get-Content -Raw pubspec.yaml
if ($pub -notmatch "assets:\s*\n") {
  $pub = $pub -replace "uses-material-design:\s*true", "uses-material-design: true`n  assets:`n    - assets/images/`n    - assets/data/"
} elseif ($pub -notmatch "assets/images/") {
  $pub = $pub -replace "assets:\s*\n", "assets:`n    - assets/images/`n    - assets/data/`n"
}
Set-Content -Encoding UTF8 pubspec.yaml $pub

# 4) THEME
@'
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF271443);
  static const Color secondary = Color(0xFF50276E);
  static const Color accent = Color(0xFFFBE7C6);
  static const Color bg = Color(0xFFF7EFE2);

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      scaffoldBackgroundColor: bg,
      textTheme: GoogleFonts.cairoTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/core/theme/app_theme.dart

# 5) STRINGS
@'
class S {
  static const appName = "EAHE 2025";
  static const venue = "Hilton Cairo Grand Nile";
  static const date = "7 October 2025 • Cairo, Egypt";

  static const tabHome = "Home";
  static const tabInfo = "Information";
  static const tabProgram = "Program";
  static const tabRegistration = "Registration";
  static const tabSpeakers = "Speakers";
  static const tabAbout = "About EAHE";
  static const tabGallery = "Gallery";
  static const tabContact = "Contact";
}
'@ | Set-Content -Encoding UTF8 lib/core/config/app_strings.dart

# 6) SHARED NAV BAR WIDGET
@'
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
        NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
        NavigationDestination(icon: Icon(Icons.info_outline), label: "Info"),
        NavigationDestination(icon: Icon(Icons.event_note_outlined), label: "Program"),
        NavigationDestination(icon: Icon(Icons.app_registration_outlined), label: "Register"),
        NavigationDestination(icon: Icon(Icons.people_alt_outlined), label: "Speakers"),
        NavigationDestination(icon: Icon(Icons.approval_outlined), label: "About"),
        NavigationDestination(icon: Icon(Icons.photo_library_outlined), label: "Gallery"),
        NavigationDestination(icon: Icon(Icons.contact_mail_outlined), label: "Contact"),
      ],
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/core/widgets/app_nav_bar.dart

# 7) ROUTES (Shell + tabs)
@'
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../../core/widgets/app_nav_bar.dart";
import "../../features/home/home_page.dart";
import "../../features/information/information_page.dart";
import "../../features/program/program_page.dart";
import "../../features/registration/registration_page.dart";
import "../../features/speakers/speakers_page.dart";
import "../../features/about/about_page.dart";
import "../../features/gallery/gallery_page.dart";
import "../../features/contact/contact_page.dart";

class _TabsShell extends StatefulWidget {
  final Widget child;
  final int index;
  const _TabsShell({required this.child, required this.index});

  @override
  State<_TabsShell> createState() => _TabsShellState();
}

class _TabsShellState extends State<_TabsShell> {
  void _onTap(int i) {
    switch (i) {
      case 0: context.go("/"); break;
      case 1: context.go("/info"); break;
      case 2: context.go("/program"); break;
      case 3: context.go("/registration"); break;
      case 4: context.go("/speakers"); break;
      case 5: context.go("/about"); break;
      case 6: context.go("/gallery"); break;
      case 7: context.go("/contact"); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EAHE 2025")),
      body: widget.child,
      bottomNavigationBar: AppNavBar(currentIndex: widget.index, onTap: _onTap),
    );
  }
}

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    ShellRoute(
      builder: (ctx, state, child) => _TabsShell(
        child: child,
        index: switch (state.uri.path) {
          "/": 0,
          "/info": 1,
          "/program": 2,
          "/registration": 3,
          "/speakers": 4,
          "/about": 5,
          "/gallery": 6,
          "/contact": 7,
          _ => 0,
        },
      ),
      routes: [
        GoRoute(path: "/", builder: (ctx, st) => const HomePage()),
        GoRoute(path: "/info", builder: (ctx, st) => const InformationPage()),
        GoRoute(path: "/program", builder: (ctx, st) => const ProgramPage()),
        GoRoute(path: "/registration", builder: (ctx, st) => const RegistrationPage()),
        GoRoute(path: "/speakers", builder: (ctx, st) => const SpeakersPage()),
        GoRoute(path: "/about", builder: (ctx, st) => const AboutPage()),
        GoRoute(path: "/gallery", builder: (ctx, st) => const GalleryPage()),
        GoRoute(path: "/contact", builder: (ctx, st) => const ContactPage()),
      ],
    ),
  ],
);
'@ | Set-Content -Encoding UTF8 lib/core/config/app_routes.dart

# 8) MAIN
@'
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
'@ | Set-Content -Encoding UTF8 lib/main.dart

# 9) HOME (Hero + CTA + Counter)
@'
import "package:flutter/material.dart";
import "dart:async";

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _t;
  Duration _left = const Duration();

  @override
  void initState() {
    super.initState();
    final event = DateTime(2025, 10, 7, 9, 0); // 7 Oct 2025, 9:00
    void tick() {
      setState(() => _left = event.difference(DateTime.now()));
    }
    tick();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String fmt(Duration d) {
      if (d.isNegative) return "Started";
      final days = d.inDays;
      final hours = d.inHours % 24;
      final mins = d.inMinutes % 60;
      final secs = d.inSeconds % 60;
      return "$days d : $hours h : $mins m : $secs s";
    }

    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 16/9,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF271443), Color(0xFF50276E)],
                begin: Alignment.topLeft, end: Alignment.bottomRight
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("EAHE 2025",
                        style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      const Text("Hilton Cairo Grand Nile • 7 October 2025",
                        style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      FilledButton(onPressed: (){}, child: const Text("Explore Program")),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text("Countdown: ${fmt(_left)}",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12, runSpacing: 12,
            children: const [
              _QuickCard(icon: Icons.info_outline, title: "Information", route: "/info"),
              _QuickCard(icon: Icons.event_note_outlined, title: "Program", route: "/program"),
              _QuickCard(icon: Icons.app_registration_outlined, title: "Registration", route: "/registration"),
              _QuickCard(icon: Icons.people_alt_outlined, title: "Speakers", route: "/speakers"),
              _QuickCard(icon: Icons.approval_outlined, title: "About EAHE", route: "/about"),
              _QuickCard(icon: Icons.photo_library_outlined, title: "Gallery", route: "/gallery"),
              _QuickCard(icon: Icons.contact_mail_outlined, title: "Contact", route: "/contact"),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  const _QuickCard({required this.icon, required this.title, required this.route, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(route), // handled by GoRouter via context.go in NavBar
      child: Container(
        width: 160, height: 110,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/home/home_page.dart

# 10) INFORMATION (نصوصك كما أرسلت)
@'
import "package:flutter/material.dart";

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  Widget section(String title, String body) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text(body),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    const intro = "The Egyptian Association for Health Economics is proud to announce its 4th Annual Conference, to be held on the 7th of October 2025, at the prestigious Hilton Cairo Grand Nile. This highly anticipated event brings together experts, professionals, and stakeholders from diverse fields, including healthcare, media, and governmental institutions.";
    const vision = "Becoming the leading platform in Egypt for advancing knowledge, policy, and practice in health economics, fostering innovation, and improving health outcomes.";
    const mission = "To facilitate meaningful dialogue and collaboration by providing high-quality workshops, training, and discussions, the conference aims to empower decision-makers with the knowledge and tools necessary to address the complex economic challenges in the healthcare sector and to promote sustainable health policies and practices.";
    const about = "The Egyptian Association for Health Economics was founded in 2022 and has established itself rapidly as a leading organization dedicated to the advancement of health economics in Egypt. The association is led by an esteemed board comprising Prof. Ashraf Hatem (Conference President), Major General Dr. Magdy Amin (Conference Vice President), Prof. Nader Fasseeh (Conference Vice President), Dr. Sherif Abaza (Conference General Secretary), and  Dr. Ahmed Nader Fasseeh (Conference Treasurer)\n\nAs our launching conference, which was held in October 2022, was a resounding success, attracting a wide array of specialists and garnering significant attention. Building on this momentum, the upcoming conference promises to be even more impactful, featuring an extensive program that includes engaging discussions, workshops, and short training courses tailored for decision-makers.\n\nHealth Economics Conference 2025 is proudly sponsored by numerous local and international medical companies reflecting the significant support and interest from the industry in advancing health economics, creating and strengthening valuable networking opportunities.";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          section("Venue & Date", "Hilton Cairo Grand Nile – 7 October 2025"),
          section("Introduction", intro),
          section("Vision", vision),
          section("Mission", mission),
          section("About Us", about),
        ],
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/information/information_page.dart

# 11) PROGRAM (ديمو Days->Sessions->Topics + Favorites)
@'
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key});
  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  final Map<String, dynamic> data = {
    "days": [
      {
        "date": "2025-10-07",
        "title": "Day 1",
        "sessions": [
          {
            "time": "09:00 - 10:30",
            "title": "Opening & Keynotes",
            "topics": [
              {"id":"t1","time":"09:00","title":"Welcome Remarks","speaker":"EAHE Board"},
              {"id":"t2","time":"09:30","title":"Health Economics Landscape","speaker":"Prof. A. Hatem"},
            ]
          },
          {
            "time": "11:00 - 12:30",
            "title": "HTA & Policy",
            "topics": [
              {"id":"t3","time":"11:00","title":"HTA Roadmap in Egypt","speaker":"Panel"},
              {"id":"t4","time":"11:40","title":"MCDA in Oncology","speaker":"Dr. X"},
            ]
          }
        ]
      }
    ]
  };

  Set<String> fav = {};

  @override
  void initState() {
    super.initState();
    _loadFav();
  }

  Future<void> _loadFav() async {
    final sp = await SharedPreferences.getInstance();
    fav = sp.getStringList("fav_topics")?.toSet() ?? {};
    setState((){});
  }

  Future<void> _toggleFav(String id) async {
    final sp = await SharedPreferences.getInstance();
    if (fav.contains(id)) { fav.remove(id); } else { fav.add(id); }
    await sp.setStringList("fav_topics", fav.toList());
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    final days = (data["days"] as List).cast<Map<String,dynamic>>();
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: days.length,
      itemBuilder: (_, di) {
        final day = days[di];
        final sessions = (day["sessions"] as List).cast<Map<String,dynamic>>();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${day["title"]} • ${day["date"]}",
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 8),
                ...sessions.map((s) {
                  final topics = (s["topics"] as List).cast<Map<String,dynamic>>();
                  return ExpansionTile(
                    title: Text("${s["time"]} — ${s["title"]}", style: const TextStyle(fontWeight: FontWeight.w700)),
                    children: topics.map((t) {
                      final id = t["id"] as String;
                      final marked = fav.contains(id);
                      return ListTile(
                        title: Text("${t["time"]}  ${t["title"]}"),
                        subtitle: Text("${t["speaker"]}"),
                        trailing: IconButton(
                          icon: Icon(marked ? Icons.favorite : Icons.favorite_border,
                            color: marked ? Colors.red : null),
                          onPressed: () => _toggleFav(id),
                        ),
                      );
                    }).toList(),
                  );
                })
              ],
            ),
          ),
        );
      },
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/program/program_page.dart

# 12) REGISTRATION (يفتح لينك خارجي)
@'
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  Future<void> _open() async {
    final uri = Uri.parse("https://example.com/registration"); // TODO: ضع لينك التسجيل الحقيقي
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(onPressed: _open, child: const Text("Go to Registration")),
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/registration/registration_page.dart

# 13) SPEAKERS (Grid بسيط)
@'
import "package:flutter/material.dart";

class SpeakersPage extends StatelessWidget {
  const SpeakersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final speakers = List.generate(8, (i) => {
      "name": "Speaker ${i+1}",
      "bio": "Short bio snippet for speaker ${i+1}."
    });
    final cross = MediaQuery.of(context).size.width >= 700 ? 3 : 2;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cross, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .85),
        itemCount: speakers.length,
        itemBuilder: (_, i) {
          final sp = speakers[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const CircleAvatar(radius: 36, child: Icon(Icons.person, size: 36)),
                  const SizedBox(height: 10),
                  Text("${sp["name"]}", style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text("${sp["bio"]}", textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/speakers/speakers_page.dart

# 14) ABOUT EAHE (النصوص الكبيرة)
@'
import "package:flutter/material.dart";

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget title(String t) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
  );

  Widget bullet(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [
      const Icon(Icons.circle, size: 8), const SizedBox(width: 8), Expanded(child: Text(t))
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        title("Vision"),
        const Text("Evidence based decision making is the norm in the health care system in Egypt"),
        title("Mission"),
        const Text("Mainstreaming the utilization of health economics in decision making"),
        title("Objectives"),
        bullet("Increase awareness about the role of health economics in decision making in Egypt."),
        bullet("Scientific evaluation of the health care system."),
        bullet("Policy recommendations based on scientific research findings & white papers."),
        bullet("Health decision makers development."),
        bullet("Developing capacities on different technical levels."),
        bullet("Increase publication rate in Health Economics from Egypt."),
        bullet("International collaboration initiatives for policy experience exchange."),
        bullet("Conduct international workshops for top decision makers."),
        bullet("Support students and economists to progress and find jobs."),
        bullet("Help good researches to have sponsored publications."),
        bullet("Communicate with health authorities about related topics."),
        bullet("Build awareness about healthcare financing systems."),
        title("Activities"),
        bullet("Research Projects"), bullet("Publications"), bullet("Meetings/conferences"),
        bullet("Policy workshops"), bullet("Training programs"), bullet("Public policy advice"),
        bullet("Science dissemination"), bullet("Educational/Research Grants"),
        title("Research Projects & Publications"),
        bullet("HTA Road map – implementing HTA in Egypt."),
        bullet("HTA impact – can implementation guarantee cost-savings?"),
        bullet("CET – defining a cost-effectiveness threshold in Egypt."),
        bullet("MCDA OOP – tool for purchasing oncology off-patent pharmaceuticals."),
        bullet("Burden of disease – TBD."),
        title("Policy workshops"),
        bullet("International workshops to exchange experience."),
        bullet("Local policy workshops for efficiency."),
        title("Training programs"),
        bullet("Short training for students"),
        bullet("Short training for decision makers"),
        title("Issuing advice for public policies"),
        bullet("Policy recommendations to mitigate disease burden."),
        title("Planned Collaboration"),
        bullet("Parliament, GAHAR, GAHI, HIO, MoHP, UHIA, UMPA, Universities, Societies, International authorities, Private insurance, NGOs, Pharma"),
        title("Action Plan"),
        const Text("…"),
      ],
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/about/about_page.dart

# 15) GALLERY (Grid Placeholder)
@'
import "package:flutter/material.dart";

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(12, (i) => i);
    final cross = MediaQuery.of(context).size.width >= 700 ? 4 : 2;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cross, mainAxisSpacing: 10, crossAxisSpacing: 10),
        itemCount: items.length,
        itemBuilder: (_, i) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFFBE7C6), Color(0xFFF7EFE2)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            border: Border.all(color: Colors.black12),
          ),
          child: const Icon(Icons.photo, size: 36),
        ),
      ),
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/gallery/gallery_page.dart

# 16) CONTACT (Mail/Phone/Map)
@'
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _open(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.email_outlined),
          title: const Text("info@eahe.org.eg"),
          onTap: () => _open(Uri.parse("mailto:info@eahe.org.eg")),
        ),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text("+20 100 000 0000"),
          onTap: () => _open(Uri.parse("tel:+201000000000")),
        ),
        ListTile(
          leading: const Icon(Icons.place_outlined),
          title: const Text("Hilton Cairo Grand Nile"),
          subtitle: const Text("Cairo, Egypt"),
          onTap: () => _open(Uri.parse("https://maps.google.com/?q=Hilton+Cairo+Grand+Nile")),
        ),
      ],
    );
  }
}
'@ | Set-Content -Encoding UTF8 lib/features/contact/contact_page.dart
