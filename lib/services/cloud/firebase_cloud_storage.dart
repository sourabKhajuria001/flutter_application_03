import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_03/services/cloud/cloud_note.dart';
import 'package:flutter_application_03/services/cloud/cloud_storage_constants.dart';
import 'package:flutter_application_03/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  // get  notes collection from firebase
  final notes = FirebaseFirestore.instance.collection('notes');

  // create Singalton for FirebaseCloudStorage
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() {
    return _shared;
  }
  // -- end Singalton

// create Stream of Iterable clud Notes
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserId, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  // get Notes from Firebase - NOT IN USE
  // Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
  //   try {
  //     return await notes
  //         .where(
  //           ownerUserIdFieldName,
  //           isEqualTo: ownerUserId,
  //         )
  //         .get()
  //         .then((value) {
  //       return value.docs.map(
  //         (doc) => CloudNote.fromSnapshot(doc),
  //       );
  //     });
  //   } catch (e) {
  //     throw CouldNotGetAllNotesException();
  //   }
  // }

// create Note
  Future<CloudNote> createNewNote({required ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }
}// 
