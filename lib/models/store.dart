
class Store {
  String storeId;
  String radius;
  String storeName;
  String lat;
  String longi;
  String admin;

  Store({this.radius, this.storeId, this.lat,this.longi, this.storeName,this.admin});

  Store.map(dynamic obj) {
    this.storeId = obj['storeId'];
    this.lat = obj['lat'];
    this.longi=obj['longi'];
    this.radius = obj['radius'];
    this.storeName = obj['storeName'];
    this.admin=obj['admin'];
  }

  String get id => storeId;
  String get rad => radius;
  String get name => storeName;
  String get latitude => lat;
  String get longitute => longi;
  String get admins=> admin;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['storeId'] = storeId;
    map['lat'] = lat;
    map['longi'] = longi;
    map['radius'] = radius;
    map['storeName'] = storeName;
    map['admin']= admin;

    return map;
  }

  Store.fromMap(Map<dynamic, dynamic> map) {
    this.storeId = map['storeId'];
    this.lat = map['lat'];
    this.longi=map['longi'];
    this.radius = map['radius'];
    this.storeName = map['storeName'];
    this.admin = map['admin'];
  }

}
