import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_countdown.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_hit_page_led_1920x1080LedRLFloor2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_1920x1080_ATM.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_1920x1080_Curved_F.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_1920x1080_MARX.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_1920x1080_NonSmoke.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_1920x1080_VMS.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_1920x1080_stair_F.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_2080x1560_Floor2.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_2080x1560_LedWings.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_state_socket.dart';

import '../bloc_jp_price/main/jackpot_price_event.dart';

class JackpotHitShowScreenHdLed1920x1080 extends StatelessWidget {
  const JackpotHitShowScreenHdLed1920x1080({super.key});
  @override
  Widget build(BuildContext context) {

  // return const JackpotBackgroundVideoHitLedHD1920x1080NonSmoke(
  //           id: '109',
  //           number: '100',
  //           value: '0',
  // );

    //  return const JackpotBackgroundVideoHitLedHD1920x1080MARX(
    //         id: '109',
    //         number: '100',
    //         value: '0',
    //   );

//  return const JackpotBackgroundVideoHitLedHD1920x1080StairF(
//             id: '109',
//             number: '100',
//             value: '0',
//       );

    //  return const JackpotBackgroundVideoHitLedHD1920x1080CurvedF(
    //         id: '0',
    //         number: '100',
    //         value: '1000',
    //   );

// return const JackpotBackgroundVideoHitLedHD1920x1080ATM(
//             id: '109',
//             number: '100',
//             value: '0',
//       );
//  return  JackpotBackgroundVideoHit1920x1080Floor2(
//           id: '0',
//             number: '1111',
//             value: '110',
//   );


      // return const JackpotBackgroundVideoHitLedHD1920x1080NonSmoke(
      //       id: '0',
      //       number: '1111',
      //       value: '110',
      // );
    // JackpotBackgroundVideoHitLedHD1920x1080ATM

    return BlocListener<JackpotBloc2, JackpotState2>(
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
          if (data.requiresCountdown) {
            return Container(
              width:MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height,
              color:Colors.black,
              child: const JackpotCountdownVideo());
          }
          
          // return JackpotBackgroundVideoHitLedHD1920x1080NonSmoke(
          //   id: data.hitData!['id'].toString(),
          //   number: data.hitData!['machineNumber'].toString(),
          //   value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          // );
          // return JackpotBackgroundVideoHitLedHD1920x1080NonSmoke(
          //   id: data.hitData!['id'].toString(),
          //   number: data.hitData!['machineNumber'].toString(),
          //   value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          // );
          //  return JackpotBackgroundVideoHitLedHD1920x1080StairF(
          //   id: data.hitData!['id'].toString(),
          //   number: data.hitData!['machineNumber'].toString(),
          //   value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          // );
          //  return JackpotBackgroundVideoHitLedHD1920x1080CurvedF(
          //   id: data.hitData!['id'].toString(),
          //   number: data.hitData!['machineNumber'].toString(),
          //   value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          // );
          // return JackpotBackgroundVideoHitLedHD1920x1080ATM(
          //   id: data.hitData!['id'].toString(),
          //   number: data.hitData!['machineNumber'].toString(),
          //   value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          // );
          // return JackpotBackgroundVideoHitLedHD1920x1080MARX(
          //   id: data.hitData!['id'].toString(),
          //   number: data.hitData!['machineNumber'].toString(),
          //   value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          // );
          // return JackpotBackgroundVideoHitLedHD1920x1080NonSmoke(
          //   id: data.hitData!['id'].toString(),
          //   number: data.hitData!['machineNumber'].toString(),
          //   value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          // );
          return JackpotBackgroundVideoHitLedHD1920x1080NonSmoke(
            id: data.hitData!['id'].toString(),
            number: data.hitData!['machineNumber'].toString(),
            value: data.hitData!['amount'] == [] ? "0" : data.hitData!['amount'].toString(),
          );
        },
      ));
  }
}



