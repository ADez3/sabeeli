import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/error/failure_text.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../../location/presentation/cubit/location_cubit.dart';

/// First-run prompt: explains why the location is needed before asking for it.
class SetLocationCard extends StatelessWidget {
  const SetLocationCard({super.key, this.expanded = false});

  /// Fills the screen (prayer tab) rather than sitting in a list (home).
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final state = context.watch<LocationCubit>().state;
    final busy = state.status == LocationStatus.locating;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const IconBadge(LucideIcons.mapPin, size: 56),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.setLocation,
          style: text.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.setLocationHint,
          textAlign: TextAlign.center,
          style: text.bodyMedium?.copyWith(
            color: colors.textMuted,
            height: 1.5,
          ),
        ),
        if (state.failure != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            failureText(l10n, state.failure!),
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: colors.danger),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: busy
                ? null
                : () => _onUseCurrent(context, state.failure),
            icon: busy
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.locateFixed),
            label: Text(
              busy ? l10n.locating : _primaryLabel(l10n, state.failure),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.pushNamed(AppRoutes.locationName),
            icon: const Icon(LucideIcons.search),
            label: Text(l10n.searchCity),
          ),
        ),
      ],
    );

    if (!expanded) {
      return AppCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: content,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(child: SingleChildScrollView(child: content)),
    );
  }

  static String _primaryLabel(AppLocalizations l10n, Failure? failure) =>
      switch (failure) {
        LocationPermissionFailure(permanently: true) ||
        LocationDisabledFailure() => l10n.openSettings,
        _ => l10n.useCurrentLocation,
      };

  static void _onUseCurrent(BuildContext context, Failure? failure) {
    final cubit = context.read<LocationCubit>();
    switch (failure) {
      case LocationPermissionFailure(permanently: true):
        cubit.openAppSettings();
      case LocationDisabledFailure():
        cubit.openLocationSettings();
      default:
        cubit.locate(context.languageCode);
    }
  }
}
