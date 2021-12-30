import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Part.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference partCollection = FirebaseFirestore.instance.collection('parts');

  //MAPPING FUNCTION SECTION
  AccountData _accountFromSnapshot(DocumentSnapshot snapshot) {
    return AccountData(
      uid: snapshot.id,
      fullName: snapshot.get('fullName') ?? '',
      username: snapshot.get('username') ?? '',
      accountType: snapshot.get('accountType') ?? '',
      email: snapshot.get('email') ?? '',
      isVerified: snapshot.get('isVerified') ?? ''
    );
  }

  Part _partFromSnapshot(DocumentSnapshot snapshot) {
    return Part(
      pid: snapshot.id,
      partNo: snapshot.get('partNo') ?? '',
      assetAccountCode: snapshot.get('assetAccountCode') ?? '',
      process: snapshot.get('process') ?? '',
      subProcess: snapshot.get('subProcess') ?? '',
      description: snapshot.get('description') ?? '',
      type: snapshot.get('type') ?? '',
      criticality: snapshot.get('criticality') ?? '',
      status: snapshot.get('status') ?? '',
      yearInstalled: snapshot.get('yearInstalled') ?? '',
      description2: snapshot.get('description2') ?? '',
      brand: snapshot.get('brand') ?? '',
      model: snapshot.get('model') ?? '',
      spec1: snapshot.get('spec1') ?? '',
      spec2: snapshot.get('spec2') ?? '',
      dept: snapshot.get('dept') ?? '',
      facility: snapshot.get('facility') ?? '',
      facilityType: snapshot.get('facilityType') ?? '',
      sapFacility: snapshot.get('sapFacility') ?? '',
      criticalByPM: snapshot.get('criticalByPM') ?? '',
    );
  }

  List<Part> _partListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Part(
        pid: doc.id,
        partNo: doc.get('partNo') ?? '',
        assetAccountCode: doc.get('assetAccountCode') ?? '',
        process: doc.get('process') ?? '',
        subProcess: doc.get('subProcess') ?? '',
        description: doc.get('description') ?? '',
        type: doc.get('type') ?? '',
        criticality: doc.get('criticality') ?? '',
        status: doc.get('status') ?? '',
        yearInstalled: doc.get('yearInstalled') ?? '',
        description2: doc.get('description2') ?? '',
        brand: doc.get('brand') ?? '',
        model: doc.get('model') ?? '',
        spec1: doc.get('spec1') ?? '',
        spec2: doc.get('spec2') ?? '',
        dept: doc.get('dept') ?? '',
        facility: doc.get('facility') ?? '',
        facilityType: doc.get('facilityType') ?? '',
        sapFacility: doc.get('sapFacility') ?? '',
        criticalByPM: doc.get('criticalByPM') ?? '',
      );
    }).toList();
  }

  List<AccountData> _accountListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AccountData(
        uid: doc.id,
        fullName: doc.get('fullName') ?? '',
        username: doc.get('username') ?? '',
        accountType: doc.get('accountType') ?? '',
        email: doc.get('email') ?? '',
        isVerified: doc.get('isVerified') ?? ''
      );
    }).toList();
  }

  // OPERATOR FUNCTIONS SECTION
  Future removePart(String pid) async {
    String result = '';
    await partCollection
      .doc(pid).delete()
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> addPart(Part part) async {
    String result = '';
    await partCollection
      .doc(part.pid).set({
        'partNo': part.partNo,
        'assetAccountCode': part.assetAccountCode,
        'process': part.process,
        'subProcess': part.subProcess,
        'description': part.description,
        'type': part.type,
        'criticality': part.criticality,
        'status': part.status,
        'yearInstalled': part.yearInstalled,
        'description2': part.description2,
        'brand': part.brand,
        'model': part.model,
        'spec1': part.spec1,
        'spec2': part.spec2,
        'dept': part.dept,
        'facility': part.facility,
        'facilityType': part.facilityType,
        'sapFacility': part.sapFacility,
        'criticalByPM': part.criticalByPM,
      })
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> editPart(Part part) async {
    String result = '';
    await partCollection.doc(part.pid)
    .update({
      'partNo': part.partNo,
      'assetAccountCode': part.assetAccountCode,
      'process': part.process,
      'subProcess': part.subProcess,
      'description': part.description,
      'type': part.type,
      'criticality': part.criticality,
      'status': part.status,
      'yearInstalled': part.yearInstalled,
      'description2': part.description2,
      'brand': part.brand,
      'model': part.model,
      'spec1': part.spec1,
      'spec2': part.spec2,
      'dept': part.dept,
      'facility': part.facility,
      'facilityType': part.facilityType,
      'sapFacility': part.sapFacility,
      'criticalByPM': part.criticalByPM,
    })
    .then((value) => result = 'SUCCESS')
    .catchError((error) => result = error.toString());
    return result;
  }

  Future<Part> getPart(String pid) async {
    Part part;
    await partCollection.doc(pid).get()
      .then((DocumentSnapshot snapshot) => part = _partFromSnapshot(snapshot))
      .catchError((error) {print('Failed to get part');});
    return part;
  }

  Future createAccount(AccountData person, String email, String uid) async {
    String result = '';
    await userCollection.doc(uid).set({
      'fullName': person.fullName,
      'username': person.username,
      'accountType': 'EMPLOYEE',
      'isVerified': false,
      'email': email
    })
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> editAccount(String fullName, String username, String uid) async {
    String result = '';
    await userCollection.doc(uid).update({
      'fullName': fullName,
      'username': username
    })
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> promoteAccount(String uid, String accountType) async {
    String result = '';
    await userCollection.doc(uid).update({
      'accountType': accountType,
    })
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> verifyAccount(String uid, bool isVerified) async {
    String result = '';
    await userCollection.doc(uid).update({
      'isVerified': isVerified
    })
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }
  
  Future<String> importParts(List<Part> parts) async {
    String result = '';
    await Future.wait(parts.map((part) => addPart(part)))
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  // //GETTER FUNCTIONS

  Future<AccountData> getAccount(String uid) async {
    return userCollection.doc(uid).get().then(_accountFromSnapshot);
  }

  Future<List<AccountData>> getAccounts(List<String> userIds) {
    if(userIds.isNotEmpty) {
      return userCollection.where('__name__', whereIn: userIds).get().then(_accountListFromSnapshot);
    } else {
      return Future(() => <AccountData>[]);
    }
  }

  // //STREAM SECTION

  Stream<AccountData> getUser(String uid) {
    return userCollection.doc(uid).snapshots().map(_accountFromSnapshot);
  }
  //
  Stream<List<AccountData>> get users {
    return userCollection.orderBy("fullName").snapshots().map(_accountListFromSnapshot);
  }
  //
  Stream<List<Part>> get parts {
    return partCollection.orderBy("partNo").snapshots().map(_partListFromSnapshot);
  }
}