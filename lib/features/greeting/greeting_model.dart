class Greeting {
  Pagi? pagi;
  Siang? siang;
  Sore? sore;
  Malam? malam;

  Greeting({this.pagi, this.siang, this.sore, this.malam});

  Greeting.fromJson(Map<String, dynamic> json) {
    pagi = json['pagi'] != null ? new Pagi.fromJson(json['pagi']) : null;
    siang = json['siang'] != null ? new Siang.fromJson(json['siang']) : null;
    sore = json['sore'] != null ? new Sore.fromJson(json['sore']) : null;
    malam = json['malam'] != null ? new Malam.fromJson(json['malam']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagi != null) {
      data['pagi'] = pagi!.toJson();
    }
    if (siang != null) {
      data['siang'] = siang!.toJson();
    }
    if (sore != null) {
      data['sore'] = sore!.toJson();
    }
    if (malam != null) {
      data['malam'] = malam!.toJson();
    }
    return data;
  }
}

class Pagi {
  String? image;
  String? text;

  Pagi({this.image, this.text});

  Pagi.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['text'] = text;
    return data;
  }
}

class Siang {
  String? image;
  String? text;

  Siang({this.image, this.text});

  Siang.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['text'] = text;
    return data;
  }
}

class Sore {
  String? image;
  String? text;

  Sore({this.image, this.text});

  Sore.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['text'] = text;
    return data;
  }
}

class Malam {
  String? image;
  String? text;

  Malam({this.image, this.text});

  Malam.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['text'] = text;
    return data;
  }
}