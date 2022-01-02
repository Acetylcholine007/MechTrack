import 'dart:async';

import 'package:mech_track/models/ImportResponse.dart';
import 'package:mech_track/models/LocalDBDataPack.dart';
import 'package:mech_track/models/Part.dart';
import 'package:mech_track/services/LocalDatabaseService.dart';

class PartsBloc {
  String query;
  String category;

  PartsBloc(String query, String category) {
    this.query = query;
    this.category = category;
    getParts(query, category);
  }

  final _partController = StreamController<LocalDBDataPack>.broadcast();

  get localParts => _partController.stream;

  getParts(String query, String category) async {
    _partController.sink.add(await LocalDatabaseService.db.getParts(query, category));
  }

  getPart(String pid) async {
    return await LocalDatabaseService.db.getPart(pid);
  }

  Future<String> addPart(Part part, String action) async {
    String result = '';
    result = await LocalDatabaseService.db.addPart(part, action);
    getParts(query, category);
    return result;
  }

  Future<String> editPart(Part part) async {
    String result = '';
    result = await LocalDatabaseService.db.editPart(part);
    getParts(query, category);
    return result;
  }

  Future<String> deletePart(String pid) async {
    String result = '';
    result = await LocalDatabaseService.db.deletePart(pid);
    getParts(query, category);
    return result;
  }

  Future<ImportResponse> importParts(List<Part> parts, String action) async {
    ImportResponse response;
    response = await LocalDatabaseService.db.importParts(parts, action);
    getParts(query, category);
    return response;
  }

  dispose() {
    _partController.close();
  }
}