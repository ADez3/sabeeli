import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/l10n.dart';
import '../../../location/presentation/cubit/location_cubit.dart';

/// The current place, tappable to change it.
class LocationChip extends StatelessWidget {
  const LocationChip({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = context.watch<LocationCubit>().state;
    final name = state.location?.name ?? context.l10n.unknownPlace;
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      onTap: () => context.pushNamed(AppRoutes.locationName),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.location?.isManual ?? false
                  ? Icons.location_city_rounded
                  : Icons.near_me_rounded,
              size: 16,
              color: colors.primary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: colors.textMuted),
              ),
            ),
            if (state.status == LocationStatus.locating) ...[
              const SizedBox(width: AppSpacing.sm),
              const SizedBox.square(
                dimension: 12,
                child: CircularProgressIndicator(strokeWidth: 1.5),
              ),
            ],
            Icon(Icons.expand_more_rounded, size: 18, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}
