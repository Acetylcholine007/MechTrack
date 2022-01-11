import 'package:mech_track/models/Part.dart';

class CSVReadResult {
  List<Part> parts;
  Map<String, String> headers;
  String result;

  CSVReadResult({this.parts, this.headers, this.result});
}