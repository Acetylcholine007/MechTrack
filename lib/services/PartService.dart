import 'package:mech_track/models/Part.dart';

class PartService {
  static Future<List<Part>> getPartSuggestions(String query, List<Part> parts, String selector) async {
  return parts.where((part) => part.fields[selector]
      .toString()
      .toLowerCase()
      .contains(query.toLowerCase())).toList();
  }
}