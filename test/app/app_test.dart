import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/app.dart';
import 'package:myapp/app/theme/theme_cubit.dart';
import 'package:myapp/app/ui/missing_supabase_keys_screen.dart';
import 'package:myapp/core/di/injection.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}

void main() {
  late MockThemeCubit themeCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    themeCubit = MockThemeCubit();
    when(() => themeCubit.state).thenReturn(const ThemeState.initial(themeMode: ThemeMode.light));
    when(() => themeCubit.stream).thenAnswer((_) => Stream.value(const ThemeState.initial(themeMode: ThemeMode.light)));
    when(() => themeCubit.isClosed).thenReturn(false);
    when(() => themeCubit.close()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerLazySingleton<ThemeCubit>(() => themeCubit);
  });

  testWidgets('configures Flutter localizations on MaterialApp', (
    tester,
  ) async {
    await tester.pumpWidget(const App(hasSupabaseKeys: false));
    await tester.pump();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    final screenContext = tester.element(
      find.byType(MissingSupabaseKeysScreen),
    );

    expect(app.localizationsDelegates, AppLocalizations.localizationsDelegates);
    expect(app.supportedLocales, AppLocalizations.supportedLocales);
    expect(Localizations.localeOf(screenContext), const Locale('pl'));
    expect(AppLocalizations.of(screenContext), isNotNull);
  });
}
