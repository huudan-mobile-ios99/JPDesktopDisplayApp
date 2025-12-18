import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Floor2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Floor3Mega.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Non_Smoke.dart';
import 'package:playtech_transmitter_app/service/hive_service/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_state.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';

class JackpotDisplayScreen5200x1664LedMega extends StatefulWidget {
  const JackpotDisplayScreen5200x1664LedMega({super.key});

  @override
  State<JackpotDisplayScreen5200x1664LedMega> createState() => _JackpotDisplayScreen5200x1664LedMegaState();
}

class _JackpotDisplayScreen5200x1664LedMegaState extends State<JackpotDisplayScreen5200x1664LedMega> {
  final SettingsService settingsService = SettingsService();
  late Future<Map<String, double>> _hiveValuesFuture;

  @override
  void initState() {
    super.initState();
    // Fetch Hive data once on initialization
    _hiveValuesFuture = JackpotHiveService().getJackpotHistory().then((state) => state.first );
  }

  @override
  Widget build(BuildContext context) {
    return
    Container(
      width: ConfigCustom.fixWidth_ledFloor3Mega,
      height: ConfigCustom.fixHeight_ledFloor3Mega,
      // height: 200,
      // color: Colors.white.withOpacity(0.31),
      child: FutureBuilder<Map<String, double>>(
        future: _hiveValuesFuture,
        builder: (context, snapshot) {
          Map<String, double> hiveValues = {};
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            hiveValues = snapshot.data!;
          } else if (snapshot.hasError) {
            debugPrint('Error loading Hive data: ${snapshot.error}');
          }
      
          return BlocBuilder<VideoBloc, ViddeoState>(
            buildWhen: (previous, current) => previous.id != current.id,
            builder: (context, state) {
              return BlocBuilder<JackpotPriceBloc, JackpotPriceState>(
                buildWhen: (previous, current) =>
                    previous.isConnected != current.isConnected ||
                    previous.error != current.error ||
                    previous.jackpotValues != current.jackpotValues ||
                    previous.previousJackpotValues != current.previousJackpotValues,
                builder: (context, priceState) {
                  debugPrint('Building JackpotDisplayScreen5200x1664LedMega:${priceState.hasData}');
                  return priceState.isConnected
                      ?  SizedBox(
                          width: ConfigCustom.fixWidth_HD_led_curved,
                          height: ConfigCustom.fixWidth_HD_led_curved,
                          child: screenLedFloor3Mega(context, hiveValues,priceState.previousJackpotValues,priceState.jackpotValues),
                        
                        )
                      :
                      priceState.error != null ? Container() : circularProgessCustom();
                },
              );
            },
          );
        },
      ),
    );
  }
}
