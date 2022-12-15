import 'package:flutter/material.dart';

class TextButtonClass extends StatelessWidget {
  final String title;
  final Function function;
  const TextButtonClass({Key? key, required this.title, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        fixedSize: MaterialStateProperty.all(
          const Size(350, 55),
        ),
      ),
      onPressed: () => function(),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}
