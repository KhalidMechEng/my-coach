import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class PRBadge extends StatelessWidget {
  final String label;
  final bool large;

  const PRBadge({super.key, this.label = 'PR', this.large = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.prGold, AppColors.prGoldDark],
        ),
        borderRadius: BorderRadius.circular(large ? 10 : 6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: large ? 13 : 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    )
        .animate()
        .scale(begin: const Offset(0.5, 0.5), duration: 300.ms, curve: Curves.elasticOut)
        .fadeIn(duration: 200.ms);
  }
}

class PRCelebrationOverlay extends StatelessWidget {
  final List<String> exerciseNames;
  final VoidCallback onDismiss;

  const PRCelebrationOverlay({
    super.key,
    required this.exerciseNames,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        color: AppColors.overlay,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.prGold, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                Text(
                  'New Personal Record!',
                  style: TextStyle(
                    color: AppColors.prGold,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                ...exerciseNames.map((name) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                Text(
                  'Tap to continue',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.8, 0.8), duration: 400.ms, curve: Curves.elasticOut),
      ),
    );
  }
}
