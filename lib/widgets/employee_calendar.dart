import 'package:flutter/material.dart';
import 'package:mark/ui/leave_request_page.dart';
import 'package:table_calendar/table_calendar.dart';

class employeeCalendar extends StatefulWidget {
  // const employeeCalendar({Key? key}) : super(key: key);

  @override
  State<employeeCalendar> createState() => _employeeCalendarState();
}

class _employeeCalendarState extends State<employeeCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.arrow_forward,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => leaveRequest()),
        //       );
        //     },
        //   )
        // ],
        centerTitle: true,
        title: const Text("Employee Calendar"),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2022),
            lastDay: DateTime(2023),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            rowHeight: 60,
            daysOfWeekHeight: 60,
            headerStyle: HeaderStyle(
              titleTextStyle: const TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
              formatButtonTextStyle:
                  const TextStyle(color: Color.fromARGB(255, 76, 111, 175)),
              formatButtonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              leftChevronIcon: const Icon(
                Icons.arrow_back,
                color: Colors.blueAccent,
                size: 28,
              ),
              rightChevronIcon: const Icon(
                Icons.arrow_forward,
                color: Colors.blueAccent,
                size: 28,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.blue),
            ),
            calendarStyle: const CalendarStyle(
              weekendTextStyle:
                  TextStyle(color: Color.fromARGB(255, 235, 54, 244)),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 7, 156, 255),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 29, 144, 239),
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(190, 40),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => leaveRequest()),
              );
            },
            child: FittedBox(child: const Text('Leave Request')),
          )
        ],
      ),
    );
  }
}
