import 'package:flutter/material.dart';
import 'package:mark/services/authentication.dart';
import 'package:mark/models/user.dart';
import 'package:mark/ui/alreadyhaveaaccount.dart';
import 'package:mark/ui/login_page.dart';
import 'package:mark/services/validate.dart';

class register extends StatefulWidget {
  final VoidCallback loginCallback;
  register({Key key,this.loginCallback}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  Auth auth = Auth();
  String _email;
  String _password;
  String _phoneNumber;
  String _errorMessage = '';
  bool _isLoading = false;

  void registeradmin() async{
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    User user = User(phonenumber: _phoneNumber,email: _email,admin: true, password: _password);
    Map<String, dynamic> userdata = user.toMap();
    String username= await auth.signUp(userdata);
    if(username != '' && username!= null)
    {
      setState(() {
        _isLoading = false;
        _errorMessage ='';
      });
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return LoginPage(loginCallback: widget.loginCallback);
          },
        ),
      );
      Navigator.pop(context);
    }
    else{
      setState(() {
        _isLoading = false;
        _errorMessage ='Unable to register, because your phonenumber and mobile number not unique';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showForm(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPhoneInput(),
              SizedBox(
                height: 10.0,
              ),
              showErrorMessage(_errorMessage),
              showPrimaryButton(),
              SizedBox(
                height: 15.0,
              ),
              AlreadyHaveAnAccountCheck(login: false,
                press: () async{
                 await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginPage(loginCallback: widget.loginCallback);
                      },
                    ),
                  );
                 Navigator.pop(context);
                },
              ),
            ],
          ),
        )
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showErrorMessage(String text) {
    if (text.length > 0 && text != null) {
      return new Text(
        text,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.jpg'),
        ),
      ),
    );
  }

  Widget showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: false,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: "Please enter your Phone Number",
          icon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
        value.isEmpty
            ? 'Number can\'t be empty'
            : new Validate().verfiyMobile(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Please enter your Password',
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Please enter your Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onChanged: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: new Text('Register',
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          onPressed: ()
          async{
            registeradmin();
          },
        ),
      ),
    );
  }
}