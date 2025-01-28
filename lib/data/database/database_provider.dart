import 'database_schema.dart';

class DatabaseProvider {

  static final AppDatabase _database = AppDatabase();

  static AppDatabase getDatabase() => _database;

}