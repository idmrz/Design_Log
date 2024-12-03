import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '/user_model.dart';
import '/token_manager.dart';
import '/constants.dart';
import '/DesignModels/wd_model.dart'; // For WD model
import '/DesignModels/pdesign_model.dart'; // For Pdesign model
import '/DesignModels/letter_model.dart'; // For Response model

import 'dart:io';




class Service {
  final TokenManager _tokenManager = TokenManager();
  final UserModel _userModel = UserModel();
  //create the method to save user

  Future<http.Response> saveUser(
      String userName, String password, String role) async {
    //create uri
    var uri = Uri.parse("$baseUrl/api/register/user");
    //header
    Map<String, String> headers = {"Content-Type": "application/json"};
    //body
    Map data = {
      'userName': userName,
      'password': password,
      'role': role,
    };

    //convert the above data into json
    var body = json.encode(data);
      print("Requesting to: $uri");
      print("Headers: $headers");
      print("Body: $body");
    var response = await http.post(uri, headers: headers, body: body);

    //print the response body
    print("Response: ${response.statusCode} ${response.body}");

    return response;
  }

    Future<http.Response> loginUser(String userName, String password) async {
    var uri =
        Uri.parse("$baseUrl/api/login?userName=$userName&password=$password");
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map data = {
      'userName': userName,
      'password': password,
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Extract the JWT token from the response body
      String token = response.body;

      // Store the JWT token in the TokenManager
      await _tokenManager.storeToken(token);
      await _userModel.storeUserName(userName);
    }

    return response;
  }

    Future<http.Response> updateUser(String userName, String firstName,
      String lastName, String birthDate, String gender) async {
    var uri = Uri.parse("$baseUrl/api/$userName/info");
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, String> data = {
      "firstName": firstName,
      "lastName": lastName,
      "birthDate": birthDate,
      "gender": gender
    };
    var body = json.encode(data);

    // Send a PATCH request to update the user info
    var patchResponse = await http.patch(uri, headers: headers, body: body);

    if (patchResponse.statusCode != 200) {
      // User info doesn't exist, send a POST request to create it
      var postResponse = await http.post(uri, headers: headers, body: body);
      print(postResponse.body);
      return postResponse;
    } else {
      // User info updated successfully
      print(patchResponse.body);
      return patchResponse;
    }
  }

   Future<UserInfoDto?> getUserInfo(String userName) async {
    var uri = Uri.parse("$baseUrl/api/$userName/info");
    var response = await http.get(uri);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var userInfoDto = UserInfoDto.fromJson(jsonResponse);
      userInfoDto.age = calculateAge(
          userInfoDto.birthDate); // Set the age using a helper function
      return userInfoDto;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to retrieve user info');
    }
  }

   Future<http.Response> deleteUser(String userName) async {
    // Create URI
    var uri = Uri.parse("$baseUrl/api/deleteUser/$userName");
    // Send the request
    var response = await http.delete(uri);

    // Print the response body
    print(response.body);

    return response;
  }

   Future<String> updateUserPassword(
      String userName, String currentPassword, String newPassword) async {
    var uri = Uri.parse('$baseUrl/api/updatePassword/$userName');
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, String> data = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
    var body = jsonEncode(data);

    var response = await http.put(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Password updated successfully
      return 'Password updated successfully';
    } else {
      // Failed to update password
      return 'Failed to update password';
    }
  }

  int calculateAge(String birthDate) {
    DateTime now = DateTime.now();
    DateTime dateOfBirth = DateTime.parse(birthDate);

    int age = now.year - dateOfBirth.year;

    // Check if the birthday hasn't occurred yet this year
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }






  // Design-Related Methods
  //Lists
//WD list
Future<List<WD>> fetchLatestWds() async {
  try {
    // Token'ı al
    String token = await _tokenManager.getToken();
    
    final response = await http.get(
      Uri.parse('$baseUrl/api/latest/wds'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Token'ı ekle
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => WD.fromJson(data)).toList();
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load WDs');
    }
  } catch (e) {
    print('Exception: $e');
    throw Exception('Failed to load WDs');
  }
}
//PD list
Future<List<Pdesign>> fetchLatestPds() async {
  try {
    // Token'ı al
    String token = await _tokenManager.getToken();
    
    final response = await http.get(
      Uri.parse('$baseUrl/api/latest/pds'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Token'ı ekle
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Pdesign.fromJson(data)).toList();
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load PDs');
    }
  } catch (e) {
    print('Exception: $e');
    throw Exception('Failed to load PDs');
  }
}
//LT list
Future<List<Letter>> fetchLatestLts() async {
  try {
    // Token'ı al
    String token = await _tokenManager.getToken();
    
    final response = await http.get(
      Uri.parse('$baseUrl/api/latest/lt'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // Token'ı ekle
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Letter.fromJson(data)).toList();
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load LTs');
    }
  } catch (e) {
    print('Exception: $e');
    throw Exception('Failed to load LTs');
  }
}
 Future<List<String>> fetchFilesInFolder(String type, String folderName) async {
  final url = Uri.parse('$baseUrl/api/folders/files?type=$type&folderName=$folderName');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> files = jsonDecode(response.body);
    return files.cast<String>();
  } else {
    throw Exception('Failed to fetch files in folder');
  }
}

   Future<void> downloadFile(
      String type, String folderName, String fileName) async {
    final url = Uri.parse('$baseUrl/api/folders/download?type=$type&folderName=$folderName&fileName=$fileName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      // Dosyayı cihazın indirilenler klasörüne kaydet
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      print('File saved to $filePath');
    } else {
      throw Exception('Failed to download file');
    }
  }

//Registers WD
  Future<void> registerWD(
      String kks,
      String description,
      int revisionNo,
      int versionNo,
      List<File> files, // Updated to handle multiple files
      ) async {

    // Retrieve the JWT token from TokenManager
    String token = await _tokenManager.getToken();

    // Create the URI for the request
    var uri = Uri.parse("$baseUrl/api/register/wd");

    // Create a multipart request
    var request = http.MultipartRequest('POST', uri);

    // Include the Authorization header
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Create a JSON object for the WD data
    Map<String, dynamic> wdData = {
      'kks': kks,
      'description': description,
      'revisionNo': revisionNo,
      'versionNo': versionNo,
    };

    // Add the JSON object as a field
    request.fields['wd'] = json.encode(wdData); // Convert to JSON string


  // Dosyalar ekleniyor (multiple files)
  if (files.isNotEmpty) {
    for (var file in files) {
      var multipartFile = await http.MultipartFile.fromPath(
        'files', // Backend'deki form alanı adı "files" olmalı
        file.path,
        filename: basename(file.path), // Dosya adını güvenli şekilde alıyoruz
      );
      request.files.add(multipartFile);
    }
  }

    // İstek gönderiliyor
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Data and file uploaded successfully');
    } else {
      print('Failed to upload data: ${response.statusCode}');
    }
   }


   // Method to update WD
  Future<http.Response> updateWD(WD wd) async {
    final url = Uri.parse('$baseUrl/api/update/wd/${wd.wdId}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(wd.toJson()),
    );
    return response;
  }

  // Method to delete WD by ID
  Future<http.Response> deleteWD(int wdId) async {
    final url = Uri.parse('$baseUrl/api/delete/wd/$wdId');
    
    final response = await http.delete(url);
    
    return response;
  }




//Registers PD
  Future<void> registerPD(
      String kks,
      String description,
      int revisionNo,
      int versionNo,
      List<File> files, // Updated to handle multiple files
      ) async {

    // Retrieve the JWT token from TokenManager
    String token = await _tokenManager.getToken();

    // Create the URI for the request
    var uri = Uri.parse("$baseUrl/api/register/pd");

    // Create a multipart request
    var request = http.MultipartRequest('POST', uri);

    // Include the Authorization header
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Create a JSON object for the PD data
    Map<String, dynamic> pdData = {
      'kks': kks,
      'description': description,
      'revisionNo': revisionNo,
      'versionNo': versionNo,
    };

    // Add the JSON object as a field
    request.fields['pd'] = json.encode(pdData); // Convert to JSON string
      

  // Dosyalar ekleniyor (multiple files)
  if (files.isNotEmpty) {
    for (var file in files) {
      var multipartFile = await http.MultipartFile.fromPath(
        'files', // Backend'deki form alanı adı "files" olmalı
        file.path,
        filename: basename(file.path), // Dosya adını güvenli şekilde alıyoruz
      );
      request.files.add(multipartFile);
    }
  }

    // İstek gönderiliyor
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Data and file uploaded successfully');
    } else {
      print('Failed to upload data: ${response.statusCode}');
    }
   }

   // Method to update PD
  Future<http.Response> updatePD(Pdesign pd) async {
    final url = Uri.parse('$baseUrl/api/update/pd/${pd.pdId}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pd.toJson()),
    );
    return response;
  }

  // Method to delete PD by ID
  Future<http.Response> deletePD(int pdId) async {
    final url = Uri.parse('$baseUrl/api/delete/pd/$pdId');
    
    final response = await http.delete(url);
    
    return response;
  }



//Registers LT
  Future<void> registerLT(
      String letterDate,
      String letterNo,
      String description,
      String category,
      List<File> files, // Updated to handle multiple files
      ) async {

    // Retrieve the JWT token from TokenManager
    String token = await _tokenManager.getToken();

    // Create the URI for the request
    var uri = Uri.parse("$baseUrl/api/register/lt");

    // Create a multipart request
    var request = http.MultipartRequest('POST', uri);

    // Include the Authorization header
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Create a JSON object for the WD data
    Map<String, dynamic> ltData = {
      'letterDate': letterDate,
      'letterNo': letterNo,
      'description': description,
      'category': category,
    };

    // Add the JSON object as a field
    request.fields['lt'] = json.encode(ltData); // Convert to JSON string

  // Dosyalar ekleniyor (multiple files)
  if (files.isNotEmpty) {
    for (var file in files) {
      var multipartFile = await http.MultipartFile.fromPath(
        'files', // Backend'deki form alanı adı "files" olmalı
        file.path,
        filename: basename(file.path), // Dosya adını güvenli şekilde alıyoruz
      );
      request.files.add(multipartFile);
    }
  }

    // İstek gönderiliyor
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Data and file uploaded successfully');
    } else {
      print('Failed to upload data: ${response.statusCode}');
    }
   }

   // Method to update LT
  Future<http.Response> updateLT(Letter lt) async {
    final url = Uri.parse('$baseUrl/api/update/letter/${lt.letterId}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(lt.toJson()),
    );
    return response;
  }

    // Method to delete Letter by ID
  Future<http.Response> deleteLT(int letterId) async {
    final url = Uri.parse('$baseUrl/api/delete/letter/$letterId');
    
    final response = await http.delete(url);
    
    return response;
  }


}

class UserInfoDto {
  String firstName;
  String lastName;
  String birthDate;
  String gender;
  int age;

  UserInfoDto({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.age,
  });

  factory UserInfoDto.fromJson(Map<String, dynamic> json) {
    return UserInfoDto(
      firstName: json['firstName'],
      lastName: json['lastName'],
      birthDate: json['birthDate'],
      gender: json['gender'],
      age: 0,
    );
  }

}