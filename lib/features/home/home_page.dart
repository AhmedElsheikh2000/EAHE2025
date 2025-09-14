import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "dart:async";
import "package:url_launcher/url_launcher.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Timer _t;
  Duration _left = const Duration();

  // ألوان الهوية
  static const kBg = Color(0xFFD3C6B2);   // الخلفية المطلوبة
  static const kPrimary = Color(0xFF27456B); // اللون الأزرق المطلوب

  @override
  void initState() {
    super.initState();
    final event = DateTime(2025, 10, 7, 9, 0); // 7 Oct 2025, 9:00
    void tick() => setState(() => _left = event.difference(DateTime.now()));
    tick();
    _t = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    if (d.isNegative) return "Started";
    final days = d.inDays,
        hours = d.inHours % 24,
        mins = d.inMinutes % 60,
        secs = d.inSeconds % 60;
    return "$days d : $hours h : $mins m : $secs s";
  }

  Future<void> _openMaps() async {
  // جرّب geo: (يفتح Google Maps أو أي خرائط مثبتة)
  final geo = Uri.parse("geo:0,0?q=${Uri.encodeComponent("Hilton Cairo Grand Nile, Cairo")}");
  if (await canLaunchUrl(geo)) {
    await launchUrl(geo, mode: LaunchMode.externalApplication);
    return;
  }

  // لو مفيش app للـ geo، افتح https في المتصفح
  final web = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent("Hilton Cairo Grand Nile")}");
  await launchUrl(web, mode: LaunchMode.externalApplication);
}


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ===== HERO / HEADER (Gradient + Centered Logo) =====
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE9DFD1), // أفتح من #d3c6b2 عشان الواجهة تبقى airy
                  kBg,                // #d3c6b2
                ],
              ),
            ),
            child: LayoutBuilder(
              builder: (context, c) {
                // استجابة بسيطة لحجم الشاشة
                final wide = c.maxWidth > 420;
                final logoSize = wide ? 124.0 : 108.0;
                final titleSize = wide ? 28.0 : 26.0;
                final countdownSize = wide ? 26.0 : 24.0;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.75),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimary.withOpacity(0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(color: kPrimary.withOpacity(0.15)),
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: logoSize * 0.72,
                        height: logoSize * 0.72,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.local_hospital,
                          size: logoSize * 0.1,
                          color: kPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),
                    // Title
                    Text(
                      "Welcome EAHE 2025",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w800,
                        color: kPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 8),
                    // Date chip (highlight)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.black : Colors.white).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: kPrimary.withOpacity(0.15)),
                      ),
                      child: const Text(
                        "Hilton Cairo Grand Nile • 7 October 2025",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: kPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          onPressed: () => context.go("/program"),
                          child: const Text("Explore Program", style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kPrimary, width: 1.2),
                            foregroundColor: kPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => context.go("/info"),
                          child: const Text("Event Info", style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    // Countdown (bigger + mono-like spacing)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.65),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kPrimary.withOpacity(0.12)),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimary.withOpacity(0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        "Countdown: ${_fmt(_left)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: countdownSize,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ===== VENUE SECTION (Card) =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _SectionCard(
              title: "Venue",
              icon: Icons.place_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hilton Cairo Grand Nile, Garden City, Cairo, Egypt",
                    style: TextStyle(fontSize: 15.5, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _openMaps,
                        icon: const Icon(Icons.map_outlined),
                        label: const Text("Open in Maps"),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kPrimary, width: 1.2),
                          foregroundColor: kPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

// ===== Reusable Section Card with consistent style =====
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  static const kPrimary = Color(0xFF27456B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kPrimary.withOpacity(.12)),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: kPrimary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.5,
                  fontWeight: FontWeight.w900,
                  color: kPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
