import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trikart_flutter_app/common/font_style.dart';
import 'package:trikart_flutter_app/utilities/hex_color.dart';

class OtpCountDownTimer extends StatefulWidget {
  final VoidCallback? callback;
  final int? otpTime;
  OtpCountDownTimer({this.callback, this.otpTime});
  @override
  _OtpCountDownTimerState createState() => _OtpCountDownTimerState();
}

class _OtpCountDownTimerState extends State<OtpCountDownTimer> {
  late StreamController<bool> _showResendButton;
  late StreamController<int> _otpTimerCount;

  Stream<bool> get showResendButtonStream => _showResendButton.stream;
  Stream<int> get otpTimerCountStream => _otpTimerCount.stream;

  Sink<bool> get showResendButton => _showResendButton.sink;
  Sink<int> get otpTimerCount => _otpTimerCount.sink;

  late Timer timer;
  late int ticker;

  @override
  void initState() {
    _showResendButton = StreamController<bool>.broadcast();
    _otpTimerCount = StreamController<int>.broadcast();
    otpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _showResendButton.close();
    _otpTimerCount.close();
    timer.cancel();
    super.dispose();
  }

  void otpTimer() {
    showResendButton.add(true);
    ticker = widget.otpTime!;
    const seconds = Duration(seconds: 1);
    timer = Timer.periodic(seconds, (_) {
      if (ticker == 0) {
        print("Timer Cancelled");
        showResendButton.add(false);
        timer.cancel();
        ticker = widget.otpTime!;
      } else {
        // print("Seconds : $ticker");
        otpTimerCount.add(ticker);
        ticker--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: showResendButtonStream,
        initialData: true,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == false) {
              return GestureDetector(
                onTap: () {
                  widget.callback!();
                  otpTimer();
                },
                child: Text("Resend code",
                    style: FontStyle.primary14Bold),
              );
            } else {
              return StreamBuilder<int>(
                  stream: otpTimerCountStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Duration clockTimer = Duration(seconds: snapshot.data ?? 0);

                      String timerText =
                          '0${clockTimer.inMinutes.remainder(60).toString()} : ${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

                      // print(timerText);
                      return Text(timerText,
                          style: FontStyle.primary14Bold);
                    } else {
                      return Container();
                    }
                  });
            }
          } else {
            return Container();
          }
        });
  }
}
