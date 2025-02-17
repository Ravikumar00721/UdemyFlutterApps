import 'dart:io';

import 'package:chat_app/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLogin = true;
  var _enteredEmail = '';
  var _enetredPassword = '';
  File? _selectedImage;
  var _isAuthenticating = false;
  var _imageurl;
  var _username = "";

  final _form = GlobalKey<FormState>();

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || (!_isLogin && _selectedImage == null)) {
      print("NULL");
      return;
    }
    _form.currentState!.save();
    print(_enteredEmail);
    print(_enetredPassword);

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enetredPassword,
        );
        print("User Logged In: ${userCredential.user?.uid}");
      } else {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enetredPassword,
        );

        userCredential.user?.sendEmailVerification();
        print("User signed up: ${userCredential.user?.uid}");
        print("Verification email sent.");

        if (_selectedImage != null) {
          final storageRef =
              FirebaseStorage.instanceFor(bucket: 'gs://ffff-4d4b8.appspot.com')
                  .ref()
                  .child('user_images')
                  .child('${DateTime.timestamp()}.jpg');

          await storageRef.putFile(_selectedImage!);
          _imageurl = await storageRef.getDownloadURL();
          print("ImageUrl : $_imageurl");
        }
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid) // Store using UID
              .set({
            'username': _username,
            'email': _enteredEmail,
            'imageurl': _imageurl ?? '', // Ensure it stores a string (not null)
          });
          print("User data stored successfully!");
        } catch (e) {
          print("Error storing user data: $e");
        }
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? "Authentication Failed"),
      ));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset("assets/images/chat.png"),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin)
                            ImagePickerWidget(
                              onPickedImage: (pickedImage) {
                                _selectedImage = pickedImage;
                                if (_selectedImage == null) {
                                  print("Image is Null");
                                } else {
                                  print(
                                      "Not Null , Image is Fetched Successfully");
                                }
                              },
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Email Address",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return "Please Enter valid Email";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Username"),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return "Password should not be less than 6";
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _username = value.toString();
                              },
                              enableSuggestions: false,
                            ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Password should not be less than 6";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enetredPassword = value!;
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(_isLogin ? "Log In" : "Sign Up")),
                          if (!_isAuthenticating)
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? "Create An Account"
                                    : "Already have an Account"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
