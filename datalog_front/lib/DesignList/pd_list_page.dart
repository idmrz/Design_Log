import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_system/DesignPages/pdesign_page.dart';
import 'package:login_system/DesignUpdates/update_pd_page.dart';
import '/DesignModels/pdesign_model.dart';
import '/service.dart';
import '/api_service.dart';
import 'package:login_system/foldercontentpage.dart';

class PDListPage extends StatefulWidget {
  const PDListPage({super.key});

  @override
  PDListPageState createState() => PDListPageState();
}

class PDListPageState extends State<PDListPage> {
  final Service service = Service();
  List<Pdesign> pdList = [];
  List<Pdesign> filteredPdList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLatestPdList();
    searchController.addListener(_filterList);
  }

  Future<void> _loadLatestPdList() async {
    List<Pdesign> fetchedList = await service.fetchLatestPds();
    setState(() {
      pdList = fetchedList;
      filteredPdList = pdList;
    });
  }

  void _filterList() {
    setState(() {
      filteredPdList = pdList
          .where((pd) => pd.kks.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void deletePD(int pdId) async {
    var response = await service.deletePD(pdId);

    if (response.statusCode == 200) {
      setState(() {
        filteredPdList.removeWhere((pd) => pd.pdId == pdId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDesign with ID $pdId deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete PDesign with ID $pdId')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P design')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by KKS',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "KKS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Revision",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: Colors.blueAccent, size: 18),
                          SizedBox(width: 4),
                          Text(
                            "Operation",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredPdList.length,
                  itemBuilder: (context, index) {
                    Pdesign pd = filteredPdList[index];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 247, 246),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                pd.kks,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                pd.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                pd.revisionNo.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdatePDPage(pd: pd),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      if (pd.pdId != null) {
                                        deletePD(pd.pdId!);
                                      } else {
                                        print('PD ID is null, cannot delete');
                                      }
                                    },
                                  ),
                                    IconButton(
                                      icon: const Icon(Icons.download, color: Colors.green),
                                      onPressed: () async {
                                        if (pd.filePath != null && pd.filePath!.isNotEmpty && pd.fileName != null) {
                                          try {
                                            await ApiService.downloadFile('pdesign', pd.filePath!, pd.fileName!);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  kIsWeb
                                                      ? 'İndirme işlemi başlatıldı'
                                                      : '${pd.fileName} başarıyla indirildi!'
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Dosya indirilemedi: $e')),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.folder_open, color: Colors.blue),
                                    onPressed: () {
                                      if (pd.filePath != null && pd.filePath!.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FolderContentsPage(
                                              folderType: "pdesign",
                                              folderName: pd.filePath!,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text("Geçerli bir dosya yolu bulunamadı.")),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PdesignPage(),
            ),
          );
          _loadLatestPdList();
        },
        tooltip: 'Create New PD',
        child: const Icon(Icons.add),
      ),
    );
  }
}
