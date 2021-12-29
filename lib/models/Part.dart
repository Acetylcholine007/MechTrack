class Part {
  String pid;
  String partNo;
  String assetAccountCode;
  String process;
  String subProcess;
  String description;
  String type;
  String criticality;
  String status;
  String yearInstalled;
  String description2;
  String brand;
  String model;
  String spec1;
  String spec2;
  String dept;
  String facility;
  String facilityType;
  String sapFacility;
  String criticalByPM;

  Part({
    this.pid = '',
    this.partNo = "",
    this.assetAccountCode = '',
    this.process = '',
    this.subProcess = '',
    this.description = '',
    this.type = '',
    this.criticality = '',
    this.status = '',
    this.yearInstalled = '',
    this.description2 = '',
    this.brand = '',
    this.model = '',
    this.spec1 = '',
    this.spec2 = '',
    this.dept = '',
    this.facility = '',
    this.facilityType = '',
    this.sapFacility = '',
    this.criticalByPM = '',
  });

  Part copy() => Part(
    pid: this.pid,
    partNo: this.partNo,
    assetAccountCode: this.assetAccountCode,
    process: this.process,
    subProcess: this.subProcess,
    description: this.description,
    type: this.type,
    criticality: this.criticality,
    status: this.status,
    yearInstalled: this.yearInstalled,
    description2: this.description2,
    brand: this.brand,
    model: this.model,
    spec1: this.spec1,
    spec2: this.spec2,
    dept: this.dept,
    facility: this.facility,
    facilityType: this.facilityType,
    sapFacility: this.sapFacility,
    criticalByPM: this.criticalByPM,
  );

  Map<String, String> toMap() {
    return {
      'pid': this.pid,
      'partNo': this.partNo,
      'assetAccountCode': this.assetAccountCode,
      'process': this.process,
      'subProcess': this.subProcess,
      'description': this.description,
      'type': this.type,
      'criticality': this.criticality,
      'status': this.status,
      'yearInstalled': this.yearInstalled,
      'description2': this.description2,
      'brand': this.brand,
      'model': this.model,
      'spec1': this.spec1,
      'spec2': this.spec2,
      'dept': this.dept,
      'facility': this.facility,
      'facilityType': this.facilityType,
      'sapFacility': this.sapFacility,
      'criticalByPM': this.criticalByPM,
    };
  }

  @override
  String toString() {
    return 'Part{'
      'pid: $pid, '
      'partNo: $partNo, '
      'assetAccountCode: $assetAccountCode,'
      'process: $process,'
      'subProcess: $subProcess,'
      'description: $description,'
      'type: $type,'
      'criticality: $criticality,'
      'status: $status,'
      'yearInstalled: $yearInstalled,'
      'description2: $description2,'
      'brand: $brand,'
      'model: $model,'
      'spec1: $spec1,'
      'spec2: $spec2,'
      'dept: $dept,'
      'facility: $facility,'
      'facilityType: $facilityType,'
      'sapFacility: $sapFacility,'
      'criticalityByPM: $criticalByPM}';
  }
}