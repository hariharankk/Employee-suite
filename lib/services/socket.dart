import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class StreamSocket{
  StreamController _socketResponse = StreamController<List<dynamic>>();
  IO.Socket socket;
  void Function(List<dynamic>) get addResponse => _socketResponse.sink.add;
  Stream<List<dynamic>> get getResponse => _socketResponse.stream;

  StreamSocket(){
    socket = IO.io('http://127.0.0.1:5000/approval-getdata', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });
    socket.connect();

  }

  void openingapprovalconnectAndListen(String id){


    socket.emit('/approval/getdata',id);

    //When an event recieved from server, data is added to the stream
    socket.on('/approval/getdata', (data) {
      print(data);
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

