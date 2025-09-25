import 'package:flutter/material.dart';

import 'BaseColors.dart';
import 'hex_color.dart';

class AppColors implements BaseColors {
  @override
  Color get colorPrimary => HexColor('#767BA9');

  @override
  Color get colorBlackMain => HexColor('#28282C');

  @override
  Color get background => HexColor('#FFFFFF');

  @override
  Color get colorWhite => HexColor('#FFFFFF');

  @override
  Color get colorBlack => HexColor('#161616');

  @override
  Color get colorGrey => HexColor('#D8D8D8');

  @override
  Color get colorRed => HexColor('#C73A3A');

  @override
  Color get colorRed2 => HexColor('#EE5353');

  @override
  Color get colorGreen => HexColor('#395D6B');

  @override
  Color get colorGreen2 => HexColor('#068D84');
}
