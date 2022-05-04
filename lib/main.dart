import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';

import '../key.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as BS;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphism/LoginPage.dart';
import 'package:neumorphism/widgets/album.dart';
import 'package:neumorphism/widgets/beats.dart';
import 'package:provider/provider.dart';
import 'HomePage.dart';
import 'api/auth.dart';
import 'widgets/neu_button.dart';
import 'constants.dart';
import 'widgets/neu_button.dart';
import 'widgets/neu_icon_button.dart';
import 'widgets/neu_text.dart';
import 'widgets/labels.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (ctx) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ThemeData().colorScheme.copyWith(
            primary: mainButtonColor,
          ),
        )
      ),
    );
  }
}

bool isDarkMode = false;

class PlayerPage extends StatefulWidget {
  final Uint8List track;

  PlayerPage({
    required this.track,
  });

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPressed = false;
  bool isPlayPressed = false;
  bool isLiked = false;
  bool isRepeating = false;
  bool isShuffling = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late AnimationController _controller;


  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) async {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) async {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) async {
      setState(() {
        position = newPosition;
      });
    });

    _controller = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _controller.repeat(reverse: true);
  }

  Future<Uint8List> get _localFile async {
    final directory = await getTemporaryDirectory();
    final path = directory.path;
    final file = File('$path/audio.mp3');
    final contents = file.readAsBytesSync();

    return contents;
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.STOP);
/*
    String url = 'https://www.dropbox.com/s/w8mxxudnwm11zoi/154chicago.wav?dl=0';
    audioPlayer.setUrl(url);*/

    /*
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/audio.mp3');
    final AudioCache player = AudioCache(prefix: path, fixedPlayer: audioPlayer);
    await audioPlayer.setUrl(Uri.file(file.path).path, isLocal: true);
    await player.load('/audio.mp3');
*/

    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/audio.mp3');
    await tempFile.writeAsBytes(ByteData.view(widget.track.buffer).buffer.asUint8List(), flush: true);
    String mp3Uri = tempFile.uri.toString();
    audioPlayer.setUrl(mp3Uri, isLocal: true);

/*
    var url = await player.load('103swt.mp3');
    audioPlayer.setUrl(url.path, isLocal: true);
    url = await player.load('audio.mp3');
*/

    /*
    Uint8List track = await _localFile;
    Uint8List audiobytes = track.buffer.asUint8List(track.offsetInBytes, track.lengthInBytes);
    final AudioCache player = AudioCache(fixedPlayer: audioPlayer);
    player.playBytes(audiobytes);*/

    /*
    final url = await player.load('103swt.mp3');
    audioPlayer.setUrl(url.path, isLocal: true);*/
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    //final bgColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    Offset offset = isPressed ? offsetPress : offsetNonPress;
    double blur = blurButton;
    final width = MediaQuery.of(context).size.width;
    final squareSideLength = width / buttonSizeMultiplier;
    final buttonSize = Size(squareSideLength, squareSideLength);

    //final song = ModalRoute.of(context)!.settings.arguments as SongTrack;

    return Scaffold(
      //backgroundColor: bgColor,
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
                                  setState(() {});
                                  isDarkMode = !isDarkMode;
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
                const SizedBox(height: defaultPadding * 2,),
                Album(),
                const SizedBox(height: defaultPadding * 2,),
                Labels(),
                SliderTheme(
                  data: SliderThemeData(
                    thumbColor: mainButtonColor,
                    inactiveTrackColor: isDarkMode ? neutralButtonColor : lightButtonColor,
                    activeTrackColor: mainButtonColor,
                    overlayColor: mainButtonColor,
                      thumbShape: SliderComponentShape.noThumb,
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                  ),
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);

                      await audioPlayer.resume();
                    },
                  ),
                ),
                /*
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [

                      Text(formatTime(position),
                        style: GoogleFonts.openSans(
                          fontSize: defTextSize * 0.8,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                        ),
                      ),
                      Text(formatTime(duration),
                        style: GoogleFonts.openSans(
                          fontSize: defTextSize * 0.8,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode ? darkMainTextColor : lightMainTextColor,
                        ),
                      ),
                    ],
                  ),
                ),*/
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: defaultPadding, right: defaultPadding, top: defaultPadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            NeuIconButton(
                              icon: CupertinoIcons.backward_end_fill,
                              iconColor: neutralButtonColor,
                              secondaryIcon: CupertinoIcons.backward_end_fill,
                              onPressed: () {  },),
                            const SizedBox(width: defaultPadding * 2.5,),
                            SizedBox(
                              width: buttonSize.width,
                              height: buttonSize.height,
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
                                        if (isPlaying) {
                                          await audioPlayer.pause();
                                        }
                                        else {
                                          await audioPlayer.resume();
                                        }
                                      },
                                      icon: isPlaying ? const Icon(CupertinoIcons.pause_solid) : const Icon(CupertinoIcons.play_arrow_solid),

                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: defaultPadding * 2.5,),
                            NeuIconButton(
                              icon: CupertinoIcons.forward_end_fill,
                              iconColor: neutralButtonColor,
                              secondaryIcon: CupertinoIcons.forward_end_fill,
                              onPressed: () {  },),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0, top: defaultPadding * 3),
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

                                },
                                icon: Icon(CupertinoIcons.square_list),
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
                                color: isShuffling ? mainButtonColor : neutralButtonColor,
                                onPressed: () {
                                  setState(() {
                                    isShuffling = !isShuffling;
                                  });
                                },
                                icon: Icon(CupertinoIcons.shuffle),
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
                                color: isRepeating ? mainButtonColor : neutralButtonColor,
                                onPressed: () {
                                  setState(() {
                                    isRepeating = !isRepeating;
                                  });
                                },
                                icon: Icon(CupertinoIcons.repeat),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ScaleTransition(
                        scale: isLiked ? Tween(begin: 0.45, end: 1.0).animate(CurvedAnimation(
                            parent: _controller,
                            curve: Curves.elasticOut
                          )
                        ) : Tween(begin: 1.0, end: 1.0).animate(CurvedAnimation(
                            parent: _controller,
                            curve: Curves.elasticOut
                        )
                        ),
                        child: SizedBox(
                          width: buttonSize.width,
                          height: buttonSize.height,
                          child: Listener(
                            onPointerUp: (_) => setState(() => isPressed = false),
                            onPointerDown: (_) => setState(() => isPressed = true),
                            child:
                            AnimatedContainer(
                              duration: const Duration(milliseconds: animationTime),
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
                                boxShadow: [
                                  BS.BoxShadow(
                                    color: isDarkMode ? darkLeftShadow : lightLeftShadow,
                                    offset: -offset,
                                    blurRadius: blur,
                                    spreadRadius: 0.0,
                                    inset: isPressed,
                                  ),
                                  BS.BoxShadow(
                                    color: isDarkMode ? darkRightShadow : lightRightShadow,
                                    offset: offset,
                                    blurRadius: blur,
                                    spreadRadius: 0.0,
                                    inset: isPressed,
                                  ),
                                ]
                            ),*/
                              child: Align(
                                alignment: Alignment(0, 0),
                                child: IconButton(
                                  color: isLiked ? mainButtonColor : neutralButtonColor,
                                  onPressed: () {
                                    setState(() {
                                      isLiked = !isLiked;
                                    });
                                  },
                                  icon: isLiked ? Icon(CupertinoIcons.suit_heart_fill) : Icon(CupertinoIcons.suit_heart),
                                ),
                              ),
                            ),
                          ),
                         ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}