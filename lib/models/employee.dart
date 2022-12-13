
class Employee {
  String userId;
  String storeId;
  String imageId;
  String firstName;
  String lastName;
  String emailId;
  String phoneNumber;
  String specialization;
  String aadharNumber;
  String address;
  String experience;
  String radius;
  String lat;
  String longi;
  String admin;

  Employee(
      {this.userId,
      this.firstName,
      this.lastName,
      this.emailId,
        this.lat,
        this.longi,
      this.phoneNumber,
      this.specialization,
      this.storeId,
      this.imageId,
      this.aadharNumber,
      this.address,
      this.experience,
      this.radius,
      this.admin});

  Employee.map(dynamic obj) {
    this.userId = obj['userId'];
    this.firstName = obj['firstName'];
    this.lastName = obj['lastName'];
    this.emailId = obj['emailId'];
    this.phoneNumber = obj['phoneNumber'];
    this.specialization = obj['specialization'];
    this.lat = obj['lat'];
    this.longi=obj['longi'];
    this.storeId = obj['storeId'];
    this.imageId = obj['imageId'];
    this.aadharNumber = obj['aadharNumber'];
    this.address = obj['address'];
    this.radius = obj['radius'];
    this.experience = obj['experience'];
    this.admin=obj['admin'];
  }

  String get id => userId;
  String get first => firstName;
  String get last => lastName;
  String get phone => phoneNumber;
  String get email => emailId;
  String get expertise => specialization;
  String get storeID => storeId;
  String get image => imageId;
  String get aadhar => aadharNumber;
  String get addr => address;
  String get exp => experience;
  String get rad => radius;
  String get latitude => lat;
  String get longitute => longi;
  String get admins=> admin;

  Map<dynamic, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['userId'] = userId;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['emailId'] = emailId;
    map['phoneNumber'] = phoneNumber;
    map['specialization'] = specialization;
    map['lat'] = lat;
    map['longi'] = longi;
    map['storeId'] = storeId;
    map['imageId'] = imageId;
    map['aadharNumber'] = aadharNumber;
    map['address'] = address;
    map['experience'] = experience;
    map['radius'] = radius;
    map['admin']=admin;
    return map;
  }

  Employee.fromMap(Map<dynamic, dynamic> map) {
    this.userId = map['userId'];
    this.firstName = map['firstName'];
    this.lastName = map['lastName'];
    this.emailId = map['emailId'];
    this.phoneNumber = map['phoneNumber'];
    this.specialization = map['specialization'];
    this.lat = map['lat'];
    this.longi=map['longi'];
    this.storeId = '${map['storeId']}';
    this.imageId = map['imageId'];
    this.aadharNumber = map['aadharNumber'];
    this.address = map['address'];
    this.experience = map['experience'];
    this.radius = map['radius'];
    this.admin=map['admin'];
  }

}
