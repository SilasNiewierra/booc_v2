import 'package:booc/services/colors.dart';
import 'package:booc/views/signup.dart';
import 'package:booc/views/singin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/authenticate-background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "booc",
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: queryData.size.width / 2,
                    margin: EdgeInsets.symmetric(vertical: 0.0),
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: Text(
                      "Let's Get Started",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0, bottom: 50.0),
                    child: Text(
                      "your reading history in one place",
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      width: queryData.size.width,
                      child: RaisedButton(
                          child: Text(
                            "Sign Up".toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color: ColorService().getLightTextColor()),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          }),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Already got an account? ',
                          style: Theme.of(context).textTheme.headline6,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignInScreen()));
                                },
                            ),
                            // can add more TextSpans here...
                          ],
                        ),
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
