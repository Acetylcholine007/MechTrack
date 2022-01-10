import 'dart:async';

import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/ImportResponse.dart';
import 'package:mech_track/models/LocalDBDataPack.dart';
import 'package:mech_track/models/Part.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseService {
  LocalDatabaseService._();

  static final LocalDatabaseService db = LocalDatabaseService._();

  Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'mech_database.db'),
      onCreate: (db, version) {
        Batch batch = db.batch();
        batch.execute(
          'CREATE TABLE parts(partNo INTEGER PRIMARY KEY)'
        );
        batch.execute('CREATE TABLE fields(id INTEGER PRIMARY KEY, field TEXT)');
        return batch.commit();
      },
      version: 1
    );
    return _database;
  }

  Future<Field> getFields() async {
    Database db = await database;
    List<Map<String, Object>> maps = await db.query('fields',
        orderBy: 'id ASC'
    );

    return Field(fields: List.generate(maps.length, (i) {
      return maps[i]['field'];
    }));
  }

  Future<String> addPart(Part part, String action) async {
    String result = '';
    Database db = await database;

    List<Map<String, Object>> maps = await db.query(
        'parts',
        where: 'partNo = ?',
        whereArgs: [part.partNo],
        limit: 1
    );

    if(!(maps == null || maps.isEmpty) && action == 'SAFE')
      return 'EXIST';

    if(action == 'APPEND') {
      part.partNo = null;
    }

    await db.insert(
      'parts',
      part.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> editPart(Part part) async {
    String result = '';
    Database db = await database;
    await db.update(
      'parts',
      part.toMap(),
      where: 'partNo = ?',
      whereArgs: [part.partNo],
    )
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<Part> getPart(String partNo) async {
    Database db = await database;
    List<Map<String, Object>> maps = await db.query(
      'parts',
      where: 'partNo = ?',
      whereArgs: [partNo],
      limit: 1
    );

    if(maps == null || maps.isEmpty)
      return null;

    return Part(
      partNo: maps[0]['partNo'],
      fields: maps[0],
    );
  }

  Future<LocalDBDataPack> getParts(String query, String category) async {
    Database db = await database;
    List<Map<String, Object>> maps = await db.query('parts',
      orderBy: 'partNo ASC'
    );

    if (query.isNotEmpty) {
      maps = await db.query('parts', where: '$category LIKE ?', whereArgs: ["%$query%"]);
    } else {
      maps = await db.query('parts');
    }

    return LocalDBDataPack(parts: List.generate(maps.length, (i) {
      return Part(
        partNo: maps[i]['partNo'],
        fields: maps[i],
      );
    }), hasRecords: await hasRecords(), fields: await getFields());
  }

  Future<String> clearDatabase() async {
    String result = '';
    Database db = await database;

    await db.rawDelete("DELETE * from parts")
    .then((value) => result = "SUCCESS")
    .catchError((error) => result = error.toString());

    return result;
  }

  Future exportParts() async {
    //TODO: get data
    //TODO: write data
    //TODO: save data
  }

  Future<ImportResponse> importParts(List<Part> parts, String action, List<String> headers) async {
    Database db = await database;
    String result = '';
    List<Part> duplicateParts = [];
    List<Part> invalidParts = [];

    //TODO: drop part table
    await db.execute("DROP TABLE IF EXISTS parts");
    await db.rawDelete("DELETE from fields");

    //TODO: create part table
    await db.execute(
        'CREATE TABLE parts('
            'partNo INTEGER PRIMARY KEY,'
            '${headers.map((header) => header + ' TEXT')
            .reduce((a, b) => a + ', ' + b)})'
    );

    //TODO: create field table
    for(int index = 0; index < headers.length; index++) {
      await db.insert(
        'fields',
        {'id': index, 'field': headers[index]},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await Future.wait(parts.map((part) {
      if(part.partNo == null)
        return Future(() => invalidParts.add(part));
      return addPart(part, action).then((value) => value == 'EXIST' ? duplicateParts.add(part) : null);
    }))
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return ImportResponse(result: result, parts: duplicateParts, invalidIdParts: invalidParts);
  }

  Future<bool> hasRecords() async {
    Database db = await database;
    int count = Sqflite
        .firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM parts'));
    return count != 0;
  }

  Future<String> deletePart(String pid) async {
    String result = '';
    Database db = await database;
    await db.delete(
      'parts',
      where: 'partNo = ?',
      whereArgs: [pid],
    )
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }
}