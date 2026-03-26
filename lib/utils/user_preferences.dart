import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;

  static const _keyFirstName = 'firstName';
  static const _keyLastName = 'lastName';
  static const _keyEmail = 'email';
  static const _keyPhone = 'phone';
  static const _keyBio = 'bio';

  // Email Preferences
  static const _keyDailyReminders = 'dailyReminders';
  static const _keyWeeklyReports = 'weeklyReports';
  static const _keyMonthlyInsights = 'monthlyInsights';
  static const _keyStreakMilestones = 'streakMilestones';
  static const _keyAiCoachUpdates = 'aiCoachUpdates';
  static const _keyProductUpdates = 'productUpdates';
  static const _keyMarketingEmails = 'marketingEmails';

  // Security Settings
  static const _keyTwoFactorAuth = 'twoFactorAuth';
  static const _keyBiometricAuth = 'biometricAuth';
  static const _keyAutoSessionTimeout = 'autoSessionTimeout';

  // Appearance & Settings
  static const _keyReducedMotion = 'reducedMotion';
  static const _keyCompactView = 'compactView';
  static const _keyPushNotifications = 'pushNotifications';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setFirstName(String firstName) async =>
      await _prefs.setString(_keyFirstName, firstName);

  static String getFirstName() => _prefs.getString(_keyFirstName) ?? 'User';

  static Future<void> setLastName(String lastName) async =>
      await _prefs.setString(_keyLastName, lastName);

  static String getLastName() => _prefs.getString(_keyLastName) ?? '';

  static Future<void> setEmail(String email) async =>
      await _prefs.setString(_keyEmail, email);

  static String getEmail() => _prefs.getString(_keyEmail) ?? '';

  static Future<void> setPhone(String phone) async =>
      await _prefs.setString(_keyPhone, phone);

  static String getPhone() => _prefs.getString(_keyPhone) ?? '';

  static Future<void> setBio(String bio) async =>
      await _prefs.setString(_keyBio, bio);

  static String getBio() => _prefs.getString(_keyBio) ?? '';

  // Email Preferences Getter / Setters
  static Future<void> setDailyReminders(bool val) async => await _prefs.setBool(_keyDailyReminders, val);
  static bool getDailyReminders() => _prefs.getBool(_keyDailyReminders) ?? true;

  static Future<void> setWeeklyReports(bool val) async => await _prefs.setBool(_keyWeeklyReports, val);
  static bool getWeeklyReports() => _prefs.getBool(_keyWeeklyReports) ?? true;

  static Future<void> setMonthlyInsights(bool val) async => await _prefs.setBool(_keyMonthlyInsights, val);
  static bool getMonthlyInsights() => _prefs.getBool(_keyMonthlyInsights) ?? true;

  static Future<void> setStreakMilestones(bool val) async => await _prefs.setBool(_keyStreakMilestones, val);
  static bool getStreakMilestones() => _prefs.getBool(_keyStreakMilestones) ?? true;

  static Future<void> setAiCoachUpdates(bool val) async => await _prefs.setBool(_keyAiCoachUpdates, val);
  static bool getAiCoachUpdates() => _prefs.getBool(_keyAiCoachUpdates) ?? false;

  static Future<void> setProductUpdates(bool val) async => await _prefs.setBool(_keyProductUpdates, val);
  static bool getProductUpdates() => _prefs.getBool(_keyProductUpdates) ?? true;

  static Future<void> setMarketingEmails(bool val) async => await _prefs.setBool(_keyMarketingEmails, val);
  static bool getMarketingEmails() => _prefs.getBool(_keyMarketingEmails) ?? false;

  // Security Settings Getter / Setters
  static Future<void> setTwoFactorAuth(bool val) async => await _prefs.setBool(_keyTwoFactorAuth, val);
  static bool getTwoFactorAuth() => _prefs.getBool(_keyTwoFactorAuth) ?? false;

  static Future<void> setBiometricAuth(bool val) async => await _prefs.setBool(_keyBiometricAuth, val);
  static bool getBiometricAuth() => _prefs.getBool(_keyBiometricAuth) ?? true;

  static Future<void> setAutoSessionTimeout(bool val) async => await _prefs.setBool(_keyAutoSessionTimeout, val);
  static bool getAutoSessionTimeout() => _prefs.getBool(_keyAutoSessionTimeout) ?? true;

  // Appearance & General Settings Getter / Setters
  static Future<void> setReducedMotion(bool val) async => await _prefs.setBool(_keyReducedMotion, val);
  static bool getReducedMotion() => _prefs.getBool(_keyReducedMotion) ?? false;

  static Future<void> setCompactView(bool val) async => await _prefs.setBool(_keyCompactView, val);
  static bool getCompactView() => _prefs.getBool(_keyCompactView) ?? false;

  static Future<void> setPushNotifications(bool val) async => await _prefs.setBool(_keyPushNotifications, val);
  static bool getPushNotifications() => _prefs.getBool(_keyPushNotifications) ?? true;
}
