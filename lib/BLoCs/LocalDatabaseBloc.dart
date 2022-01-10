import 'dart:async';

import 'package:mech_track/models/ImportResponse.dart';
import 'package:mech_track/models/LocalDBDataPack.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/services/LocalDatabaseService.dart';

class PartsBloc {
  String query1;
  String category1;
  String query2;
  String category2;

  PartsBloc(String query1, String category1, String query2, String category2) {
    this.query1 = query1;
    this.category1 = category1;
    this.query2 = query2;
    this.category2 = category2;
    getParts(query1, category1, query2, category2);
  }

  final _partController = StreamController<LocalDBDataPack>.broadcast();

  get localParts => _partController.stream;

  getParts(String query1, String category1, String query2, String category2) async {
    _partController.sink.add(await LocalDatabaseService.db.getParts(query1, category1, query2, category2));
  }

  getPart(String pid) async {
    return await LocalDatabaseService.db.getPart(pid);
  }

  Future<String> addPart(Part part, String action) async {
    String result = '';
    result = await LocalDatabaseService.db.addPart(part, action);
    getParts(query1, category1, query2, category2);
    return result;
  }

  Future<String> editPart(Part part) async {
    String result = '';
    result = await LocalDatabaseService.db.editPart(part);
    getParts(query1, category1, query2, category2);
    return result;
  }

  Future<String> deletePart(String pid) async {
    String result = '';
    result = await LocalDatabaseService.db.deletePart(pid);
    getParts(query1, category1, query2, category2);
    return result;
  }

  Future<String> clearDatabase(String pid) async {
    String result = '';
    result = await LocalDatabaseService.db.clearDatabase();
    getParts(query1, category1, query2, category2);
    return result;
  }

  Future<ImportResponse> importParts(List<Part> parts, Map<String, String> headers) async {
    ImportResponse response;
    response = await LocalDatabaseService.db.importParts(parts, headers);
    getParts(query1, category1, query2, category2);
    return response;
  }

  dispose() {
    _partController.close();
  }
}