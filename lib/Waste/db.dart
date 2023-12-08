// import 'package:ecjourney/UserModel.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'dart:io' as io;
//
// class DbHelper {
//   static Database? _db;
//
//   DbHelper._privateConstructor();
//   static final DbHelper instance = DbHelper._privateConstructor();
//
//   static const String DB_Name = 'ECJourney';
//   static const String Table_User = 'User_Info';
//   static const int Version = 9;
//
//   static const String C_UserID = 'User_ID';
//   static const String C_UserGender = 'Gender';
//   static const String C_UserFname = 'First_Name';
//   static const String C_UserLname = 'Last_Name';
//   static const String C_Email = 'Email';
//   static const String C_MobileNum = 'Mobile_Num';
//   static const String C_UserNic = 'NIC_Num';
//   static const String C_UserPassport = 'Passport_Num';
//   static const String C_Password = 'Confirmed_Password';
//
//   Future<Database> get db async {
//     if (_db != null) {
//       return _db!;
//     }
//     _db = await initDb();
//     return _db!;
//   }
//
//   initDb() async {
//     io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, DB_Name);
//     var db = await openDatabase(path, version: Version, onCreate: _onCreate, onUpgrade: onUpgrade);
//     return db;
//   }
//
//   _onCreate(Database db, int intVersion) async {
//     await db.execute('''
//           CREATE TABLE $Table_User (
//           $C_UserID INTEGER PRIMARY KEY,
//           $C_UserGender TEXT,
//           $C_UserFname TEXT,
//           $C_UserLname TEXT,
//           $C_Email TEXT,
//           $C_MobileNum TEXT,
//           $C_UserNic TEXT,
//           $C_UserPassport TEXT,
//           $C_Password TEXT
//           )
//       ''');
//   }
//
//   Future<int> saveData(UserModel user) async {
//     var dbClient = await db;
//     var res = await dbClient.insert(Table_User, user.toMap());
//     return res;
//   }
//
//   Future<UserModel?> getLoginUser(String userEmail, String password) async {
//     var dbClient = await db;
//     var res = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
//         "$C_Email = '$userEmail' AND "
//         "$C_Password = '$password'");
//
//     if (res.length > 0) {
//       return UserModel.fromMap(res.first);
//     }
//
//     return null;
//   }
//
//   Future<bool> getEmail(String email) async {
//     var dbClient = await db;
//     final result = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
//         "$C_Email = '$email'");
//     return result.isNotEmpty;
//   }
//
//   Future<List<Map<String, dynamic>>> queryAll() async {
//     var dbClient = await db;
//     var res = await dbClient.query(Table_User);
//     return res;
//   }
//
//   Future<void> deleteUser() async {
//     final dbClient = await db;
//     final res = await dbClient.delete(Table_User);
//   }
//
//   Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
//     if (oldVersion < newVersion) {
//       //await db.execute('ALTER TABLE $Table_User DROP COLUMN $C_UserFname');
//       await db.execute('''
//           CREATE TABLE $Table_User (
//           $C_UserID INTEGER PRIMARY KEY,
//           $C_UserGender TEXT,
//           $C_UserFname TEXT,
//           $C_UserLname TEXT,
//           $C_Email TEXT,
//           $C_MobileNum TEXT,
//           $C_UserNic TEXT,
//           $C_UserPassport TEXT,
//           $C_Password TEXT
//           )
//       ''');
//
//     }
//   }
/*
// Define the singleton instance of the DatabaseHelper
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;

  }

  _onCreate(Database db, int intVersion) async {
      await db.execute('''
          CREATE TABLE $Table_User (
          $C_UserID INTEGER PRIMARY KEY,
          $C_UserName TEXT, 
          $C_Email TEXT,
          $C_Password TEXT
          )
      ''');
    }

  Future<int> saveData(Map<String,dynamic> row) async {
    var dbClient = await database;
    var res = await dbClient.insert(Table_User, row);
    return res;
  }

  Future<bool> getEmail(String email) async {
    var dbClient = await database;
    final result = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_Email = '$email'");
    return result.isNotEmpty;
  }

  Future<List<Map<String,dynamic>>> queryAll() async{
    var dbClient = await database;
    var res = await dbClient.query(Table_User);
    return res;
  }

  /*Future<int> updateUser(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient.update(Table_User, user.toMap(),
        where: '$C_UserID = ?', whereArgs: [user.user_id]);
    return res;
  }*/

  Future<void> deleteUser() async {
    final String path = join(await getDatabasesPath(), '$Table_User');
    final Database database = await openDatabase(path, version: 1);
    await database.execute('DROP TABLE IF EXISTS $Table_User');

  }
}*/

/*import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'UserModel.dart';
//import 'dart:html';
//import 'package:flutter/foundation.dart' show kIsWeb;

class DatabaseHelper{

  static final DatabaseHelper instance = DatabaseHelper();
  static Database? _db;

  static const String _dbName = 'ECJourney.db';
  static const int _dbVersion =1;

  static const String _tableName = 'UserDetails';
  //static const String _UserID = 'user_id';
  static const String _UserFirstName ='user_firstname';
  static const String _UserEmail = 'email';
  static const String _UserConfirmedPassword = 'password';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    var db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return db;
  }

  /*DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //initialize database
  static Database? _database;
  Future<Database> get database async{
    if(_database!=null) return _database!;

    _database = await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase () async{
    //if (kIsWeb) {
      //return window.location.href;
    //}else{
      Directory directory = await getApplicationDocumentsDirectory();
      String path = join(directory.path, _dbName);
      return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    //}
  }*/

  /*Future<Database> _initiateDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate);
  }*/

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $_tableName ("
        //" $_UserID TEXT, "
        " $_UserFirstName TEXT, "
        " $_UserEmail TEXT,"
        " $_UserConfirmedPassword TEXT, "
        //" PRIMARY KEY ($_UserID)"
        ")");
  }

  Future<int> saveData(UserModel UserDetails) async {
    var dbClient = await db;
    var res = await dbClient.insert(_tableName, UserDetails.toMap());
    return res;
  }

  Future<UserModel> getLoginUser(String userEmail, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $_tableName WHERE "
        "$_UserEmail = '$userEmail' AND "
        "$_UserConfirmedPassword = '$password'");

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }

    return null!;
  }

  /*Future _onCreate(Database db,int version) async{
    db.execute(
      '''
      CREATE TABLE $_tableName(
      $userID INTEGER PRIMARY KEY,
      $userFirstName TEXT NOT NULL,
      $userEmail TEXT NOT NULL,
      $userConfirmedPassword TEXT NOT NULL)
      '''
    );
  }

  Future<int> insert(Map<String,dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String,dynamic>>> queryAll() async{
    Database db = await instance.database;
    return await db.query(_tableName);
  }*/

  static final _databaseName = 'my_database.db';
  static final _databaseVersion = 1;

  static final table = 'my_table';
  static final columnId = '_id';
  static final columnName = 'name';

  // Define the singleton instance of the DatabaseHelper
  static Database? _database;
  static DatabaseHelper? _instance;

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    if (_instance == null) {
      _instance = DatabaseHelper._privateConstructor();
    }
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT
      )
      ''');
  }

  Future<int> insertData(String name) async {
    final db = await database;
    return await db.insert(table, {columnName: name});
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db.query(table);
  }*/
//}
