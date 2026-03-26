// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:myapp/app/profile/presentation/cubit/account_actions_cubit.dart'
    as _i639;
import 'package:myapp/app/session/data/repositories/session_repository.dart'
    as _i526;
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart'
    as _i934;
import 'package:myapp/app/theme/theme_cubit.dart' as _i169;
import 'package:myapp/core/di/app_module.dart' as _i832;
import 'package:myapp/core/di/injection.dart' as _i979;
import 'package:myapp/features/auth/data/datasources/auth_data_source.dart'
    as _i538;
import 'package:myapp/features/auth/data/repositories/auth_repository.dart'
    as _i37;
import 'package:myapp/features/auth/presentation/cubit/login_cubit.dart'
    as _i918;
import 'package:myapp/features/auth/presentation/cubit/register_cubit.dart'
    as _i27;
import 'package:myapp/features/auth/presentation/cubit/welcome_cubit.dart'
    as _i491;
import 'package:myapp/features/documents/data/datasources/document_data_source.dart'
    as _i308;
import 'package:myapp/features/documents/data/repositories/document_repository.dart'
    as _i368;
import 'package:myapp/features/documents/data/services/document_scanner_service.dart'
    as _i130;
import 'package:myapp/features/documents/presentation/cubit/document_detail_cubit.dart'
    as _i300;
import 'package:myapp/features/documents/presentation/cubit/document_list_cubit.dart'
    as _i112;
import 'package:myapp/features/documents/presentation/cubit/document_scanner_cubit.dart'
    as _i756;
import 'package:myapp/features/documents/presentation/cubit/pdf_export_cubit.dart'
    as _i971;
import 'package:myapp/features/profiles/data/datasources/shared_user_data_source.dart'
    as _i381;
import 'package:myapp/features/profiles/data/repositories/shared_user_repository.dart'
    as _i636;
import 'package:myapp/features/profiles/presentation/cubit/profile_cubit.dart'
    as _i463;
import 'package:myapp/features/settings/data/backup_repository.dart' as _i532;
import 'package:myapp/features/settings/presentation/cubit/backup_cubit.dart'
    as _i936;
import 'package:myapp/features/subscription/data/datasources/subscription_data_source.dart'
    as _i138;
import 'package:myapp/features/subscription/data/repositories/subscription_repository.dart'
    as _i894;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i971.PdfExportCubit>(() => _i971.PdfExportCubit());
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.lazySingleton<_i130.DocumentScannerService>(
      () => _i130.DocumentScannerServiceImpl(),
    );
    gh.lazySingleton<_i138.SubscriptionDataSource>(
      () => _i138.FakeSubscriptionDataSource(),
    );
    gh.lazySingleton<_i894.SubscriptionRepository>(
      () =>
          _i894.SubscriptionRepositoryImpl(gh<_i138.SubscriptionDataSource>()),
    );
    gh.lazySingleton<_i381.SharedUserDataSource>(
      () => _i381.SupabaseSharedUserDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i308.DocumentDataSource>(
      () => _i308.SupabaseDocumentDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i169.ThemeCubit>(
      () => _i169.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i538.AuthDataSource>(
      () => _i538.SupabaseAuthDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i636.SharedUserRepository>(
      () => _i636.SharedUserRepositoryImpl(gh<_i381.SharedUserDataSource>()),
    );
    gh.factory<_i463.ProfileCubit>(
      () => _i463.ProfileCubit(gh<_i636.SharedUserRepository>()),
    );
    gh.lazySingleton<_i37.AuthRepository>(
      () => _i37.AuthRepositoryImpl(gh<_i538.AuthDataSource>()),
    );
    gh.lazySingleton<_i368.DocumentRepository>(
      () => _i368.DocumentRepositoryImpl(gh<_i308.DocumentDataSource>()),
    );
    gh.lazySingleton<_i532.BackupRepository>(
      () => _i532.BackupRepositoryImpl(gh<_i368.DocumentRepository>()),
    );
    gh.lazySingleton<_i526.SessionRepository>(
      () => _i526.SessionRepositoryImpl(
        gh<_i37.AuthRepository>(),
        gh<_i636.SharedUserRepository>(),
        gh<_i894.SubscriptionRepository>(),
      ),
    );
    gh.factory<_i300.DocumentDetailCubit>(
      () => _i300.DocumentDetailCubit(gh<_i368.DocumentRepository>()),
    );
    gh.lazySingleton<_i112.DocumentListCubit>(
      () => _i112.DocumentListCubit(gh<_i368.DocumentRepository>()),
    );
    gh.factory<_i918.LoginCubit>(
      () => _i918.LoginCubit(gh<_i37.AuthRepository>()),
    );
    gh.factory<_i27.RegisterCubit>(
      () => _i27.RegisterCubit(gh<_i37.AuthRepository>()),
    );
    gh.factory<_i491.WelcomeCubit>(
      () => _i491.WelcomeCubit(gh<_i37.AuthRepository>()),
    );
    gh.factory<_i936.BackupCubit>(
      () => _i936.BackupCubit(gh<_i532.BackupRepository>()),
    );
    gh.factory<_i756.DocumentScannerCubit>(
      () => _i756.DocumentScannerCubit(
        gh<_i368.DocumentRepository>(),
        gh<_i130.DocumentScannerService>(),
      ),
    );
    gh.factory<_i639.AccountActionsCubit>(
      () => _i639.AccountActionsCubit(
        gh<_i37.AuthRepository>(),
        gh<_i894.SubscriptionRepository>(),
      ),
    );
    gh.lazySingleton<_i934.SessionCubit>(
      () => _i934.SessionCubit(gh<_i526.SessionRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i979.RegisterModule {}

class _$AppModule extends _i832.AppModule {}
