// lib/theme/app_shell.dart
// ═══════════════════════════════════════════════════════════════
//  REDESIGNED APP SHELL — Dark navy · Neon accents · Glow UI
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'cyber_theme.dart';
import '../screens/evidence_collected_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/investigation_hub_screen.dart';
import '../widgets/cyber_widgets.dart';

class AppShell extends StatefulWidget {
  final Widget child;
  final bool showBack;
  final String? title;
  final int currentIndex;
  final bool showBottomNav;

  const AppShell({
    super.key,
    required this.child,
    this.showBack = true,
    this.title,
    this.showBottomNav = true,
    this.currentIndex = 0,
  });

  // Keep backward-compatible alias
  static const Color neonCyan = CyberColors.neonCyan;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(context,
          _route(const InvestigationHubScreen()));
    } else if (index == 1) {
      Navigator.push(context,
          _route(const EvidencesCollectedScreen()));
    } else if (index == 2) {
      Navigator.push(context,
          _route(const ProfileScreen()));
    }
  }

  PageRouteBuilder _route(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.bgDeep,
      extendBody: true,

      // ── Bottom Nav ──
      bottomNavigationBar: widget.showBottomNav
          ? _CyberBottomNav(
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
      )
          : null,

      body: Stack(
        children: [
          // ── Background gradient ──
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: CyberColors.backgroundGradient,
              ),
            ),
          ),

          // ── Subtle corner accent shapes ──
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CyberColors.neonCyan.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    CyberColors.neonPurple.withOpacity(0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Scanline overlay ──
          const ScanlineOverlay(),

          // ── Corner line decorations ──
          const Positioned.fill(child: _CornerDecorations()),

          // ── Main content ──
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top bar
                _TopBar(
                  title: widget.title,
                  showBack: widget.showBack,
                ),
                // Screen content
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  TOP BAR
// ──────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String? title;
  final bool showBack;

  const _TopBar({this.title, required this.showBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CyberColors.neonCyan.withOpacity(0.15),
            width: 1,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CyberColors.bgDeep.withOpacity(0.9),
            Colors.transparent,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back button
          if (showBack && Navigator.canPop(context))
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: CyberRadius.small,
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: CyberColors.neonCyan.withOpacity(0.3),
                          width: 1),
                      borderRadius: CyberRadius.small,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: CyberColors.neonCyan,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),

          // Title
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'DotMatrix',
                fontSize: 22,
                color: CyberColors.neonCyan,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: CyberColors.neonCyan,
                    blurRadius: 12,
                  ),
                ],
              ),
            ),

          // Right — subtle status dot
          Align(
            alignment: Alignment.centerRight,
            child: StatusChip(
              label: 'ONLINE',
              color: CyberColors.neonGreen,
              pulsing: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  BOTTOM NAV
// ──────────────────────────────────────────────────────────────
class _CyberBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CyberBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: CyberColors.bgCard,
        borderRadius: CyberRadius.large,
        border: Border.all(
          color: CyberColors.neonCyan.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberColors.neonCyan.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.cases_outlined,
            label: 'Cases',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.folder_outlined,
            label: 'Evidence',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? CyberColors.neonCyan.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: CyberRadius.medium,
          border: isActive
              ? Border.all(
              color: CyberColors.neonCyan.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? CyberColors.neonCyan
                  : CyberColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive
                    ? CyberColors.neonCyan
                    : CyberColors.textMuted,
                fontWeight:
                isActive ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  CORNER DECORATIONS  (very subtle cyber UI lines)
// ──────────────────────────────────────────────────────────────
class _CornerDecorations extends StatelessWidget {
  const _CornerDecorations();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CornerPainter(),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberColors.neonCyan.withOpacity(0.18)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const len = 28.0;

    // Top-left corner
    canvas.drawPath(
      Path()
        ..moveTo(16, 16 + len)
        ..lineTo(16, 16)
        ..lineTo(16 + len, 16),
      paint,
    );

    // Top-right corner
    canvas.drawPath(
      Path()
        ..moveTo(size.width - 16 - len, 16)
        ..lineTo(size.width - 16, 16)
        ..lineTo(size.width - 16, 16 + len),
      paint,
    );

    // Bottom-left corner
    canvas.drawPath(
      Path()
        ..moveTo(16, size.height - 16 - len)
        ..lineTo(16, size.height - 16)
        ..lineTo(16 + len, size.height - 16),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CornerPainter _) => false;
}