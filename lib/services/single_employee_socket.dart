import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class employee3Socket{
  StreamController _socketResponse = StreamController<Map<dynamic,dynamic>>();
  IO.Socket socket;
  void Function(Map<dynamic,dynamic>) get addResponse => _socketResponse.sink.add;
  Stream<Map<dynamic,dynamic>> get getResponse => _socketResponse.stream;

  employee3Socket(){
    socket = IO.io('http://127.0.0.1:5000/employee3-data', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });
    socket.connect();

  }

  void openingapprovalconnectAndListen(String id){
    socket.emit('/employee3/data',id);
    //When an event recieved from server, data is added to the stream
    socket.on('/employee3/data', (data) {
      print(data['data']);

      addResponse(data['data']);
    });

  }

  void openingapprovaldisconnect(){
    socket.dispose();
    socket.destroy();
    socket.close();
    socket.disconnect();
    //controller.close();
  }

}

