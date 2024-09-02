import 'package:flutter/material.dart';

class EachNoteView extends StatelessWidget {
  final String noteData;
  const EachNoteView({super.key, required this.noteData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Note',
          selectionColor: Colors.orange,
        ),
      ),
      body: ListView(
        children: [
          Container(
            color: Color(0xffF3EDF6),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                noteData,
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
        // color: Color(0xffF3EDF6),
        // child: Text(noteData),
        // print(noteData);
      ),
    );
  }
}
