import 'package:socket_io_client/socket_io_client.dart' as IO;

class HistoryExitSocket {
  IO.Socket socket;
  HistoryExitSocket() {
    socket = IO.io('http://127.0.0.1:5000/history-stopthread', <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'foo': 'bar'} // optional
    });
    socket.connect();
  }
  void Stopthread(){
    socket.emit('/history/stop_thread');
  }
}
