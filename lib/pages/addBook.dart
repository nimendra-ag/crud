import 'package:crud/service/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String? selectedCategory; // Selected category for the dropdown
  final List<String> categories = [
    "Fiction",
    "Non-Fiction",
    "Science",
    "Biography",
    "Fantasy",
    "Mystery",
    "History",
  ]; // Predefined list of categories

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(254, 216, 106, 1), // Updated app bar color
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Add a New Book',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Container(
          color: const Color.fromRGBO(246, 246, 246, 1), // Updated background color
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
                keyboardType: TextInputType.multiline,
                maxLines: 5, // Multi-line text area
              ),
              const SizedBox(height: 20),
              buildDropdownField(
                label: "Category",
                icon: Icons.category,
                items: categories,
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
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
                    if (selectedCategory == null) {
                      Fluttertoast.showToast(
                        msg: "Please select a category",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: const Color.fromRGBO(254, 216, 106, 1),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    String id = randomAlphaNumeric(10);
                    String userId = FirebaseAuth.instance.currentUser!.uid; // Get current user ID

                    Map<String, dynamic> bookInfoMap = {
                      "Name": nameController.text,
                      "Author": authorController.text,
                      "Id": id,
                      "Description": descriptionController.text,
                      "Category": selectedCategory,
                      "Contact Number": contactNumberController.text,
                      "Location": locationController.text,
                      "UploadedBy": userId, // Add the current user's ID
                    };

                    nameController.clear();
                    authorController.clear();
                    descriptionController.clear();
                    contactNumberController.clear();
                    locationController.clear();
                    setState(() {
                      selectedCategory = null;
                    });

                    await DatabaseMethods()
                        .addBookDetails(bookInfoMap, id)
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
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5, // Transparent background for gradient
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Set the background as transparent
                    shadowColor: MaterialStateProperty.all<Color>(Colors.transparent), // Optional: Remove shadow
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 216, 106, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 50.0,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    int maxLines = 1, // Added parameter for multiline input
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
            maxLines: maxLines, // Set maxLines to make it multiline
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

  Widget buildDropdownField({
    required String label,
    required IconData icon,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
            color: Colors.grey[200],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: const Text("Select a category"),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              isExpanded: true,
              items: items
                  .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
