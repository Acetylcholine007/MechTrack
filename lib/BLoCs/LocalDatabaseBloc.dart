import 'dart:async';

import 'package:mech_track/models/LocalPart.dart';
import 'package:mech_track/services/LocalDatabaseService.dart';

class PartsBloc {
  String query;
  String category;

  PartsBloc(String query, String category) {
    this.query = query;
    this.category = category;
    getParts(query, category);
  }

  final _partController = StreamController<List<LocalPart>>.broadcast();

  get localParts => _partController.stream;

  getParts(String query, String category) async {
    _partController.sink.add(await LocalDatabaseService.db.getParts(query, category));
  }

  getPart(String pid) async {
    return await LocalDatabaseService.db.getPart(pid);
  }

  addPart(LocalPart part) async {
    await LocalDatabaseService.db.addPart(part);
    getParts(query, category);
  }

  editPart(LocalPart part) async {
    await LocalDatabaseService.db.editPart(part);
    getParts(query, category);
  }

  deletePart(String pid) async {
    await LocalDatabaseService.db.deletePart(pid);
    getParts(query, category);
  }

  dispose() {
    _partController.close();
  }
}