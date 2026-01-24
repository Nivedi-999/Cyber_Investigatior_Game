import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppShell(
        child: SafeArea(
          child: Column(
            children: [
              _appBar(context),
              _divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select an option to start or continue your investigation.',
                      style: GoogleFonts.sofiaSans(
                        color: Colors.white70,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _button(
                      icon: Icons.search,
                      label: 'Start New Investigation',
                      color: const Color(0xFF4EEBCA),
                      primary: true,
                    ),
                    const SizedBox(height: 18),
                    _button(
                      icon: Icons.folder_open_outlined,
                      label: 'Continue Ongoing Investigation',
                      color: const Color(0xFF2F6F8F),
                      primary: false,
                    ),
                    const SizedBox(height: 36),
                    _rankSection(),
                  ],
                ),
              ),
              const Spacer(),
              _bottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── APP BAR ─────────────────

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Cyber Investigator\nSimulation',
              style: GoogleFonts.robotoSerif(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ───────────────── UI PARTS ─────────────────

  Widget _divider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white.withOpacity(0.06),
    );
  }

  Widget _button({
    required IconData icon,
    required String label,
    required Color color,
    required bool primary,
  }) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.6)),
        boxShadow: primary
            ? [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12,
            spreadRadius: -8,
          ),
        ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.sofiaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _rankSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _divider(),
        const SizedBox(height: 18),
        Text(
          'Rank: Junior Analyst',
          style: GoogleFonts.rajdhani(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'XP: 275 / 500',
              style: GoogleFonts.rajdhani(color: Colors.white60, fontSize: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.55,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF4EEBCA),
                          Color(0xFF2EC4B6),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _divider(),
      ],
    );
  }

  Widget _bottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _ProfileNavItem(),
          _NavItem(Icons.folder_copy_outlined, 'Case History'),
          _NavItem(Icons.emoji_events_outlined, 'Leaderboard'),
          _NavItem(Icons.settings_outlined, 'Settings'),
        ],
      ),
    );
  }
}

// ───────────────── NAV ITEMS ─────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white38, size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.rajdhani(
            fontSize: 12,
            color: Colors.white38,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ProfileNavItem extends StatelessWidget {
  const _ProfileNavItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
          ),
          child: Image.network(
            'https://i.pravatar.cc/150?u=cyber',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Profile',
          style: GoogleFonts.rajdhani(
            fontSize: 12,
            color: Colors.white38,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
