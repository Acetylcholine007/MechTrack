import 'package:mech_track/models/Part.dart';

class ImportResponse {
  String result;
  List<Part> parts;

  ImportResponse({this.result, this.parts});
}