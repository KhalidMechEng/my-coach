import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/image_url.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../providers/exercise_provider.dart';

class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;
  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseProvider(exerciseId));
    final l10n = ref.watch(l10nProvider);
    final ar = l10n.ar;

    return exerciseAsync.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('${l10n.error}: $e')),
      ),
      data: (exercise) {
        if (exercise == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.exerciseNotFound)),
          );
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(exercise.localizedName(ar),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (exercise.gifUrl != null)
                        CachedNetworkImage(
                          imageUrl: webSafeImageUrl(exercise.gifUrl!),
                          fit: BoxFit.contain,
                          placeholder: (_, __) => Container(color: AppColors.surface),
                          errorWidget: (_, __, ___) => _VideoThumbnail(exercise: exercise),
                        )
                      else if (exercise.youtubeVideoId != null)
                        _VideoThumbnail(exercise: exercise)
                      else
                        Container(
                          color: AppColors.surface,
                          child: Center(
                            child: Text(
                              exercise.localizedPrimaryMuscle(ar).toUpperCase(),
                              style: TextStyle(color: AppColors.textTertiary, fontSize: 11, letterSpacing: 2),
                            ),
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, AppColors.background],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Muscle group chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _MuscleChip(label: exercise.localizedPrimaryMuscle(ar), isPrimary: true),
                          ...exercise.localizedSecondaryMuscles(ar).map((m) => _MuscleChip(label: m, isPrimary: false)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Equipment
                      if (exercise.localizedEquipment(ar).isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(Icons.fitness_center, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Expanded(child: Text(exercise.localizedEquipment(ar).join('، '), style: AppTextStyles.bodySmall)),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],

                      // Watch video button
                      if (exercise.youtubeVideoId != null) ...[
                        _WatchButton(videoId: exercise.youtubeVideoId!, label: l10n.watchOnYoutube),
                        const SizedBox(height: AppSpacing.xxl),
                      ],

                      // Instructions
                      if (exercise.localizedInstructions(ar).isNotEmpty) ...[
                        Text(l10n.howToPerform, style: AppTextStyles.headlineMedium),
                        const SizedBox(height: AppSpacing.md),
                        ...exercise.localizedInstructions(ar).asMap().entries.map((entry) =>
                          _InstructionStep(number: entry.key + 1, text: entry.value),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],

                      // Breathing
                      if (exercise.localizedBreathing(ar).isNotEmpty) ...[
                        _InfoCard(
                          icon: Icons.air,
                          title: l10n.breathing,
                          content: exercise.localizedBreathing(ar),
                          color: const Color(0xFF3B82F6),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Safety
                      if (exercise.localizedSafety(ar).isNotEmpty) ...[
                        _InfoCard(
                          icon: Icons.shield_outlined,
                          title: l10n.safetyNote,
                          content: exercise.localizedSafety(ar),
                          color: AppColors.warning,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      // Common mistakes
                      if (exercise.localizedMistakes(ar).isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(l10n.commonMistakes, style: AppTextStyles.headlineMedium),
                        const SizedBox(height: AppSpacing.md),
                        ...exercise.localizedMistakes(ar).map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.close, color: AppColors.error, size: 18),
                              const SizedBox(width: 8),
                              Expanded(child: Text(m, style: AppTextStyles.bodyMedium)),
                            ],
                          ),
                        )),
                      ],

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MuscleChip extends StatelessWidget {
  final String label;
  final bool isPrimary;
  const _MuscleChip({required this.label, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.primaryContainer : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.replaceAll('_', ' '),
        style: TextStyle(
          color: isPrimary ? AppColors.primary : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _InstructionStep extends StatelessWidget {
  final int number;
  final String text;
  const _InstructionStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color color;
  const _InfoCard({required this.icon, required this.title, required this.content, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 4),
                Text(content, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final dynamic exercise;
  const _VideoThumbnail({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final thumbUrl = exercise.youtubeVideoId != null
        ? 'https://img.youtube.com/vi/${exercise.youtubeVideoId}/hqdefault.jpg'
        : null;
    return thumbUrl != null
        ? CachedNetworkImage(
            imageUrl: webSafeImageUrl(thumbUrl),
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: AppColors.surface),
            errorWidget: (_, __, ___) => Container(color: AppColors.surface),
          )
        : Container(color: AppColors.surface);
  }
}

class _WatchButton extends StatelessWidget {
  final String videoId;
  final String label;
  const _WatchButton({required this.videoId, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
        if (await canLaunchUrl(url)) launchUrl(url, mode: LaunchMode.externalApplication);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000).withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          border: Border.all(color: const Color(0xFFFF0000).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_fill, color: Color(0xFFFF0000), size: 24),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Color(0xFFFF0000), fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
