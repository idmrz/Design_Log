import 'package:flutter/material.dart';
import '/DesignModels/letter_model.dart';
import '/service.dart';
import 'package:intl/intl.dart'; // intl kütüphanesi eklendi
import 'package:file_picker/file_picker.dart'; // File picker paketi
import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
   LetterPageState createState() =>  LetterPageState();
}

class  LetterPageState extends State<LetterPage> {

  final Service service = Service();
  // final String apiUrl = "http://localhost:8080/api/wd/latest";
  late Future<List<Letter>> latestLetterList;

  


  // Controller'lar tanımlanıyor
  TextEditingController letterDateController = TextEditingController(); // Tarih için Controller
  TextEditingController letterNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  List<File> selectedFiles = []; // Seçilen dosyaları tutmak için liste
  String? fileName;

  // Dosya seçici
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.any);
    if (result != null) {
      setState(() {
        selectedFiles = result.paths.map((path) => File(path!)).toList();
        fileName = result.files.map((e) => e.name).join(', ');
      });
       // Seçilen dosya yollarını loglayın
    print("Selected File Paths: ${selectedFiles.map((file) => file.path).toList()}");
    
    }
  }


  // Tarih seçici fonksiyonu
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formattedDate = formatter.format(picked); // yyyy-MM-dd formatına çeviriyoruz
      setState(() {
        letterDateController.text = formattedDate; // Tarih 'yyyy-MM-dd' formatında atandı
      });
    }
  }



  
  // LT kaydetme fonksiyonu
  Future<void> registerLT() async {

    try {
      // LT modelini oluşturuyoruz
      Letter lt = Letter(
        letterDate: letterDateController.text,
        letterNo: letterNoController.text,
        description: descriptionController.text,
        category: categoryController.text,
      );

       // Servis sınıfındaki registerWD metodunu çağırıyoruz
      await service.registerLT(
        lt.letterDate,
        lt.letterNo,
        lt.description,
        lt.category,
        selectedFiles, // Seçilen dosyaları gönderiyoruz
      );



   // Başarılı mesajı gösteriyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('LT registered successfully')),
      );
    } catch (e) {
      // Hata durumunda mesaj gösteriliyor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register LT: $e')),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register LT')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: letterNoController, decoration: const InputDecoration(labelText: 'Letter No')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
            // Tarih seçici
            ListTile( title: Text(letterDateController.text.isEmpty 
            ? 'Select Letter Date' : letterDateController.text, // Seçilen tarih gösteriliyor
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context), // Tarih seçici açılıyor
              ),

            // Dosya seçici butonu
            ListTile(
              title: Text(selectedFiles.isEmpty
                  ? 'No files selected'
                  : 'Selected files: $fileName'),
              trailing: const Icon(Icons.attach_file),
              onTap: _pickFiles,
            ),
            ElevatedButton(
              onPressed: registerLT,
              child: const Text('Register LT'),
            ),
          ],
        ),
      ),
    );
  }
}
