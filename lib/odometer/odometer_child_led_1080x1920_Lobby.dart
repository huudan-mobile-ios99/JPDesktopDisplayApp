

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/odometer/odometer_child.dart';
import 'package:playtech_transmitter_app/odometer/odometer_number.dart';
import 'package:playtech_transmitter_app/odometer/slide_odometer.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'dart:async';
import 'package:playtech_transmitter_app/service/widget/text_style.dart';



class GameOdometerChildLed1080x1920Lobby extends StatefulWidget {
  final double startValue;
  final double endValue;
  final double hiveValue; // New field for Hive initial value
  final String nameJP;
  final bool isSmall;

   const GameOdometerChildLed1080x1920Lobby({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.hiveValue,
    required this.nameJP,
    required this.isSmall,
  });

  @override
  _GameOdometerChildLed1080x1920LobbyState createState() => _GameOdometerChildLed1080x1920LobbyState();
}

class _GameOdometerChildLed1080x1920LobbyState extends State<GameOdometerChildLed1080x1920Lobby> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<OdometerNumber> odometerAnimation;
  late ValueNotifier<double> currentValueNotifier;
  late int durationPerStep;
  late int durationPerStepHive;
  Timer? _animationTimer;
  final String fontFamily = 'sf-pro-display';
  bool _isFirstRun = true; // Flag to use hiveValue on first run
  static const Duration _debounceDuration = Duration(seconds: 0);
  DateTime? _lastUpdateTime;
  final bool _isDisposing = false;
  final double totalDuration = ConfigCustom.durationFinishCircleSpinNumberDouble; // 29.5 seconds


  @override
  void initState() {
    super.initState();
    final initialValue = widget.startValue == 0.0 ? widget.hiveValue : widget.startValue;
    currentValueNotifier = ValueNotifier<double>(initialValue);
    durationPerStep = calculationDurationPerStep(
      // totalDuration: totalDuration,
      startValue: initialValue,
      endValue: widget.endValue,
    );
    // debugPrint('INIT durationPerStep $durationPerStep');
    _initializeAnimationController();
    _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);
    // _isFirstRun? debugPrint('#FirstRun') : debugPrint('#NextRun');
  }



  @override
  void didUpdateWidget(covariant GameOdometerChildLed1080x1920Lobby oldWidget) {
    super.didUpdateWidget(oldWidget);
    final now = DateTime.now();
    // if (_lastUpdateTime != null && now.difference(_lastUpdateTime!) < _debounceDuration) {
    //   // _logger.d('Odometer: ${widget.nameJP}, Skipping update due to debounce, lastUpdate: $_lastUpdateTime');
    //   return;
    // }
    if (widget.startValue != oldWidget.startValue || widget.endValue != oldWidget.endValue) {
      _animationTimer?.cancel();
      currentValueNotifier.value = widget.startValue == 0.0 ? widget.endValue : widget.startValue;
      durationPerStep = calculationDurationPerStep(
        // totalDuration: totalDuration,
        startValue:_isFirstRun==true ? widget.hiveValue :  widget.startValue,
        endValue: widget.endValue,
      );
      // debugPrint('DIDUPDATe durationPerStep $durationPerStep');


      animationController
        ..stop()
        ..duration = Duration(milliseconds: durationPerStep);
       _updateAnimation(currentValueNotifier.value, currentValueNotifier.value);

      if (_isFirstRun == true && widget.hiveValue > 0 && widget.hiveValue < widget.endValue) {
        _startAutoAnimation(widget.hiveValue);
      }
      if (widget.startValue != 0.0  || widget.startValue !=0 && !_isDisposing) {
        _startAutoAnimation(widget.startValue);
      }
      _isFirstRun = false; // Disable hiveValue after first run
      _lastUpdateTime = now;
    }
  }




  void _startAutoAnimation(double startValue) {
    const increment = 0.01;
    final interval = Duration(milliseconds:  durationPerStep.clamp(10,ConfigCustom.maxTimeToStartAnDecimalAnimationMs));
    _animationTimer?.cancel();
    currentValueNotifier.value = startValue;
    _updateAnimation(startValue, startValue);
    _animationTimer = Timer.periodic(interval, (timer) {
      if (!mounted || _isDisposing || currentValueNotifier.value >= widget.endValue) {
        timer.cancel();
        // _logger.d('Odometer: ${widget.nameJP}, Animation completed or unmounted, currentValue: ${currentValueNotifier.value}');
        return;
      }
      if (currentValueNotifier.value >= widget.endValue || !mounted) {
        timer.cancel();
        return;
      }
      final nextValue = (currentValueNotifier.value + increment).clamp(currentValueNotifier.value, widget.endValue);
      _updateAnimation(currentValueNotifier.value, nextValue);
      currentValueNotifier.value = nextValue;
      animationController.forward(from: 0.0);

    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    animationController.dispose();
    currentValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

 return ClipRect(
      child: RepaintBoundary(
        child: Container(
          // color:Colors.white10,
          alignment: Alignment.center,
          width: ConfigCustom.fixWidth_HD_led_lobby,
          height: ConfigCustom.odo_height_1080x1920_lobby,
          child: Stack(
            children: [
              Positioned(
                top:  -ConfigCustom.odo_position_top_1080x1920_lobby,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<double>(
                  valueListenable: currentValueNotifier,
                  builder: (context, value, child) {
                    // FINAL RULE: If value is 0.0 or negative ? SHOW NOTHING
                    if (value <= 0.01) {
                      return const SizedBox.shrink(); // Completely invisible, no space, no 0.00
                    }
                    return SlideOdometerTransition(
                      verticalOffset:  ConfigCustom.text_odo_letter_vertical_offset_1080x1920_lobby,
                      groupSeparator: const Text(',', style:  textStyleOdo1080x1920Lobby,),
                      decimalSeparator: const Text('.', style:  textStyleOdo1080x1920Lobby,),
                      letterWidth:ConfigCustom.text_odo_letter_width_1080x1920_lobby,
                      odometerAnimation: odometerAnimation,
                      numberTextStyle: textStyleOdo1080x1920Lobby, 
                      decimalPlaces: 2,
                      integerDigits: 0,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _initializeAnimationController() {
    animationController = AnimationController(
      duration: Duration(milliseconds: durationPerStep),
      vsync: this,
    );
  }

  void _updateAnimation(double start, double end) {
    odometerAnimation = OdometerTween(
      begin: OdometerNumber((start * 100).round()),
      end: OdometerNumber((end * 100).round()),
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );
  }
}


