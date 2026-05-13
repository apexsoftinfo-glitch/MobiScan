// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Georgian (`ka`).
class AppLocalizationsKa extends AppLocalizations {
  AppLocalizationsKa([String locale = 'ka']) : super(locale);

  @override
  String get localizationBootstrap =>
      'აპლიკაციის ლოკალიზაცია კონფიგურირებულია.';

  @override
  String get errorInvalidCredentials => 'არასწორი ელფოსტა ან პაროლი.';

  @override
  String get errorAnonymousAuthDisabled =>
      'სტუმრის სტატუსით შესვლა ამჟამად გამორთულია.';

  @override
  String get errorEmail => 'შეამოწმეთ ელფოსტა და სცადეთ თავიდან.';

  @override
  String get errorPassword => 'შეამოწმეთ პაროლი და სცადეთ თავიდან.';

  @override
  String get errorNetwork => 'კავშირის პრობლემა. სცადეთ თავიდან.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'ანგარიშის წაშლა საჭიროებს Supabase-ში დაყენების დასრულებას.';

  @override
  String get errorDeleteAccountFailed =>
      'ანგარიშის წაშლა ვერ მოხერხდა. სცადეთ თავიდან.';

  @override
  String get errorSharedUsersSetupRequired =>
      'აკლია shared_users ცხრილი ან მისი სქემა არ შეესაბამება შაბლონს.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'ანგარიშის წაშლა ჯერ არ არის მზად.';

  @override
  String get errorUnknown => 'მოხდა მოულოდნელი შეცდომა.';

  @override
  String errorWithKey(Object errorKey) {
    return 'მოხდა შეცდომა: $errorKey';
  }

  @override
  String get guestDisplayName => 'სტუმარი';

  @override
  String get registeredUserDisplayName => 'მომხმარებელი';

  @override
  String get loadingLabel => 'იტვირთება...';

  @override
  String get sessionErrorTitle => 'სესიის შეცდომა';

  @override
  String get accountTypeGuest => 'სტუმარი';

  @override
  String get accountTypeRegistered => 'რეგისტრირებული';

  @override
  String get commonYes => 'დიახ';

  @override
  String get commonNo => 'არა';

  @override
  String get userTierGuest => 'სტუმარი';

  @override
  String get userTierRegistered => 'ანგარიში';

  @override
  String get userTierPro => 'Pro';

  @override
  String get homeTitle => 'სტარტი';

  @override
  String get currentSessionTitle => 'მიმდინარე სესია';

  @override
  String sessionUserId(Object value) {
    return 'მომხმარებლის ID: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'ანგარიშის ტიპი: $value';
  }

  @override
  String sessionPlan(Object value) {
    return 'გეგმა: $value';
  }

  @override
  String sessionPro(Object value) {
    return 'Pro: $value';
  }

  @override
  String sessionEmail(Object value) {
    return 'ელფოსტა: $value';
  }

  @override
  String sessionDisplayNameValue(Object value) {
    return 'საჩვენებელი სახელი: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'სახელი: $value';
  }

  @override
  String get developerToolsTitle => 'დეველოპერის ხელსაწყოები';

  @override
  String get retryButtonLabel => 'თავიდან ცდა';

  @override
  String get welcomeTitle => 'მოგესალმებით';

  @override
  String get welcomeBody =>
      'გააგრძელეთ როგორც სტუმარი ან შედით არსებულ ანგარიშზე.';

  @override
  String get continueAsGuestButtonLabel => 'გაგრძელება როგორც სტუმარი';

  @override
  String get loginButtonLabel => 'შესვლა';

  @override
  String get loginScreenTitle => 'შესვლა';

  @override
  String get loginExistingAccountTitle => 'შესვლა არსებულ ანგარიშზე';

  @override
  String get loginExistingAccountBody =>
      'გამოიყენეთ თქვენი ელფოსტა და პაროლი არსებულ ანგარიშზე გადასასვლელად.';

  @override
  String get emailFieldLabel => 'ელფოსტა';

  @override
  String get passwordFieldLabel => 'პაროლი';

  @override
  String get switchAccountWarningTitle => 'ანგარიშის შეცვლა';

  @override
  String get switchAccountWarningBody =>
      'აქ შესვლა გადაგიყვანთ თქვენი მიმდინარე სტუმრის ანგარიშიდან სხვა ანგარიშზე. სტუმრის და Pro მონაცემები ავტომატურად არ ერთიანდება.';

  @override
  String get registerScreenTitle => 'რეგისტრაცია';

  @override
  String get secureGuestAccountTitle => 'დაიცავით ეს სტუმრის ანგარიში';

  @override
  String get secureGuestAccountBody =>
      'ეს შეინარჩუნებს თქვენს მიმდინარე მონაცემებს და დააკავშირებს ამ სტუმრის ანგარიშს ელფოსტასთან და პაროლთან.';

  @override
  String get registerButtonLabel => 'რეგისტრაცია';

  @override
  String get profileSavedSnackbar => 'პროფილი შენახულია';

  @override
  String get proEnabledSnackbar => 'Pro გააქტიურებულია';

  @override
  String get passwordUpdatedSnackbar => 'პაროლი შეიცვალა';

  @override
  String get profileTitle => 'პროფილი';

  @override
  String get firstNameFieldLabel => 'სახელი';

  @override
  String get saveFirstNameButtonLabel => 'სახელის შენახვა';

  @override
  String get changePasswordButtonLabel => 'პაროლის შეცვლა';

  @override
  String get newPasswordFieldLabel => 'ახალი პაროლი';

  @override
  String get changePasswordDialogTitle => 'პაროლის შეცვლა';

  @override
  String get changePasswordDialogBody =>
      'შეიყვანეთ ახალი პაროლი თქვენი ანგარიშისთვის.';

  @override
  String get forgotPasswordButtonLabel => 'დაგავიწყდათ პაროლი?';

  @override
  String get passwordResetSentSnackbar =>
      'პაროლის აღდგენის ბმული გამოგზავნილია თქვენს ელფოსტაზე';

  @override
  String get emailEmptyError => 'შეიყვანეთ თქვენი ელფოსტა';

  @override
  String get resetPasswordDialogTitle => 'პაროლის აღდგენა';

  @override
  String get resetPasswordDialogBody =>
      'ჩვენ გამოვაგზავნით პაროლის აღდგენის ბმულს თქვენს ელფოსტაზე.';

  @override
  String get resetPasswordConfirmButtonLabel => 'ბმულის გაგზავნა';

  @override
  String get accountSecuredSnackbar => 'ანგარიში დაცულია';

  @override
  String get logoutButtonLabel => 'გამოსვლა';

  @override
  String get buyProButtonLabel => 'Pro-ს ყიდვა';

  @override
  String get deleteAccountButtonLabel => 'ანგარიშის წაშლა';

  @override
  String get discardChangesTitle => 'გააუქმოთ ცვლილებები?';

  @override
  String get discardChangesBody =>
      'გაქვთ შეუნახავი ცვლილებები. თუ ახლა გახვალთ, ისინი დაიკარგება.';

  @override
  String get stayButtonLabel => 'დარჩენა';

  @override
  String get discardButtonLabel => 'გაუქმება';

  @override
  String get closeButtonLabel => 'დახურვა';

  @override
  String get protectProBannerTitle => 'დაიცავით Pro წვდომა';

  @override
  String get protectProBannerBody =>
      'ამ სტუმრის ანგარიშს უკვე აქვს Pro. დაარეგისტრირეთ ეს ანგარიში, რათა მომავალში არ დაკარგოთ წვდომა.';

  @override
  String get developerDiagnosticsTitle => 'დიაგნოსტიკა (მხოლოდ debug)';

  @override
  String get developerDiagnosticsBody =>
      'გამოიყენეთ ეს ეკრანი აპლიკაციის ლოკალური კონფიგურაციისა და ინტეგრაციის სტატუსის შესამოწმებლად.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat არ არის დაკავშირებული';

  @override
  String get revenueCatDisconnectedBody =>
      'დაამატეთ RevenueCat გასაღებები config/api-keys.json-ში, როცა მზად იქნებით გამოწერების დასატესტად.';

  @override
  String get sessionSectionTitle => 'სესია';

  @override
  String get loggedInLabel => 'შესული';

  @override
  String get anonymousLabel => 'ანონიმური';

  @override
  String get planLabel => 'გეგმა';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'მომხმარებლის ID';

  @override
  String get emailLabel => 'ელფოსტა';

  @override
  String get displayNameLabel => 'საჩვენებელი სახელი';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'გასაღებები კონფიგურირებულია';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'მხარდაჭერილი პლატფორმა';

  @override
  String get sdkActiveLabel => 'SDK აქტიურია';

  @override
  String get currentKeySourceLabel => 'გასაღების მიმდინარე წყარო';

  @override
  String get missingValueLabel => 'არ არის';

  @override
  String get debugForceProTitle => 'Debug: Pro სტატუსის იძულება';

  @override
  String get debugForceProSubtitle =>
      'მუშაობს მხოლოდ აქტიური RevenueCat-ის გარეშე და მხოლოდ debug ხელსაწყოში.';

  @override
  String get missingSupabaseAgentPrompt =>
      'დააკავშირეთ `Supabase MCP` ჩემს Supabase პროექტთან და შეავსეთ `config/api-keys.json` `SUPABASE_URL` და `SUPABASE_ANON_KEY` მნიშვნელობებით.';

  @override
  String get missingSupabaseTitle => 'აკლია Supabase გასაღებები';

  @override
  String get missingSupabaseBody =>
      'დაამატეთ Supabase გასაღებები კონფიგურაციის ფაილში და გადატვირთეთ აპლიკაცია.';

  @override
  String get missingSupabaseFileLabel => 'შეავსეთ ეს ფაილი';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title =>
      'ნაბიჯი 1: დააინსტალირეთ `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'ჯერ დაამატეთ `Supabase MCP` თქვენს AI აგენტს.';

  @override
  String get missingSupabaseStep2Title => 'ნაბიჯი 2: ჩაასვით ეს პრომპტი აგენტს';

  @override
  String get copyPromptButtonLabel => 'პრომპტის კოპირება';

  @override
  String get promptCopiedSnackbar => 'პრომპტი კოპირებულია';

  @override
  String get missingSupabaseStep3Title =>
      'ნაბიჯი 3: დახურეთ და თავიდან გახსენით აპლიკაცია';

  @override
  String get missingSupabaseStep3Body =>
      'როცა აგენტი შეავსებს ფაილს გასაღებებით, დახურეთ აპლიკაცია და გაუშვით თავიდან.';

  @override
  String get sharedUsersAgentPrompt =>
      'გაუშვით დავალება `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` და მოიყვანეთ `shared_users` ცხრილი მინიმალურ შესაბამისობაში ამ პროექტთან `Supabase MCP`-ს გამოყენებით.';

  @override
  String get sharedUsersSetupTitle => 'აკლია `shared_users` ცხრილი Supabase-ში';

  @override
  String get sharedUsersSetupBody =>
      'აპლიკაციას არ შეუძლია მომხმარებლის დამატებითი მონაცემების ჩატვირთვა (მაგალითად, სახელი), რადგან `shared_users` ცხრილი არ არსებობს ან მისი სტრუქტურა არ შეესაბამება მინიმალურ მოთხოვნებს.';

  @override
  String get sharedUsersGuideLabel => 'გამოიყენეთ მოცემული ინსტრუქცია:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle => 'ჩაასვით ეს პრომპტი თქვენს AI აგენტს';

  @override
  String get sharedUsersAiHelpBody =>
      'თუ თქვენს AI აგენტს აქვს წვდომა Supabase MCP-ზე, ის ავტომატურად დააყენებს ყველაფერს მომზადებული ინსტრუქციის მიხედვით.';

  @override
  String get deleteAccountSetupAgentPrompt =>
      'გაუშვით დავალება `docs/tasks/03_SUPABASE_DELETE_ACCOUNT_SETUP.md` და დაასრულეთ `delete-account`-ის დეპლოიმენტი Supabase-ში და დააკავშირეთ პროფილი მზა ფლოუსთან `Supabase MCP`-ს გამოყენებით.';

  @override
  String get deleteAccountSetupTitle =>
      'ანგარიშის წაშლა საჭიროებს დამატებით დაყენებას';

  @override
  String get deleteAccountSetupBody =>
      '`ანგარიშის წაშლის` ლოგიკა უკვე წინასწარ მომზადებულია შაბლონში, მაგრამ `delete-account` ფუნქცია ჯერ არ არის განლაგებული ამ პროექტში და პროფილი კვლავ მიგვიყვანს ამ დაყენების ეკრანზე.';

  @override
  String get deleteAccountGuideLabel => 'გამოიყენეთ მოცემული ინსტრუქცია:';

  @override
  String get deleteAccountGuideFile => '03_SUPABASE_DELETE_ACCOUNT_SETUP.md';

  @override
  String get deleteAccountAiPromptTitle =>
      'ჩაასვით ეს პრომპტი თქვენს AI აგენტს';

  @override
  String get deleteAccountAiHelpBody =>
      'თუ თქვენს AI აგენტს აქვს წვდომა Supabase MCP-ზე, მას შეუძლია განათავსოს `delete-account` ფუნქცია, შეამოწმოს `verify_jwt`, დააკავშიროს პროფილი მზა ფლოუსთან და განაახლოს ტესტები.';

  @override
  String get accountDeletedSnackbar => 'ანგარიში წაშლილია';

  @override
  String get deleteAccountDialogTitle => 'წავშალოთ ანგარიში?';

  @override
  String get deleteAccountDialogBody =>
      'დარწმუნებული ხართ, რომ გსურთ ანგარიშის წაშლა? ამ ოპერაციის გაუქმება შეუძლებელია.';

  @override
  String get deleteDocumentDialogTitle => 'წავშალოთ დოკუმენტი?';

  @override
  String get deleteDocumentDialogBody =>
      'დარწმუნებული ხართ, რომ გსურთ ამ დოკუმენტის წაშლა? ამ ოპერაციის გაუქმება შეუძლებელია.';

  @override
  String get cancelButtonLabel => 'გაუქმება';

  @override
  String get addScanButtonLabel => 'სკანის დამატება';

  @override
  String get noScansTitle => 'სკანები არ არის';

  @override
  String get noScansBody =>
      'დააჭირეთ ქვემოთ მოცემულ ღილაკს სკანირების დასაწყებად.';

  @override
  String get searchScansPlaceholder => 'სკანების ძებნა...';

  @override
  String get documentDetailsTitle => 'დეტალები';

  @override
  String get renameDocumentDialogTitle => 'სახელის შეცვლა';

  @override
  String get exportPdfButtonLabel => 'PDF-ის გაზიარება';

  @override
  String get savingLabel => 'ინახება...';

  @override
  String get generatingPdfLabel => 'გენერირდება PDF...';

  @override
  String get noPagesError => 'დოკუმენტს არ აქვს გვერდები.';

  @override
  String get documentRenamedSnackbar => 'სახელი შეიცვალა';

  @override
  String get errorUnknownKey => 'უცნობი შეცდომა';

  @override
  String get navDashboard => 'პულტი';

  @override
  String get dashboardRecentScans => 'ბოლო სკანები';

  @override
  String get navMyScans => 'ჩემი სკანები';

  @override
  String get navSettings => 'პარამეტრები';

  @override
  String get settingsDarkMode => 'ბნელი თემა';

  @override
  String get dashboardGreeting => 'მოგესალმებით MobiScan-ში';

  @override
  String get dashboardGreetingSubtitle =>
      'სწრაფი სკანირება, რეკლამების გარეშე.';

  @override
  String get dashboardTotalScans => 'სულ სკანები';

  @override
  String get dashboardStartScan => 'ახალი სკანი';

  @override
  String get settingsTitle => 'პარამეტრები';

  @override
  String get settingsProfile => 'ჩემი პროფილი';

  @override
  String get settingsVersion => 'აპლიკაციის ვერსია';

  @override
  String get settingsBackupSection => 'სარეზერვო ასლი';

  @override
  String get settingsCreateBackup => 'ასლის შექმნა';

  @override
  String get settingsRestoreBackup => 'აღდგენა ასლიდან';

  @override
  String get backupSuccessMessage => 'სარეზერვო ასლი წარმატებით შეიქმნა!';

  @override
  String get restoreSuccessMessage => 'მონაცემები წარმატებით აღდგა!';

  @override
  String get backupFailedMessage => 'შეცდომა სარეზერვო ასლის შექმნისას.';

  @override
  String get settingsLanguage => 'ენა';

  @override
  String get settingsBackupHowItWorks => 'როგორ მუშაობს?';

  @override
  String get settingsBackupHowItWorksBody =>
      'სარეზერვო ასლი გამოიყენება თქვენი ყველა მონაცემისა და სკანირების სურათის სხვა ტელეფონზე უსაფრთხოდ გადასატანად.';

  @override
  String get settingsDataInfoTitle => 'ინფორმაცია მონაცემების შესახებ';

  @override
  String get settingsDataInfoPrivacyTitle => 'კონფიდენციალურობა';

  @override
  String get settingsDataInfoPrivacyBody =>
      'თქვენი ფიზიკური სკანები არ ტოვებს მოწყობილობას თქვენი ცოდნის გარეშე (მაგ. სანამ არ გააზიარებთ მათ PDF-ის სახით).';

  @override
  String get settingsDataInfoNoSyncTitle => 'სინქრონიზაციის გარეშე';

  @override
  String get settingsDataInfoNoSyncBody =>
      'თუ სხვა ტელეფონით შეხვალთ, დაინახავთ სკანირების სიას, მაგრამ ვერ შეძლებთ სურათების ნახვას, რადგან საწყისი ფაილები დარჩა პირველ ტელეფონზე.';

  @override
  String get settingsDataInfoRiskTitle => 'დაკარგვის რისკი';

  @override
  String get settingsDataInfoRiskBody =>
      'თუ წაშლით აპლიკაციას ან გაასუფთავებთ მონაცემებს, თქვენი სკანები სამუდამოდ წაიშლება (თუ არ გაქვთ მთელი ტელეფონის სარეზერვო ასლი).';

  @override
  String get settingsOtherSection => 'სხვა';

  @override
  String get settingsAboutApp => 'აპლიკაციის შესახებ';

  @override
  String get settingsAboutAppBody =>
      'პროფესიონალური ინსტრუმენტი PDF დოკუმენტების სკანირებისა და მართვისთვის პირდაპირ თქვენს ტელეფონში.';

  @override
  String get backupSubject => 'MobiScan-ის სარეზერვო ასლი';

  @override
  String get backupText => 'ჩემი MobiScan-ის სარეზერვო ასლი';

  @override
  String get sortLatest => 'უახლესი';

  @override
  String get sortOldest => 'უძველესი';

  @override
  String get sortNameAZ => 'სახელი ა-ჰ';

  @override
  String get sortNameZA => 'სახელი ჰ-ა';

  @override
  String get noSearchResultsTitle => 'შედეგი ვერ მოიძებნა';

  @override
  String get noSearchResultsBody =>
      'თქვენი მოთხოვნის შესაბამისი სკანები ვერ მოიძებნა.';

  @override
  String get pageCountAbbreviation => 'გვ';

  @override
  String get deleteButtonLabel => 'წაშლა';

  @override
  String get errorTechnicalDifficulties =>
      'ტექნიკური ხარვეზი. გთხოვთ, მოგვიანებით სცადოთ.';

  @override
  String get okButtonLabel => 'კარგი';

  @override
  String get profileSectionAccount => 'თქვენი ანგარიში';

  @override
  String get profileSectionOther => 'სხვა';

  @override
  String get profileSecureDataSubtitle => 'დაიცავით თქვენი მონაცემები';

  @override
  String get profileTemporaryAccountLabel => 'დროებითი ანგარიში';

  @override
  String get profileGuestUserLabel => 'სტუმარი';

  @override
  String get restoreFailedMessage => 'შეცდომა მონაცემების აღდგენისას.';

  @override
  String dashboardGreetingName(Object firstName) {
    return 'გამარჯობა, $firstName! 👋';
  }

  @override
  String get dashboardWelcomeBack => 'მოგესალმებით MobiScan-ში';

  @override
  String get dashboardNewScan => 'ახალი სკანი';

  @override
  String get dashboardCaptureDocument => 'დოკუმენტის გადაღება';

  @override
  String get dashboardScanWithCamera => 'სკანირება კამერით';

  @override
  String get dashboardStartScanning => 'სკანირების დაწყება';

  @override
  String get dashboardRecentDocuments => 'ბოლო დოკუმენტები';

  @override
  String get navHome => 'მთავარი';

  @override
  String get navLibrary => 'ჩემი სკანები';

  @override
  String get navCloud => 'ღრუბელი';
}
