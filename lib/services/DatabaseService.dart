import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/AppTask.dart';
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
    Map<String, dynamic> fields = snapshot.data() ?? {};
    fields.remove('_sortingIndex');
    return Part(
      partId: snapshot.id,
      fields: fields,
    );
  }

  List<Part> _partListFromSnapshot(QuerySnapshot snapshot) {
    snapshot.docs.map((doc) {
      print(doc.data());
    });
    return snapshot.docs.map((doc) {
      Map<String, dynamic> fields = doc.data() ?? {};
      fields.remove('_sortingIndex');
      return Part(
        partId: doc.id,
        fields: fields,
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

  Field _fieldFromSnapshot(QuerySnapshot snapshot) {
    Map<String, String> fields = {};
    snapshot.docs.forEach((doc) => fields[doc.get('fieldKey')] = doc.get('fieldValue'));
    return Field(fields: fields);
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

  Future<String> addPart(Part part, String action) async {
    var doc = await partCollection.doc(part.partId.toString()).get();
    String docId = part.partId;
    String result = '';

    if(doc.exists && action == 'SAFE')
      return 'EXIST';

    int lastPartIndex = (await partCollection.orderBy('_sortingIndex').get()).docs.last.get('_sortingIndex');

    await partCollection
      .doc(docId).set({...part.fields, '_sortingIndex': lastPartIndex + 1})
        .then((value) => result = 'SUCCESS')
        .catchError((error) => result = error.toString());
    return result;
  }

  Future<String> editPart(Part part) async {
    String result = '';
    await partCollection.doc(part.partId)
    .update(part.fields)
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
  
  Future<ImportResponse> importParts(List<Part> oldParts, List<Part> newParts, Map<String, String> headers, Function initializeTaskList, Function incrementLoading) async {
    final auxBatch = FirebaseFirestore.instance.batch();
    final fields = await fieldCollection.get();
    final List<MapEntry<int, Part>> indexedParts = newParts.asMap().entries.toList();
    final int chunkSize = 100;

    final int partsLength = oldParts.length;
    final int newPartsLength = indexedParts.length;
    final int deleteOpChunkCount = (partsLength / chunkSize).ceil();
    final int addOpChunkCount = (newPartsLength / chunkSize).ceil();
    
    List<Part> duplicateParts = [];
    List<Part> invalidParts = [];

    initializeTaskList(
      List.generate(deleteOpChunkCount, (index) => AppTask(heading: "Clearing Global", content: 'Clearing data chunk ${index+1} / $deleteOpChunkCount')) +
      [AppTask(heading: 'Setting Data Structure', content: '')] +
      List.generate(addOpChunkCount, (index) => AppTask(heading: "Populating Global", content: 'Adding data chunk ${index+1} / $addOpChunkCount')) +
        [AppTask(heading: 'Import Complete', content: '')]
    );

    try {
      if(partsLength != 0) {
        for(int chunkIndex = 0; chunkIndex <= deleteOpChunkCount; chunkIndex++) {
          final batch = FirebaseFirestore.instance.batch();
          for(int partIndex = 0; partIndex < chunkSize && partIndex + chunkIndex * chunkSize < partsLength; partIndex++) {
            // print(partIndex + chunkIndex * chunkSize);
            batch.delete(partCollection.doc(oldParts[partIndex + chunkIndex * chunkSize].partId));
          }
          await batch.commit().then((value) => print('>>>>>>>>>>>>>>CHUNK $chunkIndex DELETED'));
          incrementLoading();
        }
      }

      for(final field in fields.docs) {
        auxBatch.delete(field.reference);
      }
      headers.keys.toList().asMap().forEach((index, field) {
        auxBatch.set(fieldCollection.doc(field), {'index': index, 'fieldKey': field, 'fieldValue': headers[field]});
      });
      await auxBatch.commit().then((value) => print(">>>>>>>>>>>>>>AUX SUCCESS")).catchError((e) => print(e));
      incrementLoading();

      for(int chunkIndex = 0; chunkIndex <= (newPartsLength / chunkSize).ceil(); chunkIndex++) {
        final batch = FirebaseFirestore.instance.batch();
        for(int partIndex = 0; partIndex < chunkSize && partIndex + chunkIndex * chunkSize < newPartsLength; partIndex++) {
          // print(partIndex + chunkIndex * chunkSize);
          batch.set(partCollection.doc(
              indexedParts[partIndex + chunkIndex * chunkSize].value.partId),
              {...indexedParts[partIndex + chunkIndex * chunkSize].value.toMap(),
                '_sortingIndex': indexedParts[partIndex + chunkIndex * chunkSize].key});
        }
        await batch.commit().then((value) => print('>>>>>>>>>>>>>>CHUNK $chunkIndex ADDED'));
        incrementLoading();
      }

      return ImportResponse(result: 'SUCCESS', parts: duplicateParts, invalidIdParts: invalidParts);
    } catch (e) {
      return ImportResponse(result: e.toString(), parts: duplicateParts, invalidIdParts: invalidParts);
    }
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
    return partCollection.orderBy("_sortingIndex").snapshots().map(_partListFromSnapshot);
  }

  Stream<Field> get fields {
    return fieldCollection.orderBy("index").snapshots().map(_fieldFromSnapshot);
  }
}