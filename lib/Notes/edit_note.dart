import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/Notes/note_view.dart';
import 'package:firebase_notes/Widgets/custom_buttons.dart';
import 'package:firebase_notes/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String noteDocID;
  final String categoryDocID;
  final String noteOldValue;
  EditNote(
      {super.key,
      required this.noteDocID,
      required this.categoryDocID,
      required this.noteOldValue});

  @override
  State<EditNote> createState() => _EditNoteState();
}

GlobalKey<FormState> globalKey = GlobalKey();
TextEditingController note = TextEditingController();
bool isLoading = false;

class _EditNoteState extends State<EditNote> {
  Future<void> editNote() async {
    CollectionReference CollectionNote = FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.categoryDocID)
        .collection('note');
    if (globalKey.currentState?.validate() ?? false) {
      try {
        isLoading = true;
        setState(() {});
        await CollectionNote.doc(widget.noteDocID)
            .update({'note': note.text}).then((value) => print("Note Updated"));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteView(noteID: widget.categoryDocID)));
      } catch (error) {
        isLoading = false;
        setState(() {});
        print("Failed to add Note: $error");
      }
    }
  }

  @override
  void initState() {
    note.text = widget.noteOldValue;
    super.initState();
  }

  // @override
  // void dispose() {
  //   note.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Form(
        key: globalKey,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: CustomTextFormField(
                  hintText: 'Edit Your Note', myController: note),
            ),
            CustomButtonAuth(
              title: 'Save',
              onPressed: () {
                editNote();
              },
            )
          ],
        ),
      ),
    );
  }
}
