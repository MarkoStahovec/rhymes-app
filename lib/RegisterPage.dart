import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphism/widgets/album.dart';
import 'package:neumorphism/widgets/responseBar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'LoginPage.dart';
import 'api/auth.dart';
import 'api/like.dart';
import 'constants.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isloading = false;
  bool isPressed = false;
  bool isEmailPressed = false;
  bool isNicknamePressed = false;
  bool isPasswordPressed = false;
  bool isConfirmPasswordPressed = false;
  bool isLoginPressed = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final bgColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    Offset offset = isPressed ? offsetPress : offsetNonPress;
    double blur = blurButton;
    final width = MediaQuery.of(context).size.width;
    final squareSideLength = width / buttonSizeMultiplier;
    final buttonSize = Size(squareSideLength, squareSideLength);

    return Scaffold(
      resizeToAvoidBottomInset : true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode ? [
                  darkLeftBackgroundColor,
                  darkRightBackgroundColor,
                ]
                    : [
                  lightLeftBackgroundColor,
                  lightRightBackgroundColor,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: defaultPadding * 1.5,
                right: defaultPadding * 1.5,),
              child: Form(
                key: _formKey,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, top: defaultPadding * 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: buttonSize.width,
                            height: buttonSize.height,
                            child: Listener(
                              onPointerUp: (_) => setState(() => isPressed = false),
                              onPointerDown: (_) => setState(() => isPressed = true),
                              child:
                              AnimatedContainer(
                                duration: const Duration(milliseconds: animationTime),
                                child: Align(
                                  alignment: Alignment(0, 0),
                                  child: IconButton(
                                    color: neutralButtonColor,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(CupertinoIcons.arrow_left),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: buttonSize.width,
                            height: buttonSize.height,
                            child: Listener(
                              onPointerUp: (_) => setState(() => isPressed = false),
                              onPointerDown: (_) => setState(() => isPressed = true),
                              child:
                              AnimatedContainer(
                                duration: const Duration(milliseconds: animationTime),
                                child: Align(
                                  alignment: Alignment(0, 0),
                                  child: IconButton(
                                    color: neutralButtonColor,
                                    onPressed: () {
                                      setState(() {
                                        isDarkMode = !isDarkMode;
                                      });
                                    },
                                    icon: isDarkMode ? const Icon(CupertinoIcons.sun_max) : const Icon(CupertinoIcons.moon),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding,),
                    /*
                  RichText(
                    text: TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: const TextStyle(
                        fontSize: defTextSize * 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: ' rhymes', style: TextStyle(color: isDarkMode ? darkMainTextColor : lightMainTextColor,)),
                        const TextSpan(text: '.', style: TextStyle(color: mainButtonColor)),
                      ],
                    ),
                  ),*/
                    Album(size: 15,),
                    const SizedBox(height: defaultPadding,),
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: defaultPadding * 2),
                      child: Listener(/*
                      onPointerUp: (_) => setState(() => isUsernamePressed = false),
                      onPointerDown: (_) => setState(() => isUsernamePressed = true),*/
                        child:
                        AnimatedContainer(
                          curve: Curves.easeOutExpo,
                          duration: const Duration(milliseconds: animationTime),
                          decoration: BS.BoxDecoration(
                              borderRadius: BorderRadius.circular(defRadius * 2),
                              gradient: LinearGradient(
                                colors: isDarkMode ? [
                                  darkLeftBackgroundColor,
                                  darkRightBackgroundColor,
                                ]
                                    : [
                                  lightLeftBackgroundColor,
                                  lightRightBackgroundColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              //gradient: beatGradient,
                              //color: mainButtonColor,
                              boxShadow: [
                                BS.BoxShadow(
                                  color: isDarkMode ? darkLeftShadow : lightLeftShadow,
                                  offset: -(isEmailPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isEmailPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isEmailPressed,
                                ),
                                BS.BoxShadow(
                                  color: isDarkMode ? darkRightShadow : lightRightShadow,
                                  offset: (isEmailPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isEmailPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isEmailPressed,
                                ),
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: defaultPadding / 4, top: defaultPadding / 4, right: defaultPadding / 4, bottom: defaultPadding / 4),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                isEmailPressed = !isEmailPressed;
                                setState(() {

                                });
                              },
                              child: TextFormField(
                                // TODO validators
                                controller: emailController,
                                style: GoogleFonts.poppins(
                                  fontSize: defTextSize * 0.75,
                                  fontWeight: FontWeight.w400,
                                  color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                                ),
                                autocorrect: false,
                                enableSuggestions: false,
                                autofocus: false,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                decoration: InputDecoration(hintText: "Email",
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: defTextSize * 0.7,
                                    fontWeight: FontWeight.w400,
                                    color: secondaryTextColor,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                                    child: Icon(CupertinoIcons.mail, color: neutralButtonColor,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: defaultPadding * 1.3),
                      child: Listener(/*
                      onPointerUp: (_) => setState(() => isUsernamePressed = false),
                      onPointerDown: (_) => setState(() => isUsernamePressed = true),*/
                        child:
                        AnimatedContainer(
                          curve: Curves.easeOutExpo,
                          duration: const Duration(milliseconds: animationTime),
                          decoration: BS.BoxDecoration(
                              borderRadius: BorderRadius.circular(defRadius * 2),
                              gradient: LinearGradient(
                                colors: isDarkMode ? [
                                  darkLeftBackgroundColor,
                                  darkRightBackgroundColor,
                                ]
                                    : [
                                  lightLeftBackgroundColor,
                                  lightRightBackgroundColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              //gradient: beatGradient,
                              //color: mainButtonColor,
                              boxShadow: [
                                BS.BoxShadow(
                                  color: isDarkMode ? darkLeftShadow : lightLeftShadow,
                                  offset: -(isNicknamePressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isNicknamePressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isNicknamePressed,
                                ),
                                BS.BoxShadow(
                                  color: isDarkMode ? darkRightShadow : lightRightShadow,
                                  offset: (isNicknamePressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isNicknamePressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isNicknamePressed,
                                ),
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: defaultPadding / 4, top: defaultPadding / 4, right: defaultPadding / 4, bottom: defaultPadding / 4),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                isNicknamePressed = !isNicknamePressed;
                                setState(() {

                                });
                              },
                              child: TextFormField(
                                // TODO validators
                                controller: nicknameController,
                                style: GoogleFonts.poppins(
                                  fontSize: defTextSize * 0.75,
                                  fontWeight: FontWeight.w400,
                                  color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                                ),
                                autocorrect: false,
                                enableSuggestions: false,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                obscureText: false,
                                decoration: InputDecoration(hintText: "Nickname",
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: defTextSize * 0.7,
                                    fontWeight: FontWeight.w400,
                                    color: secondaryTextColor,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                                    child: Icon(CupertinoIcons.person, color: neutralButtonColor,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: defaultPadding * 1.3),
                      child: Listener(/*
                      onPointerUp: (_) => setState(() => isUsernamePressed = false),
                      onPointerDown: (_) => setState(() => isUsernamePressed = true),*/
                        child:
                        AnimatedContainer(
                          curve: Curves.easeOutExpo,
                          duration: const Duration(milliseconds: animationTime),
                          decoration: BS.BoxDecoration(
                              borderRadius: BorderRadius.circular(defRadius * 2),
                              gradient: LinearGradient(
                                colors: isDarkMode ? [
                                  darkLeftBackgroundColor,
                                  darkRightBackgroundColor,
                                ]
                                    : [
                                  lightLeftBackgroundColor,
                                  lightRightBackgroundColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              //gradient: beatGradient,
                              //color: mainButtonColor,
                              boxShadow: [
                                BS.BoxShadow(
                                  color: isDarkMode ? darkLeftShadow : lightLeftShadow,
                                  offset: -(isPasswordPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isPasswordPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isPasswordPressed,
                                ),
                                BS.BoxShadow(
                                  color: isDarkMode ? darkRightShadow : lightRightShadow,
                                  offset: (isPasswordPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isPasswordPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isPasswordPressed,
                                ),
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: defaultPadding / 4, top: defaultPadding / 4, right: defaultPadding / 4, bottom: defaultPadding / 4),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                isPasswordPressed = !isPasswordPressed;
                                setState(() {

                                });
                              },
                              child: TextFormField(
                                // TODO validators
                                controller: passwordController,
                                style: GoogleFonts.poppins(
                                  fontSize: defTextSize * 0.75,
                                  fontWeight: FontWeight.w400,
                                  color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                                ),
                                autocorrect: false,
                                enableSuggestions: false,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(hintText: "Password",
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: defTextSize * 0.7,
                                    fontWeight: FontWeight.w400,
                                    color: secondaryTextColor,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                                    child: Icon(CupertinoIcons.lock, color: neutralButtonColor,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: defaultPadding * 1.3),
                      child: Listener(/*
                      onPointerUp: (_) => setState(() => isUsernamePressed = false),
                      onPointerDown: (_) => setState(() => isUsernamePressed = true),*/
                        child:
                        AnimatedContainer(
                          curve: Curves.easeOutExpo,
                          duration: const Duration(milliseconds: animationTime),
                          decoration: BS.BoxDecoration(
                              borderRadius: BorderRadius.circular(defRadius * 2),
                              gradient: LinearGradient(
                                colors: isDarkMode ? [
                                  darkLeftBackgroundColor,
                                  darkRightBackgroundColor,
                                ]
                                    : [
                                  lightLeftBackgroundColor,
                                  lightRightBackgroundColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              //gradient: beatGradient,
                              //color: mainButtonColor,
                              boxShadow: [
                                BS.BoxShadow(
                                  color: isDarkMode ? darkLeftShadow : lightLeftShadow,
                                  offset: -(isConfirmPasswordPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isConfirmPasswordPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isConfirmPasswordPressed,
                                ),
                                BS.BoxShadow(
                                  color: isDarkMode ? darkRightShadow : lightRightShadow,
                                  offset: (isConfirmPasswordPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isConfirmPasswordPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isConfirmPasswordPressed,
                                ),
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: defaultPadding / 4, top: defaultPadding / 4, right: defaultPadding / 4, bottom: defaultPadding / 4),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                isConfirmPasswordPressed = !isConfirmPasswordPressed;
                                setState(() {

                                });
                              },
                              child: TextFormField(
                                controller: passwordConfirmController,
                                style: GoogleFonts.poppins(
                                  fontSize: defTextSize * 0.75,
                                  fontWeight: FontWeight.w400,
                                  color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                                ),
                                autocorrect: false,
                                enableSuggestions: false,
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: InputDecoration(hintText: "Confirm Password",
                                  border: InputBorder.none,
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: defTextSize * 0.7,
                                    fontWeight: FontWeight.w400,
                                    color: secondaryTextColor,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(top: 0), // add padding to adjust icon
                                    child: Icon(CupertinoIcons.lock_fill, color: neutralButtonColor,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: defaultPadding * 1.3),
                    SizedBox(
                      width: buttonSize.width,
                      height: buttonSize.height,
                      child: Listener(
                        onPointerUp: (_) => setState(() => isLoginPressed = false),
                        onPointerDown: (_) => setState(() => isLoginPressed = true),
                        child:
                        AnimatedContainer(
                          curve: Curves.easeOutExpo,
                          duration: const Duration(milliseconds: animationTime),
                          decoration: BS.BoxDecoration(
                              borderRadius: BorderRadius.circular(defRadius * 2),
                              gradient: LinearGradient(
                                colors: isDarkMode ? [
                                  darkLeftBackgroundColor,
                                  darkRightBackgroundColor,
                                ]
                                    : [
                                  lightLeftBackgroundColor,
                                  lightRightBackgroundColor,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              //gradient: beatGradient,
                              //color: mainButtonColor,
                              boxShadow: [
                                BS.BoxShadow(
                                  color: isDarkMode ? darkLeftShadow : lightLeftShadow,
                                  offset: -(isLoginPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isLoginPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isLoginPressed,
                                ),
                                BS.BoxShadow(
                                  color: isDarkMode ? darkRightShadow : lightRightShadow,
                                  offset: (isLoginPressed ? offsetPress : offsetNonPress) * 1.2,
                                  blurRadius: (isLoginPressed ? blur : blur * 3),
                                  spreadRadius: 0.0,
                                  inset: isLoginPressed,
                                ),
                              ]
                          ),
                          child: Align(
                            alignment: Alignment(0, 0),
                            child: IconButton(
                              color: mainButtonColor,
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  setState(() {
                                    _isloading = true;
                                  });

                                  if (passwordConfirmController.text != passwordController.text) {
                                    responseBar("Passwords do not match.", neutralButtonColor, context);
                                  }
                                  else if (passwordConfirmController.text != passwordController.text) {
                                    responseBar("Passwords do not match.", neutralButtonColor, context);
                                  }
                                  else {
                                    var response = await Provider.of<Auth>(context, listen: false).register(emailController.text,
                                      nicknameController.text,
                                      passwordController.text,
                                    );
                                    if (response == null) {
                                      responseBar("There was en error during registration. Check your connection.", neutralButtonColor, context);
                                    }
                                    else if (passwordConfirmController.text != passwordController.text) {
                                      responseBar("Passwords do not match.", neutralButtonColor, context);
                                    }
                                    else {
                                      if (response.statusCode == 201) {
                                        responseBar("Registration successful", neutralButtonColor, context);
                                        await Provider.of<Auth>(context, listen: false).login(nicknameController.text, passwordController.text);
                                        var resp = await Like().likeSong(24);
                                        resp = await Like().likeSong(30);
                                        resp = await Like().likeSong(10);
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.clear();
                                        Navigator.of(context).pop();
                                      }
                                      else if (response.statusCode == 403) {
                                        responseBar(response.data["detail"], neutralButtonColor, context);
                                      }
                                      else if (response.statusCode >= 500) {
                                        responseBar("There is an error on server side, sit tight...", neutralButtonColor, context);
                                      }
                                      else {
                                        responseBar("There was en error during registration.", neutralButtonColor, context);
                                      }
                                    }
                                  }

                                  setState(() {
                                  _isloading = false;
                                  });

                                }
                              },
                              icon: const Icon(CupertinoIcons.play_arrow_solid),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: defaultPadding * 2,),

                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: defTextSize * 0.75,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? ', style: TextStyle(color: secondaryTextColor,)),
                          TextSpan(text: 'Sign In.', style: const TextStyle(color: mainButtonColor),
                            recognizer: TapGestureRecognizer()..onTap = () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                              setState(() {

                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
}


