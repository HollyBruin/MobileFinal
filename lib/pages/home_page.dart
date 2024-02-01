import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilefinalhw/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //firestore
  final FirestoreService firestoreService = FirestoreService();


  //text controller
  final TextEditingController textController = TextEditingController();


  //open a dialog box to add a note
  void openNoteBox(){
    showDialog(context: context, builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        //button to save
        ElevatedButton(onPressed: () {
          //add a new note
          firestoreService.addNote(textController.text);

          //clear the text controller
          textController.clear();

          //close the box
          Navigator.pop(context);
        }, child: Text("Add"))
      ],
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes"),),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot){
          //if we have data, get all the docs
          if (snapshot.hasData){
            List notesList = snapshot.data!.docs;

            //display as a list
            return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
              //get each individual doc
              DocumentSnapshot document = notesList[index];
              String docID=document.id;

              //get note from erach doc
              Map<String, dynamic> data=
                  document.data() as Map<String,dynamic>;
              String noteText = data['note'];

              //display as a list tile
              return ListTile(
                title: Text(noteText),
              );

            }
            );
          } else{
            return const Text("No notes...");
          }
      }
      ),
    );

  }
}
