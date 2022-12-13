part of 'openingbloc.dart';

abstract class openingEvent extends Equatable {
  const openingEvent();

  @override
  List<Object> get props => [];
}

class openingapproval extends openingEvent {
  String empid;
  openingapproval(this.empid);
}

class getemployeedata extends openingEvent{
  String userid;
  getemployeedata(this.userid);
}

class captureimage extends openingEvent{
  File img;
  String userid;
  captureimage(this.userid,this.img);
}