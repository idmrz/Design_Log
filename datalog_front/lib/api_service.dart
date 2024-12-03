import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.19:8080/api';

  static Future<void> downloadFile(
      String type, String folderName, String fileName) async {
    try {
      if (!kIsWeb) {
        // Mobil platform için indirme
        var status = await Permission.storage.request();
        
        if (status.isGranted) {
          final url = Uri.parse(
              '$baseUrl/folders/download?type=$type&folderName=$folderName&fileName=$fileName');
          final response = await http.get(url);

          if (response.statusCode == 200) {
            Directory? directory;
            if (Platform.isAndroid) {
              // Android için indirme klasörü
              directory = Directory('/storage/emulated/0/Download');
              if (!directory.existsSync()) {
                directory.createSync(recursive: true);
              }
            } else if (Platform.isIOS) {
              // iOS için dökümanlar klasörü
              directory = await getApplicationDocumentsDirectory();
            }

            if (directory != null) {
              final filePath = '${directory.path}/$fileName';
              final file = File(filePath);
              await file.writeAsBytes(response.bodyBytes);
              print('File saved to: $filePath');
            }
          } else {
            throw Exception('Failed to download file: ${response.statusCode}');
          }
        } else {
          throw Exception('Storage permission denied');
        }
      } else {
        // Web platformu için tarayıcının indirme özelliğini kullan
        final url = Uri.parse(
            '$baseUrl/folders/download?type=$type&folderName=$folderName&fileName=$fileName');
        final response = await http.get(url);
        
        if (response.statusCode == 200) {
          final blob = response.bodyBytes;
          // Web'de indirme işlemi için gerekli kod buraya eklenecek
          // Not: Bu kısım web platformunda farklı şekilde ele alınmalı
        }
      }
    } catch (e) {
      print('Error downloading file: $e');
      rethrow;
    }
  }

  static Future<List<String>> listFolderContents(
      String type, String folderName) async {
    final url =
        Uri.parse('$baseUrl/folders/contents?type=$type&folderName=$folderName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.cast<String>();
      } else {
        throw Exception('Failed to list folder contents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error listing folder contents: $e');
    }
  }
}