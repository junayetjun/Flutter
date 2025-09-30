

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{


  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(16.00),


        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email)),
            ),

            SizedBox(
              height: 20.0,
            ),

            TextField(
              controller: password,
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.password)),
              obscureText: true,
            ),

            SizedBox(
              height: 20.0,
            ),

            ElevatedButton(
                onPressed: (){
              String em = email.text;
              String pass = password.text;
              print('Email: $em, Password: $pass');
            },
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20.00,
                    fontWeight: FontWeight.w800,

                  ),

                ),
                
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white
                )
            ),


          ],
        ),
      )
    );
  }

}