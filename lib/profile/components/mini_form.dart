import 'package:citiguide_app/profile/components/myTextField.dart';
import 'package:citiguide_app/profile/components/my_button.dart';
import 'package:flutter/material.dart';

class MiniForm extends StatelessWidget {
  MiniForm({super.key});
  // text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Username",
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Mytextfield(
              controller: usernameController,
              hintText: "Username",
              obscureText: false),
          SizedBox(
            height: 10,
          ),
          Text(
            "Phone Number",
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Mytextfield(
              controller: phoneController,
              hintText: "01023456789",
              obscureText: false),
          SizedBox(
            height: 15,
          ),
          Text(
            "Email",
            style: TextStyle(
                fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Mytextfield(
              controller: emailController,
              hintText: "ed91@gmail.com",
              obscureText: false),
          SizedBox(
            height: 10,
          ),
          MyButton(
            buttonText: "SAVE CHANGES",
          )
        ],
      ),
    );
  }
}
