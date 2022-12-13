import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JWT{
  final storage = const FlutterSecureStorage();

  Future<void> store_token(var data)async{
    await storage.write(key: 'token', value: data);
  }

  Future<dynamic> read_token()async{
    var value = await storage.read(key: 'token');
    return value;
  }

  Future<void> delete_token()async{
    await storage.deleteAll();
  }

}