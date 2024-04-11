import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({this.message, Key? key}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    String textMessage = "Carregando...";
    if (message != null) {
      textMessage = message!;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(),
          ),
          Text(
            textMessage,
            style: const TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
