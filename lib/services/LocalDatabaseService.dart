import 'dart:async';

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
      join(await getDatabasesPath(), 'part_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE parts('
            'partNo INTEGER PRIMARY KEY,'
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
    }), hasRecords: await hasRecords());
  }

  Future<ImportResponse> importParts(List<Part> parts, String action) async {
    String result = '';
    List<Part> duplicateParts = [];
    List<Part> invalidParts = [];

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