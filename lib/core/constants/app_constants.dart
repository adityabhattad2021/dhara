class AppConstants {
  static const String appName = 'Dhara';
  static const String baseUrl = 'https://api.dhara.app';
  
  // API Endpoints
  static const String parseExpenseEndpoint = '/parse-expense';
  static const String syncMessagesEndpoint = '/sync-messages';
  static const String chatEndpoint = '/chat';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String lastSyncKey = 'last_sync';
  
  // Floor Database
  static const String databaseName = 'dhara_database.db';
  static const int databaseVersion = 1;
}