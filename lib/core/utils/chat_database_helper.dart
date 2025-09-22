import 'package:data_learns_247/features/chatbot/data/models/chat_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDatabaseHelper {
  static final ChatDatabaseHelper _instance = ChatDatabaseHelper._internal();
  factory ChatDatabaseHelper() => _instance;
  ChatDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chats(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT,
        question TEXT,
        chatId TEXT,
        chatMessageId TEXT,
        isStreamValid INTEGER,
        sessionId TEXT,
        memoryType TEXT,
        userId TEXT,
        courseId TEXT
      )
    ''');
  }

  Future<void> insertChat(Chat chat) async {
    final db = await database;
    await db.insert(
      'chats',
      chat.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Chat>> getChatsByUserAndCourse(String userId, String courseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chats',
      where: 'userId = ? AND courseId = ?',
      whereArgs: [userId, courseId],
    );

    return List.generate(maps.length, (i) {
      return Chat.fromJson(maps[i]);
    });
  }

  Future<void> clearChats() async {
    final db = await database;
    await db.delete('chats');
  }
}