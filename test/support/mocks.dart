import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/session/data/repositories/session_repository.dart';
import 'package:myapp/app/session/models/session_status_model.dart';
import 'package:myapp/app/session/models/user_session_model.dart';
import 'package:myapp/features/auth/data/repositories/auth_repository.dart';
import 'package:myapp/features/auth/models/auth_principal_model.dart';
import 'package:myapp/features/profiles/data/repositories/shared_user_repository.dart';
import 'package:myapp/features/profiles/models/shared_user_model.dart';
import 'package:myapp/features/subscription/data/repositories/subscription_repository.dart';
import 'package:myapp/features/documents/data/repositories/document_repository.dart';
import 'package:myapp/features/documents/models/document_model.dart';
import 'package:myapp/features/documents/models/page_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSharedUserRepository extends Mock implements SharedUserRepository {}

class MockSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

AuthPrincipalModel buildPrincipal({
  required String userId,
  String? email,
  bool isAnonymous = false,
}) {
  return AuthPrincipalModel(
    userId: userId,
    email: email,
    isAnonymous: isAnonymous,
  );
}

SharedUserModel buildSharedUser({required String id, String? firstName}) {
  return SharedUserModel(id: id, firstName: firstName);
}

UserSessionModel buildSessionModel({
  required String userId,
  String? email,
  bool isAnonymous = false,
  bool isPro = false,
  SharedUserModel? sharedUser,
}) {
  return UserSessionModel(
    userId: userId,
    email: email,
    isAnonymous: isAnonymous,
    sharedUser: sharedUser,
    isPro: isPro,
  );
}

SessionStatusModel buildAuthenticatedSessionStatus({
  required String userId,
  String? email,
  bool isAnonymous = false,
  bool isPro = false,
  SharedUserModel? sharedUser,
}) {
  return SessionStatusModel.authenticated(
    session: buildSessionModel(
      userId: userId,
      email: email,
      isAnonymous: isAnonymous,
      isPro: isPro,
      sharedUser: sharedUser,
    ),
  );
}

DocumentModel buildDocumentModel({
  required String id,
  required String userId,
  required String name,
  List<PageModel> pages = const [],
}) {
  return DocumentModel(
    id: id,
    userId: userId,
    name: name,
    createdAt: DateTime.now(),
    pages: pages,
  );
}

PageModel buildPageModel({
  required String id,
  required String documentId,
  required String storagePath,
  int pageIndex = 0,
}) {
  return PageModel(
    id: id,
    documentId: documentId,
    storagePath: storagePath,
    pageIndex: pageIndex,
    createdAt: DateTime.now(),
  );
}
