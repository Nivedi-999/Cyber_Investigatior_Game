// lib/screens/home_screen.dart
// ═══════════════════════════════════════════════════════════════
//  HOME SCREEN — Matrix rain background · 2 buttons only
// ═══════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/cyber_theme.dart';
import '../widgets/cyber_widgets.dart';
import '../screens/case_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  static const Color neonCyan = CyberColors.neonCyan;

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _rainCtrl;
  late AnimationController _entryCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    // Continuous rain — loops forever
    _rainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // Entry fade + slide for UI
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // Logo gentle pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _pulse = Tween<double>(begin: 0.93, end: 1.0)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _rainCtrl.dispose();
    _entryCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.bgDeep,
      body: Stack(
        children: [
          // ── 1. Matrix rain fills entire screen ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _rainCtrl,
              builder: (_, __) => CustomPaint(
                painter: _CyberMatrixPainter(progress: _rainCtrl.value),
              ),
            ),
          ),

          // ── 2. Radial dark overlay — centre is less dark so rain shows
          //       edges are darker for readability ──
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.1,
                  colors: [
                    CyberColors.bgDeep.withOpacity(0.50),
                    CyberColors.bgDeep.withOpacity(0.86),
                  ],
                ),
              ),
            ),
          ),

          // ── 3. Corner decoration lines ──
          const Positioned.fill(child: _CornerLines()),

          // ── 4. Main UI ──
          SafeArea(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    // Logo
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, __) => Transform.scale(
                        scale: _pulse.value,
                        child: const _LogoEmblem(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Title
                    Text(
                      'CYBER',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: CyberColors.neonCyan,
                        letterSpacing: 6,
                        shadows: [
                          Shadow(color: CyberColors.neonCyan, blurRadius: 20),
                          Shadow(color: CyberColors.neonCyan, blurRadius: 40),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'INVESTIGATOR',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(color: CyberColors.neonCyan, blurRadius: 20),
                          Shadow(color: CyberColors.neonCyan, blurRadius: 40),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // ── 2 Buttons only ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: CyberButton(
                              label: 'New Investigation',
                              fontSize: 20,
                              icon: Icons.search,
                              onTap: () => Navigator.push(
                                context,
                                _fadeRoute(const CaseListScreen()),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: CyberButton(
                              label: 'Continue Investigation',
                              fontSize: 20,
                              icon: Icons.play_arrow_outlined,
                              isOutlined: true,
                              onTap: () {
                                // TODO: navigate to saved progress
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PageRouteBuilder _fadeRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  MATRIX RAIN PAINTER — Cyan, seamless top-to-bottom columns
// ══════════════════════════════════════════════════════════════
class _CyberMatrixPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0, loops

  const _CyberMatrixPainter({required this.progress});

  static const String _chars =
      '01アカサタナハマヤ0123456789ABCDEF◈◉⬡';
  static const double _colWidth  = 20.0;
  static const double _charSize  = 14.0;
  static const double _lineHeight = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final int cols = (size.width / _colWidth).ceil();
    // Extra rows above screen so the stream looks full at all times
    final int rows = (size.height / _lineHeight).ceil() + 4;

    for (int col = 0; col < cols; col++) {
      // Stable RNG seeded by column — determines speed & character choices
      final rng = Random(col * 7919);

      // Each column scrolls at a slightly different speed (no synchrony)
      final double speed = 0.55 + rng.nextDouble() * 0.9;

      // Phase offset so columns don't all start at row 0 simultaneously
      final double phase = rng.nextDouble();

      // Current fractional row-scroll position for this column
      final double scroll = (progress * speed * rows + phase * rows) % rows;

      for (int row = 0; row < rows; row++) {
        // y coordinate: shift each row by the scroll amount, wrap around
        final double rawY = (row - scroll) * _lineHeight;
        // Wrap into [0, totalHeight + extra] seamlessly
        final double y = rawY % (rows * _lineHeight);

        if (y < -_lineHeight || y > size.height) continue;

        // Characters at the very top of the column stream are bright
        // (the "head"), the rest fade out toward the bottom.
        // We define head as the top ~3 rows of the stream.
        final bool isHead = row <= 2;
        final bool isWhiteTip = row == 0;

        double alpha;
        if (isWhiteTip) {
          alpha = 1.0;
        } else if (isHead) {
          alpha = 0.78;
        } else {
          // Fade: rows further from head are more transparent
          alpha = (1.0 - row / rows) * 0.45;
          alpha = alpha.clamp(0.04, 0.45);
        }

        final Color color = isWhiteTip
            ? Colors.white.withOpacity(alpha)
            : isHead
            ? Color.lerp(Colors.white, CyberColors.neonCyan, row / 3.0)!
            .withOpacity(alpha)
            : CyberColors.neonCyan.withOpacity(alpha);

        // Character changes slowly over time — stable flicker, not random noise
        final int charIdx =
            (col * 317 + row * 53 + (progress * 5).toInt()) %
                _chars.length;
        final String char = _chars[charIdx];

        final tp = TextPainter(
          text: TextSpan(
            text: char,
            style: TextStyle(
              fontSize: _charSize,
              color: color,
              fontWeight: isHead ? FontWeight.bold : FontWeight.normal,
              shadows: isHead
                  ? [
                Shadow(
                  color: CyberColors.neonCyan.withOpacity(0.7),
                  blurRadius: 10,
                ),
              ]
                  : null,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        tp.paint(canvas, Offset(col * _colWidth, y));
      }
    }
  }

  @override
  bool shouldRepaint(_CyberMatrixPainter old) => old.progress != progress;
}

// ══════════════════════════════════════════════════════════════
//  LOGO EMBLEM
// ══════════════════════════════════════════════════════════════
class _LogoEmblem extends StatelessWidget {
  const _LogoEmblem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 108,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CyberColors.bgDeep.withOpacity(0.6),
        border: Border.all(
          color: CyberColors.neonCyan.withOpacity(0.65),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberColors.neonCyan.withOpacity(0.45),
            blurRadius: 32,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: CyberColors.neonCyan.withOpacity(0.12),
            blurRadius: 64,
            spreadRadius: 10,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.shield_outlined,
          color: CyberColors.neonCyan,
          size: 50,
          shadows: [
            Shadow(color: CyberColors.neonCyan, blurRadius: 18),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  CORNER DECORATION LINES
// ══════════════════════════════════════════════════════════════
class _CornerLines extends StatelessWidget {
  const _CornerLines();

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _CornerPainter());
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberColors.neonCyan.withOpacity(0.45)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double len = 32;
    const double m   = 20;

    // Top-left
    canvas.drawPath(
        Path()
          ..moveTo(m, m + len)
          ..lineTo(m, m)
          ..lineTo(m + len, m),
        paint);
    // Top-right
    canvas.drawPath(
        Path()
          ..moveTo(size.width - m - len, m)
          ..lineTo(size.width - m, m)
          ..lineTo(size.width - m, m + len),
        paint);
    // Bottom-left
    canvas.drawPath(
        Path()
          ..moveTo(m, size.height - m - len)
          ..lineTo(m, size.height - m)
          ..lineTo(m + len, size.height - m),
        paint);
    // Bottom-right
    canvas.drawPath(
        Path()
          ..moveTo(size.width - m - len, size.height - m)
          ..lineTo(size.width - m, size.height - m)
          ..lineTo(size.width - m, size.height - m - len),
        paint);
  }

  @override
  bool shouldRepaint(_CornerPainter _) => false;
}