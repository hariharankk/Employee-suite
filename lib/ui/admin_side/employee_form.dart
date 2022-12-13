import 'package:mark/models/employee.dart';
import 'package:mark/models/store.dart';
import 'package:mark/services/authentication.dart';
import 'package:mark/services/firebase_service.dart';
import 'package:mark/services/validate.dart';
import 'package:flutter/material.dart';
import 'package:mark/models/user.dart';


class EmployeeForm extends StatefulWidget {
  final List<Store> stores;
  String userid;

  EmployeeForm({@required this.stores,this.userid});

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {

  Store _dropdownValue; // Current dropdown value
  List<DropdownMenuItem<Store>> _items; // Store all the drop down menu items
  Validate validate = new Validate();
  bool _isUploading = false, _storelength = false ;


  String firstName,
      lastName,
      emailId,
      password,
      experience,
      expertise,
      imageId,
      empId,
      mobile,
      aadhar,
      address,
      radius,
      latitude,
      longitude;

  //bool _autoValidate;

  @override
  void initState() {
    super.initState();
    if(widget.stores.length > 0){
      _items = _buildDropdownMenuItem();
      _dropdownValue = widget.stores[0];
    } else{
      _storelength = true;
    };
  }

  /// Build Drop Down Menu Item
  List<DropdownMenuItem<Store>> _buildDropdownMenuItem() {
    var tempList = [];
    tempList = widget.stores.map((Store store) {
      return DropdownMenuItem<Store>(value: store, child: Text(store.name));
    }).toList();
    return tempList;
  }

  // TODO: Link Phone and Email Accounts together
  // TODO: Make a step process? Like email+password -> phone number+verification -> link in background -> other informations -> upload everthing to firebase?

  /// Upload Data to Firebase Storage
  _uploadToFirebase() async {
    apirepository Apirepository = apirepository();
    Auth auth =Auth();
    User users = User(email: emailId, password: password,phonenumber:mobile,admin:false);
    // Create a user
    Map<String, dynamic> user = users.toMap();
    empId = await auth.signUp(user);

    latitude=_dropdownValue.lat.toString();
    longitude=_dropdownValue.longi.toString();

    // Create an employee and its map
    Employee emp = new Employee(
      userId: empId,
      firstName: firstName,
      lastName: lastName,
      storeId: _dropdownValue.id,
      imageId: null, // Store null always...the user will upload the image 
      emailId: emailId,
      phoneNumber: mobile,
      specialization: expertise,
      aadharNumber: aadhar,
      address: address,
      experience: experience,
      radius: _dropdownValue.radius,
      longi: longitude,
      lat: latitude,
      admin: widget.userid
    );

    //Create employee map
    Map<String, dynamic> empMap = emp.toMap();

    //Upload to firebase
    await Apirepository.employee_uploaddata(empMap);
  }

  /// Submit form after validating it
  _submitForm() async {
      setState(() {
        _isUploading = true;
      });

      // upload files to firebase
      await _uploadToFirebase();

      setState(() {
        _isUploading = false;
      });
    }

  /// Reset Form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Employee Form"),
      ),
      body:_storelength
          ? Center(
          child:
              Text(
                "Please create a business",
                textScaleFactor: 1.5,
              ),
      )
      : _isUploading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                _buildSpace(),
                Text(
                  "Uploading...",
                  textScaleFactor: 1.5,
                ),
              ],
            ))
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => validate.verifyName(name),
                          onChanged: (value) {
                            firstName = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "First Name",
                            hintText: "John",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (name) => validate.verifyName(name),
                          onChanged: (value) {
                            lastName = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Last Name",
                            hintText: "Doe",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) => validate.verifyEmail(email),
                          onChanged: (value) {
                            emailId = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email Name",
                            hintText: "you@example.com",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (password) =>
                              validate.verifyPassword(password),
                          onChanged: (value) {
                            password = value;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            hintText: "P@ssword!123",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (addr) => validate.verifyAddress(addr),
                          onChanged: (value) {
                            address = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Address",
                            hintText: "123/131/J, Nagar",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (mobile) => validate.verfiyMobile(mobile),
                          onChanged: (value) {
                            mobile = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Mobile Number",
                            hintText: "9450032010",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (add) => validate.verifyAadhar(add),
                          onChanged: (value) {
                            aadhar = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Aadhar Number",
                            hintText: "123456789376",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (exp) => validate.verifyExpertise(exp),
                          onChanged: (value) {
                            expertise = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Expertise",
                            hintText: "Haircut",
                          ),
                        ),
                        _buildSpace(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 8,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (exp) => validate.verifyExperience(exp),
                          onChanged: (value) {
                            experience = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Experience (in  years)",
                            hintText: "2",
                          ),
                        ),
                        _buildSpace(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          padding: EdgeInsets.only(left: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Store:     ",
                                textScaleFactor: 1.4,
                              ),
                              DropdownButton<dynamic>(
                                  value: _dropdownValue,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 26,
                                  elevation: 16,
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 23.0,
                                  ),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  items: _items,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _dropdownValue = newValue;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        _buildSpace(height: 20.0),
                        Center(
                          child: MaterialButton(
                            padding: EdgeInsets.all(13.0),
                            onPressed: _submitForm,
                            textColor: Colors.white,
                            color: Colors.blue,
                            child: Text(
                              "  SUBMIT  ",
                              textScaleFactor: 1.3,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
    );
  }

  /// Adds a constant space between two widgets
  Widget _buildSpace({double height = 15.0}) {
    return SizedBox(
      height: height,
    );
  }
}
