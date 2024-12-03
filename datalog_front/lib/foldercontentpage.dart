import 'package:flutter/material.dart';
import '/service.dart';


class FolderContentsPage extends StatefulWidget {
  final String folderType; // letter, pdesign, wd gibi tür
  final String folderName; // Klasör adı

  const FolderContentsPage({Key? key, required this.folderType, required this.folderName}) : super(key: key);

  @override
  State<FolderContentsPage> createState() => _FolderContentsPageState();
}

class _FolderContentsPageState extends State<FolderContentsPage> {
  final Service service = Service();
  late Future<List<String>> fileList; // Dosya listesi için Future

  @override
  void initState() {
    super.initState();
    fileList = service.fetchFilesInFolder(widget.folderType, widget.folderName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Files in ${widget.folderName}"),
      ),
      body: FutureBuilder<List<String>>(
        future: fileList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No files found"));
          }

          final files = snapshot.data!;
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              final fileName = files[index];
              return ListTile(
                title: Text(fileName),
                trailing: IconButton(
                  icon: const Icon(Icons.download, color: Colors.green),
                  onPressed: () async {
                    try {
                      await service.downloadFile(widget.folderType, widget.folderName, fileName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$fileName başarıyla indirildi!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Dosya indirilemedi: $e')),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
