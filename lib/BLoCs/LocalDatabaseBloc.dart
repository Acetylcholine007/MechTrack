import 'dart:async';

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

  final _partController = StreamController<List<Part>>.broadcast();

  get localParts => _partController.stream;

  getParts(String query, String category) async {
    _partController.sink.add(await LocalDatabaseService.db.getParts(query, category));
  }

  getPart(String pid) async {
    return await LocalDatabaseService.db.getPart(pid);
  }

  addPart(Part part) async {
    await LocalDatabaseService.db.addPart(part);
    getParts(query, category);
  }

  editPart(Part part) async {
    await LocalDatabaseService.db.editPart(part);
    getParts(query, category);
  }

  deletePart(String pid) async {
    await LocalDatabaseService.db.deletePart(pid);
    getParts(query, category);
  }

  importParts(List<Part> parts) async {
    await LocalDatabaseService.db.importParts(parts);
    getParts(query, category);
  }

  dispose() {
    _partController.close();
  }
}