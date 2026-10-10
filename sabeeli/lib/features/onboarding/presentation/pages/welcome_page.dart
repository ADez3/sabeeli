import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/astronomy/coordinates.dart';
import '../../../../core/error/failure_text.dart';
import '../../../../core/layout/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../l10n/l10n.dart';
import '../../../home/presentation/widgets/living_sky/living_sky.dart';
import '../../../location/presentation/cubit/location_cubit.dart';
import '../../../prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../quran/presentation/cubit/quran_cubit.dart';
import '../../../quran/presentation/widgets/riwayah_picker.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

const _onSky = Colors.white;
final _onSkyMuted = Colors.white.withValues(alpha: 0.74);

/// The first launch: three short steps over the living sky. What the app is,
/// where the user is (for the times and the Qibla), and the prayer
/// notifications. Every step can be skipped; all of it lives in Settings too.
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Changing the language rebuilds this page with `_index` back at 0; a kept
  // page would come back at its old position and disagree with the dots and
  // the button.
  final _pages = PageController(keepPage: false);
  int _index = 0;

  /// Where the sky is drawn from before the user has set a location.
  static const _defaultSky = Coordinates(latitude: 21.4225, longitude: 39.8262);

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _next() {
    HapticFeedback.selectionClick();
    if (_index < 2) {
      _pages.nextPage(duration: Motion.page, curve: Motion.enter);
    } else {
      _finish();
    }
  }

  void _finish() {
    context.read<SettingsCubit>().completeOnboarding();
    context.go(AppRoutes.today);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final where = context.select(
      (LocationCubit c) => c.state.location?.coordinates,
    );

    // AppSync (above the router) points the riwayah at the chosen region.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            LivingSky(coordinates: where ?? _defaultSky),
            // A veil so the text reads on any sky.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x55000000),
                    Color(0x00000000),
                    Color(0xCC05070F),
                  ],
                  stops: [0, 0.35, 0.8],
                ),
              ),
            ),
            SafeArea(
              child: ContentWidth(
                maxWidth: 560,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.sm,
                        AppSpacing.lg,
                        0,
                      ),
                      child: Row(
                        children: [
                          const _LanguageButton(),
                          const Spacer(),
                          if (_index < 2)
                            TextButton(
                              onPressed: _finish,
                              style: TextButton.styleFrom(
                                foregroundColor: _onSkyMuted,
                              ),
                              child: Text(l10n.skipStep),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pages,
                        onPageChanged: (i) => setState(() => _index = i),
                        children: const [_Hello(), _Place(), _Notify()],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        0,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      child: Row(
                        children: [
                          for (var i = 0; i < 3; i++)
                            AnimatedContainer(
                              duration: Motion.component,
                              curve: Motion.enter,
                              margin: const EdgeInsetsDirectional.only(
                                end: AppSpacing.xs + 2,
                              ),
                              width: i == _index ? 22 : 7,
                              height: 7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: i == _index
                                    ? _onSky
                                    : _onSky.withValues(alpha: 0.3),
                              ),
                            ),
                          const Spacer(),
                          FilledButton(
                            onPressed: _next,
                            style: FilledButton.styleFrom(
                              backgroundColor: _onSky,
                              foregroundColor: const Color(0xFF0A0E1A),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xl,
                              ),
                            ),
                            child: Text(
                              _index == 0
                                  ? l10n.welcomeBegin
                                  : _index == 1
                                  ? l10n.welcomeNext
                                  : l10n.welcomeStart,
                              style: text.labelLarge?.copyWith(
                                fontSize: 15,
                                color: const Color(0xFF0A0E1A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A step: title and words at the bottom of the sky, then its own actions.
class _Step extends StatelessWidget {
  const _Step({
    required this.title,
    required this.body,
    this.children = const [],
    this.titleStyle,
  });

  final String title;
  final String body;
  final List<Widget> children;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: titleStyle ?? text.displaySmall?.copyWith(color: _onSky),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            body,
            style: text.bodyLarge?.copyWith(color: _onSkyMuted, height: 1.55),
          ),
          const SizedBox(height: AppSpacing.xl),
          ...children,
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Hello extends StatelessWidget {
  const _Hello();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    return _Step(
      title: l10n.appName,
      titleStyle: text.displayLarge?.copyWith(color: _onSky),
      body: l10n.welcomeTagline,
      children: [
        Text(
          'سَبِيلِي',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: AppFonts.display,
            fontSize: 30,
            color: const Color(0xFFF4B56A).withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

class _Place extends StatelessWidget {
  const _Place();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = context.select((LocationCubit c) => c.state.location);
    final busy = context.select(
      (LocationCubit c) => c.state.status == LocationStatus.locating,
    );
    final failure = context.select((LocationCubit c) => c.state.failure);
    return _Step(
      title: l10n.welcomePlaceTitle,
      body: l10n.setLocationHint,
      children: [
        if (location != null)
          _Done(text: location.name ?? l10n.unknownPlace)
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _Choice(
                icon: LucideIcons.locateFixed,
                label: busy ? l10n.locating : l10n.useCurrentLocation,
                onTap: busy
                    ? null
                    : () => context.read<LocationCubit>().locate(
                        context.languageCode,
                      ),
              ),
              _Choice(
                icon: LucideIcons.search,
                label: l10n.searchCity,
                onTap: () => context.push('${AppRoutes.welcome}/location'),
              ),
            ],
          ),
        // Without this a failed attempt looks like nothing happened.
        if (location == null && failure != null && !busy)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              failureText(l10n, failure),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: context.colors.danger),
            ),
          ),
      ],
    );
  }
}

class _Notify extends StatelessWidget {
  const _Notify();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final allowed = context.select(
      (PrayerTimesCubit c) =>
          c.state.permissions?.notificationsAllowed ?? false,
    );
    // Android 14+ denies exact alarms to new installs: without them a
    // notification can come minutes late.
    final exact = context.select(
      (PrayerTimesCubit c) => c.state.permissions?.exactAlarmsAllowed ?? true,
    );
    final riwayah = context.select(
      (QuranCubit c) => c.state.preferences.riwayah,
    );
    final quran = context.read<QuranCubit>();
    return _Step(
      title: l10n.welcomeNotifyTitle,
      body: l10n.welcomeNotifyBody,
      children: [
        if (allowed)
          _Done(text: l10n.welcomeNotifyOn)
        else
          _Choice(
            icon: LucideIcons.bellRing,
            label: l10n.welcomeNotifyAllow,
            onTap: () => context
                .read<PrayerTimesCubit>()
                .requestNotificationPermission(),
          ),
        if (allowed && !exact) ...[
          const SizedBox(height: AppSpacing.sm),
          _Choice(
            icon: LucideIcons.alarmClock,
            label: l10n.welcomeExactAlarms,
            onTap: () => context.read<PrayerTimesCubit>().requestExactAlarms(),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        // The riwayah can be changed right here, before the first reading.
        InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => BlocProvider.value(
              value: quran,
              child: const SafeArea(
                child: SingleChildScrollView(child: RiwayahPicker()),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    l10n.welcomeRiwayah(
                      l10n.riwayahName(riwayah ?? quran.riwayah),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: _onSkyMuted),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(LucideIcons.chevronDown, size: 16, color: _onSkyMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GlassPanel(
    radius: 24,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    onTap: onTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: _onSky),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: const TextStyle(color: _onSky)),
      ],
    ),
  );
}

class _Done extends StatelessWidget {
  const _Done({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(LucideIcons.circleCheck, color: Color(0xFFF4B56A), size: 20),
      const SizedBox(width: AppSpacing.sm),
      Flexible(
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: _onSky),
        ),
      ),
    ],
  );
}

/// The language, first thing: a newcomer may not read the device's.
class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) {
    final current = context.languageCode;
    final name = L10n.languages
        .firstWhere((l) => l.code == current, orElse: () => L10n.languages[1])
        .nativeName;
    return GlassPanel(
      radius: 20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        builder: (sheet) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final lang in L10n.languages)
                ListTile(
                  title: Text(lang.nativeName),
                  trailing: lang.code == current
                      ? const Icon(LucideIcons.check)
                      : null,
                  onTap: () {
                    context.read<SettingsCubit>().setLanguage(lang.code);
                    Navigator.of(sheet).pop();
                  },
                ),
            ],
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.languages, size: 16, color: _onSky),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(name, style: const TextStyle(color: _onSky)),
        ],
      ),
    );
  }
}
