import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/profile/presentation/cubit/account_actions_cubit.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart';
import 'package:myapp/app/theme/theme_cubit.dart';
import 'package:myapp/core/di/injection.dart';
import 'package:myapp/features/profiles/presentation/cubit/profile_cubit.dart';
import 'package:myapp/features/profiles/presentation/ui/profile_screen.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../support/mocks.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}
class MockProfileCubit extends Mock implements ProfileCubit {}
class MockAccountActionsCubit extends Mock implements AccountActionsCubit {}

void main() {
  late MockSessionRepository sessionRepository;
  late BehaviorSubject<SessionStatusModel> sessionController;
  late MockThemeCubit themeCubit;
  late MockProfileCubit profileCubit;
  late MockAccountActionsCubit accountActionsCubit;

  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
  });

  setUp(() async {
    sessionRepository = MockSessionRepository();
    sessionController = BehaviorSubject.seeded(
      buildAuthenticatedSessionStatus(
        userId: 'guest-1',
        isAnonymous: true,
        isPro: true,
        sharedUser: buildSharedUser(id: 'guest-1', firstName: 'Guest'),
      ),
    );
    
    themeCubit = MockThemeCubit();
    when(() => themeCubit.state).thenReturn(const ThemeState.initial(themeMode: ThemeMode.light));
    when(() => themeCubit.stream).thenAnswer((_) => Stream.value(const ThemeState.initial(themeMode: ThemeMode.light)));
    when(() => themeCubit.isClosed).thenReturn(false);
    when(() => themeCubit.close()).thenAnswer((_) async {});

    profileCubit = MockProfileCubit();
    when(() => profileCubit.state).thenReturn(const ProfileState.initial());
    when(() => profileCubit.stream).thenAnswer((_) => Stream.value(const ProfileState.initial()));
    when(() => profileCubit.isClosed).thenReturn(false);
    when(() => profileCubit.close()).thenAnswer((_) async {});

    accountActionsCubit = MockAccountActionsCubit();
    when(() => accountActionsCubit.state).thenReturn(const AccountActionsState.initial());
    when(() => accountActionsCubit.stream).thenAnswer((_) => Stream.value(const AccountActionsState.initial()));
    when(() => accountActionsCubit.isClosed).thenReturn(false);
    when(() => accountActionsCubit.close()).thenAnswer((_) async {});

    when(() => sessionRepository.sessionStream).thenAnswer((_) => sessionController.stream.cast());
    when(() => sessionRepository.current).thenAnswer((_) => sessionController.value);
    when(() => sessionRepository.refresh()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerFactory<ProfileCubit>(() => profileCubit);
    getIt.registerFactory<AccountActionsCubit>(() => accountActionsCubit);
  });

  tearDown(() async {
    await sessionController.close();
    await getIt.reset();
  });

  testWidgets('shows protect-pro banner for guest with pro', (tester) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SessionCubit>.value(value: sessionCubit),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
          ],
          child: const ProfileScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Zabezpiecz dostęp do Pro'), findsOneWidget);
    expect(find.text('Zarejestruj się'), findsOneWidget);
    expect(find.text('Zaloguj się'), findsOneWidget);
  });

  testWidgets('shows delete confirmation dialog', (tester) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SessionCubit>.value(value: sessionCubit),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
          ],
          child: const ProfileScreen(),
        ),
      ),
    );
    await tester.pump();

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Usuń konto'),
      200,
      scrollable: scrollable,
    );
    await tester.tap(find.text('Usuń konto'));
    await tester.pumpAndSettle();

    expect(find.text('Usuń konto?'), findsOneWidget);
    expect(find.text('Czy na pewno chcesz usunąć swoje konto? Tej operacji nie można cofnąć.'), findsOneWidget);
  });
}
