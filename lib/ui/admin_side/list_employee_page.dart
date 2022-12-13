import 'package:mark/models/employee.dart';
import 'package:mark/models/store.dart';
import 'package:mark/ui/common/attendance_history.dart';
import 'package:flutter/material.dart';
import 'package:mark/services/employee_Socket.dart';
import 'package:mark/services/exit socket.dart';
import 'package:mark/services/employee socket exit.dart';
import 'package:mark/services/history socket exit.dart';

class ListEmployeePage extends StatefulWidget {
  final List<Store> stores;
  String userid;
  ListEmployeePage({@required this.stores,this.userid});

  @override
  _ListEmployeePageState createState() => _ListEmployeePageState();
}

class _ListEmployeePageState extends State<ListEmployeePage> {
  Map<String, String> storeNames = {};


  employee_StreamSocket employee2 = employee_StreamSocket();
  ApprovalExitSocket streamSocket = ApprovalExitSocket();
  EmployeeExitSocket employee = EmployeeExitSocket();
  HistoryExitSocket history = HistoryExitSocket();

  @override
  void initState() {
    print('empinit');
    streamSocket.Stopthread();
    _initStoreName();
    employee2.openingapprovalconnectAndListen(widget.userid);
    super.initState();
  }

  void dispose() {
    super.dispose();
    print('dispose emplooyee2');
    employee.Stopthread();
  }

  /// Map [store.id] to [store.name] and save it
  _initStoreName() async {
    Map<String, String> map = {};
    for (Store store in widget.stores) {
      map[store.id] = store.name;
    }
    setState(() {
      storeNames = map;
    });
  }

  /// Build Drop Down Menu Item

  /// Build a list of employees
  List<Widget> _buildList(
      BuildContext context, List<dynamic> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  /// Build list item (employee)
  Widget _buildListItem(BuildContext context, Map<dynamic,dynamic> data) {
    Employee emp = Employee.fromMap(data);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: () async{
          employee.Stopthread();
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AttendanceHistory(
                  userId: emp.id,
                  appBarNeeded: true,
                )));
          history.Stopthread();
          employee2.openingapprovalconnectAndListen(widget.userid);
          },
        leading: CircleAvatar(
          radius: 25,
          child: ClipOval(
            child: Center(
              child: emp.image == null
            ? Container(
            color: Colors.blue,
              child: Center(
                child: Text(
                  "Add Image",
                  textScaleFactor: 0.5,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                ),
              ),
            )
                :Image.network(
                emp.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  );
                },
              ),
            ),
          ),
        ),
        title: Text(
          "${emp.first} ${emp.last}",
          textScaleFactor: 1.2,
        ),
        subtitle: Text(
          "Store: ${storeNames[emp.storeID]}",
          textScaleFactor: 1.1,
        ),
        trailing: Icon(Icons.chevron_right, size: 40.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: //_dropdownValue.id == null ?
        employee2.getResponse, //: employee1.getResponse,
          builder: (context,   snapshot) {

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

          if (snapshot.data == null || snapshot.data.length == 0) {
              return Center(
                child: Text(
                  "No Employees Found!",
                  textScaleFactor: 1.3,
                  maxLines: 2,
                ),
              );
            }

    List<Widget> _empList = _buildList(context, snapshot.data);
    return
    SingleChildScrollView(
    child:Container(
      margin: EdgeInsets.all(15.0),
      child:
      ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => _empList[index],
        itemCount: _empList.length,
      ),
      ),
    );
    })
    );
    }
  }