import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/failure_text.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/saved_location.dart';
import '../../domain/usecases/location_usecases.dart';
import '../cubit/location_cubit.dart';

/// Use the GPS, or search for a city (for travellers planning ahead, or anyone who
/// prefers not to share their position).
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _search = getIt<SearchPlacesUseCase>();
  final _controller = TextEditingController();
  Timer? _debounce;
  List<SavedLocation> _results = const [];
  bool _searching = false;
  String? _error;

  void _onQuery(String query) {
    _debounce?.cancel();
    if (query.trim().length < 2) {
      setState(() => _results = const []);
      return;
    }
    // Nominatim allows one request a second; typing is debounced well past that.
    _debounce = Timer(
      const Duration(milliseconds: 700),
      () => _run(query.trim()),
    );
  }

  Future<void> _run(String query) async {
    setState(() {
      _searching = true;
      _error = null;
    });
    final result = await _search(
      SearchPlacesParams(query: query, language: context.languageCode),
    );
    if (!mounted) return;
    setState(() {
      _searching = false;
      result.fold(
        (failure) => _error = failureText(context.l10n, failure),
        (places) => _results = places,
      );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = context.watch<LocationCubit>().state;
    final busy = state.status == LocationStatus.locating;

    return BlocListener<LocationCubit, LocationState>(
      listenWhen: (a, b) =>
          a.status == LocationStatus.locating &&
          b.status == LocationStatus.ready,
      listener: (context, _) => context.pop(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.location)),
        body: ContentWidth(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              AppCard(
                onTap: busy
                    ? null
                    : () => context.read<LocationCubit>().locate(
                        context.languageCode,
                      ),
                child: Row(
                  children: [
                    const IconBadge(LucideIcons.locateFixed),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            busy ? l10n.locating : l10n.useCurrentLocation,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (state.failure != null)
                            Text(
                              failureText(l10n, state.failure!),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colors.danger),
                            ),
                        ],
                      ),
                    ),
                    if (busy)
                      const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _controller,
                onChanged: _onQuery,
                textInputAction: TextInputAction.search,
                onSubmitted: (q) =>
                    q.trim().length >= 2 ? _run(q.trim()) : null,
                decoration: InputDecoration(
                  hintText: l10n.searchCityHint,
                  prefixIcon: const Icon(LucideIcons.search),
                  suffixIcon: _searching
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(color: colors.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    borderSide: BorderSide(color: colors.outline),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(_error!, style: TextStyle(color: colors.danger)),
                )
              else if (!_searching &&
                  _controller.text.trim().length >= 2 &&
                  _results.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    l10n.noResults,
                    style: TextStyle(color: colors.textMuted),
                  ),
                ),
              for (final place in _results)
                ListTile(
                  leading: const Icon(LucideIcons.building2),
                  title: Text(place.name ?? ''),
                  onTap: () {
                    context.read<LocationCubit>().choose(place);
                    context.pop();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
