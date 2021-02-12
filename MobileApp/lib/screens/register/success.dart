import 'package:flutter/material.dart';

class RegisterSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Регистрация")),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          "Вы успешно зарегистрировались. Пройдите по ссылке из письма для завершения регистрации.",
        ),
      ),
    );
  }
}
