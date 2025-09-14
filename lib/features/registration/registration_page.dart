import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  static final Uri _regUri = Uri.parse(
    "https://sys.foldergroup.com/confregisteration/add?confid=18483",
  );

  Future<void> _open() async {
    if (!await launchUrl(_regUri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch registration link";
    }
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFE9DFD1); // requested brand color
    final onBg = Colors.brown.shade900;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _HeroHeader(onBg: onBg),
                  const SizedBox(height: 24),

                  // Why Attend section (4 points)
                  _SectionCard(
                    title: "🌟 Why Attend EAHE 2025?",
                    subtitle:
                        "A world-class, high-impact health economics event in Cairo.",
                    children: const [
                      _BulletTile(
                        icon: Icons.location_city,
                        title: "Prestigious Venue & High-Level Event",
                        body:
                            "Hilton Cairo Grand Nile • 7 Oct 2025 — a professional, world-class experience.",
                      ),
                      _BulletTile(
                        icon: Icons.verified_user,
                        title: "Expert Leadership & Credibility",
                        body:
                            "Organized by the Egyptian Association for Health Economics, led by esteemed national figures.",
                      ),
                      _BulletTile(
                        icon: Icons.menu_book,
                        title: "Rich Scientific Program",
                        body:
                            "Engaging discussions, interactive workshops, and short training courses for decision-makers.",
                      ),
                      _BulletTile(
                        icon: Icons.groups,
                        title: "Cross-Sector Participation",
                        body:
                            "Healthcare professionals, media, and government stakeholders for impactful dialogue.",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Vision & Mission brief (optional compact)
                  _SectionCard(
                    title: "Vision & Mission",
                    subtitle: "Driving sustainable health policy in Egypt.",
                    children: const [
                      _MiniKPI(
                        label: "Vision",
                        value:
                            "Egypt’s leading platform for advancing knowledge & practice in health economics.",
                        icon: Icons.remove_red_eye,
                      ),
                      _MiniKPI(
                        label: "Mission",
                        value:
                            "Empower decision-makers with tools and insights to improve health outcomes.",
                        icon: Icons.flag,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Registration Button
                  _RegisterCTA(onTap: _open, onBg: onBg),

                  const SizedBox(height: 12),

                  // Small helper text (bilingual)
                  Text(
                    "Secure your seat now.\n.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: onBg.withOpacity(0.75),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ======================= UI Pieces ======================= */

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.onBg});
  final Color onBg;

  @override
  Widget build(BuildContext context) {
    final title = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w800,
      color: onBg,
      height: 1.2,
      letterSpacing: 0.2,
    );
    final subtitle = TextStyle(
      fontSize: 14,
      color: onBg.withOpacity(0.85),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.85),
            Colors.white.withOpacity(0.55),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("EAHE Health Economics Conference 2025", style: title),
          const SizedBox(height: 8),
          Text(
            "Hilton Cairo Grand Nile • 7 October 2025",
            style: subtitle,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _ChipInfo(icon: Icons.place, label: "Cairo, Egypt"),
              _ChipInfo(icon: Icons.date_range, label: "7 Oct 2025"),
              _ChipInfo(icon: Icons.public, label: "International Audience"),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    this.subtitle,
    required this.children,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.brown.shade800,
                    )),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.brown.shade700.withOpacity(0.9),
                    ),
              ),
            ],
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _BulletTile extends StatelessWidget {
  const _BulletTile({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFE9DFD1).withOpacity(0.55),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.brown.shade800),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.brown.shade900,
            ),
      ),
      subtitle: Text(
        body,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.brown.shade700,
              height: 1.35,
            ),
      ),
    );
  }
}

class _MiniKPI extends StatelessWidget {
  const _MiniKPI({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE9DFD1).withOpacity(0.9),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(
                      color: Colors.brown.shade800,
                    ),
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  const _ChipInfo({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
      avatar: Icon(icon, size: 18, color: Colors.brown.shade800),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.brown.shade900,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: const Color(0xFFE9DFD1).withOpacity(0.9),
          width: 1,
        ),
      ),
      elevation: 0.5,
      shadowColor: Colors.black12,
    );
  }
}

class _RegisterCTA extends StatelessWidget {
  const _RegisterCTA({required this.onTap, required this.onBg});
  final VoidCallback onTap;
  final Color onBg;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              children: [
                Text(
                  "Ready to Register?",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: onBg.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.brown.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onTap,
                    icon: const Icon(Icons.open_in_new),
                    label: const Text(
                      "Go to Registration",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "",
                  style: TextStyle(fontSize: 12.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
