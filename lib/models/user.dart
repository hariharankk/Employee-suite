class User {
  String password;
  String email;
  bool admin;
  String phonenumber;
  String username;

  User({this.phonenumber, this.admin, this.email, this.password, this.username });

  User.map(dynamic obj) {
    password = obj['password'];
    email = obj['email'];
    phonenumber = obj['phonenumber'];
    admin = obj['admin'];
    username = obj['username'];
  }

  String get phone => phonenumber;
  String get emailid => email;
  bool get administrator => admin;
  String get user => username;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String , dynamic>();
    map['password'] = password;
    map['email'] = email;
    map['admin'] = admin;
    map['phonenumber'] = phonenumber;
    map['username'] = username;
    return map;

  }

  User.fromMap(Map<dynamic,dynamic> map) {
    this.phonenumber = map['phonenumber'];
    this.email = map['email'];
    this.admin = map['admin'];
    this.password = map['password'];
    this.username = map['username'];
  }

}