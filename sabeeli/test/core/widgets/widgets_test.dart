import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sabeeli/core/platform/live_state.dart';
import 'package:sabeeli/core/theme/app_theme.dart';
import 'package:sabeeli/core/widgets/bento_tile.dart';
import 'package:sabeeli/core/widgets/pill_tabs.dart';
import 'package:sabeeli/core/widgets/rolling_digits.dart';

/// The app's theme around a widget, as on a phone.
Widget app(Widget child) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('RollingDigits', () {
    testWidgets('shows every character, in any digits', (tester) async {
      await tester.pumpWidget(
        app(const RollingDigits('1:05', style: TextStyle(fontSize: 40))),
      );
      for (final c in ['1', ':', '0', '5']) {
        expect(find.text(c), findsOneWidget);
      }
      await tester.pumpWidget(
        app(const RollingDigits('٤٢', style: TextStyle(fontSize: 40))),
      );
      await tester.pumpAndSettle();
      expect(find.text('٤'), findsOneWidget);
      expect(find.text('٢'), findsOneWidget);
    });

    testWidgets('keeps its width while a digit changes', (tester) async {
      Future<double> widthOf(String s) async {
        await tester.pumpWidget(
          app(RollingDigits(s, style: const TextStyle(fontSize: 40))),
        );
        await tester.pumpAndSettle();
        return tester.getSize(find.byType(RollingDigits)).width;
      }

      // Every digit sits in a slot as wide as the widest: "11" and "88" match.
      expect(await widthOf('11'), await widthOf('88'));
    });
  });

  testWidgets('PillTabs reports the tab tapped, not the one selected', (
    tester,
  ) async {
    final taps = <int>[];
    await tester.pumpWidget(
      app(
        SizedBox(
          width: 300,
          child: PillTabs(
            labels: const ['Tafsir', 'Translation'],
            selected: 0,
            onChanged: taps.add,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Tafsir'));
    await tester.tap(find.text('Translation'));
    expect(taps, [1]);
  });

  testWidgets('BentoTile answers a tap', (tester) async {
    var tapped = 0;
    await tester.pumpWidget(
      app(
        SizedBox(
          width: 200,
          height: 120,
          child: BentoTile(onTap: () => tapped++, child: const Text('Qibla')),
        ),
      ),
    );
    await tester.tap(find.text('Qibla'));
    await tester.pumpAndSettle();
    expect(tapped, 1);
  });

  group('LiveStateMixin', () {
    testWidgets('a widget in a hidden tab is not live', (tester) async {
      final probe = GlobalKey<_ProbeState>();
      await tester.pumpWidget(
        app(TickerMode(enabled: false, child: _Probe(key: probe))),
      );
      expect(probe.currentState!.isLive, isFalse);

      await tester.pumpWidget(
        app(TickerMode(enabled: true, child: _Probe(key: probe))),
      );
      expect(probe.currentState!.isLive, isTrue);
      expect(probe.currentState!.changes, [true]);
    });

    testWidgets('work stops when the app goes to the background', (
      tester,
    ) async {
      final probe = GlobalKey<_ProbeState>();
      await tester.pumpWidget(app(_Probe(key: probe)));
      expect(probe.currentState!.isLive, isTrue);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      expect(probe.currentState!.isLive, isFalse);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      expect(probe.currentState!.isLive, isTrue);
    });
  });

  test('FrameClock ticks only while started', () async {
    final clock = FrameClock(fps: 50);
    var ticks = 0;
    clock.addListener(() => ticks++);
    clock.start();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    clock.stop();
    final atStop = ticks;
    expect(atStop, greaterThan(2));
    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect(ticks, atStop);
    clock.dispose();
  });
}

class _Probe extends StatefulWidget {
  const _Probe({super.key});

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> with LiveStateMixin {
  final changes = <bool>[];

  @override
  void onLiveChanged(bool live) => changes.add(live);

  @override
  Widget build(BuildContext context) => const SizedBox();
}
