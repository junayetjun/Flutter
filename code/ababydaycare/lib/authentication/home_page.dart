
import 'package:ababydaycare/authentication/admin/admin_registration.dart';
import 'package:ababydaycare/authentication/login_page.dart';
import 'package:ababydaycare/caregiver/caregiver_registration.dart';
import 'package:ababydaycare/parent/parent_registration.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    // Default dropdown value
    selectedRole = "no"; // "no" = Select One
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure dropdown resets if null
    selectedRole ??= "no";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff4f7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🌸 Hero Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🍼 Baby image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/baby.jpg', // ✅ Ensure this path exists
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // ✨ Title
                    Text(
                      "Welcome to Angel Baby Day Care 👼",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xfff06292),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 💬 Description
                    Text(
                      "Where every giggle, nap, and tiny step matters! 💖\n"
                          "At Angel Baby Day Care, we provide a safe, joyful, and nurturing environment "
                          "for your little ones to explore, learn, and bloom with love.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 45),

                    // 🌼 Centered Buttons
                    Column(
                      children: [
                        // 🌸 Login Button → navigates to LoginPage
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xfff06292),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // 🌷 Registration Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xfff06292),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedRole,
                              hint: Text(
                                "Register As",
                                style: GoogleFonts.poppins(
                                  color: const Color(0xfff06292),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              icon: const Icon(Icons.arrow_drop_down, color: Color(0xfff06292)),
                              items: const [
                                DropdownMenuItem(
                                  value: "no",
                                  child: Text("Register As"),
                                ),
                                DropdownMenuItem(
                                  value: "PARENT",
                                  child: Text("PARENT"),
                                ),
                                DropdownMenuItem(
                                  value: "CAREGIVER",
                                  child: Text("CAREGIVER"),
                                ),
                                DropdownMenuItem(
                                  value: "ADMIN",
                                  child: Text("ADMIN"),
                                ),
                              ],
                              onChanged: (value) async {
                                setState(() => selectedRole = value);

                                // Navigate based on selection
                                if (value == "PARENT") {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ParentRegistrationPage()),
                                  );
                                } else if (value == "CAREGIVER") {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Registration()),
                                  );
                                } else if (value == "ADMIN") {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AdminRegistrationPage()),
                                  );
                                }

                                // Reset dropdown after coming back
                                setState(() => selectedRole = "no");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 💌 Contact Us Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xffffe3ec),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  children: [
                    Text(
                      "Get in Touch 💌",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xfff06292),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "We’re here to answer your questions and welcome your little angel to our family.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[700],
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _contactCard(
                          icon: Icons.phone,
                          title: "Call Us",
                          detail: "+880 1XXX-XXXXXX",
                        ),
                        _contactCard(
                          icon: Icons.email,
                          title: "Email",
                          detail: "info@angeldaycare.com",
                        ),
                        _contactCard(
                          icon: Icons.location_on,
                          title: "Visit Us",
                          detail: "123 Happy Street, Dhaka, Bangladesh",
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 💫 Contact Card Widget
  Widget _contactCard({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xfff06292), size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color(0xfff06292),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            detail,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
