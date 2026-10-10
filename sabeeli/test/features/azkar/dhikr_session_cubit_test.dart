import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sabeeli/core/astronomy/prayer.dart';
import 'package:sabeeli/core/result/result.dart';
import 'package:sabeeli/features/azkar/domain/entities/dhikr_step.dart';
import 'package:sabeeli/features/azkar/domain/usecases/get_after_prayer_steps_usecase.dart';
import 'package:sabeeli/features/azkar/presentation/cubit/dhikr_session_cubit.dart';
import 'package:sabeeli/features/quran/domain/entities/quran_entities.dart';

class _Steps extends Mock implements GetAfterPrayerStepsUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() => registerFallbackValue(Prayer.fajr));

  const istighfar = DhikrStep(id: 'istighfar', arabic: 'أستغفر الله', count: 3);
  const salam = DhikrStep(id: 'salam', arabic: 'اللهم أنت السلام', count: 1);
  const ikhlas = DhikrStep(
    id: 'ikhlas',
    quranFrom: AyahRef(112, 1),
    quranTo: AyahRef(112, 4),
    count: 1,
    countAfterFajrAndMaghrib: 3,
  );

  test('counts each step and moves on when it is complete', () {
    final cubit = DhikrSessionCubit(_Steps())..start([istighfar, salam]);
    expect(cubit.state.step, istighfar);
    cubit
      ..count()
      ..count();
    expect(cubit.state.counted, 2);
    expect(cubit.state.index, 0);
    cubit.count();
    expect(cubit.state.step, salam);
    expect(cubit.state.counted, 0);
    cubit.count();
    expect(cubit.state.finished, isTrue);
    expect(cubit.state.totalRepetitions, 4);
  });

  test('the Quls are said three times after Fajr, once after Dhuhr', () async {
    final steps = _Steps();
    when(() => steps(any())).thenAnswer((_) async => const Ok([ikhlas]));
    final cubit = DhikrSessionCubit(steps);

    await cubit.loadAfterPrayer(Prayer.fajr);
    expect(cubit.state.target, 3);

    await cubit.loadAfterPrayer(Prayer.dhuhr);
    expect(cubit.state.target, 1);
  });

  test('going back and skipping reset the count of the step', () {
    final cubit = DhikrSessionCubit(_Steps())..start([istighfar, salam]);
    cubit
      ..count()
      ..goTo(1);
    expect(cubit.state.step, salam);
    expect(cubit.state.counted, 0);
    cubit.goTo(0);
    expect(cubit.state.step, istighfar);
    cubit
      ..count()
      ..restart();
    expect(cubit.state.counted, 0);
    expect(cubit.state.index, 0);
  });
}
