import 'package:flutter/material.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';

enum type { camera, gallery, both }

class ImagePickerPrompt {
  @required
  BuildContext _context;

  get context => this._context;

  set context(BuildContext value) => this._context = value;

  ImagePickerPrompt();

  Future getNewImage(type source) async {
    ImgSource origin;

    switch (source) {
      case type.gallery:
        origin = ImgSource.Gallery;
        break;
      case type.camera:
        origin = ImgSource.Camera;
        break;
      default:
        origin = ImgSource.Both;
    }

    return await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: _context,
        source: origin,
        barrierDismissible: true,
        cameraIcon: Icon(
          Icons.camera_alt,
          color: Colors.red,
        ),
        cameraText: Text(
          "Camera",
          style: TextStyle(color: Colors.red),
        ),
        galleryText: Text(
          "Gallery",
          style: TextStyle(color: Colors.blue),
        ));
  }
}
