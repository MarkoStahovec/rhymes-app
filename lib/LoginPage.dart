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

import 'HomePage.dart';
import 'RegisterPage.dart';
import 'api/auth.dart';
import 'constants.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPressed = false;
  bool isNicknamePressed = false;
  bool isPasswordPressed = false;
  bool isLoginPressed = false;
  bool _isloading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //final bgColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    Offset offset = isPressed ? offsetPress : offsetNonPress;
    double blur = blurButton;
    final width = MediaQuery.of(context).size.width;
    final squareSideLength = width / buttonSizeMultiplier;
    final buttonSize = Size(squareSideLength, squareSideLength);

    return Scaffold(
      //backgroundColor: bgColor,
      resizeToAvoidBottomInset : false,
      body: Container(
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
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    setState(() {

                                    });
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
                  Album(size: 15,),
                  const SizedBox(height: defaultPadding * 2,),
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
                  ),
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
                                print(nicknameController);
                                print(passwordController);
                                var response = await Provider.of<Auth>(context, listen: false).login(nicknameController.text, passwordController.text);
                                print(response);

                                if (response == null) {
                                  responseBar("There was en error logging in. Check your connection.", mainButtonColor, context);
                                }
                                else {
                                  if (response.statusCode == 200) {
                                    // responseBar("Login successful", isDarkMode ? darkLeftBackgroundColor : lightLeftBackgroundColor);
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  }
                                  else if (response.statusCode == 403) {
                                    responseBar("Invalid credentials. Check your email and password.", mainButtonColor, context);
                                    //Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SearchScreen()));
                                  }
                                  else if (response.statusCode >= 500) {
                                    responseBar("There is an error on server side, sit tight...", mainButtonColor, context);
                                  }
                                  else {
                                    responseBar("There was en error logging in. Check your connection.", mainButtonColor, context);
                                  }
                                }

                                //Provider.of<Auth>(context, listen: false).login(emailController.text, passwordController.text);
                              }
                            },
                            icon: const Icon(CupertinoIcons.play_arrow_solid),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: defaultPadding * 3,),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: defTextSize * 0.75,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        const TextSpan(text: 'Don\'t have an account? ', style: TextStyle(color: secondaryTextColor,)),
                        TextSpan(text: 'Sign Up.', style: const TextStyle(color: mainButtonColor),
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (context) => RegisterPage(),
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
    );
  }
}