import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart';
import 'package:myapp/features/home/ui/home_screen.dart';
import 'package:myapp/l10n/generated/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../../../support/mocks.dart';

void main() {
  late MockSessionRepository sessionRepository;
  late BehaviorSubject<SessionStatusModel> sessionController;

  setUp(() {
    sessionRepository = MockSessionRepository();
    sessionController = BehaviorSubject.seeded(
      buildAuthenticatedSessionStatus(
        userId: 'user-1',
        email: 'user@example.com',
        isAnonymous: false,
        sharedUser: buildSharedUser(id: 'user-1', firstName: 'Adam'),
      ),
    );

    when(
      () => sessionRepository.sessionStream,
    ).thenAnswer((_) => sessionController.stream.cast());
    when(
      () => sessionRepository.current,
    ).thenAnswer((_) => sessionController.value);
    when(() => sessionRepository.refresh()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await sessionController.close();
  });

  testWidgets('shows email and display name from session stream', (
    tester,
  ) async {
    final sessionCubit = SessionCubit(sessionRepository);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<SessionCubit>.value(
          value: sessionCubit,
          child: const HomeScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('user@example.com'), findsOneWidget);
    expect(find.textContaining('Adam'), findsWidgets);
    expect(find.textContaining('zalogowany'), findsOneWidget);
  });
}
