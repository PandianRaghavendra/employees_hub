import 'package:employees_hub/Utils/color.dart';
import 'package:flutter/material.dart';

class Reusable{
   Widget button(String name,color,onClick){
    return  TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<BeveledRectangleBorder>(
            BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            )),
        backgroundColor:
        WidgetStateProperty.all<Color>(color),
        foregroundColor: WidgetStateProperty.all<Color>(name=="Cancel"?AppColors.primaryColor:Colors.white),
      ),
      onPressed:onClick,
      child: Text(name),
    );
  }
}