import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/service.dart';
import '/user_model.dart';

enum Gender {
  MALE,
  FEMALE,
  OTHER,
}

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final Service service = Service();
  final UserModel _userModel = UserModel();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  Gender selectedGender = Gender.MALE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  final DateFormat formatter = DateFormat('yyyy-MM-dd');
                  final String formattedDate = formatter.format(picked);
                  setState(() {
                    birthDateController.text = formattedDate;
                  });
                }
              },
              child: Text(
                birthDateController.text.isEmpty
                    ? 'Select birthdate'
                    : birthDateController.text,
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Gender>(
              value: selectedGender,
              onChanged: (Gender? newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
              items: [
                DropdownMenuItem<Gender>(
                  value: Gender.MALE,
                  child: Text('Male'),
                ),
                DropdownMenuItem<Gender>(
                  value: Gender.FEMALE,
                  child: Text('Female'),
                ),
                DropdownMenuItem<Gender>(
                  value: Gender.OTHER,
                  child: Text('Other'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String birthDate = birthDateController.text;
                String gender = selectedGender.toString().split('.').last;
                String userName = await _userModel.getUserNames();

                // Call the updateUser method from the Service class
                var response = await service.updateUser(
                  userName,
                  firstName,
                  lastName,
                  birthDate,
                  gender,
                );

                if (response.statusCode == 200) {
                  // User info saved successfully
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User info saved successfully')),
                  );
                } else {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to save user info')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}