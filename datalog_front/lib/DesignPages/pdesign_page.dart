import 'package:flutter/material.dart';
import '/DesignModels/pdesign_model.dart';
import '/service.dart';
import 'package:file_picker/file_picker.dart'; // File picker paketi
import 'dart:io';


class PdesignPage extends StatefulWidget {
  const PdesignPage({super.key});

  @override
   PdesignPageState createState() =>  PdesignPageState();
}

class  PdesignPageState extends State<PdesignPage> {

  final Service service = Service();
  // final String apiUrl = "http://localhost:8080/api/wd/latest";
  late Future<List<Pdesign>> latestPdList;

  


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






  
  // PD kaydetme fonksiyonu
  Future<void> registerPD() async {

    try {
      // WD modelini oluşturuyoruz
      Pdesign pd = Pdesign(
        kks: kksController.text,
        description: descriptionController.text,
        revisionNo: int.tryParse(revisionNoController.text) ?? 0,
        versionNo: int.tryParse(versionNoController.text) ?? 0,
      );

       // Servis sınıfındaki registerWD metodunu çağırıyoruz
      await service.registerPD(
        pd.kks,
        pd.description,
        pd.revisionNo,
        pd.versionNo,
        selectedFiles, // Seçilen dosyaları gönderiyoruz
      );



   // Başarılı mesajı gösteriyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PD registered successfully')),
      );
    } catch (e) {
      // Hata durumunda mesaj gösteriliyor
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register PD: $e')),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register PD')),
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
              onPressed: registerPD,
              child: const Text('Register PD'),
            ),
          ],
        ),
      ),
    );
  }
}
