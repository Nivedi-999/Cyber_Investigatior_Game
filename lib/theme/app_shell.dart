import 'package:flutter/material.dart';
import '../screens/evidence_collected_screen.dart'; // we'll create this next
import '../screens/profile_screen.dart';
import '../screens/investigation_hub_screen.dart';

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

  // ───── THEME COLORS ─────
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color bgBlack = Colors.black;

  @override
  State<AppShell> createState() => _AppShellState();
}



class _AppShellState extends State<AppShell> {
  late int _currentIndex;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate based on index
    if (index == 0) {
      // Cases → go to case list or home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const InvestigationHubScreen()),
      );
    } else if (index == 1) {
      // Evidences Collected
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EvidencesCollectedScreen()),
      );
    } else if (index == 2) {
      // Profile
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppShell.bgBlack,
      // ───── BOTTOM NAVIGATION ─────
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.9),
        selectedItemColor: AppShell.neonCyan,
        unselectedItemColor: Colors.white70,
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cases_outlined), label: 'Cases',),
          BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Evidences'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      )
          : null,
      body: Stack(
        children: [
          // ───── BACKGROUND IMAGE ─────
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          // ───── CYBER LINE DECORATION ─────
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _CyberLinePainter(AppShell.neonCyan),
          ),
          // ───── CONTENT ─────
          SafeArea(
            child: Column(
              children: [
                // ───── TOP BAR ─────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (widget.showBack && Navigator.canPop(context))
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: AppShell.neonCyan, size: 22),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      if (widget.title != null)
                        Text(
                          widget.title!,
                          style: const TextStyle(
                            color: AppShell.neonCyan,
                            fontSize: 28,
                            fontFamily: 'DotMatrix',
                          ),
                        ),
                    ],
                  ),
                ),
                // ───── SCREEN CONTENT ─────
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CyberLinePainter extends CustomPainter {
  final Color color;
  _CyberLinePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(20, 0);
    path.lineTo(20, 40);
    path.lineTo(60, 40);
    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width, 100), paint);
    canvas.drawLine(Offset(size.width * 0.7, 0), Offset(size.width * 0.7, 50), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}