import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphism/constants.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import 'package:neumorphism/widgets/album.dart';
import 'package:neumorphism/widgets/loadingScreen.dart';
import 'package:neumorphism/widgets/responseBar.dart';
import 'package:neumorphism/widgets/tinyAlbum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'api/like.dart';
import 'api/song.dart';
import 'main.dart';
import 'widgets/beats.dart';

class SongItem {
  final int song_id;
  final String counter;
  final String name;
  final String author;

  const SongItem({
    required this.song_id,
    required this.counter,
    required this.name,
    required this.author
  });
}

class SongTrack {
  final int song_id;
  final String counter;
  final String name;
  final String author;

  const SongTrack({
    required this.song_id,
    required this.counter,
    required this.name,
    required this.author
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 1;
  bool isPressed = false;
  bool isPlayPressed = false;
  bool isCheckPressed = false;
  bool isXPressed = false;

  bool _isLoading = false;

  List<SongItem> favorites = [/*
    const SongItem(song_id: 1,counter: "01", name: "159feel.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 2,counter: "02", name: "77que.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 3,counter: "03", name: "146quake.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 4,counter: "04", name: "154chicago.mp3", author: "Marko Stahovec"),
  */];

  List<SongItem> allSongs = [/*
    const SongItem(song_id: 8,counter: "01", name: "45smoke.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 9,counter: "02", name: "57dmatch.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 10,counter: "03", name: "62trav.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 11,counter: "04", name: "66lack.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 12,counter: "01", name: "73model.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 13,counter: "02", name: "73west.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 14,counter: "03", name: "85bay.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 15,counter: "04", name: "91ride.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 16,counter: "01", name: "98swing.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 17,counter: "02", name: "103swt.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 18,counter: "03", name: "106new.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 19,counter: "04", name: "110wao.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 20,counter: "01", name: "112reveal.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 21,counter: "02", name: "117duel.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 22,counter: "03", name: "118ny.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 23,counter: "04", name: "122mind.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 24,counter: "01", name: "125dua.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 25,counter: "02", name: "130matrix.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 26,counter: "03", name: "142neon.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 27,counter: "04", name: "145around.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 28,counter: "01", name: "146quake.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 29,counter: "02", name: "148corda.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 30,counter: "03", name: "149life.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 31,counter: "04", name: "154chicago.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 32,counter: "01", name: "157waves.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 33,counter: "02", name: "158spin.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 34,counter: "03", name: "159feel.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 35,counter: "04", name: "52stomp.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 36,counter: "04", name: "54code.mp3", author: "Marko Stahovec"),
    const SongItem(song_id: 37,counter: "04", name: "89glitch.mp3", author: "Marko Stahovec"),
  */];

  String formatCounter(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return seconds;
  }

  String formatCount(String n) => n.toString().padLeft(2, '0');

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    loadAllSongs();
    loadFavorites();
    setState(() {
      _isLoading = false;
    });
  }

  loadFavorites() async {
    var response = await Like().getAllLikes();

    favorites.clear();
    response?.data.forEach((item){
      favorites.add(SongItem(song_id: item["song_id"], name: item["name"], author: item["author"], counter: counter.toString()));
      counter = counter + 1;
    });

    setState(() {});
  }

  loadAllSongs() async {
    var response = await Song().getAllSongs();

    allSongs.clear();
    response?.data.forEach((item){
      allSongs.add(SongItem(song_id: item["song_id"], name: item["name"], author: item["author"], counter: counter.toString()));
      print(item);
    });

    setState(() {});
  }

  Future<bool> dialogConfirmation(
      Offset offset,
      Size buttonSize,
      BuildContext context,
      String questionMark,
      String content, {
        String textNo = 'No',
        String textYes = 'Yes',
      }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState)
        {
          return AlertDialog(
            backgroundColor: isDarkMode
                ? darkRightBackgroundColor
                : lightRightBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            alignment: Alignment.center,
            content: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: const TextStyle(
                  fontSize: defTextSize,
                  fontWeight: FontWeight.w400,
                ),
                children: <TextSpan>[
                  TextSpan(text: content, style: TextStyle(color: isDarkMode ? darkMainTextColor : lightMainTextColor,)),
                  TextSpan(text: questionMark, style: TextStyle(color: mainButtonColor)),
                ],
              ),
            ),
            actionsOverflowButtonSpacing: 0.0,
            actions: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: buttonSize.width,
                        height: buttonSize.height,
                        child: Listener(
                          onPointerUp: (_) =>
                              setState(() => isCheckPressed = false),
                          onPointerDown: (_) =>
                              setState(() => isCheckPressed = true),
                          child:
                          AnimatedContainer(
                            duration: const Duration(
                                milliseconds: animationTime),
                            decoration: BS.BoxDecoration(
                                borderRadius: BorderRadius.circular(defRadius),
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
                                boxShadow: [
                                  BS.BoxShadow(
                                    color: isDarkMode
                                        ? darkLeftShadow
                                        : lightLeftShadow,
                                    offset: -offset,
                                    blurRadius: blurButton,
                                    spreadRadius: 0.0,
                                    inset: isCheckPressed,
                                  ),
                                  BS.BoxShadow(
                                    color: isDarkMode
                                        ? darkRightShadow
                                        : lightRightShadow,
                                    offset: offset,
                                    blurRadius: blurButton,
                                    spreadRadius: 0.0,
                                    inset: isCheckPressed,
                                  ),
                                ]


                            ),
                            child: Align(
                              alignment: Alignment(0, 0),
                              child: IconButton(
                                color: neutralButtonColor,
                                onPressed: () => Navigator.pop(context, true),
                                icon: Icon(CupertinoIcons.check_mark),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: buttonSize.width,
                        height: buttonSize.height,
                        child: Listener(
                          onPointerUp: (_) =>
                              setState(() => isXPressed = false),
                          onPointerDown: (_) =>
                              setState(() => isXPressed = true),
                          child:
                          AnimatedContainer(
                            duration: const Duration(
                                milliseconds: animationTime),
                            decoration: BS.BoxDecoration(
                                borderRadius: BorderRadius.circular(defRadius),
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
                                boxShadow: [
                                  BS.BoxShadow(
                                    color: isDarkMode
                                        ? darkLeftShadow
                                        : lightLeftShadow,
                                    offset: -offset,
                                    blurRadius: blurButton,
                                    spreadRadius: 0.0,
                                    inset: isXPressed,
                                  ),
                                  BS.BoxShadow(
                                    color: isDarkMode
                                        ? darkRightShadow
                                        : lightRightShadow,
                                    offset: offset,
                                    blurRadius: blurButton,
                                    spreadRadius: 0.0,
                                    inset: isXPressed,
                                  ),
                                ]
                            ),
                            child: Align(
                              alignment: Alignment(0, 0),
                              child: IconButton(
                                color: neutralButtonColor,
                                onPressed: () => Navigator.pop(context, false),
                                icon: Icon(CupertinoIcons.xmark),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Offset offset = isPressed ? offsetPress : offsetNonPress;
    double blur = blurButton;
    final width = MediaQuery.of(context).size.width;
    final squareSideLength = width / buttonSizeMultiplier;
    final buttonSize = Size(squareSideLength, squareSideLength);

    return WillPopScope(
      onWillPop: () async {
        bool? result= await dialogConfirmation(offset, buttonSize, context, "?",
            "Are you sure you want to log out");
        if(result == null){
          result = false;
        }
        else if (result == true) {
          await Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) => LoginPage()),
            ModalRoute.withName('/'),
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          responseBar("Log Out Successful", isDarkMode ? darkSnackbarColor : lightSnackbarColor, context);
        }
        return result;
      },
      child: Scaffold(
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
                right: 0,),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: defaultPadding * 1.5, top: defaultPadding * 2),
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
                                    Navigator.maybePop(context);
                                  },
                                  icon: Icon(CupertinoIcons.arrow_left),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                        /*
                      Text(
                        "All tracks",
                        style: GoogleFonts.poppins(
                          fontSize: defTextSize * 1.3,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                        ),
                      ),*/
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: defaultPadding, right: 0, top: defaultPadding),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Favorites",
                            style: GoogleFonts.poppins(
                              fontSize: defTextSize * 1.3,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: defaultPadding * 2.5, top: defaultPadding),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: buttonSize.width / 1.25,
                            height: buttonSize.height / 1.25,
                            child: Listener(
                              onPointerUp: (_) => setState(() => isPlayPressed = false),
                              onPointerDown: (_) => setState(() => isPlayPressed = true),
                              child:
                              AnimatedContainer(
                                curve: Curves.easeOutExpo,
                                duration: const Duration(milliseconds: animationTime),
                                decoration: BS.BoxDecoration(
                                    borderRadius: BorderRadius.circular(defRadius),
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
                                        offset: -offset,
                                        blurRadius: blur,
                                        spreadRadius: 0.0,
                                        inset: isPlayPressed,
                                      ),
                                      BS.BoxShadow(
                                        color: isDarkMode ? darkRightShadow : lightRightShadow,
                                        offset: offset,
                                        blurRadius: blur,
                                        spreadRadius: 0.0,
                                        inset: isPlayPressed,
                                      ),
                                    ]
                                ),
                                child: Align(
                                  alignment: Alignment(0, 0),
                                  child: IconButton(
                                    color: mainButtonColor,
                                    onPressed: () async {
                                      var response2 = await Song().getSongInfo(favorites[0].song_id);

                                      if (response2 == null) {
                                        responseBar("There was en error, check your connection.", mainButtonColor, context);
                                      }
                                      else {
                                        if (response2.statusCode == 200) {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlayerPage(queue: favorites, trackname: favorites[0].name, song_id: 2, favorites: favorites),
                                            ),
                                          );
                                          setState(() {

                                          });
                                        }
                                        else if (response2.statusCode == 403) {
                                          responseBar(response2.data["detail"], mainButtonColor, context);
                                          //Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SearchScreen()));
                                        }
                                        else if (response2.statusCode >= 500) {
                                          responseBar("There is an error on server side, sit tight...", mainButtonColor, context);
                                        }
                                        else {
                                          responseBar("There was en error, check your connection.", mainButtonColor, context);
                                        }
                                      }
                                      setState(() {});
                                    },
                                    icon: const Icon(CupertinoIcons.play_arrow_solid),

                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding / 2, right: 0, top: defaultPadding),
                    child: Container(
                      color: Colors.white.withOpacity(0),
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: favorites.length,
                        separatorBuilder: (context, _) => const SizedBox(height: defaultPadding, width: defaultPadding,),
                        itemBuilder: (context, index) => buildCard(item: favorites[index]),
                      ),
                    ),
                  ),
                  const SizedBox(height: defaultPadding * 1.5,),
                  Padding(
                    padding: const EdgeInsets.only(left: defaultPadding / 2, right: 0, top: defaultPadding),
                    child: Container(
                      color: Colors.white.withOpacity(0),
                      height: MediaQuery.of(context).size.height * 0.38,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: allSongs.length,
                        key: UniqueKey(),
                        separatorBuilder: (context, _) => const SizedBox(height: 0, width: defaultPadding,),
                        itemBuilder: (context, index) =>  buildRow(item: allSongs[index]),
                      ),
                    ),
                  ),
                  linearLoadingScreen(_isLoading),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget buildCard({
  required SongItem item,
}) => AnimatedContainer(
    width: MediaQuery.of(context).size.height * 0.25,
    curve: Curves.easeOutExpo,
    duration: const Duration(milliseconds: animationTime),
    margin: EdgeInsets.only(top: defaultPadding / 1.5, bottom: defaultPadding / 1.5,
    left: defaultPadding / 2, right: defaultPadding / 2),
    decoration: BS.BoxDecoration(
        borderRadius: BorderRadius.circular(defRadius),
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
            offset: -(isPressed ? offsetPress : offsetNonPress),
            blurRadius: blurButton,
            spreadRadius: 0.0,
            //inset: isPlayPressed,
          ),
          BS.BoxShadow(
            color: isDarkMode ? darkRightShadow : lightRightShadow,
            offset: isPressed ? offsetPress : offsetNonPress,
            blurRadius: blurButton,
            spreadRadius: 0.0,
            //inset: isPlayPressed,
          ),
        ]
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: defaultPadding, top: defaultPadding),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              formatCount(item.counter),
              style: GoogleFonts.poppins(
                fontSize: defTextSize * 1.5,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? darkMainTextColor : lightMainTextColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: defaultPadding / 8,),
        Padding(
          padding: EdgeInsets.only(left: defaultPadding, top: defaultPadding / 1.5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: GoogleFonts.poppins(
                fontSize: defTextSize * 0.8,
                fontWeight: FontWeight.w300,
                color: secondaryTextColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: defaultPadding / 8,),
        Padding(
          padding: EdgeInsets.only(left: defaultPadding,),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.author,
              style: GoogleFonts.poppins(
                fontSize: defTextSize * 0.8,
                fontWeight: FontWeight.w300,
                color: secondaryTextColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildRow({
    required SongItem item,
  }) => AnimatedContainer(
    curve: Curves.easeOutExpo,
    duration: const Duration(milliseconds: animationTime),
    margin: const EdgeInsets.only(top: 0, bottom: 0,
        left: defaultPadding / 2, right: defaultPadding / 2),
    /*
    decoration: BS.BoxDecoration(
        borderRadius: BorderRadius.circular(defRadius),
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
            offset: -(isPressed ? offsetPress : offsetNonPress),
            blurRadius: blurButton,
            spreadRadius: 0.0,
            //inset: isPlayPressed,
          ),
          BS.BoxShadow(
            color: isDarkMode ? darkRightShadow : lightRightShadow,
            offset: isPressed ? offsetPress : offsetNonPress,
            blurRadius: blurButton,
            spreadRadius: 0.0,
            //inset: isPlayPressed,
          ),
        ]
    ),*/
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TinyAlbum(),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: defaultPadding, top: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: defTextSize * 0.75,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: defaultPadding / 8,),
            Padding(
              padding: EdgeInsets.only(left: defaultPadding, top: 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item.author,
                  style: GoogleFonts.poppins(
                    fontSize: defTextSize * 0.6,
                    fontWeight: FontWeight.w300,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: defaultPadding * 2, top: 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: MediaQuery.of(context).size.width / buttonSizeMultiplier / 1.25,
              height: MediaQuery.of(context).size.width / buttonSizeMultiplier / 1.25,
              child: AnimatedContainer(
                curve: Curves.easeOutExpo,
                duration: const Duration(milliseconds: animationTime),
                decoration: BS.BoxDecoration(
                    borderRadius: BorderRadius.circular(defRadius),
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
                    ]
                ),
                child: Align(
                  alignment: Alignment(0, 0),
                  child: IconButton(
                    color: neutralButtonColor,
                    onPressed: () async {
                      print(item.song_id);

                      var response2 = await Song().getSongInfo(item.song_id);

                      if (response2 == null) {
                        responseBar("There was en error, check your connection.", mainButtonColor, context);
                      }
                      else {
                        if (response2.statusCode == 200) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerPage(favorites: favorites, queue: allSongs, trackname: item.name, song_id: item.song_id),
                            ),
                          );
                          setState(() {

                          });
                        }
                        else if (response2.statusCode == 403) {
                          responseBar(response2.data["detail"], mainButtonColor, context);
                          //Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SearchScreen()));
                        }
                        else if (response2.statusCode >= 500) {
                          responseBar("There is an error on server side, sit tight...", mainButtonColor, context);
                        }
                        else {
                          responseBar("There was en error, check your connection.", mainButtonColor, context);
                        }
                      }
                    },
                    icon: const Icon(CupertinoIcons.play_arrow_solid),

                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}