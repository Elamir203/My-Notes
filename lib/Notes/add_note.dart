import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notes/Notes/note_view.dart';
import 'package:firebase_notes/Widgets/custom_buttons.dart';
import 'package:firebase_notes/Widgets/custom_text_form_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

class AddNote extends StatefulWidget {
  final String noteID;

  AddNote({super.key, required this.noteID});

  @override
  State<AddNote> createState() => _AddNoteState();
}

GlobalKey<FormState> globalKey = GlobalKey();
TextEditingController note = TextEditingController();
bool isLoading = false;
File? file;
String? url;

class _AddNoteState extends State<AddNote> {
  Future<void> addNote(context) async {
    CollectionReference CollectionNote = FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.noteID)
        .collection('note');
    if (globalKey.currentState?.validate() ?? false) {
      try {
        isLoading = true;
        setState(() {});
        await CollectionNote.add({'note': note.text, 'url': url ?? 'none'})
            .then((value) => print("Note Added"));
        note.clear();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NoteView(noteID: widget.noteID)));
      } catch (error) {
        isLoading = false;
        setState(() {});
        print("Failed to add Note: $error");
      }
      // Reset the URL and file to set isUploaded to false
      setState(() {
        url = null;
        file = null;
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   note.dispose();
  // }

  getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    // final XFile? imageCamera = await picker.pickImage(source: ImageSource.camera);
    // if (imageCamera != null) {
    //   file = File(imageCamera.path);
    // }
    if (imageGallery != null) {
      file = File(imageGallery!.path);
      var imageName = basename(imageGallery!.path);
      var refStorage = FirebaseStorage.instance.ref('images').child(imageName);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Form(
        key: globalKey,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: CustomTextFormField(
                  hintText: 'Enter Your Note', myController: note),
            ),
            CustomButtonUploadImage(
              title: 'Upload Image',
              onPressed: () async {
                await getImage();
              },
              isUploaded: url == null ? false : true,
            ),
            SizedBox(
              height: 20,
            ),
            CustomButtonAuth(
              title: 'Add',
              onPressed: () {
                addNote(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
