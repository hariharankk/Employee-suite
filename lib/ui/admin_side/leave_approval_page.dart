import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:mark/ui/leave_request_page.dart';

class leaveApproval extends StatelessWidget {
  // const leaveApproval({super.key});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Leave Approval"),
        centerTitle: true,
      ),
      body: new Center(
        child: new Text("Leave Approval"),
      ),
    );
    
  }
}
