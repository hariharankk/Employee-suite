import 'package:mark/models/store.dart';
import 'package:mark/services/firebase_service.dart';
import 'package:mark/ui/admin_side/list_approval_page.dart';
import 'package:mark/ui/admin_side/employee_form.dart';
import 'package:mark/ui/admin_side/list_employee_page.dart';
import 'package:mark/ui/admin_side/store_config_page.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';


class AdminPage extends StatefulWidget {
  final VoidCallback logoutCallback;
  String userid;

  AdminPage({this.logoutCallback,this.userid});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List appBarText = [
    'Home',
    'Employees',
    'Approvals'
  ]; // Text appearing as the title of pages
  int _currentIndex = 0; // stores the current index of page
  PageController _pageController;

  List<Store> allStores = []; // Store all the stores

  @override
  void initState() {
    _initStores();
    print('init home page');
    super.initState();
    _currentIndex = 0;
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
    print('dispose home');
  }

  /// Fetch and store [stores] from firebase
  _initStores() async {
    apirepository Apirepository = apirepository();
    List<dynamic> store = await Apirepository.store_getdata(widget.userid);
    List<Store> tempStore = [];
    tempStore = store.map((snapshot) {
      Store store = Store.fromMap(snapshot);
      return store;
    }).toList();
    setState(() {
      allStores = tempStore;
    });
  }

  ///Generate routes depending on the state of the [stores]
  _navigateTo(int index) async {
    // 1 -> Employee Form
    // 2 -> Store Configurator
    if (index == 1 ) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              EmployeeForm(stores: allStores,userid:widget.userid)));
    }
    else {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StoreConfigPage(stores: allStores,userid:widget.userid)));
        await _initStores();
    }
  }

  /// Void Callback to check if stores are complete or not (intializes store again)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText[_currentIndex]),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: widget.logoutCallback,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.75,
                child: Image.asset('assets/logo.jpg'),
              ),
              SizedBox(height: 25.0),
              Center(
                child: MaterialButton(
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  padding: EdgeInsets.all(16.0),
                  onPressed: ()=> _navigateTo(1),
                  child: Text(
                    "Add Employee",
                    textScaleFactor: 1.3,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: MaterialButton(
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  padding: EdgeInsets.all(16.0),
                  onPressed: ()async{
                          _navigateTo(2);
                          await _initStores();
                          },
                  child: Text(
                    "Store Config",
                    textScaleFactor: 1.3,
                  ),
                ),
              ),
            ],
          ),
          ListEmployeePage(stores: allStores,userid: widget.userid,),
          ListApprovalPage(userid: widget.userid,),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          _pageController.jumpToPage(index);
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.red,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text("Employees"),
            activeColor: Colors.purpleAccent,
            inactiveColor: Colors.black,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.assignment_late),
            title: Text("Approvals"),
            activeColor: Colors.blue,
            inactiveColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
