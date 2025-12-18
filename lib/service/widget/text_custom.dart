import 'package:flutter/material.dart';
import 'package:playtech_transmitter_app/service/config_custom.dart';

Widget textCustom({required double size,required String value}){
  return Text(value,style:TextStyle(color: Colors.white,fontSize: size,fontFamily: ConfigCustom.font_family,fontWeight: FontWeight.w600));
}
