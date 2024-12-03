import 'package:flutter/material.dart';
import '/DesignModels/wd_model.dart';
import '/service.dart';
import 'package:file_picker/file_picker.dart'; // File picker paketi
import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class WDPage extends StatefulWidget {
  const WDPage({super.key});

  @override
   WDPageState createState() =>  WDPageState();
}

class  WDPageState extends State<WDPage> {

  final Service service = Service();
  // final String apiUrl = "http://localhost:8080/api/wd/latest";
  late Future<List<WD>> latestWdList;

  


  // Controller'lar tanımlanıyor
  TextEditingController kksController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController revisionNoController = TextEditingController();
  TextEditingController versionNoController = TextEditingController();
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

  // WD kaydetme fonksiyonu
  Future<void> registerWD() async {

    try {
      // WD modelini oluşturuyoruz
      WD wd = WD(
        kks: kksController.text,
        description: descriptionController.text,
        revisionNo: int.tryParse(revisionNoController.text) ?? 0,
        versionNo: int.tryParse(versionNoController.text) ?? 0,

      );

       // Servis sınıfındaki registerWD metodunu çağırıyoruz
      await service.registerWD(
        wd.kks,
        wd.description,
        wd.revisionNo,
        wd.versionNo,
        selectedFiles, // Seçilen dosyaları gönderiyoruz
      );



   // Başarılı mesajı gösteriyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WD registered successfully')),
      );
    } catch (e) {
      // Hata durumunda mesaj gösteriliyor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register WD: $e')),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register WD')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: kksController, decoration: const InputDecoration(labelText: 'KKS')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            TextField(controller: revisionNoController, decoration: const InputDecoration(labelText: 'Revision No')),
            TextField(controller: versionNoController, decoration: const InputDecoration(labelText: 'Version No')),
            // Dosya seçici butonu
            ListTile(
              title: Text(selectedFiles.isEmpty
                  ? 'No files selected'
                  : 'Selected files: $fileName'),
              trailing: const Icon(Icons.attach_file),
              onTap: _pickFiles,
            ),
            ElevatedButton(
              onPressed: registerWD,
              child: const Text('Register WD'),
            ),
          ],
        ),
      ),
    );
  }
}
