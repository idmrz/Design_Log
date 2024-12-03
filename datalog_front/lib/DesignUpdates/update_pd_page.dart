import 'package:flutter/material.dart';
import '/DesignModels/pdesign_model.dart';
import '/service.dart';

class UpdatePDPage extends StatefulWidget {
  final Pdesign pd; // The PD object to update

  const UpdatePDPage({Key? key, required this.pd}) : super(key: key);

  @override
   UpdatePDPageState createState() =>  UpdatePDPageState();
}

class  UpdatePDPageState extends  State<UpdatePDPage> {
  final Service service = Service();
  
  late TextEditingController kksController;
  late TextEditingController descriptionController;
  late TextEditingController revisionNoController;
  late TextEditingController versionNoController;

  @override
  void initState() {
    super.initState();
    kksController = TextEditingController(text: widget.pd.kks);
    descriptionController = TextEditingController(text: widget.pd.description);
    revisionNoController = TextEditingController(text: widget.pd.revisionNo.toString());
    versionNoController = TextEditingController(text: widget.pd.versionNo.toString());
  }

// Generate file name based on pdId, kks, and createdDate (only the date part)
String generateFileName(int pdId, String kks, DateTime createdDate) {
  // Format the DateTime to only include the date part (yyyy-MM-dd)
  return '$pdId-$kks-${createdDate.toLocal().toIso8601String().split("T").first}';
}

  // Method to update the PD details
  void updatePD() async {
    final updatedPD = Pdesign(
      pdId: widget.pd.pdId,
      kks: kksController.text,
      description: descriptionController.text,
      revisionNo: int.tryParse(revisionNoController.text) ?? 0,
      versionNo: int.tryParse(versionNoController.text) ?? 0,
      userId: widget.pd.userId,
      filePath: widget.pd.filePath,
      createdDate: widget.pd.createdDate,
    );

    var response = await service.updatePD(updatedPD);
    
    if (response.statusCode == 200) {
      Navigator.pop(context); // Go back to the list page
    } else {
      // Handle the error, show a message
      print('Failed to update the PD');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update PD')),
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
              onPressed: updatePD,
              child: const Text('Update PD'),
            ),
          ],
        ),
      ),
    );
  }
}
