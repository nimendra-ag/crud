import 'package:crud/service/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class Employee extends StatefulWidget {
  const Employee({super.key});

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Book Form',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextField(
              label: "Name",
              icon: Icons.person,
              controller: nameController,
              hintText: "Enter the name of the book",
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: "Author",
              icon: Icons.edit,
              controller: authorController,
              hintText: "Enter the author's name",
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: "Description",
              icon: Icons.description,
              controller: descriptionController,
              hintText: "Enter a brief description",
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: "Contact Number",
              icon: Icons.phone,
              controller: contactNumberController,
              hintText: "Enter contact number",
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            buildTextField(
              label: "Location",
              icon: Icons.location_on,
              controller: locationController,
              hintText: "Enter the location",
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  String id = randomAlphaNumeric(10);
                  Map<String, dynamic> employeeInfoMap = {
                    "Name": nameController.text,
                    "Author": authorController.text,
                    "Id": id,
                    "Description": descriptionController.text,
                    "Contact Number": contactNumberController.text,
                    "Location": locationController.text,
                  };
                  nameController.clear();
                  authorController.clear();
                  descriptionController.clear();
                  contactNumberController.clear();
                  locationController.clear();

                  await DatabaseMethods()
                      .addEmployeeDetails(employeeInfoMap, id)
                      .then((value) {
                    Fluttertoast.showToast(
                      msg: "Book data added successfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 5,
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey[200],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              hintText: hintText,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            ),
          ),
        ),
      ],
    );
  }
}
