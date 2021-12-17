import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDisplay extends StatelessWidget {
  final String data;
  final String title;

  QRDisplay({this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: Center(
          child: QrImage(
            data: data,
            version: QrVersions.auto,
            size: 300.0,
          ),
        ),
      ),
    );
  }
}
