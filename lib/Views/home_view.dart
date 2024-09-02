import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/Categories/edit_caregory.dart';
import 'package:flutter/material.dart';

import '../Notes/note_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Categories')
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushNamed('AddCategory');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            )
          : GridView.builder(
              itemCount: data.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, itemCount) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteView(
                              noteID: data[itemCount].id,
                            )));
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCategory(
                                  oldCategoryName: data[itemCount]['name'],
                                  docID: data[itemCount].id)));
                        },
                        btnCancelText: 'Delete',
                        btnCancelOnPress: () {
                          FirebaseFirestore.instance
                              .collection('Categories')
                              .doc(data[itemCount].id)
                              .delete();
                          Navigator.of(context).pushReplacementNamed('Home');
                        }).show();
                  },
                  child: Card(
                    surfaceTintColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/folder.png',
                            height: 126,
                          ),
                          Text(
                            '${data[itemCount]['name']}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
