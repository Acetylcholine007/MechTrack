class Part {
  int partNo;
  Map<String, dynamic> fields;

  Part({
    this.partNo,
    this.fields
  });

  Part copy() => Part(
    partNo: this.partNo,
    fields: this.fields
  );

  Map<String, dynamic> toMap() {
    return {'partNo': this.partNo, ...this.fields};
  }

  @override
  String toString() {
    return {'partNo': this.partNo, ...this.fields}.toString();
  }
}