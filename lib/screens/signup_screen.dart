// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_fields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    if (res != "success") {
      print('not success');
      setState(() {
        _isLoading = false;
      });
      showSnackBar(res, context);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // svg image
                SvgPicture.asset(
                  'assets/instagram_logo.svg',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 50),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: AssetImage('assets/profile.jpg'),
                          ),
                    Positioned(
                      right: -5,
                      bottom: -5,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.camera_alt),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // text field username
                TextFieldInput(
                  hintText: 'Enter your username',
                  textEditingController: _usernameController,
                  textInputType: TextInputType.text,
                  isPass: false,
                ),
                const SizedBox(height: 20),

                // text field for email
                TextFieldInput(
                  hintText: 'Enter your email',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                  isPass: false,
                ),
                const SizedBox(height: 20),
                // text field for bio
                TextFieldInput(
                  hintText: 'Enter your Bio',
                  textEditingController: _bioController,
                  textInputType: TextInputType.text,
                  isPass: false,
                ),
                const SizedBox(height: 20),

                // text field for password
                TextFieldInput(
                  hintText: 'Enter your password',
                  textEditingController: _passwordController,
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                // button login
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUpUser,
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          )
                        : const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
