import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_ATM.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Custom_TripleDaily.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Floor2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Lobby.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_MarX.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_Non_Smoke.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_RL_Floor2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_curved.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_background/screen_child_ledaris/screen_led_stair.dart';
import 'package:playtech_transmitter_app/service/hive_service/jackpot_hive_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_state.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/screen/setting/setting_service.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc/video_bloc.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';

class JackpotDisplayScreenLedCustomTripleDaily extends StatefulWidget {
  const JackpotDisplayScreenLedCustomTripleDaily({super.key});

  @override
  State<JackpotDisplayScreenLedCustomTripleDaily> createState() => _JackpotDisplayScreenLedCustomTripleDailyState();
}

class _JackpotDisplayScreenLedCustomTripleDailyState extends State<JackpotDisplayScreenLedCustomTripleDaily> {
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
    FutureBuilder<Map<String, double>>(
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
                // debugPrint('Building JackpotDisplayScreenLedCustomTripleDaily:${priceState.hasData}');
                return Center(
                  child: priceState.isConnected
                      ? SizedBox(
                          // width: ConfigCustom.fixWidth_HD_led_curved,
                          // height: ConfigCustom.fixWidth_HD_led_curved,
                          width: ConfigCustom.fixWidth_HD_led_RL_Floor2,
                          height: ConfigCustom.fixHeight_HD_led_RL_Floor2,
                          child:
                          //  screenLedNonSmoke(context, hiveValues,priceState.previousJackpotValues,priceState.jackpotValues),
                          // screenLedLobby(context, hiveValues,priceState.previousJackpotValues,priceState.jackpotValues),
                          screenCustomTripleDaily(context, hiveValues,priceState.previousJackpotValues,priceState.jackpotValues),

                        )
                      :
                      priceState.error != null ? Container() : circularProgessCustom()

                );
              },
            );
          },
        );
      },
    );
  }
}
