import 'package:book_my_doctor/src/services/fb_cloud_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String CONSULT_TABLE = "consults";

class FBChatServices {
  Stream<QuerySnapshot> getPeerChat(List<String> consultPeerIds,
      {bool areYouDoctor: false}) {
    return areYouDoctor
        ? FirebaseFirestore.instance
            .collection(USER_TABLE)
            .where('are_you_doctor', isEqualTo: false)
            .where("id", whereIn: consultPeerIds)
            .snapshots()
        : FirebaseFirestore.instance
            .collection(USER_TABLE)
            .where('are_you_doctor', isEqualTo: true)
            .where('is_complete', isEqualTo: true)
            .where("id", whereIn: consultPeerIds)
            .snapshots();
  }

  addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: true)
        .snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .get();
  }
}
