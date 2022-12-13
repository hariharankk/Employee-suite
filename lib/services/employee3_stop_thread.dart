import 'package:socket_io_client/socket_io_client.dart' as IO;

class employee3ExitSocket {
  IO.Socket socket;
  employee3ExitSocket() {
    socket = IO.io('http://127.0.0.1:5000/employee3-disconnect', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });
    socket.connect();
  }
  void Stopthread(){
    socket.emit('/employee3/stop_thread');
  }
}
