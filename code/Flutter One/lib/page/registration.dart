import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:dreamjob/entity/category.dart';
import 'package:dreamjob/page/loginpage.dart';
import 'package:dreamjob/service/authservice.dart';
import 'package:dreamjob/service/category_service.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;

class Registration extends StatefulWidget {
  const Registration({super.key});
  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _obscurePassword = true;

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();

  final v2.RadioGroupController genderController = v2.RadioGroupController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;
  DateTime? selectedDOB;

  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  // Category dropdown variables
  Category? selectedCategory;
  List<Category> categories = [];
  bool isCategoryLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final fetched = await CategoryService().fetchCategories();
      setState(() {
        categories = fetched;
        isCategoryLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isCategoryLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.app_registration,
                        size: 70,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Create Your Account",
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Fill the details below to sign up",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Full Name
                      _buildTextField(name, "Full Name", Icons.person),
                      const SizedBox(height: 15),

                      // Email
                      _buildTextField(email, "Email", Icons.email),
                      const SizedBox(height: 15),

                      // Password
                      _buildTextField(
                        password,
                        "Password",
                        Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 15),

                      // Confirm Password
                      _buildTextField(
                        confirmPassword,
                        "Confirm Password",
                        Icons.lock,
                        isPassword: true,
                      ),
                      const SizedBox(height: 15),

                      // Phone
                      _buildTextField(cell, "Cell Number", Icons.phone),
                      const SizedBox(height: 15),

                      // Address
                      _buildTextField(
                        address,
                        "Address",
                        Icons.maps_home_work_rounded,
                      ),
                      const SizedBox(height: 15),

                      // Date of Birth
                      DateTimeFormField(
                        decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        mode: DateTimeFieldPickerMode.date,
                        pickerPlatform: dob,
                        onChanged: (DateTime? value) {
                          setState(() {
                            selectedDOB = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),

                      // Gender Selection
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender:",
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            v2.RadioGroup(
                              controller: genderController,
                              values: const ["Male", "Female", "Other"],
                              indexOfDefault: 0,
                              orientation: v2.RadioGroupOrientation.horizontal,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedGender = newValue.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Category Dropdown
                      isCategoryLoading
                          ? const CircularProgressIndicator()
                          : DropdownButtonFormField<Category>(
                        decoration: InputDecoration(
                          labelText: "Select Category",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: selectedCategory,
                        items: categories.map((Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please select a category";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Upload Image Button
                      TextButton.icon(
                        icon: const Icon(Icons.image),
                        label: const Text('Upload Image'),
                        onPressed: pickImage,
                      ),

                      // Display selected image preview
                      if (kIsWeb && webImage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.memory(
                            webImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      else if (!kIsWeb && selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(selectedImage!.path),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),

                      const SizedBox(height: 25),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            "Register",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login Redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return '$label is required';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> pickImage() async {
    if (kIsWeb) {
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if (pickedImage != null) {
        setState(() {
          webImage = pickedImage;
        });
      }
    } else {
      final XFile? pickedImage =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  void register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Password match check
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Image validation
    if (kIsWeb) {
      if (webImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }
    } else {
      if (selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }
    }

    // Category validation
    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    // Prepare data
    final user = {
      "name": name.text,
      "email": email.text,
      "phone": cell.text,
      "password": password.text,
    };

    final caregiver = {
      "name": name.text,
      "email": email.text,
      "phone": cell.text,
      "gender": selectedGender ?? "other",
      "address": address.text,
      "dateOfBirth": selectedDOB?.toIso8601String() ?? '',
      "category": {
        "id": selectedCategory!.id
      }
    };

    final apiService = AuthService();
    bool success = false;

    if (kIsWeb && webImage != null) {
      success = await apiService.registerCaregiverWeb(
        user: user,
        caregiver: caregiver,
        photoBytes: webImage!,
      );
    } else if (selectedImage != null) {
      success = await apiService.registerCaregiverWeb(
        user: user,
        caregiver: caregiver,
        photoFile: File(selectedImage!.path),
      );
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Failed')),
      );
    }
  }
}
