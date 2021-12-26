import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Part.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();

  // final String uid;
  // DatabaseService({this.uid});

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
      criticalByPM: snapshot.get('criticalByPM') ?? '',
    );
  }

  List<Part> _partListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Part(
        pid: doc.id,
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
    return partCollection
      .doc(pid).delete()
      .then((value) => print('Part Removed'))
      .catchError((error) => print('Failed to remove part'));
  }

  Future<String> addPart(Part part) async {
    String partId = '';
    await partCollection
    .add({
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
    .then((value) {
      partId = value.id;
      print('Part ${value.id} created');
    })
    .catchError((error) => print('Failed to add part'));
    return partId;
  }

  Future<String> editPart(Part part) async {
    await partCollection.doc(part.pid)
    .update({
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
    .then((value) {
      print('Part ${part.pid} edited');
    })
    .catchError((error) => print('Failed to edit part'));
    return part.pid;
  }

  Future<Part> getPart(String pid) async {
    Part part;
    await partCollection.doc(pid).get()
      .then((DocumentSnapshot snapshot) => part = _partFromSnapshot(snapshot))
      .catchError((error) {print('Failed to get part');});
    return part;
  }

  Future createAccount(AccountData person, String email, String uid) async {
    return await userCollection.doc(uid).set({
      'fullName': person.fullName,
      'username': person.username,
      'accountType': 'EMPLOYEE',
      'isVerified': true,
      'email': email
    })
      .then((value) => print('User data created'))
      .catchError((error) => print('Failed to create user data'));
  }

  Future editAccount(String fullName, String username, String uid) async {
    String result = '';
    await userCollection.doc(uid).update({
      'fullName': fullName,
      'username': username
    })
        .catchError((error) => result = error.toString());
    return result;
  }

  Future promoteAccount(String uid, String accountType) async {
    String result = '';
    await userCollection.doc(uid).update({
      'accountType': accountType,
    })
        .catchError((error) => result = error.toString());
    return result;
  }

  Future verifyAccount(String uid, bool isVerified) async {
    String result = '';
    await userCollection.doc(uid).update({
      'isVerified': isVerified
    })
        .catchError((error) => result = error.toString());
    return result;
  }
  
  Future importParts(List<Part> parts) async {
    String result = '';
    await Future.wait(parts.map((part) => addPart(part)));
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
    return userCollection.snapshots().map(_accountListFromSnapshot);
  }
  //
  Stream<List<Part>> get parts {
    return partCollection.snapshots().map(_partListFromSnapshot);
  }
}