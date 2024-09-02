import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/Notes/add_note.dart';
import 'package:firebase_notes/Notes/each_note_view.dart';
import 'package:firebase_notes/Notes/edit_note.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final String noteID;

  const NoteView({super.key, required this.noteID});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.noteID)
          .collection('note')
          .get();

      setState(() {
        data = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteNoteById(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.noteID)
          .collection('note')
          .doc(docId)
          .delete();
      // Refresh data after deletion
      await getData();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData(); // Fetch data on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(noteID: widget.noteID)));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('Login');
            },
            icon: Icon(
              Icons.exit_to_app,
              size: 26,
              color: Colors.orange,
            ),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('Home', (route) => false);
          return false; // Prevent default back action
        },
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              )
            : GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      1,
                ),
                itemBuilder: (context, itemCount) {
                  var noteData = data[itemCount].data() as Map<String, dynamic>;
                  var docId = data[itemCount].id; // Get the document ID

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EachNoteView(
                                noteData: noteData['note'],
                              )));
                      print('-------------------------');
                      print(noteData[itemCount].data());
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Confirmation',
                        desc: 'Choose what you want to do.',
                        btnOkText: 'Update',
                        btnOkOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditNote(
                                noteDocID: docId,
                                categoryDocID: widget.noteID,
                                noteOldValue: noteData['note'],
                              ),
                            ),
                          );
                        },
                        btnCancelText: 'Delete',
                        btnCancelOnPress: () async {
                          await deleteNoteById(docId);

                          if (noteData['url'] != 'none') {
                            FirebaseStorage.instance
                                .refFromURL(noteData['url'])
                                .delete();
                          }
                        },
                      ).show();
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Expanded(
                            //child:
                            Text(
                              '${noteData['note'].length > 15 ? noteData['note'].substring(0, 15) + '...' : noteData['note']}',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                              maxLines: 1, // Adjust as per your requirement
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            //     ),
                            if (noteData['url'] != 'none')
                              Image.network(
                                noteData['url'],
                                height: 110,
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
