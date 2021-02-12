import 'package:flutter/material.dart';

class PhotoProcessingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Обработка фото"),
        leading: Container(),
      ),
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              "Фото обрабатывается, пожалуйста подождите.",
            ),
          ),
        ],
      ),
    );
  }
}
