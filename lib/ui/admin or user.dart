import 'package:flutter/material.dart';
import 'package:mark/ui/login_page.dart';
import 'package:mark/ui/register.dart';

class UserorAdmin extends StatefulWidget {
  final VoidCallback loginCallback;
  UserorAdmin({Key key,this.loginCallback}) : super(key: key);

  @override
  State<UserorAdmin> createState() => _UserorAdminState();
}

class _UserorAdminState extends State<UserorAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Role'),
        automaticallyImplyLeading: false,
      ),
      body:Container(
              padding: EdgeInsets.all(10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Center(
                    child: Text('Select Your Role',style:
                    TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight. bold,
                        fontSize: 30,
                      ),
                    ),
                  ),

                    SizedBox(height: 20,),

                  ListTile(
                    shape: RoundedRectangleBorder(

                      side: BorderSide(width: 2,color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    leading: const Icon(Icons.person,size: 40,color: Colors.blue,),
                    title: const Text(
                      'I am an Employee',
                      textScaleFactor: 1.2,
                    ),
                    subtitle: const Text('Use this option if you want to punch or mark attendance as an employee.'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage(loginCallback: widget.loginCallback);
                          },
                        ),
                      );

                    },
                  ),

                    SizedBox(height: 10,),

                  ListTile(
                    shape: RoundedRectangleBorder( 
                      side: BorderSide(width: 2,color: Colors.blue),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    leading: const Icon(Icons.home_work_outlined,size: 40,color: Colors.blue,),
                    title: const Text(
                      'I am a Business Owner',
                      textScaleFactor: 1.2,
                    ),
                    subtitle: const Text('Use this option if you want to capture attendance of other employees.'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return register(loginCallback: widget.loginCallback,);
                          },
                        ),
                      );
                    },
                  ),

                ]
             ),
            ),

    );
  }
}
