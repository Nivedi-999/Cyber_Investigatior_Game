// lib/screens/investigation_hub_screen.dart
// ═══════════════════════════════════════════════════════════════
//  REDESIGNED INVESTIGATION HUB
// ═══════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../theme/app_shell.dart';
import '../theme/cyber_theme.dart';
import '../widgets/cyber_widgets.dart';
import '../case_data/ghosttrace_case_data.dart';
import 'evidence_analysis_screen.dart';
import 'suspect_profile_screen.dart';
import '../services/tutorial_service.dart';
import '../widgets/aria_guide.dart';
import '../widgets/aria_controller.dart';
import '../services/evidence_collector.dart';

class InvestigationHubScreen extends StatefulWidget {
  const InvestigationHubScreen({super.key});

  @override
  State<InvestigationHubScreen> createState() => _InvestigationHubScreenState();
}

class _InvestigationHubScreenState extends State<InvestigationHubScreen>
    with AriaMixin, TickerProviderStateMixin {
  String _activeFeed = 'chat';
  late AnimationController _entryCtrl;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    TutorialService().onHubOpened();
    triggerAria(TutorialStep.welcomeToHub);

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  void _onAriaWelcomeDismissed() {
    final service = TutorialService();
    service.advance(TutorialStep.exploreFeeds);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) triggerAria(TutorialStep.exploreFeeds, delayMs: 0);
    });
  }

  void _openAnalysis(String category, String selectedItem) {
    TutorialService().onFeedTapped();
    Navigator.push(
      context,
      _slideRoute(EvidenceAnalysisScreen(
        evidenceType: category,
        selectedItem: selectedItem,
      )),
    ).then((_) {
      final service = TutorialService();
      final count = EvidenceCollector().collected.length;
      service.onReadyForDecryption();
      service.onReadyToFlag(count);
      setState(() {});
      if (service.currentStep == TutorialStep.markEvidence && !service.messageShown) {
        triggerAria(TutorialStep.markEvidence, delayMs: 300);
      } else if (service.currentStep == TutorialStep.decryptionHint && !service.messageShown) {
        triggerAria(TutorialStep.decryptionHint, delayMs: 300);
      } else if (service.currentStep == TutorialStep.flagSuspect && !service.messageShown) {
        triggerAria(TutorialStep.flagSuspect, delayMs: 300);
      }
    });
  }

  PageRouteBuilder _slideRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  @override
  Widget build(BuildContext context) {
    final caseData = ghostTraceCase;

    return AppShell(
      title: 'Investigation Hub',
      showBack: true,
      child: Stack(
        children: [
          FadeTransition(
            opacity: _fadeIn,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Case Header ──
                  _CaseHeader(caseData: caseData),
                  const SizedBox(height: 24),

                  // ── Feed Tabs ──
                  const CyberSectionHeader(
                    title: 'Evidence Feed',
                    subtitle: 'Tap a category to explore',
                  ),
                  _FeedTabBar(
                    activeFeed: _activeFeed,
                    onTabChanged: (key) {
                      setState(() => _activeFeed = key);
                      if (key != 'suspects') TutorialService().onFeedTapped();
                    },
                  ),
                  const SizedBox(height: 14),

                  // ── Evidence Viewer ──
                  NeonContainer(
                    padding: const EdgeInsets.all(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 80, maxHeight: 260),
                      child: SingleChildScrollView(
                        child: _buildEvidenceContent(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Timeline ──
                  const CyberSectionHeader(
                    title: 'Event Timeline',
                    subtitle: 'Chronological breach activity',
                  ),
                  NeonContainer(
                    borderColor: CyberColors.neonPurple,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                    child: Column(
                      children: caseData.timeline.asMap().entries.map((entry) {
                        final i = entry.key;
                        final event = entry.value;
                        return TimelineItem(
                          time: event.time,
                          title: event.title,
                          description: event.description,
                          isLast: i == caseData.timeline.length - 1,
                          accentColor: i == 0
                              ? CyberColors.neonRed
                              : CyberColors.neonPurple,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── ARIA Guide ──
          buildAriaLayer(
            onDismiss: () {
              if (ariaStep == TutorialStep.welcomeToHub) {
                _onAriaWelcomeDismissed();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceContent() {
    switch (_activeFeed) {
      case 'chat':
        return Column(
          children: [
            LogRow(
              left: 'Admin',
              right: 'Patch deployed successfully.',
              onTap: () => _openAnalysis('chat', 'Patch deployed successfully.'),
            ),
            LogRow(
              left: 'Ghost',
              right: 'I noticed.',
              onTap: () => _openAnalysis('chat', 'I noticed.'),
            ),
            LogRow(
              left: 'Ghost',
              right: 'Check your finance account.',
              onTap: () => _openAnalysis('chat', 'Check your finance workstation.'),
              highlighted: true,
            ),
          ],
        );

      case 'files':
        return Column(
          children: [
            LogRow(left: 'finance_report_q3.pdf', right: '12 MB',
                onTap: () => _openAnalysis('files', 'finance_report_q3.pdf'),
                highlighted: true),
            LogRow(left: 'system_patch.exe', right: '4.2 MB',
                onTap: () => _openAnalysis('files', 'system_patch.exe')),
            LogRow(left: 'debug_log.txt', right: '1.1 MB',
                onTap: () => _openAnalysis('files', 'debug_log.txt'),
                highlighted: true),
            LogRow(left: 'cache_dump.bin', right: '88 MB',
                onTap: () => _openAnalysis('files', 'cache_dump.bin')),
            if (GameProgress.isBriefingUnlocked)
              LogRow(
                left: 'credentials.pdf',
                right: 'UNLOCKED',
                onTap: () => _openAnalysis('files', 'credentials.pdf'),
                highlighted: true,
              ),
          ],
        );

      case 'meta':
        return Column(
          children: [
            LogRow(left: 'Device', right: 'FIN-WS-114',
                onTap: () => _openAnalysis('meta', 'Device')),
            LogRow(left: 'OS', right: 'Windows 11 Pro',
                onTap: () => _openAnalysis('meta', 'OS')),
            LogRow(
              left: 'Last User',
              right: 'Ankita E @ 09:15 AM',
              onTap: () => _openAnalysis('meta', 'Last User'),
              highlighted: true,
            ),
          ],
        );

      case 'ip':
        return Column(
          children: [
            LogRow(
              left: 'Internal Origin',
              right: '172.16.44.21',
              onTap: () => _openAnalysis('ip', 'Internal Origin'),
              highlighted: true,
            ),
            LogRow(
              left: 'External Hop',
              right: '202.56.23.101',
              onTap: () => _openAnalysis('ip', 'External Hop'),
              highlighted: true,
            ),
          ],
        );

      case 'suspects':
        return Column(
          children: ghostTraceCase.suspects.map((suspect) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SuspectCard(
                name: suspect.name,
                role: 'Employee',
                riskLevel: suspect.riskLevel,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SuspectProfileScreen(suspect: suspect),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );

      default:
        return const SizedBox();
    }
  }
}

// ── Case Header ──
class _CaseHeader extends StatelessWidget {
  final CaseData caseData;
  const _CaseHeader({required this.caseData});

  @override
  Widget build(BuildContext context) {
    return NeonContainer(
      borderColor: CyberColors.neonCyan,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Case ID badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: CyberColors.neonCyan.withOpacity(0.1),
              borderRadius: CyberRadius.small,
              border: Border.all(
                  color: CyberColors.neonCyan.withOpacity(0.4), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#${caseData.caseId}',
                  style: const TextStyle(
                    fontFamily: 'DotMatrix',
                    fontSize: 13,
                    color: CyberColors.neonCyan,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Operation GhostTrace',
                  style: TextStyle(
                    fontFamily: 'DotMatrix',
                    fontSize: 15,
                    color: CyberColors.neonCyan,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Insider Database Breach',
                  style: CyberText.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusChip(
                label: caseData.status,
                color: CyberColors.neonGreen,
                pulsing: true,
              ),
              const SizedBox(height: 6),
              Text(
                caseData.duration,
                style: CyberText.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Feed Tab Bar ──
class _FeedTabBar extends StatelessWidget {
  final String activeFeed;
  final ValueChanged<String> onTabChanged;

  const _FeedTabBar({
    required this.activeFeed,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ('chat', 'Chat'),
      ('files', 'Files'),
      ('meta', 'Meta'),
      ('ip', 'IP'),
      ('suspects', 'Suspects'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FeedTabButton(
              label: tab.$2,
              isActive: activeFeed == tab.$1,
              onTap: () => onTabChanged(tab.$1),
            ),
          );
        }).toList(),
      ),
    );
  }
}