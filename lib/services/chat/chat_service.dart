import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../model/message.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    //construct chat room id from current user id and receiver id(sorted to ensure uniqness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensure the chat room id is always the same for any pair of 2 users)
    String chatRoomId = ids.join(
        "_"); // combine the ids into a single string to use as a chatroomID

    // add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    await _createOrUpdateLatestMessage(currentUserId, receiverId);
    await _createOrUpdateLatestMessage(receiverId, currentUserId);
  }

  // Helper method to create or update the 'latestMessage' field in the 'users' collection
  Future<void> _createOrUpdateLatestMessage(
      String userId, String otherUserId) async {
    // Construct chat room id from user ids (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    // Get the latest message in the chat room
    QuerySnapshot messagesSnapshot = await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    // Check if there is any message in the chat room
    if (messagesSnapshot.docs.isNotEmpty) {
      // Extract the timestamp of the latest message
      Timestamp latestMessageTimestamp =
          messagesSnapshot.docs.first['timestamp'];

      // Check if the 'latestMessage' field exists in the 'users' collection for the receiver
      final receiverDoc = _fireStore.collection('users').doc(otherUserId);
      final receiverData = await receiverDoc.get();

      if (receiverData.exists) {
        // If 'latestMessage' field exists, update it for the receiver
        await receiverDoc.update({'latestMessage': latestMessageTimestamp});
      } else {
        // If 'latestMessage' field does not exist, create it for the receiver
        await receiverDoc.set({'latestMessage': latestMessageTimestamp});
      }
    }
  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct chat room id from user ids(sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
