import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Floor2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Floor3Mega.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Floor3Mega_BACK.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Non_Smoke.dart';
import 'package:playtech_transmitter_app/service/hive_service/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_state.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';

class JackpotDisplayScreen1920x1080Floor3MegaBack extends StatefulWidget {
  const JackpotDisplayScreen1920x1080Floor3MegaBack({super.key});

  @override
  State<JackpotDisplayScreen1920x1080Floor3MegaBack> createState() => _JackpotDisplayScreen1920x1080Floor3MegaBackState();
}

class _JackpotDisplayScreen1920x1080Floor3MegaBackState extends State<JackpotDisplayScreen1920x1080Floor3MegaBack> {
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
      width: ConfigCustom.fixWidth_HD_led_Floor3MegaBack,
      height: ConfigCustom.fixHeight_HD_led_Floor3MegaBack,
      color: Colors.black.withOpacity(0.1),
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
                  debugPrint('Building JackpotDisplayScreen1920x1080Floor3MegaBack:${priceState.hasData}');
                  return priceState.isConnected
                      ?  SizedBox(
                          width: ConfigCustom.fixWidth_HD_led_curved,
                          height: ConfigCustom.fixWidth_HD_led_curved,
                          child: screenLedFloor3Mega_BACK(context, hiveValues,priceState.previousJackpotValues,priceState.jackpotValues),
                        
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
