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

  Future<LocalPart> getPart(String pid) async {
    Database db = await database;
    List<Map<String, Object>> maps = await db.query(
      'parts',
      where: 'pid = ?',
      whereArgs: [pid],
      limit: 1
    );

    if(maps == null || maps.isEmpty)
      return null;

    return LocalPart(
      pid: maps[0]['pid'],
      assetAccountCode: maps[0]['assetAccountCode'],
      process: maps[0]['process'],
      subProcess: maps[0]['subProcess'],
      description: maps[0]['description'],
      type: maps[0]['type'],
      criticality: maps[0]['criticality'],
      status: maps[0]['status'],
      yearInstalled: maps[0]['yearInstalled'],
      description2: maps[0]['description2'],
      brand: maps[0]['brand'],
      model: maps[0]['model'],
      spec1: maps[0]['spec1'],
      spec2: maps[0]['spec2'],
      dept: maps[0]['dept'],
      facility: maps[0]['facility'],
      facilityType: maps[0]['facilityType'],
      sapFacility: maps[0]['sapFacility'],
      criticalByPM: maps[0]['criticalByPM'],
    );
  }

  Future<List<LocalPart>> getParts(String query, String category) async {
    Database db = await database;
    List<Map<String, Object>> maps = await db.query('parts');

    if (query.isNotEmpty) {
      maps = await db.query('parts', where: '$category LIKE ?', whereArgs: ["%$query%"]);
    } else {
      maps = await db.query('parts');
    }

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