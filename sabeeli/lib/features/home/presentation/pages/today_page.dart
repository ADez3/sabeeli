import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/grain.dart';
import '../../../azkar/presentation/cubit/azkar_cubit.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../widgets/living_sky/living_sky.dart';
import '../widgets/today/today_bento.dart';
import '../widgets/today/today_hero.dart';

/// Today: the living sky above the user with the next prayer written across
/// it, and below the horizon the live tiles of the day. The sky drifts slower
/// than the page as it scrolls; tapping the countdown dives into the day.
class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();

  /// 0 at rest, 1 when the dive into the day completes.
  late final AnimationController _dive = AnimationController(
    vsync: this,
    duration: Motion.page,
  );

  /// Where the sky is drawn from before the user has set a location.
  static const _defaultSky = Coordinates(latitude: 21.4225, longitude: 39.8262);

  @override
  void initState() {
    super.initState();
    context.read<QuranCubit>().load();
    context.read<AzkarCubit>().load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _dive.dispose();
    super.dispose();
  }

  Future<void> _diveIn() async {
    HapticFeedback.mediumImpact();
    final reduced = Motion.reduced(context);
    if (_scroll.hasClients && _scroll.offset > 0) {
      await _scroll.animateTo(
        0,
        duration: Motion.component,
        curve: Motion.enter,
      );
    }
    if (!reduced) {
      await _dive.animateTo(1, curve: Curves.easeInCubic);
    }
    if (!mounted) return;
    await context.pushNamed(
      AppRoutes.prayerName,
      // A fresh value each time lets the day replay its arrival.
      queryParameters: {'dive': '${DateTime.now().millisecondsSinceEpoch}'},
    );
    if (mounted) {
      _dive.animateBack(0, duration: Motion.page, curve: Motion.enter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final location = context.select((LocationCubit c) => c.state.location);
    final where = location?.coordinates ?? _defaultSky;
    final size = MediaQuery.sizeOf(context);
    final heroHeight = math.max(size.height * 0.82, 560.0);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: AnimatedBuilder(
        animation: Listenable.merge([_scroll, _dive]),
        builder: (context, _) {
          final offset = _scroll.hasClients ? _scroll.offset : 0.0;
          final v = Curves.easeIn.transform(_dive.value);
          // Light status bar icons over the sky, dark ones once paper shows.
          final overSky = dark || offset < heroHeight - 120;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                (overSky
                        ? SystemUiOverlayStyle.light
                        : SystemUiOverlayStyle.dark)
                    .copyWith(statusBarColor: Colors.transparent),
            child: Stack(
              children: [
                // The sky: half the scroll speed, zooming towards the horizon
                // during a dive.
                Positioned(
                  top: -offset * 0.5,
                  left: 0,
                  right: 0,
                  height: heroHeight + 40,
                  child: Transform.scale(
                    scale: 1 + v * 0.5,
                    alignment: const Alignment(0, 0.25),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        LivingSky(coordinates: where),
                        const Grain(opacity: 0.035),
                        // The ground fades into the page under the tiles.
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.28),
                                Colors.transparent,
                                Colors.transparent,
                                colors.background,
                              ],
                              stops: const [0, 0.22, 0.86, 1],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomScrollView(
                  controller: _scroll,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: heroHeight,
                        child: Opacity(
                          opacity: (1 - v * 2).clamp(0.0, 1.0),
                          child: SafeArea(
                            bottom: false,
                            child: ContentWidth(
                              child: TodayHeroContent(onDive: _diveIn),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        context.navBarClearance + AppSpacing.xxl,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Opacity(
                          opacity: (1 - v * 2).clamp(0.0, 1.0),
                          child: const ContentWidth(child: TodayBento()),
                        ),
                      ),
                    ),
                  ],
                ),
                // Once the sky has scrolled away, the status bar gets a veil so
                // the clock never sits on top of a tile.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.paddingOf(context).top + AppSpacing.xxl,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: ((offset - heroHeight * 0.5) / 120).clamp(
                        0.0,
                        1.0,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              colors.background,
                              colors.background.withValues(alpha: 0.9),
                              colors.background.withValues(alpha: 0),
                            ],
                            stops: const [0, 0.7, 1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
