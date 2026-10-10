import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/layout/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../l10n/l10n.dart';
import '../../domain/entities/quran_entities.dart';
import '../cubit/quran_cubit.dart';
import '../widgets/quran_sky/quran_sky_painters.dart';
import '../widgets/quran_font.dart';

/// The opening of a surah, reached from its star: its name in calligraphy, where it
/// stands in the mushaf and in the revelation, and the way in. The elements arrive
/// one after another, like a title sequence.
class SurahOpeningPage extends StatefulWidget {
  const SurahOpeningPage({super.key, required this.surah});

  final int surah;

  @override
  State<SurahOpeningPage> createState() => _SurahOpeningPageState();
}

class _SurahOpeningPageState extends State<SurahOpeningPage>
    with TickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();
  late final AnimationController _breath = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _intro.dispose();
    _breath.dispose();
    super.dispose();
  }

  /// Fades and lifts the [index]-th element in, a little after the previous one.
  Widget _stagger(int index, Widget child) {
    final start = (index * 0.09).clamp(0.0, 0.7);
    final anim = CurvedAnimation(
      parent: _intro,
      curve: Interval(
        start,
        (start + 0.45).clamp(0.0, 1.0),
        curve: Curves.easeOutCubic,
      ),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - anim.value)),
          child: child,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final state = context.watch<QuranCubit>().state;
    final data = state.data;
    if (data == null) return const Scaffold(backgroundColor: Color(0xFF04050D));

    final surah = data.surah(widget.surah);
    final (firstPage, lastPage) = data.surahPages(widget.surah);
    final progress = data.surahProgress(widget.surah, state.readPages);
    final tint = QuranSkyGeometry.tint(surah);
    final position = state.position;
    final resume = position != null && position.ref.surah == widget.surah;
    final still = MediaQuery.disableAnimationsOf(context);

    final facts = [
      surah.revelation == Revelation.meccan ? l10n.meccan : l10n.medinan,
      l10n.ayahCount(surah.ayahCount),
      l10n.revelationOrder(surah.revelationOrder),
      l10n.pagesRange(firstPage, lastPage),
      l10n.juzNumber(data.juzOf(AyahRef(widget.surah, 1))),
    ];
    final firstAyah = data.text(
      AyahRef(widget.surah, widget.surah == 1 ? 2 : 1),
    );
    final quranStyle = TextStyle(
      fontFamily: context.quranFont,
      color: Colors.white.withValues(alpha: 0.9),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF04050D),
        body: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: QuranSkyBackdropPainter(showPath: false),
              ),
            ),
            SafeArea(
              child: ContentWidth(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.sm,
                    AppSpacing.xl,
                    AppSpacing.xxl,
                  ),
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: GlassPanel(
                        shape: BoxShape.circle,
                        padding: const EdgeInsets.all(10),
                        onTap: () => context.pop(),
                        child: Icon(
                          context.isRtl
                              ? LucideIcons.arrowRight
                              : LucideIcons.arrowLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // The surah's own star, breathing.
                    _stagger(
                      0,
                      Center(
                        child: AnimatedBuilder(
                          animation: _breath,
                          builder: (_, _) {
                            final b = still
                                ? 0.5
                                : Curves.easeInOut.transform(_breath.value);
                            final r = QuranSkyGeometry.radius(surah) * 2.2;
                            return SizedBox.square(
                              dimension: 140,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      tint.withValues(alpha: 0.35 + 0.15 * b),
                                      tint.withValues(alpha: 0),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: r * 2,
                                    height: r * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.lerp(
                                        tint,
                                        Colors.white,
                                        0.35,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: tint,
                                          blurRadius: 18 + 10 * b,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    _stagger(
                      1,
                      Text(
                        context.digits('${surah.number}'),
                        textAlign: TextAlign.center,
                        style: text.labelLarge?.copyWith(
                          color: Colors.white54,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                    _stagger(
                      2,
                      Text(
                        surah.nameArabic,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontFamily: AppFonts.display,
                          fontSize: 64,
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (context.languageCode != 'ar')
                      _stagger(
                        3,
                        Text(
                          [
                            surah.nameTransliterated,
                            if (context.languageCode == 'en')
                              ?surah.meaningIfDistinct,
                          ].join(' · '),
                          textAlign: TextAlign.center,
                          style: text.titleMedium?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xl),
                    _stagger(
                      4,
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final f in facts)
                            GlassPanel(
                              radius: 16,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: 6,
                              ),
                              child: Text(
                                context.digits(f),
                                style: text.labelMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (data.hasBasmalaHeader(surah.number))
                      _stagger(
                        5,
                        Text(
                          data.basmala,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: quranStyle.copyWith(fontSize: 24, height: 2),
                        ),
                      ),
                    _stagger(
                      6,
                      // A glimpse of the first ayah, fading into the dark.
                      ShaderMask(
                        shaderCallback: (r) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.transparent],
                          stops: [0.4, 1],
                        ).createShader(r),
                        child: Text(
                          firstAyah,
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: quranStyle.copyWith(
                            fontSize: 21,
                            height: 2,
                            color: Colors.white60,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _stagger(
                      7,
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 3,
                                color: const Color(0xFFF4B860),
                                backgroundColor: Colors.white12,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Text(
                            context.digits(
                              l10n.surahProgress((progress * 100).floor()),
                            ),
                            style: text.labelMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _stagger(
                      8,
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0A0C22),
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          resume
                              ? context.pushReplacementNamed(
                                  AppRoutes.quranPageName,
                                  pathParameters: {'page': '${position.page}'},
                                )
                              : context.pushReplacementNamed(
                                  AppRoutes.quranSurahName,
                                  pathParameters: {'surah': '${widget.surah}'},
                                );
                        },
                        icon: const Icon(LucideIcons.bookOpen),
                        label: Text(
                          resume ? l10n.continueReading : l10n.startReading,
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
    );
  }
}
