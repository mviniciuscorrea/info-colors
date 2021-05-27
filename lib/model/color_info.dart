import 'dart:convert';

ColorInfo colorInfoFromMap(String str) => ColorInfo.fromMap(json.decode(str));

String colorInfoToMap(ColorInfo data) => json.encode(data.toMap());

class ColorInfo {
  ColorInfo({
    this.hex,
    this.rgb,
    this.name,
    this.image,
  });

  final Hex hex;
  final Rgb rgb;
  final Name name;
  final Image image;

  factory ColorInfo.fromMap(Map<String, dynamic> json) => ColorInfo(
        hex: Hex.fromMap(json["hex"]),
        rgb: Rgb.fromMap(json["rgb"]),
        name: Name.fromMap(json["name"]),
        image: Image.fromMap(json["image"]),
      );

  Map<String, dynamic> toMap() => {
        "hex": hex.toMap(),
        "rgb": rgb.toMap(),
        "name": name.toMap(),
        "image": image.toMap(),
      };
}

class Hex {
  Hex({
    this.value,
    this.clean,
  });

  final String value;
  final String clean;

  factory Hex.fromMap(Map<String, dynamic> json) => Hex(
        value: json["value"],
        clean: json["clean"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "clean": clean,
      };
}

class Image {
  Image({
    this.bare,
    this.named,
  });

  final String bare;
  final String named;

  factory Image.fromMap(Map<String, dynamic> json) => Image(
        bare: json["bare"],
        named: json["named"],
      );

  Map<String, dynamic> toMap() => {
        "bare": bare,
        "named": named,
      };
}

class Name {
  Name({
    this.value,
    this.closestNamedHex,
    this.exactMatchName,
    this.distance,
  });

  final String value;
  final String closestNamedHex;
  final bool exactMatchName;
  final int distance;

  factory Name.fromMap(Map<String, dynamic> json) => Name(
        value: json["value"],
        closestNamedHex: json["closest_named_hex"],
        exactMatchName: json["exact_match_name"],
        distance: json["distance"],
      );

  Map<String, dynamic> toMap() => {
        "value": value,
        "closest_named_hex": closestNamedHex,
        "exact_match_name": exactMatchName,
        "distance": distance,
      };
}

class Rgb {
  Rgb({
    this.r,
    this.g,
    this.b,
    this.value,
  });

  final int r;
  final int g;
  final int b;
  final String value;

  factory Rgb.fromMap(Map<String, dynamic> json) => Rgb(
        r: json["r"],
        g: json["g"],
        b: json["b"],
        value: json["value"],
      );

  Map<String, dynamic> toMap() => {
        "r": r,
        "g": g,
        "b": b,
        "value": value,
      };
}
