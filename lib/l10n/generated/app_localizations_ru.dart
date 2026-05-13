// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get localizationBootstrap => 'Локализация приложения настроена.';

  @override
  String get errorInvalidCredentials => 'Неверный email или пароль.';

  @override
  String get errorAnonymousAuthDisabled =>
      'Вход в качестве гостя в данный момент отключен.';

  @override
  String get errorEmail =>
      'Проверьте адрес электронной почты и попробуйте снова.';

  @override
  String get errorPassword => 'Проверьте пароль и попробуйте снова.';

  @override
  String get errorNetwork => 'Проблема с подключением. Попробуйте снова.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'Удаление учетной записи требует завершения настройки в Supabase.';

  @override
  String get errorDeleteAccountFailed =>
      'Не удалось удалить учетную запись. Попробуйте снова.';

  @override
  String get errorSharedUsersSetupRequired =>
      'Отсутствует таблица shared_users или ее схема не соответствует шаблону.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'Удаление учетной записи еще не готово.';

  @override
  String get errorUnknown => 'Произошла непредвиденная ошибка.';

  @override
  String errorWithKey(Object errorKey) {
    return 'Произошла ошибка: $errorKey';
  }

  @override
  String get guestDisplayName => 'Гость';

  @override
  String get registeredUserDisplayName => 'Пользователь';

  @override
  String get loadingLabel => 'Загрузка...';

  @override
  String get sessionErrorTitle => 'Ошибка сессии';

  @override
  String get accountTypeGuest => 'гость';

  @override
  String get accountTypeRegistered => 'зарегистрирован';

  @override
  String get commonYes => 'да';

  @override
  String get commonNo => 'нет';

  @override
  String get userTierGuest => 'гость';

  @override
  String get userTierRegistered => 'аккаунт';

  @override
  String get userTierPro => 'Pro';

  @override
  String get homeTitle => 'Старт';

  @override
  String get currentSessionTitle => 'Текущая сессия';

  @override
  String sessionUserId(Object value) {
    return 'ID пользователя: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'Тип аккаунта: $value';
  }

  @override
  String sessionPlan(Object value) {
    return 'План: $value';
  }

  @override
  String sessionPro(Object value) {
    return 'Pro: $value';
  }

  @override
  String sessionEmail(Object value) {
    return 'Email: $value';
  }

  @override
  String sessionDisplayNameValue(Object value) {
    return 'Отображаемое имя: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'Имя: $value';
  }

  @override
  String get developerToolsTitle => 'Инструменты разработчика';

  @override
  String get retryButtonLabel => 'Попробовать снова';

  @override
  String get welcomeTitle => 'Добро пожаловать';

  @override
  String get welcomeBody =>
      'Продолжите как гость или войдите в существующий аккаунт.';

  @override
  String get continueAsGuestButtonLabel => 'Продолжить как гость';

  @override
  String get loginButtonLabel => 'Войти';

  @override
  String get loginScreenTitle => 'Вход';

  @override
  String get loginExistingAccountTitle => 'Войти в существующий аккаунт';

  @override
  String get loginExistingAccountBody =>
      'Используйте свой email и пароль, чтобы переключиться на существующий аккаунт.';

  @override
  String get emailFieldLabel => 'Email';

  @override
  String get passwordFieldLabel => 'Пароль';

  @override
  String get switchAccountWarningTitle => 'Переключение аккаунта';

  @override
  String get switchAccountWarningBody =>
      'Вход в этом месте переключит вас с текущего гостевого аккаунта на другой аккаунт. Данные гостя и Pro не объединяются автоматически.';

  @override
  String get registerScreenTitle => 'Регистрация';

  @override
  String get secureGuestAccountTitle => 'Защитить этот гостевой аккаунт';

  @override
  String get secureGuestAccountBody =>
      'Это сохранит ваши текущие данные и свяжет этот гостевой аккаунт с email и паролем.';

  @override
  String get registerButtonLabel => 'Зарегистрироваться';

  @override
  String get profileSavedSnackbar => 'Профиль сохранен';

  @override
  String get proEnabledSnackbar => 'Pro активирован';

  @override
  String get passwordUpdatedSnackbar => 'Пароль изменен';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get firstNameFieldLabel => 'Имя';

  @override
  String get saveFirstNameButtonLabel => 'Сохранить имя';

  @override
  String get changePasswordButtonLabel => 'Изменить пароль';

  @override
  String get newPasswordFieldLabel => 'Новый пароль';

  @override
  String get changePasswordDialogTitle => 'Изменить пароль';

  @override
  String get changePasswordDialogBody =>
      'Введите новый пароль для вашего аккаунта.';

  @override
  String get forgotPasswordButtonLabel => 'Забыли пароль?';

  @override
  String get passwordResetSentSnackbar =>
      'Ссылка для сброса пароля отправлена на ваш email';

  @override
  String get emailEmptyError => 'Введите ваш email';

  @override
  String get resetPasswordDialogTitle => 'Восстановление пароля';

  @override
  String get resetPasswordDialogBody =>
      'Мы отправим ссылку для сброса пароля на ваш адрес электронной почты.';

  @override
  String get resetPasswordConfirmButtonLabel => 'Отправить ссылку';

  @override
  String get accountSecuredSnackbar => 'Аккаунт защищен';

  @override
  String get logoutButtonLabel => 'Выйти';

  @override
  String get buyProButtonLabel => 'Купить Pro';

  @override
  String get deleteAccountButtonLabel => 'Удалить аккаунт';

  @override
  String get discardChangesTitle => 'Отменить изменения?';

  @override
  String get discardChangesBody =>
      'У вас есть несохраненные изменения. Если вы выйдете сейчас, они будут потеряны.';

  @override
  String get stayButtonLabel => 'Остаться';

  @override
  String get discardButtonLabel => 'Отменить';

  @override
  String get closeButtonLabel => 'Закрыть';

  @override
  String get protectProBannerTitle => 'Защитить доступ к Pro';

  @override
  String get protectProBannerBody =>
      'У этого гостевого аккаунта уже есть Pro. Зарегистрируйте этот аккаунт, чтобы не потерять доступ в будущем.';

  @override
  String get developerDiagnosticsTitle => 'Диагностика (только для отладки)';

  @override
  String get developerDiagnosticsBody =>
      'Используйте этот экран для проверки локальной конфигурации приложения и статуса интеграции.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat не подключен';

  @override
  String get revenueCatDisconnectedBody =>
      'Добавьте ключи RevenueCat в config/api-keys.json, когда будете готовы тестировать подписки.';

  @override
  String get sessionSectionTitle => 'Сессия';

  @override
  String get loggedInLabel => 'Вошел';

  @override
  String get anonymousLabel => 'Анонимный';

  @override
  String get planLabel => 'План';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'ID пользователя';

  @override
  String get emailLabel => 'Email';

  @override
  String get displayNameLabel => 'Отображаемое имя';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'Ключи настроены';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'Поддерживаемая платформа';

  @override
  String get sdkActiveLabel => 'SDK активно';

  @override
  String get currentKeySourceLabel => 'Текущий источник ключа';

  @override
  String get missingValueLabel => 'отсутствует';

  @override
  String get debugForceProTitle => 'Debug: форсировать статус Pro';

  @override
  String get debugForceProSubtitle =>
      'Работает только без активного RevenueCat и только в инструменте отладки.';

  @override
  String get missingSupabaseAgentPrompt =>
      'Подключите `Supabase MCP` к моему проекту Supabase и заполните `config/api-keys.json` значениями `SUPABASE_URL` и `SUPABASE_ANON_KEY`.';

  @override
  String get missingSupabaseTitle => 'Отсутствуют ключи Supabase';

  @override
  String get missingSupabaseBody =>
      'Добавьте ключи Supabase в файл конфигурации и перезапустите приложение.';

  @override
  String get missingSupabaseFileLabel => 'Заполните этот файл';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title => 'Шаг 1: установите `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'Сначала добавьте `Supabase MCP` к вашему AI-агенту.';

  @override
  String get missingSupabaseStep2Title => 'Шаг 2: вставьте этот промпт агенту';

  @override
  String get copyPromptButtonLabel => 'Копировать промпт';

  @override
  String get promptCopiedSnackbar => 'Промпт скопирован';

  @override
  String get missingSupabaseStep3Title =>
      'Шаг 3: закройте и снова откройте приложение';

  @override
  String get missingSupabaseStep3Body =>
      'Когда агент заполнит файл ключами, закройте приложение и запустите его снова.';

  @override
  String get sharedUsersAgentPrompt =>
      'Запустите задачу `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` и приведите таблицу `shared_users` к минимальному соответствию этому проекту с помощью `Supabase MCP`.';

  @override
  String get sharedUsersSetupTitle =>
      'Отсутствует таблица `shared_users` в Supabase';

  @override
  String get sharedUsersSetupBody =>
      'Приложение не может загрузить дополнительные данные пользователей (например, имя), так как таблица `shared_users` не существует или ее структура не соответствует минимальным требованиям.';

  @override
  String get sharedUsersGuideLabel => 'Воспользуйтесь готовой инструкцией:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle =>
      'Вставьте этот промпт вашему AI-агенту';

  @override
  String get sharedUsersAiHelpBody =>
      'Если ваш AI-агент имеет доступ к Supabase MCP, он автоматически настроит все согласно подготовленной инструкции за вас.';

  @override
  String get deleteAccountSetupAgentPrompt =>
      'Запустите задачу `docs/tasks/03_SUPABASE_DELETE_ACCOUNT_SETUP.md` и завершите развертывание `delete-account` в Supabase и привяжите профиль к готовому потоку с помощью `Supabase MCP`.';

  @override
  String get deleteAccountSetupTitle =>
      'Удаление учетной записи требует дополнительной настройки';

  @override
  String get deleteAccountSetupBody =>
      'Логика `Удаление учетной записи` уже предварительно подготовлена в шаблоне, но функция `delete-account` еще не развернута в этом проекте, и профиль все еще ведет на этот экран настройки.';

  @override
  String get deleteAccountGuideLabel => 'Воспользуйтесь готовой инструкцией:';

  @override
  String get deleteAccountGuideFile => '03_SUPABASE_DELETE_ACCOUNT_SETUP.md';

  @override
  String get deleteAccountAiPromptTitle =>
      'Вставьте этот промпт вашему AI-агенту';

  @override
  String get deleteAccountAiHelpBody =>
      'Если ваш AI-агент имеет доступ к Supabase MCP, он может развернуть функцию `delete-account`, проверить `verify_jwt`, привязать профиль к готовому потоку и обновить тесты.';

  @override
  String get accountDeletedSnackbar => 'Аккаунт удален';

  @override
  String get deleteAccountDialogTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountDialogBody =>
      'Вы уверены, что хотите удалить свой аккаунт? Эту операцию нельзя отменить.';

  @override
  String get deleteDocumentDialogTitle => 'Удалить документ?';

  @override
  String get deleteDocumentDialogBody =>
      'Вы уверены, что хотите удалить этот документ? Эту операцию нельзя отменить.';

  @override
  String get cancelButtonLabel => 'Отмена';

  @override
  String get addScanButtonLabel => 'Добавить скан';

  @override
  String get noScansTitle => 'Нет сканов';

  @override
  String get noScansBody => 'Нажмите кнопку ниже, чтобы начать сканирование.';

  @override
  String get searchScansPlaceholder => 'Поиск сканов...';

  @override
  String get documentDetailsTitle => 'Детали';

  @override
  String get renameDocumentDialogTitle => 'Переименовать';

  @override
  String get exportPdfButtonLabel => 'Поделиться PDF';

  @override
  String get savingLabel => 'Сохранение...';

  @override
  String get generatingPdfLabel => 'Генерация PDF...';

  @override
  String get noPagesError => 'В документе нет страниц.';

  @override
  String get documentRenamedSnackbar => 'Имя изменено';

  @override
  String get errorUnknownKey => 'Неизвестная ошибка';

  @override
  String get navDashboard => 'Дашборд';

  @override
  String get dashboardRecentScans => 'Последние сканы';

  @override
  String get navMyScans => 'Мои сканы';

  @override
  String get navSettings => 'Настройки';

  @override
  String get settingsDarkMode => 'Темная тема';

  @override
  String get dashboardGreeting => 'Добро пожаловать в MobiScan';

  @override
  String get dashboardGreetingSubtitle => 'Быстрое сканирование, без рекламы.';

  @override
  String get dashboardTotalScans => 'Всего сканов';

  @override
  String get dashboardStartScan => 'Новый скан';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsProfile => 'Мой профиль';

  @override
  String get settingsVersion => 'Версия приложения';

  @override
  String get settingsBackupSection => 'РЕЗЕРВНОЕ КОПИРОВАНИЕ';

  @override
  String get settingsCreateBackup => 'Создать резервную копию';

  @override
  String get settingsRestoreBackup => 'Восстановить из копии';

  @override
  String get backupSuccessMessage => 'Резервная копия успешно создана!';

  @override
  String get restoreSuccessMessage => 'Данные успешно восстановлены!';

  @override
  String get backupFailedMessage => 'Ошибка при создании резервной копии.';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsBackupHowItWorks => 'КАК ЭТО РАБОТАЕТ?';

  @override
  String get settingsBackupHowItWorksBody =>
      'Резервное копирование используется для безопасного переноса всех ваших данных и изображений сканирования на другой телефон.';

  @override
  String get settingsDataInfoTitle => 'ИНФОРМАЦИЯ О ДАННЫХ';

  @override
  String get settingsDataInfoPrivacyTitle => 'Конфиденциальность';

  @override
  String get settingsDataInfoPrivacyBody =>
      'Ваши физические сканы не покидают устройство без вашего ведома (например, пока вы не поделитесь ими в формате PDF).';

  @override
  String get settingsDataInfoNoSyncTitle => 'Нет синхронизации';

  @override
  String get settingsDataInfoNoSyncBody =>
      'Если вы войдете на другом телефоне, вы увидите список сканов, но не сможете просмотреть изображения, так как исходные файлы остались на первом телефоне.';

  @override
  String get settingsDataInfoRiskTitle => 'Риск потери';

  @override
  String get settingsDataInfoRiskBody =>
      'Если вы удалите приложение или очистите данные, ваши сканы будут безвозвратно удалены (если только у вас нет резервной копии всего телефона).';

  @override
  String get settingsOtherSection => 'ПРОЧЕЕ';

  @override
  String get settingsAboutApp => 'О приложении';

  @override
  String get settingsAboutAppBody =>
      'Профессиональный инструмент для сканирования и управления PDF-документами прямо на вашем телефоне.';

  @override
  String get backupSubject => 'Резервная копия MobiScan';

  @override
  String get backupText => 'Моя резервная копия MobiScan';

  @override
  String get sortLatest => 'Сначала новые';

  @override
  String get sortOldest => 'Сначала старые';

  @override
  String get sortNameAZ => 'Имя А-Я';

  @override
  String get sortNameZA => 'Имя Я-А';

  @override
  String get noSearchResultsTitle => 'НЕТ РЕЗУЛЬТАТОВ';

  @override
  String get noSearchResultsBody =>
      'Мы не нашли сканов, соответствующих вашему запросу.';

  @override
  String get pageCountAbbreviation => 'стр';

  @override
  String get deleteButtonLabel => 'Удалить';

  @override
  String get errorTechnicalDifficulties =>
      'Технические проблемы. Пожалуйста, попробуйте позже.';

  @override
  String get okButtonLabel => 'ОК';

  @override
  String get profileSectionAccount => 'ВАША УЧЕТНАЯ ЗАПИСЬ';

  @override
  String get profileSectionOther => 'ПРОЧЕЕ';

  @override
  String get profileSecureDataSubtitle => 'Защитите свои данные';

  @override
  String get profileTemporaryAccountLabel => 'ВРЕМЕННАЯ УЧЕТНАЯ ЗАПИСЬ';

  @override
  String get profileGuestUserLabel => 'Гость';

  @override
  String get restoreFailedMessage => 'Ошибка при восстановлении данных.';

  @override
  String dashboardGreetingName(Object firstName) {
    return 'Привет, $firstName! 👋';
  }

  @override
  String get dashboardWelcomeBack => 'Добро пожаловать в MobiScan';

  @override
  String get dashboardNewScan => 'Новый скан';

  @override
  String get dashboardCaptureDocument => 'Захват документа';

  @override
  String get dashboardScanWithCamera => 'Скан через камеру';

  @override
  String get dashboardStartScanning => 'Начать сканирование';

  @override
  String get dashboardRecentDocuments => 'Последние документы';

  @override
  String get navHome => 'Главная';

  @override
  String get navLibrary => 'Мои сканы';

  @override
  String get navCloud => 'Облако';
}
