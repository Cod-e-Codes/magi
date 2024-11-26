// encryption_helper.dart

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptionHelper {
  // Retrieve the key and IV from environment variables
  static final key = Key.fromBase64(
    dotenv.env['ENCRYPTION_KEY'] ??
        (throw Exception('Encryption key not found')),
  );
  static final iv = IV.fromBase64(
    dotenv.env['ENCRYPTION_IV'] ?? (throw Exception('Encryption IV not found')),
  );

  static String encryptQuery(String query) {
    try {
      final encrypter =
          Encrypter(AES(key, mode: AESMode.cbc)); // AES-256-CBC mode
      final encrypted = encrypter.encrypt(query, iv: iv);
      return encrypted.base64; // Return encrypted query in base64 format
    } catch (e) {
      throw Exception("Encryption failed: $e");
    }
  }

  static String decryptQuery(String encryptedQuery) {
    try {
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encryptedQuery, iv: iv);
      return decrypted;
    } catch (e) {
      throw Exception("Decryption failed: $e");
    }
  }
}
