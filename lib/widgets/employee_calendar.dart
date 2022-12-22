
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:mark/ui/leave_request_page.dart';


class employeeCalendar extends StatefulWidget {
  @override
  _employeeCalendarState createState() => new _employeeCalendarState();
}

List<DateTime> NightDates = [
  DateTime(2022, 12, 1),
  DateTime(2022, 12, 3),
  DateTime(2022, 12, 4),
  DateTime(2022, 12, 5),
  DateTime(2022, 12, 6),
  DateTime(2022, 12, 9),
  DateTime(2022, 12, 10),
  DateTime(2022, 12, 12),
  DateTime(2022, 12, 15),
  DateTime(2022, 12, 22),
  DateTime(2022, 12, 23),
  DateTime(2022,11,11),
];
List<DateTime> MorningDates = [
  DateTime(2022, 12, 2),
  DateTime(2022, 12, 7),
  DateTime(2022, 12, 8),
  DateTime(2022, 12, 12),
  DateTime(2022, 12, 13),
  DateTime(2022, 12, 14),
  DateTime(2022, 12, 16),
  DateTime(2022, 12, 17),
  DateTime(2022, 12, 18),
  DateTime(2022, 12, 19),
  DateTime(2022, 12, 20),
];

class _employeeCalendarState extends State<employeeCalendar> {
  DateTime _currentDate2 = DateTime.now();
  static Widget _presentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.blue[200],
        child: Text(
          day,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );
  static Widget _MorningIcon(String day) => CircleAvatar(
        backgroundColor: Colors.red[400],
        child: Text(
          day,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarouselNoHeader;

  var len = min(MorningDates?.length, NightDates.length);
  double cHeight;

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery.of(context).size.height;
    for (int i = 0; i < len; i++) {
      _markedDateMap.add(
        NightDates[i],
        new Event(
          date: NightDates[i],
          title: 'Night Shift',
          icon: _presentIcon(
            NightDates[i].day.toString(),
          ),
        ),
      );
    }

    for (int i = 0; i < len; i++) {
      _markedDateMap.add(
        MorningDates[i],
        new Event(
          date: MorningDates[i],
          title: 'Morning Shift',
          icon: _MorningIcon(
            MorningDates[i].day.toString(),
          ),
        ),
      );
    }

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: cHeight * 0.54,
      weekendTextStyle: TextStyle(
        color: Colors.green,
      ),
      todayButtonColor: Colors.yellow[600],
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal:
          null, 
      markedDateIconBuilder: (event) {
        return event.icon;
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Employee Calendar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _calendarCarouselNoHeader,
            markerRepresent(Colors.red[400], "Morning Shift"),
            markerRepresent(Colors.blue[200], "Night Shift"),
            markerRepresent(Colors.yellow[600],"Today"),
            ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(150,80),
                  ),
                  child: FittedBox(
                    child: Text(
                      "Apply for Leave",
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => leaveRequest()),
                );
                  })
          ],
        ),
      ),
    );
  }

  Widget markerRepresent(Color color, String data) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: cHeight * 0.010,
      ),
      title: new Text(
        data,
      ),
    );
  }
}
