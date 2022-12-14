import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_03/services/cloud/cloud_note.dart';
import 'package:flutter_application_03/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_application_03/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // get  notes collection from firebase
  final notes = FirebaseFirestore.instance.collection('notes');

// get Notes from Firebase
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) {
        return value.docs.map(
          (doc) {
            return CloudNote(
              documentId: doc.id,
              ownerUserId: doc.data()[ownerUserId] as String,
              text: doc.data()[textFildName] as String,
            );
          },
        );
      });
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

// create Note
  void createNewNote({required ownerUserId}) async {
    notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFildName: '',
    });
  }

  // create Singalton for FirebaseCloudStorage
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage._sharedInstance() {
    return _shared;
  }
  // -- end Singalton

}// 
