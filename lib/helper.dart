import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  // Folder Table
  static const folderTable = 'folders';
  static const folderId = 'id';
  static const folderName = 'name';
  static const folderTimestamp = 'timestamp';

  // Card Table
  static const cardTable = 'cards';
  static const cardId = 'id';
  static const cardName = 'name';
  static const cardSuit = 'suit';
  static const cardImage = 'image_url';
  static const cardFolderId = 'folder_id';
  late Database _db;
  // this opens the database (and creates it if it doesn't exist)
  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE $folderTable (
$folderId INTEGER PRIMARY KEY,
$folderName TEXT NOT NULL,
$folderTimestamp INTEGER NOT NULL
)
''');
    await db.execute('''
CREATE TABLE $cardTable (
$cardId INTEGER PRIMARY KEY,
$cardName TEXT NOT NULL,
$cardSuit INTEGER NOT NULL
$cardImage TEXT
$cardFolderId INTEGER
   )
    ''');
  }

  // Helper methods
  // Inserts a row in the database where each key in the
  //Map is a column name
  // and the value is the column value. The return value
  //is the id of the
  // inserted row.

  Future<int> insertFolder(Map<String, dynamic> row) async {
    return await _db.insert(folderTable, row);
  }

  Future<int?> insertCard(Map<String, dynamic> row) async {
    int folderId = row[cardFolderId];
    int count = await _countCardsInFolder(folderId);

    if (count >= 6) {
      return null; // Prevent adding more than 6 cards
    }

    return await _db.insert(cardTable, row);
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    return await _db.query(folderTable);
  }

  Future<List<Map<String, dynamic>>> getCardsInFolder(int folderId) async {
    return await _db.query(
      cardTable,
      where: '$cardFolderId = ?',
      whereArgs: [folderId],
    );
  }

  Future<int> _countCardsInFolder(int folderId) async {
    final results = await _db.rawQuery(
      'SELECT COUNT(*) FROM $cardTable WHERE $cardFolderId = ?',
      [folderId],
    );
    return Sqflite.firstIntValue(results) ?? 0;
  }
  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.

  Future<int> deleteCard(int id) async {
    return await _db.delete(cardTable, where: '$cardId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    return await _db.delete(cardTable, where: '$folderId = ?', whereArgs: [id]);
  }
}
