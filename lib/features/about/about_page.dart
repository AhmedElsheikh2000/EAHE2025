import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFE9DFD1); // خلفية الهوية
    final onBg = Colors.brown.shade900;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: _Header(onBg: onBg),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.list(
                    children: const [
                      _SectionCard(
                        title: "Vision",
                        body:
                            "Evidence-based decision making is the norm in the health care system in Egypt.",
                        icon: Icons.remove_red_eye_outlined,
                      ),
                      SizedBox(height: 12),
                      _SectionCard(
                        title: "Mission",
                        body:
                            "Mainstreaming the utilization of health economics in decision making.",
                        icon: Icons.flag_outlined,
                      ),
                      SizedBox(height: 12),
                      _BulletsCard(
                        title: "Objectives",
                        icon: Icons.bolt_outlined,
                        bullets: [
                          "Increase awareness about the role of health economics in decision making in Egypt.",
                          "Scientific evaluation of the health care system.",
                          "Policy recommendations based on scientific research findings & white papers.",
                          "Health decision makers development.",
                          "Developing capacities on different technical levels.",
                          "Increase publication rate in Health Economics from Egypt.",
                          "International collaboration initiatives for policy experience exchange.",
                          "Conduct international workshops for top decision makers.",
                          "Support students and economists to progress and find jobs.",
                          "Help good researchers to have sponsored publications.",
                          "Communicate with health authorities about related topics.",
                          "Build awareness about healthcare financing systems.",
                        ],
                      ),
                      SizedBox(height: 12),
                      _BulletsCard(
                        title: "Activities",
                        icon: Icons.event_note_outlined,
                        bullets: [
                          "Research projects",
                          "Publications",
                          "Meetings / Conferences",
                          "Policy workshops",
                          "Training programs",
                          "Public policy advice",
                          "Science dissemination",
                          "Educational / Research grants",
                        ],
                      ),
                      SizedBox(height: 12),
                      _BulletsCard(
                        title: "Research Projects & Publications",
                        icon: Icons.science_outlined,
                        bullets: [
                          "HTA Roadmap – implementing HTA in Egypt.",
                          "HTA impact – can implementation guarantee cost-savings?",
                          "CET – defining a cost-effectiveness threshold in Egypt.",
                          "MCDA OOP – tool for purchasing oncology off-patent pharmaceuticals.",
                          "Burden of disease – TBD.",
                        ],
                      ),
                      SizedBox(height: 12),
                      _BulletsCard(
                        title: "Policy Workshops",
                        icon: Icons.forum_outlined,
                        bullets: [
                          "International workshops to exchange experience.",
                          "Local policy workshops for efficiency.",
                        ],
                      ),
                      SizedBox(height: 12),
                      _BulletsCard(
                        title: "Training Programs",
                        icon: Icons.school_outlined,
                        bullets: [
                          "Short training for students.",
                          "Short training for decision makers.",
                        ],
                      ),
                      SizedBox(height: 12),
                      _BulletsCard(
                        title: "Issuing Advice for Public Policies",
                        icon: Icons.policy_outlined,
                        bullets: [
                          "Policy recommendations to mitigate disease burden.",
                        ],
                      ),
                      SizedBox(height: 12),
                      _BulletsCard(
                        title: "Planned Collaboration",
                        icon: Icons.handshake_outlined,
                        bullets: [
                          "Parliament, GAHAR, GAHI, HIO, MoHP, UHIA, UMPA, universities, societies, international authorities, private insurance, NGOs, pharma.",
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ===================== Pieces ===================== */

class _Header extends StatelessWidget {
  const _Header({required this.onBg});
  final Color onBg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.65)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE9DFD1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About EAHE",
            style: TextStyle(
              color: onBg,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Egyptian Association for Health Economics",
            style: TextStyle(
              color: onBg.withOpacity(0.85),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _ChipInfo(icon: Icons.public, label: "International scope"),
              _ChipInfo(icon: Icons.health_and_safety_outlined, label: "Health economics"),
              _ChipInfo(icon: Icons.stacked_bar_chart_outlined, label: "Policy impact"),
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
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconBadge(icon: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleText(title),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.brown.shade800,
                          height: 1.45,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletsCard extends StatelessWidget {
  const _BulletsCard({
    required this.title,
    required this.icon,
    required this.bullets,
  });

  final String title;
  final IconData icon;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconBadge(icon: icon),
                const SizedBox(width: 12),
                Expanded(child: _TitleText(title)),
              ],
            ),
            const SizedBox(height: 10),
            ...bullets.map((t) => _BulletTile(text: t)).toList(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _BulletTile extends StatelessWidget {
  const _BulletTile({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8, color: Colors.brown),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.brown.shade900,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFE9DFD1).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE9DFD1),
          width: 1,
        ),
      ),
      child: Icon(icon, color: Colors.brown.shade800),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: Colors.brown.shade800,
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
      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
