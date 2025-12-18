import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';
const textStyleOdo = TextStyle(
    fontSize: ConfigCustom.text_odo_size,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
  );

const textStyleOdoSmall = TextStyle(
    fontSize: ConfigCustom.text_odo_size_small,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

const textStyleJPHit = TextStyle(
      fontSize: ConfigCustom.text_hit_price_size,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
    );
const textStyleJPHitSmall = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);

//FLOOR 3 MEGA
TextStyle textStyleJPHitFloor3Mega(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  final double scaleX = screenSize.width / 1920.0;
  final double scaleY = screenSize.height / 1080.0;
  final double scale = math.min(scaleX, scaleY); // Use the smaller scale

  return TextStyle(
    fontSize: 100 * scale,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
  );
}

const textStyleJPHitSmallFloor3Mega = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_ledFloor3Mega,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
//FLOOR 3 MEGA END







//TABLE BC SCREEN SIZE
const textStyleOdoTable = TextStyle(
    fontSize: ConfigCustom.text_odo_size_table,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
  );
const textStyleOdoSmallTable = TextStyle(
    fontSize: ConfigCustom.text_odo_size_small_table,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);





//LED VMS 2496x624
const textStyleOdo2496x624 = TextStyle(
    fontSize: ConfigCustom.text_odo_size_2496x624,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);
const textStyleOdo2496x624Small = TextStyle(
    fontSize: ConfigCustom.text_odo_size_2496x624_small,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

const textStyleJPHit2496x264 = TextStyle(
      fontSize: ConfigCustom.text_hit_price_size_2496x264,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
    );
const textStyleJPHit2496x264Small = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_2496x264,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit2496x264SmallOnlyHotSeat = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_2496x264_onlyHotSeat,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);






//LED CURVED  1080x1920
const textStyleOdo1920x1080_Curved = TextStyle(
    fontSize: ConfigCustom.text_odo_size_1920x1080_curved,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

const textStyleJPHit1920x1080_Curved = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_curved,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit1920x1080Small_Curved = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_curved,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit1920x1080SmallOnlyHotSeat_Curved = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_onlyHotSeat_curved,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
//END CURVED





//LED NON-SMOKING  1080x1920
const textStyleOdo1920x1080_Non_Smoke = TextStyle(
    fontSize: ConfigCustom.text_odo_size_1920x1080_non_smoke,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

const textStyleJPHit1920x1080_Non_Smoke = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_non_smoke,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit1920x1080Small_Non_Smoke = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_non_smoke,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);


//custom LED triple dialy
const textStyleJPHit1920x1080SmallOnlyHotSeat_CustomTripleDaily = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_CustomTripleDaly,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
//custom LED triple dialy
const textStyleJPHit1920x1080_CustomTripleDaily = TextStyle(
      fontSize: ConfigCustom.text_hit_price_size_1920x1080_ledCustomTRIPLEDAILY,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);


const textStyleJPHit1920x1080SmallOnlyHotSeat_Non_Smoke = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_onlyHotSeat_non_smoke,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
//END CURVED




//LED STAIR  1080x1920
const textStyleOdo1920x1080 = TextStyle(
    fontSize: ConfigCustom.text_odo_size_1920x1080,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

const textStyleJPHit1920x1080 = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit1920x1080Small = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit1920x1080SmallOnlyHotSeat = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_onlyHotSeat,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);











//LED FLOOR 2  1080x1920
const textStyleOdo1920x1080Floor2 = TextStyle(
    fontSize: ConfigCustom.text_odo_size_1920x1080_floor2,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

const textStyleJPHit1920x1080Floor2 = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_floor2,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);


const textStyleJPHit1920x1080SmallFloor2 = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_floor2,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit1920x1080SmallOnlyHotSeatFloor2 = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_onlyHotSeat_floor2,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);


//LED LOBBY 
const textStyleOdo1080x1920Lobby = TextStyle(
      fontSize: ConfigCustom.text_odo_size_1080x1920_lobby,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);

//LED RL FLOOR 2  
const textStyleOdo1920x1080RLFloor2 = TextStyle(
      fontSize: ConfigCustom.text_odo_size_1920x1080_RL_floor2,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);




//LED CUSTOM TRIPLE DAILY  
const textStyleOdo1920x1080CustomTripleDaily = TextStyle(
      fontSize: ConfigCustom.text_odo_size_1920x1080_ledCustomTRIPLEDAILY,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);


//LED FLOOR 3 MEGA: 5200x1664
const textStyleOdo5200x1664Floor3Mega = TextStyle(
    fontSize: ConfigCustom.text_odo_size_1920x1080_ledFloor3Mega,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

//LED FLOOR 3 MEGA:BACK -> 1920x1080
const textStyleOdo5200x1664Floor3MegaBACK = TextStyle(
    fontSize: ConfigCustom.text_odo_size_1920x1080_ledFloor3MegaBACK,
    color: Colors.white,
    fontFamily: 'sf-pro-display',
    fontWeight: FontWeight.w600,
);

const textStyleJPHit5200x1664Floor3Mega = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_ledFloor3Mega,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit5200x1664SmallFloor3Mega = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_ledFloor3Mega,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);
const textStyleJPHit5200x1664SmallOnlyHotSeatFloor3 = TextStyle(
      fontSize: ConfigCustom.text_hit_number_size_1920x1080_onlyHotSeat_ledFloor3Mega,
      color: Colors.white,
      fontFamily: 'sf-pro-display',
      fontWeight: FontWeight.w600,
);




