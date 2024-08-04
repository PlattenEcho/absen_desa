import 'package:encrypt/encrypt.dart';

final key = Key.fromUtf8('abcdefghijklmnopqrstuvwxyz123456');
final iv = IV.fromUtf8('0123456789123456');

//encrypt
String encryptMyData(String text) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted_data = e.encrypt(text, iv: iv);
  return encrypted_data.base64;
}

//dycrypt
String decryptMyData(String text) {
  final e = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted_data = e.decrypt(Encrypted.fromBase64(text), iv: iv);
  return decrypted_data;
}

void main() {
  String get;
  get = encryptMyData("12345");
  print(get);

  print(decryptMyData(get));
}
