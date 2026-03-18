import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart';
import 'package:myapp/app/theme/theme_cubit.dart';
import 'package:myapp/core/di/injection.dart';
import 'package:myapp/features/documents/presentation/cubit/document_list_cubit.dart';
import 'package:myapp/features/documents/presentation/cubit/document_scanner_cubit.dart';
import 'package:myapp/features/home/ui/dashboard_screen.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../../../support/mocks.dart';

class MockThemeCubit extends Mock implements ThemeCubit {}
class MockDocumentListCubit extends Mock implements DocumentListCubit {}
class MockDocumentScannerCubit extends Mock implements DocumentScannerCubit {}

void main() {
  late MockSessionRepository sessionRepository;
  late BehaviorSubject<SessionStatusModel> sessionController;
  late MockThemeCubit themeCubit;
  late MockDocumentListCubit documentListCubit;
  late MockDocumentScannerCubit documentScannerCubit;

  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
  });

  setUp(() async {
    sessionRepository = MockSessionRepository();
    sessionController = BehaviorSubject.seeded(
      buildAuthenticatedSessionStatus(
        userId: 'user-1',
        email: 'user@example.com',
        isAnonymous: false,
        sharedUser: buildSharedUser(id: 'user-1', firstName: 'Adam'),
      ),
    );

    themeCubit = MockThemeCubit();
    when(() => themeCubit.state).thenReturn(const ThemeState.initial(themeMode: ThemeMode.light));
    when(() => themeCubit.stream).thenAnswer((_) => Stream.value(const ThemeState.initial(themeMode: ThemeMode.light)));
    when(() => themeCubit.isClosed).thenReturn(false);
    when(() => themeCubit.close()).thenAnswer((_) async {});

    documentListCubit = MockDocumentListCubit();
    when(() => documentListCubit.state).thenReturn(const DocumentListState.initial());
    when(() => documentListCubit.stream).thenAnswer((_) => Stream.value(const DocumentListState.initial()));
    when(() => documentListCubit.loadDocuments(any())).thenAnswer((_) async {});
    when(() => documentListCubit.isClosed).thenReturn(false);
    when(() => documentListCubit.close()).thenAnswer((_) async {});

    documentScannerCubit = MockDocumentScannerCubit();
    when(() => documentScannerCubit.state).thenReturn(const DocumentScannerState.initial());
    when(() => documentScannerCubit.stream).thenAnswer((_) => Stream.value(const DocumentScannerState.initial()));
    when(() => documentScannerCubit.isClosed).thenReturn(false);
    when(() => documentScannerCubit.close()).thenAnswer((_) async {});

    when(
      () => sessionRepository.sessionStream,
    ).thenAnswer((_) => sessionController.stream.cast());
    when(
      () => sessionRepository.current,
    ).thenAnswer((_) => sessionController.value);
    when(() => sessionRepository.refresh()).thenAnswer((_) async {});

    await getIt.reset();
    getIt.registerFactory<DocumentListCubit>(() => documentListCubit);
    getIt.registerFactory<DocumentScannerCubit>(() => documentScannerCubit);
  });

  tearDown(() async {
    await sessionController.close();
    await getIt.reset();
  });

  testWidgets('shows greeting and placeholders in dashboard', (tester) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SessionCubit>.value(value: sessionCubit),
            BlocProvider<ThemeCubit>.value(value: themeCubit),
            BlocProvider<DocumentListCubit>.value(value: documentListCubit),
            BlocProvider<DocumentScannerCubit>.value(value: documentScannerCubit),
          ],
          child: const DashboardScreen(userId: 'user-1'),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Witaj w MobiScan'), findsOneWidget);
    expect(find.text('Łącznie skanów'), findsOneWidget);
    expect(find.text('Nowy skan'), findsOneWidget);
  });
}
