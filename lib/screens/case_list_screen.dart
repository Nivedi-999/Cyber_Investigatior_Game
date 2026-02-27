// lib/screens/case_list_screen.dart
// ═══════════════════════════════════════════════════════════════
//  REDESIGNED CASE LIST SCREEN
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../theme/app_shell.dart';
import '../theme/cyber_theme.dart';
import '../widgets/cyber_widgets.dart';
import 'case_story_screen.dart';

class CaseListScreen extends StatelessWidget {
  const CaseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Case Files',
      showBack: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CyberSectionHeader(
              title: 'Available Cases',
              subtitle: 'Select a case to begin investigation',
            ),

            _CaseCard(
              title: 'Operation GhostTrace',
              difficulty: 'Medium',
              theme: 'Insider Data Leak',
              status: 'Available',
              statusColor: CyberColors.neonGreen,
              isAvailable: true,
              onTap: (ctx) => Navigator.push(
                ctx,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const StorylineScreen(),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 350),
                ),
              ),
            ),

            _CaseCard(
              title: 'Phantom Transaction',
              difficulty: 'Easy',
              theme: 'Unauthorized Bank Transfer',
              status: 'Coming Soon',
              statusColor: CyberColors.textMuted,
              isAvailable: false,
            ),

            _CaseCard(
              title: 'Silent Attendance Hack',
              difficulty: 'Easy–Medium',
              theme: 'College Attendance Manipulation',
              status: 'Locked',
              statusColor: CyberColors.textMuted,
              isAvailable: false,
            ),

            _CaseCard(
              title: 'Dark Proxy Attack',
              difficulty: 'Hard',
              theme: 'Masked DDoS via Proxies',
              status: 'Locked',
              statusColor: CyberColors.textMuted,
              isAvailable: false,
            ),

            _CaseCard(
              title: 'The Vanishing Vault',
              difficulty: 'Insane',
              theme: 'Encrypted File Destruction',
              status: 'Locked',
              statusColor: CyberColors.textMuted,
              isAvailable: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _CaseCard extends StatefulWidget {
  final String title;
  final String difficulty;
  final String theme;
  final String status;
  final Color statusColor;
  final bool isAvailable;
  final void Function(BuildContext ctx)? onTap;

  const _CaseCard({
    required this.title,
    required this.difficulty,
    required this.theme,
    required this.status,
    required this.statusColor,
    required this.isAvailable,
    this.onTap,
  });

  @override
  State<_CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<_CaseCard> {
  bool _expanded = false;

  Color get _diffColor {
    switch (widget.difficulty.toLowerCase()) {
      case 'easy':         return CyberColors.neonGreen;
      case 'medium':
      case 'easy–medium':  return CyberColors.neonAmber;
      case 'hard':         return CyberColors.neonRed;
      case 'insane':       return CyberColors.neonPurple;
      default:             return CyberColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isAvailable
        ? CyberColors.neonCyan
        : CyberColors.borderSubtle;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: NeonContainer(
        borderColor: borderColor,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            // ── Header row ──
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: CyberRadius.medium,
                onTap: widget.isAvailable
                    ? () => widget.onTap?.call(context)
                    : () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      // Case icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: borderColor.withOpacity(0.1),
                          borderRadius: CyberRadius.small,
                          border: Border.all(
                              color: borderColor.withOpacity(0.4), width: 1),
                        ),
                        child: Icon(
                          widget.isAvailable
                              ? Icons.folder_open_outlined
                              : Icons.lock_outline,
                          color: borderColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Title + theme
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontFamily: 'DotMatrix',
                                fontSize: 15,
                                color: widget.isAvailable
                                    ? CyberColors.neonCyan
                                    : CyberColors.textMuted,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(widget.theme,
                                style: CyberText.bodySmall.copyWith(
                                    fontSize: 12)),
                          ],
                        ),
                      ),

                      // Status + expand
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          StatusChip(
                            label: widget.status,
                            color: widget.statusColor,
                            pulsing: widget.isAvailable,
                          ),
                          const SizedBox(height: 6),
                          Icon(
                            _expanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: CyberColors.textMuted,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Expanded info ──
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: _expanded
                  ? Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: borderColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text('Difficulty:  ',
                            style: TextStyle(
                                color: CyberColors.textSecondary,
                                fontSize: 13)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _diffColor.withOpacity(0.12),
                            borderRadius: CyberRadius.pill,
                            border: Border.all(
                                color: _diffColor.withOpacity(0.4),
                                width: 1),
                          ),
                          child: Text(
                            widget.difficulty,
                            style: TextStyle(
                              color: _diffColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Theme: ${widget.theme}',
                        style: CyberText.bodySmall.copyWith(
                            fontSize: 12)),
                    if (widget.isAvailable) ...[
                      const SizedBox(height: 14),
                      CyberButton(
                        label: 'Begin Investigation',
                        icon: Icons.play_arrow_outlined,
                        isSmall: true,
                        onTap: () => widget.onTap?.call(context),
                      ),
                    ],
                  ],
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}