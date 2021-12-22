import 'dart:async';

import 'package:mech_track/models/LocalPart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseService {
  LocalDatabaseService._();

  static final LocalDatabaseService db = LocalDatabaseService._();

  Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'part_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE parts('
            'pid TEXT PRIMARY KEY,'
            'assetAccountCode TEXT,'
            'process TEXT,'
            'subProcess TEXT,'
            'description TEXT,'
            'type TEXT,'
            'criticality TEXT,'
            'status TEXT,'
            'yearInstalled TEXT,'
            'description2 TEXT,'
            'brand TEXT,'
            'model TEXT,'
            'spec1 TEXT,'
            'spec2 TEXT,'
            'dept TEXT,'
            'facility TEXT,'
            'facilityType TEXT,'
            'sapFacility TEXT,'
            'criticalByPM TEXT)'
        );
      },
      version: 1
    );
    return _database;
  }

  Future addPart(LocalPart part) async {
    Database db = await database;
    await db.insert(
      'parts',
      part.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Complete');
  }

  Future editPart(LocalPart part) async {
    Database db = await database;
    await db.update(
      'parts',
      part.toMap(),
      where: 'pid = ?',
      whereArgs: [part.pid],
    );
  }

  Future<List<LocalPart>> getParts() async {
    Database db = await database;
    List<Map<String, Object>> maps = await db.query('parts');

    return List.generate(maps.length, (i) {
      return LocalPart(
        pid: maps[i]['pid'],
        assetAccountCode: maps[i]['assetAccountCode'],
        process: maps[i]['process'],
        subProcess: maps[i]['subProcess'],
        description: maps[i]['description'],
        type: maps[i]['type'],
        criticality: maps[i]['criticality'],
        status: maps[i]['status'],
        yearInstalled: maps[i]['yearInstalled'],
        description2: maps[i]['description2'],
        brand: maps[i]['brand'],
        model: maps[i]['model'],
        spec1: maps[i]['spec1'],
        spec2: maps[i]['spec2'],
        dept: maps[i]['dept'],
        facility: maps[i]['facility'],
        facilityType: maps[i]['facilityType'],
        sapFacility: maps[i]['sapFacility'],
        criticalByPM: maps[i]['criticalByPM'],
      );
    });
  }

  Future deletePart(String pid) async {
    Database db = await database;
    await db.delete(
      'parts',
      where: 'pid = ?',
      whereArgs: [pid],
    );
  }
}