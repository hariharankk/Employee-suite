import 'dart:io';
import 'package:mark/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mark/main.dart';
import 'package:mark/widgets/Opening_Button.dart';
import 'package:mark/widgets/dialog box.dart';
import 'package:mark/services/firebase_service.dart';
import 'package:mark/services/firebase_storage_service.dart';


class OpeningPage extends StatefulWidget {
  final String userId;
  final VoidCallback logoutCallback;
  OpeningPage({this.userId , this.logoutCallback});

  @override
  _OpeningPageState createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  File image;
  final Imagestorage imagestorage = Imagestorage();
  final apirepository database = apirepository();
  bool loading=false;
  Employee emp;


  @override
  void initState() {
     super.initState();
     database.employee_getdata(widget.userId).then((data){
       setState(() {
         emp = Employee.fromMap(data);
       });
     });
    _controller = CameraController(cameras[1], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

 Future<void> image_capture () async{
    await _initializeControllerFuture;
    var _image = await _controller.takePicture();
    image = File(_image.path);
    setState(() {
      loading=true;
    });
    String img = await imagestorage.uploadFile(image, widget.userId);
    if (img == null || img == "") {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialogbox(text: "Failure",
                content: "Your Image have been rejected, take the next image");
          }
      );
    }
    else {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialogbox(text: "Success",
                content: "Your Image have been accepted, take the next image");

          }
      );
    }
    setState(() {
      loading=false;
    });

 }


Future<void> image_approval () async{
  setState(() {
    loading=true;
  });
  bool status = await imagestorage.getstatus(widget.userId);
  if(status == true) {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialogbox(text: "success",
              content: "Your Images have been registered successfully");
        }
    );
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RootPage()));
  }
  else {

    await imagestorage.delete(widget.userId);

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialogbox(text: "Failure",
              content: "Your Images have been rejected, please try again");
        }
    );

    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => RootPage()));
  }
  setState(() {
    loading=false;
  });
  }


  Widget _buildLoading() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(color: Colors.blue,),
          SizedBox(height: 20.0),
          Text(
            "Please wait...",
            textScaleFactor: 1.1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width * 1.2;
    return Scaffold(
        appBar: AppBar(
          title: Text("Register Your FaceId"),
          leading: InkWell(
              onTap: widget.logoutCallback,
              child: Icon(
                Icons.arrow_back, color: Colors.white,)
          ),
          backgroundColor: Colors.blue,
        ),
        body:loading? _buildLoading()
            : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15,),
              ListTile(
                shape: RoundedRectangleBorder(

                  side: BorderSide(width: 2,color: Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                leading: const Icon(Icons.person,size: 40,color: Colors.blue,),
                title: emp==null
                    ?Text('Register Your FaceId,')
                    : Text(
                  'Register Your FaceId, ${emp.firstName}',
                  textScaleFactor: 1.2,
                ),
                subtitle: const Text('Use Photo button to register your FaceId, after successful registration of Face Id, Please click Complete button.'),
                onTap: () {
                 },
              ),
              SizedBox(height: 10,),
              !_controller.value.isInitialized ? Container() :
              Container(
                width: size,
                height: size,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Container(
                        width: size,
                        height: (size / _controller.value.aspectRatio) * 2,
                        child: FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              // If the Future is complete, display the preview.
                              return CameraPreview(_controller);
                            } else {
                              // Otherwise, display a loading indicator.
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    openingbutton(
                      text: 'Take photo',
                      func: () async {
                        await image_capture();
                      },
                    ),
                    openingbutton(
                      text: 'complete',
                      func: () async {
                        await image_approval();
                      },
                    )
                  ]
              )
            ]
        ),
        );
  }
}


/// Adds a constant space between two widgets

