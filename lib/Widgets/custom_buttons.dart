import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  const CustomButtonAuth({super.key, required this.title,required this.onPressed});
final String title;
final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      color: Colors.orange,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      textColor: Colors.white,
    );
  }
}


class CustomButtonUploadImage extends StatelessWidget {
  const CustomButtonUploadImage({super.key, required this.title,required this.onPressed, required this.isUploaded});
  final String title;
  final bool isUploaded;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      minWidth: 200,
      color: isUploaded ? Colors.green : Colors.orange,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      textColor: Colors.white,
    );
  }
}
