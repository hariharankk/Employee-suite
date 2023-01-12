import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mark/widgets/button_widget.dart';
import 'package:mark/widgets/employee_calendar.dart';
import '../widgets/date_picker.dart';
import '../widgets/date_range.dart';
import '../widgets/date_time_picker.dart';
import '../widgets/time_picker.dart';

import 'package:http/http.dart' as http;

class leaveRequest extends StatefulWidget {
  // const leaveRequest({super.key});
  @override
  State<leaveRequest> createState() => _leaveRequestState();
  bool apiCall = false;
  // bool isDisable = true;
  // void setButton() {
  //   if (isDisable) {
  //     isDisable = false;
  //   } else {
  //     isDisable = true;
  //   }
  // }
}

class _leaveRequestState extends State<leaveRequest> {
  int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => employeeCalendar()),
                );
              },
            ),
            centerTitle: true,
            title: Text('Leave Request')),
        body: buildPages(),
      );

  Widget buildPages() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DatePickerWidget(),
              const SizedBox(height: 15),
              TimePickerWidget(),
              const SizedBox(height: 15),
              DateRangePickerWidget(),
              const SizedBox(height: 85),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.text_snippet),
                  labelText: 'Enter Reason for leave',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1.4, color: Colors.blue),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: FittedBox(
                    child: Text(
                      "Apply for Leave",
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromARGB(255, 248, 248, 248)),
                    ),
                  ),
                  onPressed: () async { //backend work needed
                    final body = jsonEncode({'status': 1});
                    final url = Uri.http('http://google.com', '');
                    final response = await http.post(url,
                        headers: {'Content-Type': 'application/json'},
                        body: body);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
