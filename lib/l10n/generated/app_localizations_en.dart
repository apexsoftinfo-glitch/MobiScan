// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localizationBootstrap => 'Application localization is configured.';

  @override
  String get errorInvalidCredentials => 'Invalid email or password.';

  @override
  String get errorAnonymousAuthDisabled => 'Guest login is currently disabled.';

  @override
  String get errorEmail => 'Check your email and try again.';

  @override
  String get errorPassword => 'Check your password and try again.';

  @override
  String get errorNetwork => 'Connection problem. Try again.';

  @override
  String get errorDeleteAccountSetupRequired =>
      'Delete account requires completing setup in Supabase.';

  @override
  String get errorDeleteAccountFailed => 'Failed to delete account. Try again.';

  @override
  String get errorSharedUsersSetupRequired =>
      'Missing shared_users table or its schema does not match the template.';

  @override
  String get errorDeleteAccountNotImplemented =>
      'Account deletion is not yet ready.';

  @override
  String get errorUnknown => 'An unexpected error occurred.';

  @override
  String errorWithKey(Object errorKey) {
    return 'An error occurred: $errorKey';
  }

  @override
  String get guestDisplayName => 'Guest';

  @override
  String get registeredUserDisplayName => 'User';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get sessionErrorTitle => 'Session Error';

  @override
  String get accountTypeGuest => 'guest';

  @override
  String get accountTypeRegistered => 'registered';

  @override
  String get commonYes => 'yes';

  @override
  String get commonNo => 'no';

  @override
  String get userTierGuest => 'guest';

  @override
  String get userTierRegistered => 'account';

  @override
  String get userTierPro => 'Pro';

  @override
  String get homeTitle => 'Start';

  @override
  String get currentSessionTitle => 'Current Session';

  @override
  String sessionUserId(Object value) {
    return 'User ID: $value';
  }

  @override
  String sessionAccountType(Object value) {
    return 'Account Type: $value';
  }

  @override
  String sessionPlan(Object value) {
    return 'Plan: $value';
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
    return 'Display Name: $value';
  }

  @override
  String sessionFirstName(Object value) {
    return 'First Name: $value';
  }

  @override
  String get developerToolsTitle => 'Developer Tools';

  @override
  String get retryButtonLabel => 'Retry';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeBody =>
      'Continue as a guest or log in to an existing account.';

  @override
  String get continueAsGuestButtonLabel => 'Continue as guest';

  @override
  String get loginButtonLabel => 'Log in';

  @override
  String get loginScreenTitle => 'Login';

  @override
  String get loginExistingAccountTitle => 'Log in to existing account';

  @override
  String get loginExistingAccountBody =>
      'Use your email and password to switch to an existing account.';

  @override
  String get emailFieldLabel => 'Email';

  @override
  String get passwordFieldLabel => 'Password';

  @override
  String get switchAccountWarningTitle => 'Switching Account';

  @override
  String get switchAccountWarningBody =>
      'Logging in here will switch you from your current guest account to another account. Guest and Pro data do not merge automatically.';

  @override
  String get registerScreenTitle => 'Registration';

  @override
  String get secureGuestAccountTitle => 'Secure this guest account';

  @override
  String get secureGuestAccountBody =>
      'This will keep your current data and link this guest account with an email and password.';

  @override
  String get registerButtonLabel => 'Register';

  @override
  String get profileSavedSnackbar => 'Profile saved';

  @override
  String get proEnabledSnackbar => 'Pro activated';

  @override
  String get passwordUpdatedSnackbar => 'Password changed';

  @override
  String get profileTitle => 'Profile';

  @override
  String get firstNameFieldLabel => 'First Name';

  @override
  String get saveFirstNameButtonLabel => 'Save first name';

  @override
  String get changePasswordButtonLabel => 'Change password';

  @override
  String get newPasswordFieldLabel => 'New password';

  @override
  String get changePasswordDialogTitle => 'Change password';

  @override
  String get changePasswordDialogBody =>
      'Enter a new password for your account.';

  @override
  String get forgotPasswordButtonLabel => 'Forgot password?';

  @override
  String get passwordResetSentSnackbar =>
      'Password reset link sent to your email';

  @override
  String get emailEmptyError => 'Enter your email';

  @override
  String get resetPasswordDialogTitle => 'Password Recovery';

  @override
  String get resetPasswordDialogBody =>
      'We will send a password reset link to your email address.';

  @override
  String get resetPasswordConfirmButtonLabel => 'Send link';

  @override
  String get accountSecuredSnackbar => 'Account secured';

  @override
  String get logoutButtonLabel => 'Log out';

  @override
  String get buyProButtonLabel => 'Buy Pro';

  @override
  String get deleteAccountButtonLabel => 'Delete account';

  @override
  String get discardChangesTitle => 'Discard changes?';

  @override
  String get discardChangesBody =>
      'You have unsaved changes. If you leave now, they will be lost.';

  @override
  String get stayButtonLabel => 'Stay';

  @override
  String get discardButtonLabel => 'Discard';

  @override
  String get closeButtonLabel => 'Close';

  @override
  String get protectProBannerTitle => 'Secure Pro access';

  @override
  String get protectProBannerBody =>
      'This guest account already has Pro. Register this account to not lose access in the future.';

  @override
  String get developerDiagnosticsTitle => 'Diagnostics (debug only)';

  @override
  String get developerDiagnosticsBody =>
      'Use this screen to check local app configuration and integration status.';

  @override
  String get revenueCatDisconnectedTitle => 'RevenueCat is not connected';

  @override
  String get revenueCatDisconnectedBody =>
      'Add RevenueCat keys to config/api-keys.json when you\'re ready to test subscriptions.';

  @override
  String get sessionSectionTitle => 'Session';

  @override
  String get loggedInLabel => 'Logged in';

  @override
  String get anonymousLabel => 'Anonymous';

  @override
  String get planLabel => 'Plan';

  @override
  String get proLabel => 'Pro';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get emailLabel => 'Email';

  @override
  String get displayNameLabel => 'Display Name';

  @override
  String get supabaseSectionTitle => 'Supabase';

  @override
  String get keysConfiguredLabel => 'Keys configured';

  @override
  String get supabaseUrlLabel => 'Supabase URL';

  @override
  String get revenueCatSectionTitle => 'RevenueCat';

  @override
  String get supportedPlatformLabel => 'Supported platform';

  @override
  String get sdkActiveLabel => 'SDK active';

  @override
  String get currentKeySourceLabel => 'Current key source';

  @override
  String get missingValueLabel => 'none';

  @override
  String get debugForceProTitle => 'Debug: force Pro status';

  @override
  String get debugForceProSubtitle =>
      'Only works without active RevenueCat and only in debug tool.';

  @override
  String get missingSupabaseAgentPrompt =>
      'Connect `Supabase MCP` to my Supabase project and fill `config/api-keys.json` with `SUPABASE_URL` and `SUPABASE_ANON_KEY`.';

  @override
  String get missingSupabaseTitle => 'Missing Supabase keys';

  @override
  String get missingSupabaseBody =>
      'Add Supabase keys to the configuration file and restart the application.';

  @override
  String get missingSupabaseFileLabel => 'Fill this file';

  @override
  String get missingSupabaseFilePath => 'config/api-keys.json';

  @override
  String get missingSupabaseStep1Title => 'Step 1: install `Supabase MCP`';

  @override
  String get missingSupabaseStep1Body =>
      'First add `Supabase MCP` to your AI agent.';

  @override
  String get missingSupabaseStep2Title =>
      'Step 2: paste this prompt to the agent';

  @override
  String get copyPromptButtonLabel => 'Copy prompt';

  @override
  String get promptCopiedSnackbar => 'Prompt copied';

  @override
  String get missingSupabaseStep3Title =>
      'Step 3: close and open the app again';

  @override
  String get missingSupabaseStep3Body =>
      'Once the agent fills the file with keys, close the app and run it again.';

  @override
  String get sharedUsersAgentPrompt =>
      'Run task `docs/tasks/02_SUPABASE_SHARED_USERS_SETUP.md` and bring `shared_users` table to minimal compliance with this project using `Supabase MCP`.';

  @override
  String get sharedUsersSetupTitle =>
      'Missing `shared_users` table in Supabase';

  @override
  String get sharedUsersSetupBody =>
      'The app cannot load additional user data (like name) because the `shared_users` table does not exist or its structure does not match minimum requirements.';

  @override
  String get sharedUsersGuideLabel => 'Use the provided guide:';

  @override
  String get sharedUsersGuideFile => '02_SUPABASE_SHARED_USERS_SETUP.md';

  @override
  String get sharedUsersAiPromptTitle => 'Paste this prompt to your AI agent';

  @override
  String get sharedUsersAiHelpBody =>
      'If your AI agent has access to Supabase MCP, it will set up everything according to the prepared instructions for you automatically.';

  @override
  String get deleteAccountSetupAgentPrompt =>
      'Run task `docs/tasks/03_SUPABASE_DELETE_ACCOUNT_SETUP.md` and complete deployment of `delete-account` in Supabase and link profile to the ready flow using `Supabase MCP`.';

  @override
  String get deleteAccountSetupTitle =>
      'Delete account requires additional setup';

  @override
  String get deleteAccountSetupBody =>
      'The `Delete account` logic is already pre-prepared in the template, but the `delete-account` function has not yet been deployed in this project, and the profile still leads to this setup screen.';

  @override
  String get deleteAccountGuideLabel => 'Use the provided guide:';

  @override
  String get deleteAccountGuideFile => '03_SUPABASE_DELETE_ACCOUNT_SETUP.md';

  @override
  String get deleteAccountAiPromptTitle => 'Paste this prompt to your AI agent';

  @override
  String get deleteAccountAiHelpBody =>
      'If your AI agent has access to Supabase MCP, it can deploy the `delete-account` function, check `verify_jwt`, link the profile to the ready flow, and update tests.';

  @override
  String get accountDeletedSnackbar => 'Account deleted';

  @override
  String get deleteAccountDialogTitle => 'Delete account?';

  @override
  String get deleteAccountDialogBody =>
      'Are you sure you want to delete your account? This operation cannot be undone.';

  @override
  String get deleteDocumentDialogTitle => 'Delete document?';

  @override
  String get deleteDocumentDialogBody =>
      'Are you sure you want to delete this document? This operation cannot be undone.';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get addScanButtonLabel => 'Add scan';

  @override
  String get noScansTitle => 'No scans';

  @override
  String get noScansBody => 'Click the button below to start scanning.';

  @override
  String get searchScansPlaceholder => 'Search scans...';

  @override
  String get documentDetailsTitle => 'Details';

  @override
  String get renameDocumentDialogTitle => 'Rename';

  @override
  String get exportPdfButtonLabel => 'Share PDF';

  @override
  String get savingLabel => 'Saving...';

  @override
  String get generatingPdfLabel => 'Generating PDF...';

  @override
  String get noPagesError => 'Document has no pages.';

  @override
  String get documentRenamedSnackbar => 'Name changed';

  @override
  String get errorUnknownKey => 'Unknown error';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get dashboardRecentScans => 'Recent scans';

  @override
  String get navMyScans => 'My scans';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get dashboardGreeting => 'Welcome to MobiScan';

  @override
  String get dashboardGreetingSubtitle => 'Fast scanning, no ads.';

  @override
  String get dashboardTotalScans => 'Total scans';

  @override
  String get dashboardStartScan => 'New scan';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfile => 'My profile';

  @override
  String get settingsVersion => 'App version';

  @override
  String get settingsBackupSection => 'BACKUP';

  @override
  String get settingsCreateBackup => 'Create backup';

  @override
  String get settingsRestoreBackup => 'Restore from backup';

  @override
  String get backupSuccessMessage => 'Backup created successfully!';

  @override
  String get restoreSuccessMessage => 'Data restored successfully!';

  @override
  String get backupFailedMessage => 'Error while creating backup.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsBackupHowItWorks => 'HOW IT WORKS?';

  @override
  String get settingsBackupHowItWorksBody =>
      'Backup is used to safely transfer all your data and scan images to another phone.';

  @override
  String get settingsDataInfoTitle => 'DATA INFORMATION';

  @override
  String get settingsDataInfoPrivacyTitle => 'Privacy';

  @override
  String get settingsDataInfoPrivacyBody =>
      'Your physical scans do not leave the device without your knowledge (e.g. until you share them as PDF).';

  @override
  String get settingsDataInfoNoSyncTitle => 'No synchronization';

  @override
  String get settingsDataInfoNoSyncBody =>
      'If you log in on another phone, you will see a list of scans, but you won\'t be able to preview the images because the source files remained on the first phone.';

  @override
  String get settingsDataInfoRiskTitle => 'Risk of loss';

  @override
  String get settingsDataInfoRiskBody =>
      'If you uninstall the app or clear data, your scans will be permanently deleted (unless you have a backup of the entire phone).';

  @override
  String get settingsOtherSection => 'OTHER';

  @override
  String get settingsAboutApp => 'About app';

  @override
  String get settingsAboutAppBody =>
      'A professional tool for scanning and managing PDF documents directly on your phone.';

  @override
  String get backupSubject => 'MobiScan Backup';

  @override
  String get backupText => 'My MobiScan backup';

  @override
  String get sortLatest => 'Latest';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get sortNameAZ => 'Name A-Z';

  @override
  String get sortNameZA => 'Name Z-A';

  @override
  String get noSearchResultsTitle => 'NO RESULTS';

  @override
  String get noSearchResultsBody =>
      'We didn\'t find any scans matching your query.';

  @override
  String get pageCountAbbreviation => 'pg';

  @override
  String get deleteButtonLabel => 'Delete';

  @override
  String get errorTechnicalDifficulties =>
      'Technical difficulties. Please try again later.';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get profileSectionAccount => 'YOUR ACCOUNT';

  @override
  String get profileSectionOther => 'OTHER';

  @override
  String get profileSecureDataSubtitle => 'Secure your data';

  @override
  String get profileTemporaryAccountLabel => 'TEMPORARY ACCOUNT';

  @override
  String get profileGuestUserLabel => 'Guest User';

  @override
  String get restoreFailedMessage => 'Error while restoring data.';

  @override
  String dashboardGreetingName(Object firstName) {
    return 'Hello, $firstName! 👋';
  }

  @override
  String get dashboardWelcomeBack => 'Welcome back to MobiScan';

  @override
  String get dashboardNewScan => 'New Scan';

  @override
  String get dashboardCaptureDocument => 'Capture Document';

  @override
  String get dashboardScanWithCamera => 'Scan with Camera';

  @override
  String get dashboardStartScanning => 'Start Scanning';

  @override
  String get dashboardRecentDocuments => 'Recent Documents';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'My Scans';

  @override
  String get navCloud => 'Cloud';
}
