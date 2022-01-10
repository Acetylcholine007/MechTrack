import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Field.dart';
import 'package:mech_track/models/ImportResponse.dart';
import 'package:mech_track/models/Part.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService db = DatabaseService._();

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference partCollection = FirebaseFirestore.instance.collection('parts');
  final CollectionReference fieldCollection = FirebaseFirestore.instance.collection('fields');

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
      partNo: int.parse(snapshot.id),
      fields: snapshot.data() ?? {},
    );
  }

  List<Part> _partListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Part(
        partNo: int.parse(doc.id),
        fields: doc.data() ?? {},
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

  Field _fieldFromSnapshot(DocumentSnapshot snapshot) {
    return Field(fields: snapshot.get('fields') ?? []);
  }

  // OPERATOR FUNCTIONS SECTION
  Future<String> setField(List<String> fields) async {
    String result = '';
    await fieldCollection
        .doc('1').set({'fields': fields})
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  Future removePart(String pid) async {
    String result = '';
    await partCollection
      .doc(pid).delete()
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> addPart(Part part, String action) async {
    var doc = await partCollection.doc(part.partNo.toString()).get();
    String docId = part.partNo.toString();
    String result = '';

    if(doc.exists && action == 'SAFE')
      return 'EXIST';

    if(action == 'APPEND') {
      await partCollection
        .orderBy('partNo').limitToLast(1).get()
        .then((QuerySnapshot snapshot) =>
          docId = snapshot.docs.length != 0 ? (_partListFromSnapshot(snapshot)[0].partNo + 1).toString() : 1)
        .catchError((error) {result = error.toString(); print('Failed to get part for append operation');});
    }

    await partCollection
      .doc(docId).set({'partNo': int.parse(docId), ...part.fields})
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> editPart(Part part) async {
    String result = '';
    await partCollection.doc(part.partNo.toString())
    .update({
      'partNo': part.partNo, ...part.fields})
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

  Future<String> clearDatabase() async {
    String result = '';
    final batch = FirebaseFirestore.instance.batch();
    final parts = await partCollection.get();

    for(final part in parts.docs) {
      batch.delete(part.reference);
    }

    await batch.commit()
    .then((value) => result = 'SUCCESS')
    .catchError((error) => result = error.toString());

    return result;
  }

  Future exportParts() async {
    //TODO: get data
    //TODO: write data
    //TODO: save data
  }
  
  Future<ImportResponse> importParts(List<Part> parts, String action) async {
    String result = '';
    List<Part> duplicateParts = [];
    List<Part> invalidParts = [];

    //TODO: delete collection

    if(action == 'APPEND') {
      int lastPartNo = 0;

      await partCollection
          .orderBy('partNo').limitToLast(1).get()
          .then((QuerySnapshot snapshot) =>
      lastPartNo = snapshot.docs.length != 0 ? _partListFromSnapshot(snapshot)[0].partNo + 1 : 1)
          .catchError((error) {result = error.toString(); print('Failed to get part for append operation');});

      await Future.wait(parts.asMap().entries.map((entry) {
        Part part = entry.value;
        print(part.partNo);
        part.partNo = lastPartNo + entry.key;
        print(part.partNo);
        if(part.partNo == null)
          return Future(() => invalidParts.add(part));
        return addPart(part, 'SAFE');
      }))
          .then((value) => result = 'SUCCESS')
          .catchError((error) => result = error.toString());
      return ImportResponse(result: result, parts: duplicateParts, invalidIdParts: invalidParts);
    }

    await Future.wait(parts.map((part) {
      if(part.partNo == null)
        return Future(() => invalidParts.add(part));

      return addPart(part, action).then((value) =>
      value == 'EXIST' ? duplicateParts.add(part) : null);
    }))
      .then((value) => result = 'SUCCESS')
      .catchError((error) => result = error.toString());
    return ImportResponse(result: result, parts: duplicateParts, invalidIdParts: invalidParts);
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

  Stream<List<AccountData>> get users {
    return userCollection.orderBy("fullName").snapshots().map(_accountListFromSnapshot);
  }

  Stream<List<Part>> get parts {
    return partCollection.orderBy("partNo").snapshots().map(_partListFromSnapshot);
  }

  Stream<Field> get fields {
    return fieldCollection.doc('1').snapshots().map(_fieldFromSnapshot);
  }
}