import 'dart:io';
import 'package:path/path.dart' as Path;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mark/utility/jwt.dart';


class Imagestorage {
  // Uploads a file to Firebase Storage and returns the path to its location
  String uploadURL = 'http://127.0.0.1:5000';
  String Token;
  JWT jwt = JWT();
  Future<dynamic> upload(File imageFile) async {
    Token = await jwt.read_token();
    var stream = new http.ByteStream(
        DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(uploadURL+'/img-profile');

    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'x-access-token': Token
    };
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: Path.basename(imageFile.path),
        contentType: MediaType('image', 'png')
    );

    request.files.add(multipartFile);
    var response = await request.send();
    var responsevalue = await response.stream.bytesToString();
    print(jsonDecode(responsevalue)['file_name']);
    return jsonDecode(responsevalue)['file_name'];

  }


  Future<dynamic> uploadFile(File imageFile, String employee_id) async {
    Token = await jwt.read_token();
    var stream = new http.ByteStream(
        DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(uploadURL+'/img-upload');

    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'x-access-token': Token
    };
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: Path.basename(imageFile.path),
        contentType: MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.fields['employee_id'] = employee_id;
    var response = await request.send();
    var responsevalue = await response.stream.bytesToString();
    print(jsonDecode(responsevalue)['file_name']);
    return jsonDecode(responsevalue)['file_name'];

  }

  void deleteFile(String imgurl) async {
    Token = await jwt.read_token();
    var pos = imgurl.lastIndexOf('/');
    String img = (pos != -1)? imgurl.substring(pos+1, imgurl.length): imgurl;
    String imgURL = uploadURL+'/deletefile/'+img;
    final response = await http.get(imgURL,
       headers: <String, String>{
      'x-access-token': Token
    },
    );
    var responseData = json.decode(response.body);
  }

  void delete(String user) async {
    Token = await jwt.read_token();
    String imgURL = uploadURL+'/delete/'+user;
    final response = await http.get(imgURL,
      headers: <String, String>{
      'x-access-token': Token
    },
    );
    var responseData = json.decode(response.body);
  }


  Future<dynamic> check_attendance(File imageFile, String employee_id) async {
    Token = await jwt.read_token();
    var stream = new http.ByteStream(
        DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(uploadURL+'/check_attendance');

    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      'x-access-token': Token
    };
    request.headers.addAll(headers);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: Path.basename(imageFile.path),
        contentType: MediaType('image', 'png'));

    request.files.add(multipartFile);
    request.fields['employee_id'] = employee_id;
    var response = await request.send();
    var responsevalue = await response.stream.bytesToString();
    print(jsonDecode(responsevalue)['status']);
    return jsonDecode(responsevalue)['status'];

  }

  Future<bool> getstatus(String empid) async{
    Token = await jwt.read_token();
    String imgURL = uploadURL+'/get_status/'+ empid ;
    final response = await http.get(imgURL,
      headers: <String, String>{
        'x-access-token': Token
      },
    );
    var responseData = json.decode(response.body);
    print(responseData['Status']);
    return responseData['Status'];
  }


}
