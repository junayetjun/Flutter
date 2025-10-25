
import 'package:ababydaycare/authentication/login_page.dart';
import 'package:ababydaycare/parent/add_new_circular_page.dart';
import 'package:ababydaycare/parent/my_posted_circular_page.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:flutter/material.dart';

class ParentProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();

  // 🎨 NEW THEME COLORS 🎨
  static const Color _primaryColor = Color(0xFF42A5F5); // Soft Light Blue
  static const Color _accentColor = Color(0xFFFF7043); // Orange for actions
  static const Color _backgroundColor = Colors.white;
  static const Color _cardColor = Colors.white;

  ParentProfile({Key? key, required this.profile}) : super(key: key);

  void onLogout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 📸 PHOTO LOGIC IMPLEMENTED AS REQUESTED 📸
    const String baseUrl = "http://localhost:8085/images/parent/";
    final String? photoName = profile['photo'];
    final String? photoUrl = (photoName != null && photoName.isNotEmpty)
        ? "$baseUrl$photoName"
        : null;

    final ImageProvider? avatarImage = (photoUrl != null) ? NetworkImage(photoUrl) : null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Slightly off-white background
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: _backgroundColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      drawer: _buildDrawer(context, avatarImage),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header Area (Profile Photo and Name)
            _buildProfileHeader(avatarImage),

            // Main Content Body (Info Tiles and Actions)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildPersonalInfoCard(),
                  const SizedBox(height: 24),
                  _buildActionsCard(context),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGET BUILDERS ----------------

  Widget _buildProfileHeader(ImageProvider? avatarImage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
          color: _primaryColor.withOpacity(0.05),
          border: Border(bottom: BorderSide(color: Colors.grey.shade200))
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _primaryColor, width: 4),
                boxShadow: [
                  BoxShadow(
                      color: _primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5))
                ],
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: avatarImage,
                child: avatarImage == null
                    ? Icon(Icons.person, size: 60, color: _primaryColor.withOpacity(0.7))
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              profile['parentName'] ?? 'Parent Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              profile['user']?['email'] ?? 'No Email',
              style: TextStyle(fontSize: 16, color: _primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Personal Details"),
            const SizedBox(height: 10),
            _infoTile(Icons.perm_identity, "Contact Person", profile['contactPerson']),
            _infoTile(Icons.phone, "Phone", profile['phone']),
            _infoTile(Icons.home_outlined, "Address", profile['address']),
            _infoTile(Icons.child_care_outlined, "Child Name", profile['childName']),
            _infoTile(Icons.wc_outlined, "Gender", profile['gender']),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Job Management"),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_circle_outline, size: 22),
                label: const Text('Post a New Job'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  elevation: 5,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddJobPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.list_alt, size: 20),
                label: const Text('View My Posted Jobs'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: _primaryColor, width: 2),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyPostPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey,
                    )),
                const SizedBox(height: 2),
                Text(
                  value ?? 'Not provided',
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ---------------- DRAWER ----------------

  Widget _buildDrawer(BuildContext context, ImageProvider? avatarImage) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: _primaryColor),
            currentAccountPicture: CircleAvatar(
              backgroundColor: _cardColor,
              backgroundImage: avatarImage,
              child: avatarImage == null
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
            accountName: Text(
              profile['parentName'] ?? 'Parent Name',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(profile['user']?['email'] ?? 'Parent Account'),
          ),

          _buildDrawerItem(context, Icons.person_outline, 'Edit Profile', () => Navigator.pushNamed(context, '/profile/edit')),
          _buildDrawerItem(context, Icons.work_outline, 'Post a New Job', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddJobPage()));
          }),
          _buildDrawerItem(context, Icons.list_alt, 'My Posted Jobs', () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => MyPostPage()));
          }),

          const Spacer(),
          const Divider(),

          _buildDrawerItem(context, Icons.logout, 'Logout', () => onLogout(context), color: Colors.redAccent),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? _primaryColor),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      onTap: onTap,
    );
  }
}