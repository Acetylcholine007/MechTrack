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
        batch.execute('CREATE TABLE fields(id INTEGER PRIMARY KEY, fieldKey TEXT, fieldValue TEXT)');
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
    Map<String, String> fields = {'partNo': 'Part No.'};

    maps.forEach((field) => fields[field['fieldKey']] = field['fieldValue']);

    return Field(fields: fields);
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

  Future<LocalDBDataPack> getParts(String query1, String category1, String query2, String category2) async {
    Database db = await database;
    List<Map<String, Object>> maps;

    if (query1.isNotEmpty) {
      maps = await db.query('parts', where: '$category1 LIKE ?', whereArgs: ["%$query1%"]);
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

  Future<ImportResponse> importParts(List<Part> parts, Map<String, String> headers) async {
    Database db = await database;
    String result = '';
    List<Part> duplicateParts = [];
    List<Part> invalidParts = [];
    List<String> headerKeys = headers.keys.toList();
    Batch batch = db.batch();

    headers.remove('partNo');

    batch.rawDelete("DELETE from fields");
    batch.execute("DROP TABLE IF EXISTS parts");
    batch.execute(
      'CREATE TABLE parts('
        'partNo INTEGER PRIMARY KEY,'
        '${headers.keys.map((header) => header + ' TEXT')
        .reduce((a, b) => a + ', ' + b)})'
    );

    for(int index = 0; index < headerKeys.length; index++) {
      batch.insert(
        'fields',
        {'id': index, 'fieldKey': headerKeys[index], 'fieldValue': headers[headerKeys[index]]},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    parts.forEach((part) => batch.insert(
      'parts',
      part.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace)
    );
    await batch.commit()
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