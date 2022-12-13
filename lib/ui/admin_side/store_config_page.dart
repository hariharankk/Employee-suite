import 'package:mark/models/store.dart';
import 'package:mark/services/firebase_service.dart';
import 'package:mark/services/validate.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StoreConfigPage extends StatefulWidget {
  final List<Store> stores;
  String userid;

  StoreConfigPage({@required this.stores,this.userid});

  @override
  _StoreConfigPageState createState() => _StoreConfigPageState();
}

class _StoreConfigPageState extends State<StoreConfigPage> {
  String longi='',lat='';
  bool _isUploading = false;
  List<String> _location=[];
  String _radius = '' , _name = '' , _id = '';


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  /// Build Drop Down Menu Item
  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius:  BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Complete store setup",
          ),
          content: Text("if you quit, the store changes will be not be changed?"),
          actions: <Widget>[
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius:  BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Completed",
          ),
          content: Text("your store details have been uploaded"),
          actions: <Widget>[
            TextButton(
              child: Text("Done"),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  /// Display message in snack bar

  /// Get Location
  _getLocation() async {
    Position position = await Geolocator().getCurrentPosition();
    print(position);
    lat =  position.latitude.toString();
    longi = position.longitude.toString();
    print(lat);
  }

  /// Upload radius and Location in firebase
  _uploadToFirebase() async {
    setState(() {
      _isUploading = true;
    });

    apirepository Apirepository = apirepository();

    Store store = new Store(
      storeName: _name,
      storeId: _id,
      lat: lat,
      longi: longi,
      radius: _radius,
        admin: widget.userid
    );

    Map<String, dynamic> storeMap = store.toMap();
    // Upload to firebase
    print(storeMap);
    bool result = await Apirepository.store_uploaddata(storeMap);
    // Set [_isUploading] to false
    setState(() {
      _isUploading = false;
    });
  }

  /// Submit and upload

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store Configurator"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _showForm(context),
          _showCircularProgress(),
        ],
      ),
    );
  }

  /// Return progress indicator if the form is uploading data
  Widget _showCircularProgress() {
    if (_isUploading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  /// Display form for location and radius
  Widget _showForm(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 20.0),
        Form(

          child: Column(
            children: <Widget>[
              Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width * 0.80,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String value) {
                    Validate validate = new Validate();
                    return validate.verifyName(value);
                  },
                  onChanged: (value) {
                    _name = value;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name of store",
                    hintText: "Spades",
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width * 0.80,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String value) {
                    Validate validate = new Validate();
                    return validate.verfiystorenumber(value);
                 },
                  onChanged: (value) {
                    _id = value;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Store_id",
                    hintText: "123",
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Location: ", textScaleFactor: 1.1),
                  MaterialButton(
                    padding: EdgeInsets.all(10.0),
                    onPressed: _getLocation,
                    child: Text("Get Location", textScaleFactor: 1.2),
                    textColor: Colors.white,
                    color: Colors.purpleAccent,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width * 0.80,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String value) {
                    Validate validate = new Validate();
                    return validate.verifyRadius(value);
                  },
                  onChanged: (value) {
                    _radius = value;
                    print(_radius);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Radius (in meters)",
                    hintText: "",
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: MaterialButton(
                  padding: EdgeInsets.all(13.0),
                  onPressed: ()async{
                    if(_name == Null || _name == '' || _id == Null || _id == '' || _radius == Null || _radius == '' )
                  {
                    return showDiscardDialog(context);
                  }
                   else
                   {
                     print('haran');
                     await _uploadToFirebase();
                     return await Dialog(context);
                   }
                  },
                  textColor: Colors.white,
                  color: Colors.blue,
                  child: Text(
                    "  SUBMIT  ",
                    textScaleFactor: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
