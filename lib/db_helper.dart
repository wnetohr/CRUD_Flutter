import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  //Criando a tabela
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLES data(
      id INTENGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      desc TEXT,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )
""");
  }
  //Iniciando o banco de dados
  static Future<sql.Database> db() async{
    return sql.openDatabase(
      "database_crud.db",
      version: 1,
      onCreate: (sql.Database database, int version) async{
        await createTables(database);
      }
    );
  }
  //CREATE - Criando item no banco de dados
  static Future<int> createDate(String title, String? desc) async{
    final db = await SQLHelper.db();
    final data = {'title': title, 'desc': desc};
    //inserindo item na tabela
    final id = await db.insert('data', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }
  //READ - Mostrando itens
  static Future<List<Map<String, dynamic>>> getItens() async{
    final db = await SQLHelper.db();
    return db.query('data', orderBy: 'id');
  }
  //Get single item
  static Future<List<Map<String, dynamic>>> getSingleItem(int id) async{
    final db = await SQLHelper.db();
    return db.query('data', where: 'id = ?', whereArgs: [id], limit: 1);
  }
  //UPDATE - Atualizando item
  static Future<int> updateItem(int id, String title, String? desc) async{
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'desc': desc,
      'createdAt': DateTime.now().toString()
    };
    final result = await db.update('data', data, where: 'id = ?',whereArgs: [id]);
    return result;
  }
  //DELETE - Removendo item
  static Future<void> deteleItem(int id) async{
    final db = await SQLHelper.db();
    try {
      await db.delete('data', where: 'id = ?', whereArgs: [id]);
    } catch (e) {}
  }
}