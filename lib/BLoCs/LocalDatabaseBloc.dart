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
    getParts();
  }

  final _partController = StreamController<LocalDBDataPack>.broadcast();

  get localParts => _partController.stream;

  getParts() async {
    _partController.sink.add(await LocalDatabaseService.db.getParts());
  }

  getPart(String pid) async {
    return await LocalDatabaseService.db.getPart(pid);
  }

  Future<String> addPart(Part part, String action) async {
    String result = '';
    result = await LocalDatabaseService.db.addPart(part, action);
    getParts();
    return result;
  }

  Future<String> editPart(Part part) async {
    String result = '';
    result = await LocalDatabaseService.db.editPart(part);
    getParts();
    return result;
  }

  Future<String> deletePart(String pid) async {
    String result = '';
    result = await LocalDatabaseService.db.deletePart(pid);
    getParts();
    return result;
  }

  Future<String> clearDatabase(String pid) async {
    String result = '';
    result = await LocalDatabaseService.db.clearDatabase();
    getParts();
    return result;
  }

  Future<ImportResponse> importParts(List<Part> parts, Map<String, String> headers) async {
    ImportResponse response;
    response = await LocalDatabaseService.db.importParts(parts, headers);
    getParts();
    return response;
  }

  dispose() {
    _partController.close();
  }
}