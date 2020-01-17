//// Copyright 2019 The Chromium Authors. All rights reserved.
//// Use of this source code is governed by a BSD-style license that can be
//// found in the LICENSE file.
//
//import 'dart:async';
//
//import 'package:flutter_clock_helper/model.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:video_player/video_player.dart';
//
//enum _Element {
//  background,
//  text,
//  shadow,
//}
//
//final _lightTheme = {
//  _Element.background: Color(0xFFFFFFFF),
//  _Element.text: Colors.black,
//  _Element.shadow: Colors.white,
//};
//
//final _darkTheme = {
//  _Element.background: Color(0xFF1F1E51),
//  _Element.text: Colors.white,
//  _Element.shadow: Color(0xFF174EA6),
//};
//
///// A basic digital clock.
/////
///// You can do better than this!
//class DigitalClock extends StatefulWidget {
//  const DigitalClock(this.model);
//
//  final ClockModel model;
//
//  @override
//  _DigitalClockState createState() => _DigitalClockState();
//}
//
//class _DigitalClockState extends State<DigitalClock> {
//  DateTime _dateTime = DateTime.now();
//  Timer _timer;
//  VideoPlayerController _controller;
//
//  @override
//  void initState() {
//    super.initState();
//    widget.model.addListener(_updateModel);
//    _updateTime();
//    _updateModel();
//    _controller = VideoPlayerController.asset("assets/bg-light.mp4")
//      ..initialize().then((_) {
//        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//        setState(() {});
//        _controller.play();
//      });
//  }
//
//  @override
//  void didUpdateWidget(DigitalClock oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.model != oldWidget.model) {
//      oldWidget.model.removeListener(_updateModel);
//      widget.model.addListener(_updateModel);
//    }
//  }
//
//  @override
//  void dispose() {
//    _timer?.cancel();
//    widget.model.removeListener(_updateModel);
//    widget.model.dispose();
//    super.dispose();
//  }
//
//  void _updateModel() {
//    setState(() {
//      // Cause the clock to rebuild when the model changes.
//    });
//  }
//
//  void _updateTime() {
//    setState(() {
//      _dateTime = DateTime.now();
//      // Update once per minute. If you want to update every second, use the
//      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );
//      if (_controller != null) {
//        _controller.seekTo(Duration(seconds: 0));
//        _controller.play();
//      }
//      // Update once per second, but make sure to do it at the beginning of each
//      // new second, so that the clock is accurate.
//      // _timer = Timer(
//      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
//      //   _updateTime,
//      // );
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final bool _isLightTheme = Theme.of(context).brightness == Brightness.light;
//    final colors = _isLightTheme ? _lightTheme : _darkTheme;
//    final hour =
//        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
//    final minute = DateFormat('mm').format(_dateTime);
//    final fontSize = 30.0;
//    final offset = -fontSize / 7;
//    final defaultStyle = TextStyle(
//      color: colors[_Element.text],
//      fontFamily: 'PressStart2P',
//      fontSize: fontSize,
//      shadows: [
//        Shadow(
//          blurRadius: 0,
//          color: colors[_Element.shadow],
//          offset: Offset(10, 0),
//        ),
//      ],
//    );
//
//    return Container(
//      color: colors[_Element.background],
//      child: Center(
//        child:
////        DefaultTextStyle(
////          style: defaultStyle,
////          child:
//            Stack(
//          children: <Widget>[
//            _isLightTheme
//                ? Align(
//                    alignment: Alignment(2, 0),
//                    child: Container(
//                      child: _controller.value.initialized
//                          ? AspectRatio(
//                              aspectRatio: _controller.value.aspectRatio,
//                              child: VideoPlayer(_controller),
//                            )
//                          : Container(),
//                    ),
//                  )
//                : Align(
//                    alignment: Alignment.centerRight,
//                    child: Container(
//                      child: Image.asset("assets/bg-dark.jpg",
//                          height: MediaQuery.of(context).size.height * 0.5,
//                          fit: BoxFit.contain),
//                    ),
//                  ),
//            Align(
//              alignment: Alignment.centerLeft,
//              child: Container(
//                padding: EdgeInsets.only(left: 40),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text("Wed, August 8",
//                        style: TextStyle(
//                            fontSize: 30, fontWeight: FontWeight.w200)),
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      children: <Widget>[
//                        Text("$hour:",
//                            style: TextStyle(
//                                fontSize: 110, fontWeight: FontWeight.bold)),
//                        Text(minute,
//                            style: TextStyle(
//                                fontSize: 110, fontWeight: FontWeight.w200)),
//                        Padding(
//                          padding: const EdgeInsets.only(bottom: 16.0),
//                          child: Text("AM",
//                              style: TextStyle(
//                                  fontSize: 20, fontWeight: FontWeight.w300)),
//                        )
//                      ],
//                    ),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Padding(
//                          padding: EdgeInsets.only(top: 40, bottom: 5),
//                          child: Text('TODAY:',
//                              style: TextStyle(color: Color(0xffbbbbbf))),
//                        ),
//                        Column(
//                            children: [
//                          "Plan vacation with family",
//                          "Larry's Birthday"
//                        ].map((e) {
//                          return Padding(
//                            padding: const EdgeInsets.symmetric(vertical: 2.0),
//                            child: Row(
//                              children: <Widget>[
//                                Container(
//                                  width: 10,
//                                  height: 10,
//                                  color: Colors.blue,
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 8.0),
//                                  child: Text(
//                                    e,
//                                    style: TextStyle(
//                                        fontSize: 16, color: Color(0xff2c2c2c)),
//                                  ),
//                                )
//                              ],
//                            ),
//                          );
//                        }).toList())
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
////              Positioned(left: offset, top: 0, child: Text(hour)),
////              Positioned(right: offset, bottom: offset, child: Text(minute)),
//          ],
//        ),
////        ),
//      ),
//    );
//  }
//}
