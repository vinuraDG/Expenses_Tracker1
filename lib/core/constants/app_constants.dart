class AppConstants {
  AppConstants._();

  static const String appName = 'Expense Tracker';

  static const String cloudinaryCloudName = 'dehlzylna';
  static const String cloudinaryUploadPreset = 'expense_unsigned';
  static const String cloudinaryUploadUrl =
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  // Transaction types
  static const String income = 'income';
  static const String expense = 'expense';

  //  category icons
  static const List<String> categoryIcons = [
    '🍔', '🚗', '🏠', '💊', '🎮', '✈️',
    '👗', '📚', '💼', '🎁', '💡', '🏋️',
  ];
}