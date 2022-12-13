
class History {
  String checkIn;
  String checkOut;
  String hrsSpent;
  String userId;
  String randomint;

  History({this.randomint,this.hrsSpent, this.userId, this.checkIn, this.checkOut});

  History.map(dynamic obj) {
    userId = obj['userId'];
    checkIn = obj['checkIn'];
    checkOut = obj['checkOut'];
    hrsSpent = obj['hrsSpent'];
    randomint = obj['randomint'];
  }

  String get id => userId;
  String get checkin => checkIn;
  String get checkout => checkOut;
  String get hours => hrsSpent;
  String get random => randomint;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['userId'] = userId;
    map['checkIn'] = checkIn;
    map['checkOut'] = checkOut;
    map['hrsSpent'] = hrsSpent;
    map['randomint'] =randomint;

    return map;
  }

  History.fromMap(Map<dynamic, dynamic> map) {
    this.userId = map['userId'];
    this.checkIn = map['checkIn'];
    this.checkOut = map['checkOut'];
    this.hrsSpent = map['hrsSpent'];
    this.randomint = map['randomint'];
  }

}
