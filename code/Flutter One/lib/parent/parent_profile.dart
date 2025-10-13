import 'package:dreamjob/parent/mypost_page.dart';
import 'package:flutter/material.dart';
import 'package:dreamjob/service/authservice.dart';
import 'package:dreamjob/page/add_job_page.dart';
import 'package:dreamjob/page/loginpage.dart';  // <-- Make sure to import LoginPage

class ParentProfile extends StatelessWidget {
  final Map<String, dynamic> profile;
  final AuthService _authService = AuthService();

  ParentProfile({Key? key, required this.profile}) : super(key: key);

  // Updated logout function - async and await
  void onLogout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Parent Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo.shade600,
        centerTitle: true,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildProfileCard(context),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo.shade600,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: (profile['photo'] != null && profile['photo'].isNotEmpty)
                  ? NetworkImage(profile['photo'])
                  : null,
              child: (profile['photo'] == null || profile['photo'].isEmpty)
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
            accountName: Text(
              profile['parentName'] ?? 'Parent Name',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text('Parent'),
          ),

          ListTile(
            leading: const Icon(Icons.edit, color: Colors.indigo),
            title: const Text('Edit Profile'),
            onTap: () => Navigator.pushNamed(context, '/profile/edit'),
          ),

          ListTile(
            leading: const Icon(Icons.work_outline, color: Colors.indigo),
            title: const Text('Add Job'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddJobPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.list_alt, color: Colors.indigo),
            title: const Text('My Posted Jobs'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyPostPage()),
              );
            },
          ),

          const Spacer(),
          const Divider(),

          // Logout list tile with updated logout method
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => onLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (profile['photo'] != null && profile['photo'].isNotEmpty)
                  ? NetworkImage(profile['photo'])
                  : null,
              child: (profile['photo'] == null || profile['photo'].isEmpty)
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              profile['parentName'] ?? 'Parent Name',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text('Parent', style: TextStyle(color: Colors.grey)),
            const Divider(height: 30, thickness: 1.2),

            _infoTile(Icons.person_outline, "Contact Person", profile['contactPerson']),
            _infoTile(Icons.email, "Email", profile['email']),
            _infoTile(Icons.phone, "Phone", profile['phone']),
            _infoTile(Icons.home, "Address", profile['address']),
            _infoTile(Icons.child_care, "Child Name", profile['childName']),
            _infoTile(Icons.wc, "Gender", profile['gender']),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.work_outline),
              label: const Text('Add Job'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddJobPage()),
                );
              },
            ),

            const SizedBox(height: 10),

            OutlinedButton.icon(
              icon: const Icon(Icons.list_alt),
              label: const Text('My Posted Jobs'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyPostPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
                const SizedBox(height: 4),
                Text(
                  value ?? 'Not provided',
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
