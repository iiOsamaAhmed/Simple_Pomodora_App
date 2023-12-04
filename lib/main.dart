// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: PomodoroApp(),
    );
  }
}

class PomodoroApp extends StatefulWidget {
  const PomodoroApp({super.key});

  @override
  State<PomodoroApp> createState() => _PomodoroAppState();
}

class _PomodoroAppState extends State<PomodoroApp> {
  Duration duration = Duration(minutes: 25);
  Timer? appTimer;

  startTimer() {
    appTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        int newDuration = duration.inSeconds - 1;
        duration = Duration(seconds: newDuration);
        if (duration.inSeconds == 0) {
          timer.cancel();
          setState(() {
            duration = Duration(minutes: 25);
            isRunning = false;
          });
        }
      });
    });
  }

  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text("Pomodoro App",
              style: TextStyle(color: Colors.white, fontSize: 27)),
          backgroundColor: Colors.blueGrey[800],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 125,
                center: Text(
                  "${duration.inMinutes.toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
                  style: TextStyle(color: Colors.white, fontSize: 75)),
                backgroundColor: Colors.white,
                progressColor: Colors.green,
                percent: duration.inMinutes/25,
                lineWidth: 5.0,
                animation: true,
                animateFromLastPercent: true,
                animationDuration: 250,

                ),
                SizedBox(height: 28,),
              isRunning
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              appTimer!.isActive
                                  ? setState(() {
                                      appTimer!.cancel();
                                    })
                                  : startTimer();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            child: Text(
                                appTimer!.isActive
                                    ? "Stop"
                                    : duration.inSeconds == 0
                                        ? "Stop"
                                        : "Resume",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))),
                        SizedBox(
                          width: 15,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              appTimer!.cancel();
                              setState(() {
                                isRunning = false;
                                duration = Duration(minutes: 25);
                              });
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red)),
                            child: Text("Cancel",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20))),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        startTimer();
                        isRunning = true;
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[800])),
                      child: Text("Start Studying",
                          style: TextStyle(color: Colors.white, fontSize: 20)))
            ],
          ),
        ));
  }
}
