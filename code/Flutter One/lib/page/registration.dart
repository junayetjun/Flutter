import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:dreamjob/page/loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;
import 'package:radio_group_v2/radio_group_v2.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController cell = TextEditingController();
  final TextEditingController address = TextEditingController();

  final RadioGroupController genderController = RadioGroupController();
  final DateTimeFieldPickerPlatform dob = DateTimeFieldPickerPlatform.material;

  String? selectedGender;

  DateTime? selectedDOB;

  XFile? selectedImage;

  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

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
                              orientation: RadioGroupOrientation.horizontal,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedGender = newValue.toString();
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      TextButton.icon(
                          icon: Icon(Icons.image),
                          label: Text('Upload Image'),
                          onPressed: pickImage
                      ),
                      // Display selected image preview
                      if(kIsWeb && webImage != null)
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              webImage!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                        )
                      else if(
                      !kIsWeb && selectedImage != null)
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Perform registration
                              print(
                                "Registered with: ${name.text}, ${email.text}",
                              );
                            }
                          },
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
                              Navigator.push(
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

  // Custom reusable text field builder
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> pickImage() async {
    if(kIsWeb){
      // For Web: Use image_picker_web to pick image and store as bytes
      var pickedImage = await ImagePickerWeb.getImageAsBytes();
      if(pickedImage != null){
        setState(() {
          webImage = pickedImage;
        });
      }
    }
      else{
        // For Mobile: Use image_picker to pick image
        final XFile? pickedImage =
            await _picker.pickImage(source: ImageSource.gallery);
        if(pickedImage != null){
          setState(() {
            selectedImage = pickedImage;
          });
        }
      }
    }



}
