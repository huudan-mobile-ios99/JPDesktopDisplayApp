import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_jp_price/main/jackpot_price_bloc.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_countdown.dart';
import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_1920x1080_VMS.dart';

import 'package:playtech_transmitter_app/screen/background_screen/page_hit/jackpot_video_bghit_page_hd_led_2080x1560_LedWings.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
import 'package:playtech_transmitter_app/service/widget/circlar_progress.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_bloc_socket.dart';
import 'package:playtech_transmitter_app/screen/background_screen/bloc_socket_time/jackpot_state_socket.dart';

import '../bloc_jp_price/main/jackpot_price_event.dart';

class JackpotHitShowScreen2496x624VMS extends StatelessWidget {
  const JackpotHitShowScreen2496x624VMS({super.key});
  @override
  Widget build(BuildContext context) {



//  return JackpotBackgroundVideoHitLedHD1920x1080VMS_F(
//             id: '109',
//             number: '1001',
//             value: '300'
//     );
    return Container(
      width: ConfigCustom.fixWidth_led_vms,
      height:ConfigCustom.fixHeight_led_vms,
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
            if (data.requiresCountdown) {
              return Container(
                width:MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height,
                color:Colors.black,
                child: const JackpotCountdownVideo());
            }
            
            final hitId = int.tryParse(data.hitData!['id'].toString()) ?? -1;
            if (ConfigCustom.defaultJackpotValues.containsKey(hitId)) {
              data.hitData!['amount'] = ConfigCustom.defaultJackpotValues[hitId];
              debugPrint('Applied default value ${ConfigCustom.defaultJackpotValues[hitId]} for ID: $hitId');
            }
            
             return JackpotBackgroundVideoHitLedHD1920x1080VMS_F(
              id: data.hitData!['id'].toString(),
              number: data.hitData!['machineNumber'].toString(),
              value: ConfigCustom.defaultJackpotValues.containsKey(hitId) ? ConfigCustom.defaultJackpotValues[hitId].toString() : data.hitData!['amount']
            );
          },
          
        )),
    );
  }
}



