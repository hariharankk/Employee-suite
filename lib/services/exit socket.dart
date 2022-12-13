import 'package:socket_io_client/socket_io_client.dart' as IO;

class ApprovalExitSocket {
  IO.Socket socket;
  ApprovalExitSocket() {
    socket = IO.io('http://127.0.0.1:5000/approval-stop', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });
    socket.connect();
  }
  void Stopthread(){
    socket.emit('/approval/stop_thread');
  }
}
