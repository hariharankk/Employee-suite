import 'package:mark/services/validate.dart';
import 'package:flutter/material.dart';
import 'package:mark/services/authentication.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback loginCallback;


  LoginPage({this.loginCallback});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Auth auth =Auth();

  String _email;
  String _password;
  String _phoneNumber;
  String _smsCode;
  String _errorMessage;

  bool _isLoading;
  bool _isPhone;
  bool _codeSent = false;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _codeSent = false;
     _isPhone = true;
    super.initState();
  }

  void toggleEmailAndPhone() {
    setState(() {
      _isPhone = !_isPhone;
    });
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
try {
   if (_codeSent) {
     auth.signInWithOTP(_phoneNumber, _smsCode).then((data){
       if (data) {
         widget.loginCallback();
         Navigator.pop(context);
       }
       else{
         setState(() {
           _isLoading = false;
           _errorMessage = 'the credentials are incorrect, please try again';
         });
       }
     });
  }  else {
     auth.signInWithEmail(_email, _password).then((data){
       if (data) {
         widget.loginCallback();
         Navigator.pop(context);
       }
       else{
         setState(() {
           _isLoading = false;
           _errorMessage = 'the credentials are incorrect, please try again';
         });
       }
     });
    }
   }catch(e){
          setState(() {
            _isLoading = false;
            _errorMessage = 'the credentials are incorrect, please try again';
          });
 }

  }



  Future<void> verifyPhone(phoneNo) async {
    String Id = await auth.sendotp(phoneNo);
    setState(() {
      _smsCode = Id;
      _codeSent = true;
    });
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
              !_isPhone ? showEmailInput() : Container(),
              !_isPhone ? showPasswordInput() : Container(),
              _isPhone ? showPhoneInput() : Container(),
              SizedBox(
                height: 10.0,
              ),
              showErrorMessage(),
              showPrimaryButton(),
              SizedBox(
                height: 15.0,
              ),
              _codeSent ? Container() : showSecondaryButton(),
            ],
          ),
        ));
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

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
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

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child:  TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Email',
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

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
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

  Widget showPhoneInput() {
    return _codeSent
        ? showSmsCodeInput()
        : Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
            child: TextFormField(
              maxLines: 1,
              obscureText: false,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Phone Number",
                icon: Icon(
                  Icons.phone,
                  color: Colors.grey,
                ),
              ),
              validator: (value) => value.isEmpty
                  ? 'Number can\'t be empty'
                  : new Validate().verfiyMobile(value),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => _phoneNumber = value.trim(),
            ),
          );
  }

  Widget showSmsCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter OTP",
          icon: Icon(
            Icons.keyboard,
            color: Colors.grey,
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value.isEmpty
            ? 'Number can\'t be empty'
            : new Validate().verifyOTP(value),
        onChanged: (value) => _smsCode = value.trim(),
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
          child: new Text(
            _isPhone ? (_codeSent ? 'Login' : 'Verify Phone') : 'Login',
            style: new TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          onPressed: () => {
            _isPhone
                ? (_codeSent ? validateAndSubmit() : verifyPhone(_phoneNumber))
                : validateAndSubmit()
          },
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return InkWell(
      onTap: toggleEmailAndPhone,
      child: Center(
        child: _isPhone
            ? Text(
                "Sign in with Email",
                textScaleFactor: 1.1,
              )
            : Text(
                "Sign in with Phone Number",
                textScaleFactor: 1.1,
              ),
      ),
    );
  }
}
