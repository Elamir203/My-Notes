import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/Widgets/custom_buttons.dart';
import 'package:firebase_notes/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String oldCategoryName;
  final String docID;
  EditCategory({super.key, required this.oldCategoryName, required this.docID});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

GlobalKey<FormState> globalKey = GlobalKey();
TextEditingController categoryName = TextEditingController();
bool isLoading = false;

class _EditCategoryState extends State<EditCategory> {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('Categories');

  Future<void> editCategory() async {
    if (globalKey.currentState?.validate() ?? false) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.docID).update({'name': categoryName.text});
        Navigator.of(context).pushNamedAndRemoveUntil('Home', (route) => false);
      } catch (error) {
        isLoading = false;
        setState(() {});
        print("Failed to add Category: $error");
      }
    }
  }

  @override
  void initState() {
    categoryName.text = widget.oldCategoryName;
    super.initState();
  }

  // @override
  // void dispose() {
  //   categoryName.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category'),
      ),
      body: Form(
        key: globalKey,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: CustomTextFormField(
                  hintText: 'Edit Category Name', myController: categoryName),
            ),
            CustomButtonAuth(
              title: 'Edit',
              onPressed: () {
                editCategory();
              },
            )
          ],
        ),
      ),
    );
  }
}
