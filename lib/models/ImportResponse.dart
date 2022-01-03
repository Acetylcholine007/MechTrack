import 'package:mech_track/models/Part.dart';

class ImportResponse {
  String result;
  List<Part> parts;
  List<Part> invalidIdParts;

  ImportResponse({this.result, this.parts, this.invalidIdParts});
}