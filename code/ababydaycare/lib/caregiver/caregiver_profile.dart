import 'package:ababydaycare/authentication/login_page.dart';
import 'package:ababydaycare/caregiver/education_page.dart';
import 'package:ababydaycare/caregiver/parent_circular_page.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:flutter/material.dart';

class CaregiverProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();

  // 🌸 PINK THEME COLORS 🌸
  static const Color _primaryColor = Color(0xFFFF80AB); // Soft pink accent
  static const Color _secondaryColor = Color(0xFFF8BBD0); // Baby pink highlight
  static const Color _backgroundColor = Color(0xFFFFF0F5); // Light blush background
  static const Color _cardColor = Color(0xFFFFE4EC); // Soft light pink for cards
  static const Color _textColor = Color(0xFF4A148C); // Deep purple for contrast

  CaregiverProfile({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseUrl = "http://localhost:8085/images/caregiver/";
    final String? photoName = profile['photo'];
    final String? photoUrl =
    (photoName != null && photoName.isNotEmpty) ? "$baseUrl$photoName" : null;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Caregiver Profile", style: TextStyle(color: _textColor)),
        backgroundColor: _secondaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _textColor),
      ),
      drawer: _buildDrawer(context, photoUrl),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(photoUrl),
            const SizedBox(height: 30),
            const Divider(height: 1, color: Colors.pinkAccent),
            const SizedBox(height: 20),

            _buildSection(
              title: "Personal Info",
              children: [
                _buildInfoRow(Icons.phone, "Phone", profile['phone']),
                _buildInfoRow(Icons.person_outline, "Gender", profile['gender']),
                _buildInfoRow(Icons.location_on_outlined, "Address", profile['address']),
                _buildInfoRow(Icons.calendar_today_outlined, "Date of Birth", profile['dateOfBirth']),
              ],
            ),

            _buildSection(
              title: "Education",
              children: _buildEducationSection(),
              action: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EducationListScreen(profile: profile)));
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                label: const Text('MANAGE',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(foregroundColor: _primaryColor),
              ),
            ),

            _buildSection(title: "Skills", children: [_buildChipsSection('skills', includeLevel: true)]),
            _buildSection(title: "Experience", children: _buildExperienceSection()),
            _buildSection(title: "Hobbies", children: [_buildChipsSection('hobbies')]),
            _buildSection(title: "Languages", children: [_buildChipsSection('languages', includeLevel: true)]),
            _buildSection(title: "References", children: _buildReferencesSection()),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGET FACTORY ----------------
  Widget _buildSection({required String title, required List<Widget> children, Widget? action}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title, action: action),
          const SizedBox(height: 12),
          ...children,
          const SizedBox(height: 15),
          const Divider(height: 1, color: Colors.pinkAccent),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String? photoUrl) {
    return Center(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5))
              ],
              border: Border.all(color: _primaryColor, width: 3),
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: _cardColor,
              backgroundImage: (photoUrl != null)
                  ? NetworkImage(photoUrl)
                  : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
            ),
          ),
          const SizedBox(height: 16),
          Text(profile['name'] ?? 'Unknown User',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _textColor)),
          const SizedBox(height: 4),
          Text(profile['user']?['email'] ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: _primaryColor)),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, String? photoUrl) {
    return Drawer(
      backgroundColor: _cardColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: _secondaryColor),
            accountName: Text(profile['name'] ?? 'Unknown User',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: _textColor)),
            accountEmail: Text(profile['user']?['email'] ?? 'N/A',
                style: const TextStyle(color: Colors.deepPurple)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: _primaryColor,
              backgroundImage: (photoUrl != null)
                  ? NetworkImage(photoUrl)
                  : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
            ),
          ),
          _buildDrawerItem(context, Icons.person, "My Profile", () => Navigator.pop(context)),
          _buildDrawerItem(context, Icons.home, "Home", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CaregiverHome(profile: profile)));
          }),
          _buildDrawerItem(context, Icons.school, "Education", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => EducationListScreen(profile: profile)));
          }),
          _buildDrawerItem(context, Icons.settings, "Settings", () => Navigator.pop(context)),
          const Divider(color: Colors.pinkAccent),
          _buildDrawerItem(
            context,
            Icons.logout,
            "Logout",
                () async {
              await _authService.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
            },
            color: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title,
      VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? _primaryColor),
      title: Text(title, style: TextStyle(color: color ?? _textColor)),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title, {Widget? action}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _textColor)),
        if (action != null) action,
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _primaryColor, size: 20),
          const SizedBox(width: 16),
          SizedBox(
            width: 110,
            child: Text("$label:",
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.purple)),
          ),
          Expanded(
              child: Text(value?.toString() ?? "N/A",
                  style: const TextStyle(fontSize: 16, color: _textColor))),
        ],
      ),
    );
  }

  List<Widget> _buildEducationSection() {
    return List.generate(profile['educations']?.length ?? 0, (i) {
      final edu = profile['educations'][i];
      return Card(
        color: _cardColor,
        elevation: 2,
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: const Icon(Icons.school, color: _primaryColor),
          title: Text("${edu['level']} - ${edu['institute']}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _textColor)),
          subtitle: Text(
            "${edu['board'] ?? 'N/A'}, ${edu['year']}\nResult: ${edu['result']}",
            style: const TextStyle(color: Colors.deepPurple),
          ),
          isThreeLine: true,
        ),
      );
    });
  }

  Widget _buildChipsSection(String key, {bool includeLevel = false}) {
    final List<dynamic>? list = profile[key];
    if (list == null || list.isEmpty) {
      return const Text("No items listed.",
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.deepPurple));
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(list.length, (i) {
        final item = list[i];
        String label = item['name'];
        if (includeLevel && item['level'] != null) label += " (${item['level']})";
        else if (includeLevel && item['proficiency'] != null) label += " (${item['proficiency']})";

        return Chip(
          label: Text(label,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      }),
    );
  }

  List<Widget> _buildExperienceSection() {
    return List.generate(profile['experiences']?.length ?? 0, (i) {
      final exp = profile['experiences'][i];
      return Card(
        color: _cardColor,
        elevation: 2,
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${exp['position']}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: _primaryColor)),
              const SizedBox(height: 4),
              Text("${exp['company']}",
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.deepPurple)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.date_range, size: 14, color: _primaryColor),
                  const SizedBox(width: 8),
                  Text("${exp['fromDate'] ?? 'N/A'} - ${exp['toDate'] ?? 'N/A'}",
                      style: const TextStyle(fontSize: 14, color: Colors.purple)),
                ],
              ),
              if (exp['description'] != null && exp['description'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(exp['description'],
                      style: const TextStyle(fontSize: 14, color: _textColor)),
                ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _buildReferencesSection() {
    return List.generate(profile['references']?.length ?? 0, (i) {
      final ref = profile['references'][i];
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        leading: const Icon(Icons.person_pin, color: _primaryColor),
        title: Text(ref['name'],
            style: const TextStyle(fontWeight: FontWeight.w600, color: _textColor)),
        subtitle: Text("${ref['relation']} | ${ref['contact']}",
            style: const TextStyle(color: Colors.deepPurple)),
      );
    });
  }
}
