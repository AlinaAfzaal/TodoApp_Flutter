import 'package:sqflite/sqflite.dart';
import 'package:todo_app/database/db_connection.dart';
import 'package:todo_app/model/todoItem.dart';

class TodoDB{
  final tableName = 'todos';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName(
    "id" INTEGER NOT NULL, 
    "title" TEXT NOT NULL, 
    "isCompleted" BOOL DEFAULT 0,
    "reminder" DateTime, 
    PRIMARY KEY ("id" AUTOINCREMENT)
    );""");
  }

  Future<int> create({required String title, DateTime? reminder}) async {
    final database = await DatabaseConnection().database;
    return await database.rawInsert('''INSERT INTO $tableName(title, reminder) VALUES(?, ?, ?)''',
      [title, reminder ]
    );
  }

  Future<List<ToDoItem>> fetchAll() async {
    final database = await DatabaseConnection().database;
    final todos = await database.rawQuery('''SELECT* FROM $tableName''');
    return todos.map((todo) => ToDoItem.fromSqfliteDatabase(todo)).toList();
  }

  Future<ToDoItem> fetchById(int id) async {
    final database = await DatabaseConnection().database;
    final todo= await database.rawQuery('''SELECT* FROM $tableName WHERE id=?''',[id]);
    return ToDoItem.fromSqfliteDatabase(todo.first);
  }


  Future<int> update({required int id,  String? title, DateTime? reminder}) async {
    final database = await DatabaseConnection().database;
    return await database.update(
      tableName,
      {
        if(title!=null) 'title': title,
        if(reminder!=null) 'reminder': reminder,
      },
      where: 'id=?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }
  Future<int> updateCheck({required int id,required bool check}) async {
    final database = await DatabaseConnection().database;
    return await database.update(
      tableName,
      {
        'isCompleted': check ? 1 : 0,
      },
      where: 'id=?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseConnection().database;
    final todo= await database.rawDelete('''DELETE* FROM $tableName WHERE id=?''',[id]);
  }





}