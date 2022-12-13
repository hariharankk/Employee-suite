import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class employee_StreamSocket{
  var _socketResponse= StreamController<List<dynamic>>();
  IO.Socket socket;
  void Function(List<dynamic>) get addResponse => _socketResponse.sink.add;
  Stream<List<dynamic>> get getResponse => _socketResponse.stream;

  employee_StreamSocket(){
    print('hari');
    socket = IO.io('http://127.0.0.1:5000/employee2-data', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'extraHeaders': {'foo': 'bar'},
      'autoConnect': false,// optional
    });
    socket.connect();

  }
  void openingapprovalconnectAndListen(String id){

      socket.emit('/employee2/data',id);

    //When an event recieved from server, data is added to the stream
    socket.on('/employee2/data', (data) {
      print(data);
      addResponse(data['data']);
    });

  }

  void openingapprovaldisconnect(){

    socket.dispose();
    socket.destroy();
    socket.close();
    socket.disconnect();
    //_socketResponse.close();
  }

}

