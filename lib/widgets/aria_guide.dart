// lib/widgets/aria_guide.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/tutorial_service.dart';
import '../theme/app_shell.dart';

class AriaGuide extends StatefulWidget {
  final TutorialStep step;
  final VoidCallback? onDismiss;

  const AriaGuide({
    super.key,
    required this.step,
    this.onDismiss,
  });

  @override
  State<AriaGuide> createState() => _AriaGuideState();
}

class _AriaGuideState extends State<AriaGuide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  String _displayedText = '';
  int _charIndex = 0;
  Timer? _typeTimer;
  bool _typingDone = false;
  String _fullText = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    final msg = TutorialService().getMessageForStep(widget.step);
    _fullText = msg?.text ?? '';

    _controller.forward();
    _startTyping();
  }

  void _startTyping() {
    _charIndex = 0;
    _displayedText = '';
    _typingDone = false;

    _typeTimer = Timer.periodic(const Duration(milliseconds: 28), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
        setState(() => _typingDone = true);
      }
    });
  }

  void _skipTyping() {
    _typeTimer?.cancel();
    setState(() {
      _displayedText = _fullText;
      _typingDone = true;
    });
  }

  void _dismiss() {
    _typeTimer?.cancel();
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_fullText.isEmpty) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: GestureDetector(
          onTap: _typingDone ? null : _skipTyping,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ── ARIA Avatar ──
                _AriaAvatar(),
                const SizedBox(width: 10),

                // ── Speech bubble ──
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.88),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(4),
                      ),
                      border: Border.all(
                        color: AppShell.neonCyan.withOpacity(0.7),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppShell.neonCyan.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ARIA label
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppShell.neonCyan,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'ARIA',
                              style: TextStyle(
                                color: AppShell.neonCyan,
                                fontSize: 11,
                                fontFamily: 'DotMatrix',
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Blinking cursor while typing
                            if (!_typingDone)
                              _BlinkingCursor(),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Typewriter message text
                        Text(
                          _displayedText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            height: 1.55,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Dismiss button (only shown when typing done)
                        if (_typingDone)
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _dismiss,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppShell.neonCyan.withOpacity(0.6)),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Understood  ›',
                                  style: TextStyle(
                                    color: AppShell.neonCyan,
                                    fontSize: 12,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
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

// ──────────────────────────────────────────
// ARIA Avatar — animated glowing hex icon
// ──────────────────────────────────────────
class _AriaAvatar extends StatefulWidget {
  @override
  State<_AriaAvatar> createState() => _AriaAvatarState();
}

class _AriaAvatarState extends State<_AriaAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, _) {
        return Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
            border: Border.all(
              color: AppShell.neonCyan.withOpacity(_pulseAnim.value),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppShell.neonCyan.withOpacity(_pulseAnim.value * 0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'AI',
              style: TextStyle(
                color: AppShell.neonCyan.withOpacity(_pulseAnim.value),
                fontSize: 13,
                fontFamily: 'DotMatrix',
                letterSpacing: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────
// Blinking cursor animation
// ──────────────────────────────────────────
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 6,
        height: 10,
        color: AppShell.neonCyan,
      ),
    );
  }
}

// ──────────────────────────────────────────
// Wrapper that manages showing ARIA contextually
// ──────────────────────────────────────────
class AriaOverlay extends StatefulWidget {
  final Widget child;
  final TutorialStep triggerStep;

  const AriaOverlay({
    super.key,
    required this.child,
    required this.triggerStep,
  });

  @override
  State<AriaOverlay> createState() => _AriaOverlayState();
}

class _AriaOverlayState extends State<AriaOverlay> {
  bool _showAria = false;
  late TutorialStep _activeStep;

  @override
  void initState() {
    super.initState();
    _activeStep = widget.triggerStep;

    final service = TutorialService();
    if (service.isActive &&
        service.currentStep == widget.triggerStep &&
        !service.messageShown) {
      // Small delay so screen renders first
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _showAria = true);
          service.setMessageShown(true);
        }
      });
    }
  }

  void _onDismiss() {
    setState(() => _showAria = false);

    // After welcome, auto-advance to exploreFeeds step
    final service = TutorialService();
    if (_activeStep == TutorialStep.welcomeToHub) {
      service.advance(TutorialStep.exploreFeeds);
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _activeStep = TutorialStep.exploreFeeds;
            _showAria = true;
          });
          service.setMessageShown(true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showAria && TutorialService().isActive)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: AriaGuide(
              step: _activeStep,
              onDismiss: _onDismiss,
            ),
          ),
      ],
    );
  }
}