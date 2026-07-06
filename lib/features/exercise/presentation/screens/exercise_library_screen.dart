import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/utils/image_url.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/models/exercise.dart';
import '../providers/exercise_provider.dart';

/// Fixed display order of the athlete's library categories.
const _categoryOrder = [
  'push_horizontal',
  'push_vertical',
  'pull_horizontal',
  'pull_vertical',
  'lower_quad',
  'posterior',
  'arms',
  'core',
  'calves',
];

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen> {
  String _query = '';
  String? _categoryFilter; // category key, or null for all

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(l10nProvider);
    final ar = l10n.ar;
    final exercisesAsync = ref.watch(allExercisesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navLibrary)),
      body: exercisesAsync.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => Center(child: Text('${l10n.error}: $e')),
        data: (all) {
          final categories = _categoryOrder.where((c) => all.any((e) => e.category == c)).toList();

          bool matchesQuery(Exercise e) =>
              _query.isEmpty || e.name.toLowerCase().contains(_query.toLowerCase());

          final visible = all
              .where((e) =>
                  (_categoryFilter == null || e.category == _categoryFilter) && matchesQuery(e))
              .toList();

          // Build a grouped list: category header followed by its exercises.
          final children = <Widget>[];
          for (final cat in categories) {
            if (_categoryFilter != null && _categoryFilter != cat) continue;
            final items = visible.where((e) => e.category == cat).toList()
              ..sort((a, b) => a.name.compareTo(b.name));
            if (items.isEmpty) continue;
            children.add(Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
              child: Text(
                '${l10n.categoryName(cat)}  ·  ${items.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ));
            children.addAll(items.map((e) => Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                  child: _ExerciseTile(exercise: e, ar: ar, l10n: l10n),
                )));
          }

          return Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: l10n.search,
                    prefixIcon: const Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              // Category filter chips
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  children: [
                    _FilterChip(
                      label: l10n.all,
                      selected: _categoryFilter == null,
                      onTap: () => setState(() => _categoryFilter = null),
                    ),
                    for (final c in categories)
                      _FilterChip(
                        label: l10n.categoryName(c),
                        selected: _categoryFilter == c,
                        onTap: () => setState(() => _categoryFilter = c),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: children.isEmpty
                    ? Center(child: Text(l10n.pick('No results', 'لا نتائج'),
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary)))
                    : ListView(
                        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                        children: children,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.textInverse : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final bool ar;
  final L10n l10n;
  const _ExerciseTile({required this.exercise, required this.ar, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final thumb = exercise.gifUrl ?? (exercise.youtubeVideoId != null ? exercise.youtubeThumbnailUrl : null);

    return GestureDetector(
      onTap: () => context.push('/exercise/${exercise.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.textInverse),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          exercise.localizedPrimaryMuscle(ar),
                          style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFB8C7D1)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (exercise.isSubstitute) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10n.substitute,
                            style: TextStyle(color: AppColors.warning, fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 76,
                height: 76,
                child: thumb != null
                    ? Container(
                        color: Colors.white,
                        child: CachedNetworkImage(
                          imageUrl: webSafeImageUrl(thumb),
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: Colors.white),
                          errorWidget: (_, __, ___) => _placeholder(),
                        ),
                      )
                    : _placeholder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        color: Colors.white,
        child: Center(child: Icon(Icons.fitness_center, color: AppColors.textTertiary)),
      );
}
