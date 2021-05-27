import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:info_colors/model/color_info.dart' as clrInfo;
import 'package:info_colors/widget/image_picker.dart';
import 'package:info_colors/widget/input_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum _state { none, loading, show }

class _HomeState extends State<Home> {
  @override
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();
  GlobalKey expandedKey = GlobalKey();

  Color selectedColor = Colors.black;
  ImagePickerPrompt _imagePicker = ImagePickerPrompt();
  clrInfo.ColorInfo colorInfo = clrInfo.ColorInfo();

  final String _imagePath = 'images/default.jpg';
  final StreamController<Color> _stateController = StreamController<Color>();

  var _image;
  var _stateInfo = _state.none;
  img.Image photo;

  TextEditingController _controllerColorName = TextEditingController();
  TextEditingController _controllerRGB = TextEditingController();
  TextEditingController _controllerHex = TextEditingController();

  Future<void> getJsonData() async {
    final String rgb = selectedColor.red.toString() +
        ',' +
        selectedColor.green.toString() +
        ',' +
        selectedColor.blue.toString();

    final response = await http.get(
        Uri.parse('http://thecolorapi.com/id?rgb=$rgb'),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        colorInfo = clrInfo.ColorInfo.fromMap(json.decode(response.body));

        _controllerColorName.text = colorInfo.name.value;
        _controllerHex.text = colorInfo.hex.value;
        _controllerRGB.text = colorInfo.rgb.r.toString() +
            ', ' +
            colorInfo.rgb.g.toString() +
            ', ' +
            colorInfo.rgb.b.toString();
      });

      _stateInfo = _state.show;
    }
  }

  _loadInformation() {
    if (_stateInfo == _state.show) {
      return Column(
        children: [
          InputInfo(
            controller: _controllerColorName,
            labelText: "Color Name",
            color: selectedColor,
          ),
          InputInfo(
            controller: _controllerRGB,
            labelText: "RGB",
            color: selectedColor,
          ),
          InputInfo(
            controller: _controllerHex,
            labelText: "Hex",
            color: selectedColor,
          )
        ],
      );
    } else if (_stateInfo == _state.loading) {
      return Center(
          child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(selectedColor),
        ),
      ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Info Colors",
          style: TextStyle(color: Colors.grey[500]),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              child: Icon(
                Icons.image,
                color: Colors.grey[500],
              ),
              onTap: () {
                _imagePicker.context = context;
                _imagePicker.getNewImage(type.both).then((value) => {
                      setState(() {
                        photo = null;
                        _image = value;
                        _stateInfo = _state.none;
                      })
                    });
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
          initialData: Colors.black,
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            selectedColor = snapshot.data ?? Colors.black;

            return SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: RepaintBoundary(
                    key: paintKey,
                    child: GestureDetector(
                      onPanDown: (details) {
                        searchPixel(details.globalPosition);
                      },
                      onPanUpdate: (details) {
                        searchPixel(details.globalPosition);
                      },
                      child: Center(
                        child: _image != null
                            ? Image.file(
                                File(_image.path),
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                width: MediaQuery.of(context).size.width,
                              )
                            : Image.asset(
                                _imagePath,
                                key: imageKey,
                                fit: BoxFit.cover,
                                // scale: 1.0,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                width: MediaQuery.of(context).size.width,
                              ),
                      ),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5, left: 5),
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: selectedColor,
                      ),
                    ),
                    Text(
                      'R: ' +
                          selectedColor.red.toString() +
                          ' | G: ' +
                          selectedColor.green.toString() +
                          ' | B: ' +
                          selectedColor.blue.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black26,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: _loadInformation(),
                ),
              ],
            ));
          }),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.grey[900],
        child: Icon(
          Icons.color_lens_sharp,
          color: Colors.grey[500],
        ),
        onPressed: () {
          setState(() {
            _stateInfo = _state.loading;
          });

          getJsonData();
        },
      ),
    );
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await loadSnapshotBytes();
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    if (_controllerColorName.text != '') {
      setState(() {
        _stateInfo = _state.none;
        _controllerColorName.text = '';
      });
    }

    RenderBox box = paintKey.currentContext.findRenderObject();
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    _stateController.add(Color(hex));
  }

  Future<void> loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(_imagePath);
    setImageBytes(imageBytes);
  }

  Future<void> loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint = paintKey.currentContext.findRenderObject();
    ui.Image capture = await boxPaint.toImage();
    ByteData imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}
