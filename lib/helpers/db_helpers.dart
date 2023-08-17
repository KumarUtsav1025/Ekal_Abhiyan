// class DBHelper {
//   static Future<void> insert(String table, Map<String, Object> data) async {
//     final dbPath = sql.getDatabasesPath();

//     sql.openDatabase(
//       path.join(dbPath, 'ClassInformation.db'),
//       onCreate: (db, version) {
//         return db.execute('CREATE TABLE class_information(id TEXT PRIMARY KEY, )');
//       },
//       version: 1,
//     );
//   }
// }
