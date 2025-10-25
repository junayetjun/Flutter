import 'dart:io';
import 'package:ababydaycare/authentication/login_page.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:radio_group_v2/radio_group_v2.dart' as v2;

class ParentRegistrationPage extends StatefulWidget {
  const ParentRegistrationPage({super.key});

  @override
  State<ParentRegistrationPage> createState() => _ParentRegistrationPageState();
}

class _ParentRegistrationPageState extends State<ParentRegistrationPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController parentName = TextEditingController();
  final TextEditingController contactPerson = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController childName = TextEditingController();

  final v2.RadioGroupController genderController = v2.RadioGroupController();
  String? selectedGender;

  XFile? selectedImage;
  Uint8List? webImage;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3C72),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Registration As Customer"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blue[50]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.app_registration,
                                size: 70,
                                color: Color(0xFF1E3C72),
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
                              _buildTextField(parentName, "Parent Name", Icons.person),
                              const SizedBox(height: 15),
                              _buildTextField(contactPerson, "Contact Person", Icons.person),
                              const SizedBox(height: 15),
                              _buildTextField(email, "Email", Icons.email),
                              const SizedBox(height: 15),
                              _buildTextField(password, "Password", Icons.lock, isPassword: true),
                              const SizedBox(height: 15),
                              _buildTextField(confirmPassword, "Confirm Password", Icons.lock, isPassword: true),
                              const SizedBox(height: 15),
                              _buildTextField(phone, "Cell Number", Icons.phone),
                              const SizedBox(height: 15),
                              _buildTextField(address, "Address", Icons.maps_home_work_rounded),
                              const SizedBox(height: 15),
                              _buildTextField(childName, "Child Name", Icons.child_care),
                              const SizedBox(height: 20),
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
                              TextButton.icon(
                                icon: const Icon(Icons.image),
                                label: const Text('Upload Image'),
                                onPressed: pickImage,
                              ),
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
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1E3C72),
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
                                        color: Color(0xFF1E3C72),
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
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
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E3C72)),
        ),
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
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          selectedImage = pickedImage;
        });
      }
    }
  }

  void register() async {
    if (_formKey.currentState!.validate()) {
      if (password.text != confirmPassword.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }

      if ((kIsWeb && webImage == null) || (!kIsWeb && selectedImage == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image.')),
        );
        return;
      }

      final user = {
        "name": contactPerson.text,
        "email": email.text,
        "phone": phone.text,
        "password": password.text,
      };

      final parent = {
        "parentName": parentName.text,
        "contactPerson": contactPerson.text,
        "email": email.text,
        "phone": phone.text,
        "address": address.text,
        "childName": childName.text,
        "gender": selectedGender ?? "Other",
      };

      final apiService = AuthService();
      bool success = false;

      if (kIsWeb && webImage != null) {
        success = await apiService.registerParentWeb(
          user: user,
          parent: parent,
          photoBytes: webImage!,
        );
      } else if (selectedImage != null) {
        success = await apiService.registerParentWeb(
          user: user,
          parent: parent,
          photoFile: File(selectedImage!.path),
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Failed')),
        );
      }
    }
  }
}
