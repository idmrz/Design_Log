import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/DesignModels/letter_model.dart';
import '/service.dart';

class UpdateLTPage extends StatefulWidget {
  final Letter lt; // The WD object to update

  const UpdateLTPage({Key? key, required this.lt}) : super(key: key);

  @override
   UpdateLTPageState createState() =>  UpdateLTPageState();
}

class  UpdateLTPageState extends  State<UpdateLTPage> {
  final Service service = Service();
  
  late TextEditingController letterNoController;
  late TextEditingController letterDateController;
  late TextEditingController descriptionController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    letterNoController = TextEditingController(text: widget.lt.letterNo);
    letterDateController = TextEditingController(text: widget.lt.letterDate);
    descriptionController = TextEditingController(text: widget.lt.description);
    categoryController = TextEditingController(text: widget.lt.category.toString());
  }
  
// Generate file name based on pdId, kks, and createdDate (only the date part)
String generateFileName(int ltId, String letterNo, DateTime letterDate) {
  String formattedDate = DateFormat('yyyy-MM-dd').format(letterDate);
  return '$ltId-$letterNo-$formattedDate';
}

  // Method to update the LT details
  void updateLT() async {
    final updatedLT = Letter(
      letterId: widget.lt.letterId,
      letterNo: letterNoController.text,
      letterDate: letterDateController.text,
      description: descriptionController.text,
      category: categoryController.text,
      userId: widget.lt.userId,
      filePath: widget.lt.filePath,
      createdDate: widget.lt.createdDate,
    );

    var response = await service.updateLT(updatedLT);
    
    if (response.statusCode == 200) {
      Navigator.pop(context); // Go back to the list page
    } else {
      // Handle the error, show a message
      print('Failed to update the LT');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update LT')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: letterNoController,
              decoration: const InputDecoration(labelText: 'letterNo'),
            ),
             TextField(
              controller: letterDateController,
              decoration: const InputDecoration(labelText: 'letterDate'),
            ),
             TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'category'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateLT,
              child: const Text('Update LT'),
            ),
          ],
        ),
      ),
    );
  }
}
