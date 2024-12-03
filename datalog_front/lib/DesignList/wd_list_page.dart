import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_system/DesignPages/wd_page.dart';
import 'package:login_system/DesignUpdates/update_wd_page.dart';
import '/DesignModels/wd_model.dart';
import '/service.dart';
import '/api_service.dart';
import 'package:login_system/foldercontentpage.dart';

class WDListPage extends StatefulWidget {
  const WDListPage({super.key});

  @override
  WDListPageState createState() => WDListPageState();
}

class WDListPageState extends State<WDListPage> {
  final Service service = Service();
  List<WD> wdList = [];
  List<WD> filteredWdList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLatestWdList();
    searchController.addListener(_filterList);
  }

  Future<void> _loadLatestWdList() async {
    List<WD> fetchedList = await service.fetchLatestWds();
    setState(() {
      wdList = fetchedList;
      filteredWdList = wdList;
    });
  }

  void _filterList() {
    setState(() {
      filteredWdList = wdList
          .where((wd) => wd.kks.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void deleteWD(int wdId) async {
    var response = await service.deleteWD(wdId);

    if (response.statusCode == 200) {
      setState(() {
        filteredWdList.removeWhere((wd) => wd.wdId == wdId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('WD with ID $wdId deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete WD with ID $wdId')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Working Documentation')),
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
                  itemCount: filteredWdList.length,
                  itemBuilder: (context, index) {
                    WD wd = filteredWdList[index];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 247, 245, 245),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                wd.kks,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                wd.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                wd.revisionNo.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateWDPage(wd: wd),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    if (wd.wdId != null) {
                                      deleteWD(wd.wdId!);
                                    } else {
                                      print('WD ID is null, cannot delete');
                                    }
                                  },
                                ),
                               IconButton(
                                      icon: const Icon(Icons.download, color: Colors.green),
                                      onPressed: () async {
                                        if (wd.filePath != null && wd.filePath!.isNotEmpty && wd.fileName != null) {
                                          try {
                                            await ApiService.downloadFile('pdesign', wd.filePath!, wd.fileName!);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  kIsWeb
                                                      ? 'İndirme işlemi başlatıldı'
                                                      : '${wd.fileName} başarıyla indirildi!'
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
                                    if (wd.filePath != null && wd.filePath!.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FolderContentsPage(
                                            folderType: "wd",
                                            folderName: wd.filePath!,
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
              builder: (context) => const WDPage(),
            ),
          );
          _loadLatestWdList();
        },
        tooltip: 'Create New WD',
        child: const Icon(Icons.add),
      ),
    );
  }
}
