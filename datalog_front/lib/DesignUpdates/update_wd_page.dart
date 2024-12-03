import 'package:flutter/material.dart';
import '/DesignModels/wd_model.dart';
import '/service.dart';

class UpdateWDPage extends StatefulWidget {
  final WD wd; // The WD object to update

  const UpdateWDPage({Key? key, required this.wd}) : super(key: key);

  @override
   UpdateWDPageState createState() =>  UpdateWDPageState();
}

class  UpdateWDPageState extends  State<UpdateWDPage> {
  final Service service = Service();
  
  late TextEditingController kksController;
  late TextEditingController descriptionController;
  late TextEditingController revisionNoController;
  late TextEditingController versionNoController;

  @override
  void initState() {
    super.initState();
    kksController = TextEditingController(text: widget.wd.kks);
    descriptionController = TextEditingController(text: widget.wd.description);
    revisionNoController = TextEditingController(text: widget.wd.revisionNo.toString());
    versionNoController = TextEditingController(text: widget.wd.versionNo.toString());
  }
  
// Generate file name based on wdId, kks, and createdDate (only the date part)
String generateFileName(int wdId, String kks, DateTime createdDate) {
  // Format the DateTime to only include the date part (yyyy-MM-dd)
  return '$wdId-$kks-${createdDate.toLocal().toIso8601String().split("T").first}';
}

  // Method to update the WD details
  void updateWD() async {
    final updatedWD = WD(
      wdId: widget.wd.wdId,
      kks: kksController.text,
      description: descriptionController.text,
      revisionNo: int.tryParse(revisionNoController.text) ?? 0,
      versionNo: int.tryParse(versionNoController.text) ?? 0,
      userId: widget.wd.userId,
      filePath: widget.wd.filePath,
      createdDate: widget.wd.createdDate,
    );

    var response = await service.updateWD(updatedWD);
    
    if (response.statusCode == 200) {
      Navigator.pop(context); // Go back to the list page
    } else {
      // Handle the error, show a message
      print('Failed to update the WD');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update WD')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: kksController,
              decoration: const InputDecoration(labelText: 'KKS'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: revisionNoController,
              decoration: const InputDecoration(labelText: 'Revision No'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: versionNoController,
              decoration: const InputDecoration(labelText: 'Version No'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateWD,
              child: const Text('Update WD'),
            ),
          ],
        ),
      ),
    );
  }
}
