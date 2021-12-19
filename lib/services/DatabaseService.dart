import 'package:mech_track/models/Account.dart';
import 'package:mech_track/models/AccountData.dart';
import 'package:mech_track/models/Part.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

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

  List<Part> _partFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Part(
        pid: doc.id,
        assetAccountCode: doc.get('assetAccountCode') ?? '',
        process: doc.get('process') ?? '',
        subProcess: doc.get('subProcess') ?? '',
        description: doc.get('description') ?? '',
        type: doc.get('type').toDate() ?? '',
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

  List<Part> _partListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Part(
        pid: doc.id,
        assetAccountCode: doc.get('assetAccountCode') ?? '',
        process: doc.get('process') ?? '',
        subProcess: doc.get('subProcess') ?? '',
        description: doc.get('description') ?? '',
        type: doc.get('type').toDate() ?? '',
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
  //TODO: removePart
  // Future removeToMyEvents(String eventId) async {
  //   return userCollection
  //       .doc(uid).collection('myEvents').doc(eventId).delete()
  //       .then((value) => print('Removed from myEvents'))
  //       .catchError((error) => print('Failed to remove from myEvents'));
  // }

  //TODO: addPart
  // Future<String> createEvent(PeopleEvent event) async {
  //   String eventId = '';
  //   await eventCollection
  //       .add({
  //     'hostId': uid,
  //     'eventName': event.eventName,
  //     'hostName': event.hostName,
  //     'address': event.address,
  //     'datetime': Timestamp.fromDate(event.datetime),
  //     'bannerUri': event.bannerUri,
  //     'showcaseUris': event.showcaseUris,
  //     'permitUris': event.permitUris,
  //     'description': event.description,
  //     'createdAt': event.createdAt,
  //     'isArchive': event.isArchive
  //   })
  //       .then((value) {
  //     eventId = value.id;
  //     print('Event ${value.id} created');
  //   })
  //       .catchError((error) => print('Failed to create event'));
  //   return eventId;
  // }

  //TODO: Edit part
  // Future<String> editEvent(PeopleEvent event, Activity activity) async {
  //   await eventCollection.doc(event.eventId).update({
  //     'eventName': event.eventName,
  //     'hostName': event.hostName,
  //     'address': event.address,
  //     'datetime': Timestamp.fromDate(event.datetime),
  //     'bannerUri': event.bannerUri,
  //     'showcaseUris': event.showcaseUris,
  //     'permitUris': event.permitUris,
  //     'description': event.description,
  //     'isArchive': event.isArchive
  //   })
  //       .then((value) {
  //     createActivity(activity);
  //     print('Event updated');
  //   })
  //       .catchError((error) => print('Failed to edit event'));
  //   return event.eventId;
  // }

  Future createAccount(AccountData person, String email) async {
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

  Future editAccount(AccountData user) async {
    String result = '';
    await userCollection.doc(uid).update({
      'fullName': user.fullName,
      'username': user.username
    })
        .catchError((error) => result = error.toString());
    return result;
  }

  // //GETTER FUNCTIONS

  Future<AccountData> getAccount(String uid) async {
    return userCollection.doc(uid).get().then(_accountFromSnapshot);
  }
  //
  // Future<String> getInterestedCount(String eventId) async {
  //   return eventCollection.doc(eventId).collection('interested').get().then((querySnapshot) => querySnapshot.docs.length.toString());
  // }
  //
  // Future<List<MyEvent>> myEvents(List<String> eventId) {
  //   return eventCollection.where('__name__', whereIn: eventId).where('isArchive', isEqualTo: false).get().then((snapshot) {
  //     List<String> missingIds = eventId.toSet().difference(snapshot.docs.map((doc) => doc.id).toList().toSet()).toList();
  //     if(missingIds != null && missingIds.isNotEmpty) missingIds.forEach((eventId) => removeToMyEvents(eventId));
  //     return _myEventListFromSnapshot(snapshot);
  //   }).catchError((error){
  //     print(error);
  //   });
  // }
  //
  // Future<List<AccountData>> interestedUsers(List<String> userIds) {
  //   if(userIds.isNotEmpty) {
  //     return userCollection.where('__name__', whereIn: userIds).get().then(_accountListFromSnapshot);
  //   } else {
  //     return Future(() => <AccountData>[]);
  //   }
  // }
  //
  // Future<List<AccountData>> participantUsers(List<String> userIds) {
  //   if(userIds.isNotEmpty) {
  //     return userCollection.where('__name__', whereIn: userIds).get().then(_accountListFromSnapshot);
  //   } else {
  //     return Future(() => <AccountData>[]);
  //   }
  // }
  //

  // //STREAM SECTION

  Stream<AccountData> get user {
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