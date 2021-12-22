import 'dart:async';

import 'package:mech_track/models/LocalPart.dart';
import 'package:mech_track/services/LocalDatabaseService.dart';

class PartsBloc {
  PartsBloc() {
    getParts();
  }

  final _partController = StreamController<List<LocalPart>>.broadcast();

  get localParts => _partController.stream;

  getParts() async {
    _partController.sink.add(await LocalDatabaseService.db.getParts());
  }

  addPart(LocalPart part) async {
    await LocalDatabaseService.db.addPart(part);
    getParts();
  }

  editPart(LocalPart part) async {
    await LocalDatabaseService.db.editPart(part);
    getParts();
  }

  deletePart(String pid) async {
    await LocalDatabaseService.db.deletePart(pid);
    getParts();
  }

  dispose() {
    _partController.close();
  }
}