import 'package:citiguide_app/profile/components/myTextField.dart';
import 'package:citiguide_app/profile/components/my_button.dart';
import 'package:citiguide_app/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});

  // text editing controllers

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmnewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 25,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                'images/img1.png',
              ),
              height: 150,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Change Password",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Mytextfield(
                controller: oldPasswordController,
                hintText: "Old Password",
                obscureText: false),
            SizedBox(
              height: 15,
            ),
            Mytextfield(
                controller: newPasswordController,
                hintText: "New Password",
                obscureText: true),
            SizedBox(
              height: 15,
            ),
            Mytextfield(
                controller: confirmnewPasswordController,
                hintText: "Confirm new password",
                obscureText: true),
            SizedBox(
              height: 15,
            ),
            MyButton(
              buttonText: "RESET PASSWORD",
            )
          ],
        ),
      ),
    );
  }
}
