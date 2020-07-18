import 'package:flutter/material.dart';
import '../components/bloc.dart';
import 'package:mygarage/screens/find_parking.dart';
import 'package:mygarage/reusables/reusable_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
//------------------------------------------------------------------------
// the 'bloc' file and 'validator' file are used to validate
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final bloc = Bloc();
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
        ),
        body:Builder(
          builder: (context) =>
              ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: <Widget>[
                    Image(image: AssetImage('images/car.png'),height: 300,width: 200,),
                    SizedBox(
                      height: 15.0,
                    ),
                    StreamBuilder<String>(
                      stream: bloc.email,
                      builder: (context, snapshot) => TextField(
                        onChanged : bloc.emailChanged,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter email",
                            labelText: "Email",
                            errorText: snapshot.error),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    StreamBuilder<String>(
                      stream: bloc.password,
                      builder: (context, snapshot) => TextField(
                        onChanged:bloc.passwordChanged,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Enter password",
                            labelText: "Password",
                            errorText: snapshot.error),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    ReusableButton(
                      title: 'Login',
                      colour: Colors.teal,
                      onPressed: () async {

                        var connectivityResult = await (Connectivity().checkConnectivity());

                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: bloc.getEmail, password: bloc.getPassword);

                          if ((connectivityResult == ConnectivityResult.mobile)||(connectivityResult == ConnectivityResult.wifi)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindParking(),
                              ),
                            );
                          }
                          ///////////////////////////////////////////////////////
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          if ((connectivityResult != ConnectivityResult.mobile)&&(connectivityResult != ConnectivityResult.wifi)){
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              backgroundColor: Colors.black,
                              duration: Duration(seconds: 3),
                              content:
                              Text("No internet Connection !",style: TextStyle(fontSize: 17),),
                            ));
                          }else{
                            Scaffold.of(context).showSnackBar(new SnackBar(
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              content:
                              Text("Please, Enter a valid email and passowrd!"),
                            ));
                          }

                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    //--------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.blueAccent,
                            fontSize: 15,),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          );

                          },
                          child: Text(
                            'Register Here',
                            style: TextStyle(
                                color: Colors.blueAccent,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
        )
    );
  }
}
