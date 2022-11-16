import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("xcodify"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Screenshot(
              controller: screenshotController,
              child: Column(children: [
                Text("welcome"),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text("welcome to xcodify "),
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 5.0),
                    color: Colors.amberAccent,
                  ),
                ),
              ]),
            ),

/////////////////////////////////////////////////////////////////////buttons

            ElevatedButton(
              child: Text(
                'Capture Above Widget',
              ),
              onPressed: () {
                // invoking capture on
                // screenshotController
                screenshotController
                    .capture(delay: Duration(milliseconds: 10))
                    .then((capturedImage) async {
                  // showing the captured widget
                  // through ShowCapturedWidget
                  ShowCapturedWidget(context, capturedImage!);
                }).catchError((onError) {
                  print(onError);
                });
              },
            ),
            ElevatedButton(
              child: Text(
                'Capture An Invisible Widget',
              ),
              onPressed: () {
                var container = Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 5.0),
                      color: Colors.pink,
                    ),
                    child: Text(
                      "This is an invisible widget",
                      style: Theme.of(context).textTheme.headline6,
                    ));

                // capturing all the widgets
                // that are invisible
                screenshotController
                    .captureFromWidget(
                        InheritedTheme.captureAll(
                            context, Material(child: container)),
                        delay: Duration(seconds: 1))
                    .then((capturedImage) {
                  // showing the captured invisible widgets
                  ShowCapturedWidget(context, capturedImage);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

// function to show captured widget
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  _saved(Uint8List image) async {
    final result = await ImageGallerySaver.saveImage(image);
    print("File Saved to Gallery");
  }
}
