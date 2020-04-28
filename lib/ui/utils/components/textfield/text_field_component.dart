import 'package:flutter/material.dart';

TextField buildNumericTextField(
    String labelText, TextEditingController textEditingController,
    {FocusNode focusNode}) {
  return TextField(
    focusNode: focusNode,
    controller: textEditingController,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(labelText: labelText),
  );


}
