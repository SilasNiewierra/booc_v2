import 'package:booc/services/authenticate.dart';
import 'package:booc/services/colors.dart';
import 'package:booc/views/singin.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthenticationService _authService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  RegExp validMail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: _buildAppBar(context), body: _buildBody(queryData.size)),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [],
        backgroundColor: Colors.transparent);
  }

  Widget _buildBody(Size size) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to booc",
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20.0),
              Text(
                "Enter your credentials to get started",
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: ColorService().getSecondaryColor()),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 20), // add padding to adjust text
                  isDense: true,
                  hintText: "Email",
                  prefixIcon: Padding(
                    padding:
                        EdgeInsets.only(top: 15), // add padding to adjust icon
                    child: Icon(
                      Icons.perm_identity_outlined,
                      size: 30.0,
                    ),
                  ),
                ),
                validator: (val) => val.isNotEmpty && validMail.hasMatch(val)
                    ? null
                    : 'Enter an email',
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(top: 20), // add padding to adjust text
                  isDense: true,
                  hintText: "Password",
                  prefixIcon: Padding(
                    padding:
                        EdgeInsets.only(top: 15), // add padding to adjust icon
                    child: Icon(
                      Icons.vpn_key_outlined,
                      size: 30.0,
                    ),
                  ),
                ),
                obscureText: true,
                validator: (val) =>
                    val.length < 6 ? 'Enter an password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              Text(
                error,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.red),
                textAlign: TextAlign.start,
              ),
              Container(
                margin: EdgeInsets.only(top: 50.0),
                child: SizedBox(
                  width: size.width,
                  child: RaisedButton(
                      child: Text(
                        "Sign Up".toUpperCase(),
                        style: Theme.of(context).textTheme.headline6.copyWith(
                            color: ColorService().getLightTextColor()),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _authService
                              .signUpWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() =>
                                error = "Please supply valid credentials.");
                          } else {
                            print(result);
                            Navigator.pop(context);
                          }
                        }
                      }),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
                child: SizedBox(
                  width: size.width,
                  child: RaisedButton(
                      color: Theme.of(context).backgroundColor,
                      child: Text(
                        "Oops... I already have an account".toUpperCase(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 3.0)),
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
