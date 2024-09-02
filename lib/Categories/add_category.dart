import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/Widgets/custom_buttons.dart';
import 'package:firebase_notes/Widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

GlobalKey<FormState> globalKey = GlobalKey();
TextEditingController categoryName = TextEditingController();
bool isLoading = false;

class _AddCategoryState extends State<AddCategory> {
  CollectionReference categories =
      FirebaseFirestore.instance.collection('Categories');

  Future<void> addCategory() async {
    if (globalKey.currentState?.validate() ?? false) {
      try {
        isLoading = true;
        setState(() {});
        await categories.add({
          'name': categoryName.text,
          'userID': FirebaseAuth.instance.currentUser!.uid,
        }).then((value) => print("Category Added"));
        categoryName.clear();
        Navigator.of(context).pushNamedAndRemoveUntil('Home', (route) => false);
      } catch (error) {
        isLoading = false;
        setState(() {});
        print("Failed to add Category: $error");
      }
    }
  }

// @override
//   void dispose() {
//     categoryName.dispose();
//     super.dispose();
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Form(
        key: globalKey,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              child: CustomTextFormField(
                  hintText: 'Enter Category Name', myController: categoryName),
            ),
            CustomButtonAuth(
              title: 'Add',
              onPressed: () {
                addCategory();
              },
            )
          ],
        ),
      ),
    );
  }
}
