import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prior/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class SetPriorityPage extends StatefulWidget {
  SetPriorityPage({super.key});

  int priority = 0;

  @override
  State<SetPriorityPage> createState() {
    return _SetPriorityPageState();
  }
}

class _SetPriorityPageState extends State<SetPriorityPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Priority-Page'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .orderBy('priority')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (_auth.currentUser!.email != data['email']) {
      return Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
          color: Colors.grey, // Set the background color of the ListTile
        ),
        child: ListTile(
          title: Text(data['email']),
          subtitle: Text('Priority: ${data['priority']}'),
          onTap: () {
            _setPriority(context, data['email'], data['uid']);
            widget.priority = 1;
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void _setPriority(
      BuildContext context, String userEmail, String userId) async {
    TextEditingController priorityController = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Priority'),
          content: TextField(
            controller: priorityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter Priority'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (priorityController.text.isNotEmpty) {
                  // Update the priority in Firestore for the selected user
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'priority': int.parse(priorityController.text)});
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  /*void callpriority(){
    if(widget.priority==1){
      PriorityProcess;
      widget.priority=0;
    }
  }*/
}
