// lib/screens/evidence_analysis_screen.dart
import 'package:flutter/material.dart';
import '../theme/app_shell.dart';
import 'mini_game.dart'; // your decryption screen

class EvidenceAnalysisScreen extends StatelessWidget {
  final String evidenceType;
  final String? selectedItem;

  const EvidenceAnalysisScreen({
    super.key,
    required this.evidenceType,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Evidence Analysis',
      showBack: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Case #2047 • Operation GhostTrace',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
            const SizedBox(height: 24),
            Text(
              _getCategoryTitle(evidenceType),
              style: const TextStyle(
                fontFamily: 'DotMatrix',
                fontSize: 26,
                color: AppShell.neonCyan,
              ),
            ),
            const SizedBox(height: 16),
            if (selectedItem != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppShell.neonCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppShell.neonCyan.withOpacity(0.5)),
                ),
                child: Text(
                  'Selected: $selectedItem',
                  style: const TextStyle(
                    color: AppShell.neonCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _panel(
              child: SizedBox(
                height: 480,
                child: SingleChildScrollView(child: _buildContent(evidenceType, selectedItem)),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_open, color: Colors.black),
                label: const Text('Unlock Hidden Clue', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppShell.neonCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DecryptionMiniGameScreen()),
                  );
                },
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  String _getCategoryTitle(String type) {
    switch (type) {
      case 'chat': return 'Chat Logs';
      case 'files': return 'Files';
      case 'meta': return 'Metadata Extract';
      case 'ip': return 'IP Traces';
      default: return 'Evidence';
    }
  }

  Widget _buildContent(String type, String? selected) {
    // File-specific detailed views
    if (type == 'files') {
      if (selected == 'finance_report_q3.pdf') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Finance Report [Q3]', style: TextStyle(color: AppShell.neonCyan, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Q3 Financial Summary – Internal Use Only', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Quarter 3 Revenue Overview', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const Text('Total Revenue: ₹48.6 Crore'),
            const Text('Operating Costs: ₹31.2 Crore'),
            const Text('Net Profit: ₹17.4 Crore'),
            const SizedBox(height: 24),
            const Text('Anomalies Detected:', style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('• ₹2.3 Crore transferred to offshore account: ACC-4482-X'),
            const Text('• Unscheduled vendor payment: "Northstar Solutions"'),
            const Text('• Duplicate reimbursement entries on 14th August'),
            const SizedBox(height: 20),
            const Text('Notes from CFO:', style: TextStyle(color: Colors.orangeAccent, fontSize: 15)),
            const Text(
              '"These discrepancies were flagged by internal audit. Do not disclose externally until forensic review is complete."',
              style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
            ),
          ],
        );
      }

      if (selected == 'debug_log.txt') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Debug Log Excerpt', style: TextStyle(color: AppShell.neonCyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('[2026-02-02 01:14:22] PatchService: Starting update sequence...', style: TextStyle(color: Colors.white70)),
            const Text('[2026-02-02 01:14:24] PatchService: Verified signature (status: OK)', style: TextStyle(color: Colors.white70)),
            const Text('[2026-02-02 01:14:31] Network: Outbound connection established to 185.193.127.44', style: TextStyle(color: Colors.orangeAccent)),
            const Text('[2026-02-02 01:14:32] Warning: Unexpected privilege escalation detected', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            const Text('[2026-02-02 01:14:35] Error: Hash mismatch in module agent.dll', style: TextStyle(color: Colors.redAccent)),
            const Text('[2026-02-02 01:14:36] PatchService: Process terminated unexpectedly', style: TextStyle(color: Colors.white70)),
            const Text('[2026-02-02 01:14:40] SecurityAgent: No threat detected', style: TextStyle(color: Colors.white70)),
          ],
        );
      }

      if (type == 'files' && selected == 'ghosttrace_briefing.pdf') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Internal Briefing – GhostTrace Operation',
              style: TextStyle(
                color: AppShell.neonCyan,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Classification: Restricted – Analyst Eyes Only',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const Text(
              'Summary:',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Text(
              '• The data leak originated from workstation FIN-WS-114 between 10:43–10:45 AM.',
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              '• Only 4 personnel had physical + credential access during that window:',
              style: TextStyle(color: Colors.white70),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('– Dhruv A (Sysadmin – High privilege)'),
                  Text('– Ankita E (Finance Lead – Full access)'),
                  Text('– Manav R (Analyst – Read/Write)'),
                  Text('– Ayon K (Intern – Read-only)'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Key Finding:',
              style: TextStyle(color: Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'The external IP (202.56.23.101) resolves to a public WiFi hotspot 800m from the office.',
              style: TextStyle(color: Colors.white70),
            ),
            const Text(
              'No legitimate TOR / foreign proxy chain exists – the Romania/Iceland hops were retroactively injected.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            const Text(
              'Recommendation:',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            const Text(
              'Focus investigation on personnel present at FIN-WS-114 between 09:00–11:00 AM.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              'Suspect with both motive (financial anomalies in Q3 report) and opportunity is likely internal.',
              style: TextStyle(color: Colors.orangeAccent),
            ),
          ],
        );
      }

      // Add more files as needed...
      return const Text(
        'File content preview not available yet...\n\nTap "Unlock Hidden Clue" for deeper analysis.',
        style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
      );
    }

    // Full category content (when no item selected)
      if (type == 'chat') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _LogLine('Admin', 'Patch deployed successfully.'),
            _LogLine('Ghost', 'I noticed.'),
            _LogLine('Admin', 'You shouldn’t be here.'),
            _LogLine('Ghost', 'You left a door open.'),
            _LogLine('Admin', 'Who are you?'),
            _LogLine('Ghost', 'Just a shadow.'),
            _LogLine('Ghost', 'Check your finance workstation.'),
            _LogLine('Ankita E', 'Can you send me the Q3 forecast \n again?'),
            _LogLine('Admin', 'Sent to your internal mail.'),
            _LogLine('Ghost', 'For the next phase, transfer \n to offshore account.'),
          ],
        );
      }

      if (type == 'meta') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _LogLine('Device', 'FIN-WS-114'),
            _LogLine('OS', 'Windows 11 Pro'),
            _LogLine('Hash', 'd41d8cd98f00b204e9800998ecf8427e'),
            _LogLine('Timestamp', '02:14 AM'),
            _LogLine('Session', 'Signed Update Package'),
            _LogLine('Last User', 'Ankita E @ 09:15 AM'),
          ],
        );
      }

      if (type == 'ip') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _LogLine('Origin', '172.16.44.21'),
            _LogLine('VPN Hop', '185.193.127.44'),
            _LogLine('Proxy', 'TOR Exit Node'),
            _LogLine('Geo', 'Romania → Iceland'),
            _LogLine('ISP Mask', 'Yes'),
          ],
        );
      }


    // Fallback for specific selections without special handling
    return const Text(
      'Detailed content not available for this selection.\nUse "Unlock Hidden Clue" for deeper insights.',
      style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
    );
  }

  Widget _panel({required Widget child}) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(border: Border.all(color: AppShell.neonCyan, width: 2)),
    child: child,
  );
}

class _LogLine extends StatelessWidget {
  final String left;
  final String right;

  const _LogLine(this.left, this.right);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(left, style: const TextStyle(color: Colors.white)),
          Text(right, style: TextStyle(color: AppShell.neonCyan.withOpacity(0.8))),
        ],
      ),
    );
  }
}