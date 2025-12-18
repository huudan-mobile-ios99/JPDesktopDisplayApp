import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_countdown.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_led_1920x1080_LedFloor2RL_No_BG.dart';

import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_led_5200x1664_LedFloor3Mega.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_led_5200x1664_LedFloor3Mega_No_BG.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_state_socket.dart';

import '../bloc_jp_price/main/jackpot_price_event.dart';

class JackpotHitShowScreen1920x1080LedRLFloor2 extends StatelessWidget {
  const JackpotHitShowScreen1920x1080LedRLFloor2({super.key});
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: ConfigCustom.fixWidth_HD_led_RL_Floor2,
    //   height: ConfigCustom.fixHeight_HD_led_RL_Floor2,
    //   child: JackpotBackgroundVideoHitLedRLFLOOR2NoBG(
    //           id: '121',
    //           number: '1234',
    //           value: '1000',
    //   ),
    // );

    return SizedBox(
      width: ConfigCustom.fixWidth_HD_led_RL_Floor2,
      height:ConfigCustom.fixHeight_HD_led_RL_Floor2,
      // color:Colors.black,
      child: BlocListener<JackpotBloc2, JackpotState2>(
        listener: (context, state) {
          // Trigger reset when a new hit is displayed
          if (state.showImagePage && state.latestHit != null) {
            final level = state.latestHit!['id'].toString();
            context.read<JackpotPriceBloc>().add(JackpotPriceResetEvent(level));
            debugPrint('Dispatched JackpotPriceResetEvent for level: $level');
          }
        },
        child: BlocSelector<JackpotBloc2, JackpotState2, ({Map<String, dynamic>? hitData, bool requiresCountdown})>(
          selector: (state) {
            // Select hit data and countdown status when showImagePage is true and latestHit exists
            if (state.showImagePage && state.latestHit != null) {
              debugPrint('JackpotHitShowScreen: hitData=${state.latestHit}, requiresCountdown=${state.requiresCountdown}');
              return (hitData: state.latestHit, requiresCountdown: state.requiresCountdown);
            }
            // Return null for loading, error, or empty states
            if (!state.isConnected && state.hits.isEmpty) {
              return (hitData: {'isLoading': true, 'error': state.error}, requiresCountdown: false);
            }
            return (hitData: null, requiresCountdown: false);
          },
          builder: (context, data) {
            debugPrint('JackpotHitShowScreen BlocSelector: hitData=${data.hitData}, requiresCountdown=${data.requiresCountdown}');
            // Loading state
            if (data.hitData != null && data.hitData!.containsKey('isLoading')) {
              if (data.hitData!['error'] != null) {
                return Container();
              }
              return circularProgessCustom();
            }
            // Empty state
            if (data.hitData == null) {
              return Container();
            }
      
            // Hit count down state
            // if (data.requiresCountdown) {
            //   return Container(
            //     width:MediaQuery.of(context).size.width,
            //     height:MediaQuery.of(context).size.height,
            //     color:Colors.black,
            //     child: const JackpotCountdownVideo());
            // }
            final allowedIds = {40, 41, 42, 43, 97, 98, 109, 119};
            final rawId = int.tryParse(data.hitData!['id'].toString());
            final hitId = (rawId != null && allowedIds.contains(rawId)) ? rawId : -1;

            if (hitId == -1) {
              // Invalid hitId -> return empty container or loading
              return Container();
            }
            
            // final hitId = int.tryParse(data.hitData!['id'].toString()) ?? -1;
            if (ConfigCustom.defaultJackpotValueOnlyRL.containsKey(hitId)) {
              data.hitData!['amount'] = ConfigCustom.defaultJackpotValueOnlyRL[hitId];
              debugPrint('Applied default value ${ConfigCustom.defaultJackpotValueOnlyRL[hitId]} for ID: $hitId');
            }
            
       
            return JackpotBackgroundVideoHitLedRLFLOOR2NoBG(
              id: data.hitData!['id'].toString(),
              number: data.hitData!['machineNumber'].toString(),
              value: ConfigCustom.defaultJackpotValueOnlyRL.containsKey(hitId) ? ConfigCustom.defaultJackpotValueOnlyRL[hitId].toString() : data.hitData!['amount']
            );
          },
          
        )),
    );
  }
}







