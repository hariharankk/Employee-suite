
import 'package:flutter/material.dart';

import '../widgets/date_picker.dart';
import '../widgets/date_range.dart';
import '../widgets/date_time_picker.dart';
import '../widgets/time_picker.dart';

class leaveRequest extends StatefulWidget {  
  // const leaveRequest({super.key});
  @override
  
  State<leaveRequest> createState() => _leaveRequestState();
}


class _leaveRequestState extends State<leaveRequest> {
   int index = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Leave Request')),
        body: buildPages(),
      );

  Widget buildPages() {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                DatePickerWidget(),
                const SizedBox(height: 15),
                TimePickerWidget(),
                const SizedBox(height: 15),
                DateRangePickerWidget(),
                const SizedBox(height: 15),
                TextField(
                decoration: InputDecoration(labelText: 'Enter Message'),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                )
              ],
            ),
          ),
        );
    
  }
}