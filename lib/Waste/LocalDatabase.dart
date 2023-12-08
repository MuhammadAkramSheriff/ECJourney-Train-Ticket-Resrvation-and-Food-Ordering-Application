// import 'package:ecjourney/UserModel/UserDetailsModel.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
//
// Future<Database> initDatabase() async {
//   final databasePath = await getDatabasesPath();
//   final path = join(databasePath, 'App User Details');
//   return await openDatabase(path, version: 1, onCreate: (db, version) async {
//     await db.execute('''
//       CREATE TABLE Users(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         FirstName TEXT,
//         LastName TEXT,
//         Email TEXT,
//         MobileNumber TEXT,
//         NICNumber TEXT,
//         PassportNumber TEXT
//       )
//     ''');
//   });
// }
//
// Future<int> insertUser(UserDetailsModel user) async {
//   final Database db = await initDatabase();
//   final res = await db.insert('Users',
//     user.toMap());
//    return res;
// }

// Future<UserDetailsModel> getUserByEmail(String email) async {
//   final Database db = await initDatabase();
//   final List<Map<String, dynamic>> maps = await db.query(
//     'Users',
//     where: 'Email = ?',
//     whereArgs: [email],
//   );
//
//   if (maps.isNotEmpty) {
//     return UserDetailsModel.fromMap(maps.first);
//   } else {
//     throw Exception('User not found');
//   }
// }

// Future<UserDetailsModel?> getUserByEmail(String userEmail) async {
//   final Database db = await initDatabase();
//     var res = await db.rawQuery("SELECT * FROM Users WHERE "
//         "Email = '$userEmail'");
//
//     if (res.length > 0) {
//       return UserDetailsModel.fromMap(res.first);
//     }
//
//     return null;
//   }