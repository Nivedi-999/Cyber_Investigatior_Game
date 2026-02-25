// lib/widgets/aria_controller.dart
import 'package:flutter/material.dart';
import '../services/tutorial_service.dart';
import 'aria_guide.dart';

/// Use this mixin on any StatefulWidget screen to easily show ARIA messages.
///
/// Usage:
///   class _MyScreenState extends State<MyScreen> with AriaMixin {
///     @override
///     void initState() {
///       super.initState();
///       triggerAria(TutorialStep.someStep);
///     }
///   }
mixin AriaMixin<T extends StatefulWidget> on State<T> {
  bool _ariaVisible = false;
  TutorialStep _ariaStep = TutorialStep.none;

  bool get ariaVisible => _ariaVisible;
  TutorialStep get ariaStep => _ariaStep;

  void triggerAria(TutorialStep step, {int delayMs = 600}) {
    final service = TutorialService();
    if (!service.isActive) return;
    if (service.currentStep != step) return;
    if (service.messageShown) return;

    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) {
        setState(() {
          _ariaStep = step;
          _ariaVisible = true;
        });
        service.setMessageShown(true);
      }
    });
  }

  void dismissAria() {
    if (mounted) {
      setState(() => _ariaVisible = false);
    }
  }

  /// Call this inside your Stack to place ARIA at the bottom
  Widget buildAriaLayer({VoidCallback? onDismiss}) {
    if (!_ariaVisible || _ariaStep == TutorialStep.none) {
      return const SizedBox.shrink();
    }
    return Positioned(
      bottom: 80, // above bottom nav bar
      left: 0,
      right: 0,
      child: AriaGuide(
        step: _ariaStep,
        onDismiss: () {
          dismissAria();
          onDismiss?.call();
        },
      ),
    );
  }
}