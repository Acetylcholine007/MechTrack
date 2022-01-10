import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/Part.dart';

class LocalDBDataPack {
  List<Part> parts;
  bool hasRecords;
  Field fields;

  LocalDBDataPack({this.parts, this.hasRecords, this.fields});
}