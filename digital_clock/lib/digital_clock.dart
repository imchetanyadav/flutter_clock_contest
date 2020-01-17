// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'weather_background.dart';

enum _Element { background, shadow }

final _lightTheme = {
  _Element.background: Color(0xff5ebbd5),
  _Element.shadow: Color(0x77FFFFFF)
};

final _darkTheme = {
  _Element.background: Color(0xff0b2734),
  _Element.shadow: Color(0xCC000000)
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLightTheme = Theme.of(context).brightness == Brightness.light;
    final colors = _isLightTheme ? _lightTheme : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final day = "${DateFormat('E').format(_dateTime)}, ${DateFormat('LLLL').format(_dateTime)} ${DateFormat('d').format(_dateTime)}";

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        color: colors[_Element.background],
        child: Center(
          child: Stack(
            children: <Widget>[
              ClipRect(
                  child: WeatherBackground(
                      weatherType: widget.model.weatherString,
                      isLightTheme: _isLightTheme)),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(day,
                          style: TextStyle(
                              fontSize: constraints.maxWidth * 0.03,
                              fontWeight: FontWeight.w200,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: colors[_Element.shadow],
                                  offset: Offset(2.0, 2.0),
                                ),
                              ])),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("$hour:",
                              style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.2,
                                  fontWeight: FontWeight.w700,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: colors[_Element.shadow],
                                      offset: Offset(5.0, 5.0),
                                    ),
                                  ])),
                          Text(minute,
                              style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.2,
                                  fontWeight: FontWeight.w200,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: colors[_Element.shadow],
                                      offset: Offset(5.0, 5.0),
                                    ),
                                  ])),
                          widget.model.is24HourFormat
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      bottom: constraints.maxHeight * 0.06),
                                  child: Text(DateFormat('a').format(_dateTime),
                                      style: TextStyle(
                                          fontSize: constraints.maxWidth * 0.04,
                                          fontWeight: FontWeight.w300,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 10.0,
                                              color: colors[_Element.shadow],
                                              offset: Offset(5.0, 5.0),
                                            ),
                                          ])),
                                )
                        ],
                      ),
                      Opacity(
                        opacity: 0.8,
                        child: Container(
                          width: constraints.maxWidth * 0.5,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              _detailsRow(
                                  constraints.maxWidth,
                                  Icons.location_on,
                                  widget.model.location,
                                  widget.model.temperatureString),
                              _detailsRow(
                                  constraints.maxWidth,
                                  Icons.calendar_today,
                                  "Plan weekend trip",
                                  "Friend's Birthday")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

Widget _detailsRow(
    double _maxWidth, IconData _icon, String _text1, String _text2) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: _maxWidth * 0.01),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Icon(_icon, size: _maxWidth * 0.03),
        Padding(
          padding: EdgeInsets.only(left: _maxWidth * 0.02),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    _text1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: _maxWidth * 0.015),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      _text2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: _maxWidth * 0.015),
                    ))
              ]),
        )
      ],
    ),
  );
}
