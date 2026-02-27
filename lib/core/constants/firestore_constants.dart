class FirestoreConstants {
  FirestoreConstants._();

  static const String usersCollection = 'users';
  static const String categoriesCollection = 'categories';
  static const String transactionsCollection = 'transactions';

  // User fields
  static const String fieldEmail = 'email';
  static const String fieldCreatedAt = 'createdAt';

  // Category fields
  static const String fieldName = 'name';
  static const String fieldIcon = 'icon';

  // Transaction fields
  static const String fieldAmount = 'amount';
  static const String fieldType = 'type';
  static const String fieldCategoryId = 'categoryId';
  static const String fieldDate = 'date';
  static const String fieldNote = 'note';
  static const String fieldReceiptUrl = 'receiptUrl';
}