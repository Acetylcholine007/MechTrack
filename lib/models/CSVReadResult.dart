import 'package:mech_track/models/Part.dart';

class CSVReadResult {
  List<Part> parts;
  List<String> headers;

  CSVReadResult({this.parts, this.headers});
}