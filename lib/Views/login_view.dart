import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/Widgets/custom_buttons.dart';
import 'package:firebase_notes/Widgets/custom_text_form_field.dart';
import 'package:firebase_notes/Widgets/custom_logo_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: formKey,
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                )
              : ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        CustomLogoAuth(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Login To Continue Using The App',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                            hintText: 'Enter Your Email', myController: email),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                            hintText: 'Enter Your Password',
                            myController: password),
                        GestureDetector(
                          onTap: () async {
                            if (email.text == '') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'Please type your email then press forget password.',
                              ).show();
                            } else {
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(email: email.text);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Reset Password',
                                  desc:
                                      'A reset password link was sent to your email.',
                                ).show();
                              } catch (e) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'No user for found for that email.',
                                ).show();
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 14, bottom: 20),
                            alignment: Alignment.topRight,
                            child: Text(
                              'Forget Password ?',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomButtonAuth(
                      title: 'Login',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            isLoading = true;
                            setState(() {});
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            isLoading = false;
                            setState(() {});
                            if (FirebaseAuth
                                .instance.currentUser!.emailVerified) {
                              Navigator.of(context)
                                  .pushReplacementNamed('Home');
                            } else {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Verification',
                                desc:
                                    'Please check your email and verify this account.',
                              ).show();
                            }
                          } on FirebaseAuthException catch (e) {
                            isLoading = false;
                            setState(() {});
                            if (e.code == 'user-not-found') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'No user found for that email.',
                              ).show();
                            } else if (e.code == 'wrong-password') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Wrong password provided for that user.',
                              ).show();
                            }
                            // else{
                            //   AwesomeDialog(
                            //     context: context,
                            //     dialogType: DialogType.error,
                            //     animType: AnimType.rightSlide,
                            //     title: 'Error',
                            //     desc: 'Make sure your email and password are correct and try again.',
                            //   ).show();
                            // }
                          }
                        }
                      },
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    // Center(
                    //   child: Text.rich(
                    //     TextSpan(
                    //       children: [
                    //         TextSpan(
                    //             text: "Don't Have An Account ? ",
                    //             style: TextStyle(
                    //               fontSize: 18,
                    //             )),
                    //         TextSpan(
                    //           text: "Register",
                    //           style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.orange,
                    //             fontSize: 18,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have An Account ? ",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed('SignUp');
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
