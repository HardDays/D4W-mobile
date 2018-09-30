import 'package:desk4work/view/common/theme_util.dart';
import 'package:desk4work/view/filter/filter_state_container.dart';
import 'package:desk4work/view/filter/main.dart';
import 'package:flutter/material.dart';

class FilterRoot extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeUtil.getThemeForOrangeBackground(context),
        child: FilterStateContainer(child: FilterMainScreen()));
  }

}