import 'package:mech_track/services/DataService.dart';

class Part {
  String partId;
  Map<String, dynamic> fields;

  Part({
    this.partId,
    this.fields
  });

  Part.withHash (Map<String, dynamic> fields) {
    this.fields = fields;
    this.partId = DataService.ds.calculateHash(fields.toString());
  }

  Part.fromLocalDB (Map<String, dynamic> fields) {
    Map<String, dynamic> newFields = fields;
    this.partId = newFields['partId'];
    this.fields = newFields;
  }

  Part copy() => Part(
    partId: this.partId,
    fields: this.fields
  );

  Map<String, dynamic> toMap() {
    return this.fields;
  }

  Map<String, dynamic> toMapLocalImport() {
    return {'partId': this.partId, ...this.fields};
  }

  @override
  String toString() {
    return {'partId': this.partId, ...this.fields}.toString();
  }
}