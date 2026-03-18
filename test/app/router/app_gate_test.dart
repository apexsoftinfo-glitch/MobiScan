import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/router/app_gate.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart';
import 'package:myapp/app/theme/theme_cubit.dart';
import 'package:myapp/core/di/injection.dart';
import 'package:myapp/features/auth/presentation/cubit/welcome_cubit.dart';
import 'package:myapp/features/documents/presentation/cubit/document_list_cubit.dart';
import 'package:myapp/features/documents/presentation/cubit/document_scanner_cubit.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';

import '../../support/mocks.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}
class MockDocumentListCubit extends Mock implements DocumentListCubit {}
class MockDocumentScannerCubit extends Mock implements DocumentScannerCubit {}

void main() {
  late MockSessionRepository sessionRepository;
  late MockAuthRepository authRepository;
  late StreamController<SessionStatusModel> sessionController;
  late MockThemeCubit themeCubit;
  late MockDocumentListCubit documentListCubit;
  late MockDocumentScannerCubit documentScannerCubit;

  setUp(() async {
    sessionRepository = MockSessionRepository();
    authRepository = MockAuthRepository();
    sessionController = StreamController<SessionStatusModel>();
    themeCubit = MockThemeCubit();
    documentListCubit = MockDocumentListCubit();
    documentScannerCubit = MockDocumentScannerCubit();

    // ThemeCubit stubbing
    when(() => themeCubit.state).thenReturn(const ThemeState.initial(themeMode: ThemeMode.light));
    when(() => themeCubit.stream).thenAnswer((_) => Stream.value(const ThemeState.initial(themeMode: ThemeMode.light)));
    when(() => themeCubit.isClosed).thenReturn(false);
    when(() => themeCubit.close()).thenAnswer((_) async {});

    // DocumentListCubit stubbing
    when(() => documentListCubit.state).thenReturn(const DocumentListState.initial());
    when(() => documentListCubit.stream).thenAnswer((_) => Stream.value(const DocumentListState.initial()));
    when(() => documentListCubit.loadDocuments(any())).thenAnswer((_) async {});
    when(() => documentListCubit.isClosed).thenReturn(false);
    when(() => documentListCubit.close()).thenAnswer((_) async {});

    // DocumentScannerCubit stubbing
    when(() => documentScannerCubit.state).thenReturn(const DocumentScannerState.initial());
    when(() => documentScannerCubit.stream).thenAnswer((_) => Stream.value(const DocumentScannerState.initial()));
    when(() => documentScannerCubit.isClosed).thenReturn(false);
    when(() => documentScannerCubit.close()).thenAnswer((_) async {});

    when(
      () => sessionRepository.sessionStream,
    ).thenAnswer((_) => sessionController.stream.cast());
    when(
      () => sessionRepository.current,
    ).thenReturn(const SessionStatusModel.loading());
    when(() => sessionRepository.refresh()).thenAnswer((_) async {});
    when(() => authRepository.continueAsGuest()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerFactory<WelcomeCubit>(() => WelcomeCubit(authRepository));
    getIt.registerFactory<DocumentListCubit>(() => documentListCubit);
    getIt.registerFactory<DocumentScannerCubit>(() => documentScannerCubit);
  });

  tearDown(() async {
    await sessionController.close();
    await getIt.reset();
  });

  testWidgets('shows welcome when session is unauthenticated', (tester) async {
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
          child: const AppGate(),
        ),
      ),
    );
    sessionController.add(const SessionStatusModel.unauthenticated());
    await tester.pump();

    expect(find.text('Witaj'), findsOneWidget);
    expect(find.text('Kontynuuj jako gość'), findsOneWidget);
  });

  testWidgets('shows loading before first session emission', (tester) async {
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
          child: const AppGate(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Witaj'), findsNothing);
  });

  testWidgets('shows home when session is authenticated', (tester) async {
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
          child: const AppGate(),
        ),
      ),
    );
    sessionController.add(
      buildAuthenticatedSessionStatus(userId: 'guest-1', isAnonymous: true),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Witaj w MobiScan'), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
  });

  testWidgets('shows shared users setup screen for schema error', (
    tester,
  ) async {
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
          child: const AppGate(),
        ),
      ),
    );
    sessionController.addError(
      Exception(
        "Could not find the 'first_name' column of 'shared_users' in the schema cache",
      ),
    );
    await tester.pump();

    expect(find.textContaining('Brakuje tabeli'), findsOneWidget);
    expect(find.text('02_SUPABASE_SHARED_USERS_SETUP.md'), findsOneWidget);
  });
}
