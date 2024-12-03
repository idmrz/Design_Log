import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:login_system/DesignPages/letter_page.dart';
import 'package:login_system/DesignUpdates/update_lt_page.dart';
import 'package:login_system/foldercontentpage.dart';
import '/DesignModels/letter_model.dart';
import '/service.dart';
import '/api_service.dart';

class LTListPage extends StatefulWidget {
  const LTListPage({super.key});

  @override
  LTListPageState createState() => LTListPageState();
}

class LTListPageState extends State<LTListPage> {
  final Service service = Service();
  List<Letter> ltList = [];
  List<Letter> filteredLtList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLatestLtList();
    searchController.addListener(_filterList);
  }

  Future<void> _loadLatestLtList() async {
    List<Letter> fetchedList = await service.fetchLatestLts();
    setState(() {
      ltList = fetchedList;
      filteredLtList = ltList;
    });
  }

  void _filterList() {
    setState(() {
      filteredLtList = ltList
          .where((lt) => lt.letterNo.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void deleteLT(int letterId) async {
    var response = await service.deleteLT(letterId);

    if (response.statusCode == 200) {
      setState(() {
        filteredLtList.removeWhere((lt) => lt.letterId == letterId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Letter with ID $letterId deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Letter with ID $letterId')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Letters')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by LetterNo',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "LetterNo",
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
                        "LetterDate",
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.settings, color: Colors.blueAccent, size: 18),
                          const SizedBox(width: 4),
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
                  itemCount: filteredLtList.length,
                  itemBuilder: (context, index) {
                    Letter lt = filteredLtList[index];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 242, 242),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                lt.letterNo,
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
                                lt.letterDate,
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
                                lt.description,
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
                                          builder: (context) => UpdateLTPage(lt: lt),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      if (lt.letterId != null) {
                                        deleteLT(lt.letterId!);
                                      } else {
                                        print('LT ID is null, cannot delete');
                                      }
                                    },
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.download, color: Colors.green),
                                      onPressed: () async {
                                        if (lt.filePath != null && lt.filePath!.isNotEmpty && lt.fileName != null) {
                                          try {
                                            await ApiService.downloadFile('pdesign', lt.filePath!, lt.fileName!);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  kIsWeb
                                                      ? 'İndirme işlemi başlatıldı'
                                                      : '${lt.fileName} başarıyla indirildi!'
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
                                      if (lt.filePath != null && lt.filePath!.isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => FolderContentsPage(
                                              folderType: "letter",
                                              folderName: lt.filePath!,
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Geçerli bir dosya yolu bulunamadı.")),
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
              builder: (context) => const LetterPage(),
            ),
          );
          _loadLatestLtList();
        },
        tooltip: 'Create New Letter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
