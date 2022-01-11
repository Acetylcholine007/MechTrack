import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRDisplay extends StatelessWidget {
  final String data;
  final String title;

  QRDisplay({this.title, this.data});

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: () async {
            var status = await Permission.storage.status;
            bool success = false;

            if (status.isDenied) {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Save QR Code'),
                    content: Text('Saving QR code image requires allowing the app to use the phone\'s storage.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK')
                      )
                    ],
                  )
              );
              await Permission.storage.request();
              status = await Permission.storage.status;
            }

            if(status.isGranted){
                final qrValidationResult = QrValidator.validate(
                  data: data,
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                );

                final qrCode = qrValidationResult.qrCode;

                final painter = QrPainter.withQr(
                  qr: qrCode,
                  color: const Color(0xFF000000),
                  emptyColor: Colors.white,
                  gapless: true,
                  embeddedImageStyle: null,
                  embeddedImage: null,
                );

                Directory tempDir = await getTemporaryDirectory();
                String tempPath = tempDir.path;
                final ts = DateTime.now().millisecondsSinceEpoch.toString();
                String path = '$tempPath/$ts.png';

                final picData = await painter.toImageData(2048,
                    format: ui.ImageByteFormat.png);
                await writeToFile(picData, path);

                success = await GallerySaver.saveImage(path);
              }

              if(success) {
              final snackBar = SnackBar(
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                content: Text('QR image saved to your Gallery'),
                action: SnackBarAction(label: 'OK', onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar()),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Save QR Code'),
                    content: Text('Failed to save QR image to your Gallery'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK')
                      )
                    ],
                  )
              );
            }
          }),
        ]
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: new AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
        ),
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
