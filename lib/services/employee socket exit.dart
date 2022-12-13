import 'package:socket_io_client/socket_io_client.dart' as IO;

class EmployeeExitSocket {
  IO.Socket socket;
  EmployeeExitSocket() {
    socket = IO.io('http://127.0.0.1:5000/employee2-disconnect', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });
    socket.connect();
  }
  void Stopthread(){
    socket.emit('/employee2/stop_thread');
  }
}
