import 'package:flutter/material.dart';
import 'package:songswipe/helpers/export_helpers.dart';

// Widget que personaliza el ElevatedButton
class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Function onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () {
              onPressed();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                upperCaseAfterSpace(text: text),
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )),
      ),
    );
  }
}
