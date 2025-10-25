
import 'package:ababydaycare/entity/job.dart';
import 'package:ababydaycare/parent/applicants_requested_page.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:ababydaycare/service/job_service.dart';
import 'package:flutter/material.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  late Future<List<Job>> _futureJobs;
  String? _token;
  bool _loadingToken = true;

  // New Theme Colors
  static const Color _primaryColor = Color(0xFFE91E63); // PinkAccent
  static const Color _secondaryColor = Color(0xFF4CAF50); // Green for actions
  static const Color _backgroundColor = Color(0xFFF5F5F5); // Light Grey Background
  static const Color _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadTokenAndJobs();
  }

  Future<void> _loadTokenAndJobs() async {
    final authService = AuthService();
    String? token = await authService.getToken();

    if (token != null) {
      setState(() {
        _token = token;
        _futureJobs = JobService().getMyJobs();
        _loadingToken = false;
      });
    } else {
      setState(() {
        _loadingToken = false;
      });
      // In a real app, you would redirect to LoginPage here
    }
  }

  // Function to refresh job list
  Future<void> _refreshJobs() async {
    setState(() {
      _futureJobs = JobService().getMyJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_token == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Appointments Requests", style: TextStyle(color: _cardColor))),
        body: Center(
          child: Text(
            '❌ No valid auth token found. Please login.',
            style: TextStyle(fontSize: 16, color: Colors.red.shade700),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("Interested Candidates", style: TextStyle(color: _cardColor)),
        backgroundColor: _primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: _cardColor),
      ),
      body: RefreshIndicator( // Added RefreshIndicator for user-friendly refresh
        onRefresh: _refreshJobs,
        color: _primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Job>>(
            future: _futureJobs,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: _primaryColor),
                      const SizedBox(height: 16),
                      const Text("Loading your requests...", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade300)
                    ),
                    child: Text(
                      '⚠️ Error loading data: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_late_outlined, size: 50, color: Colors.black38),
                      SizedBox(height: 10),
                      Text(
                        '🚫 You have no active job requests.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Pull down to refresh.',
                        style: TextStyle(fontSize: 14, color: Colors.black38),
                      ),
                    ],
                  ),
                );
              } else {
                final jobs = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Active Requests: ${jobs.length}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          return _buildJobCard(context, jobs[index], _token!);
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  // ---------------- Job Card Widget ----------------
  Widget _buildJobCard(BuildContext context, Job job, String token) {
    return Card(
      color: _cardColor,
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Title and Salary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title ?? 'No Subject',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    job.salary != null ? "\$${job.salary}" : 'Negotiable',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: Job Type / Time and Posted Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailChip(Icons.access_time, job.jobType ?? 'Full Time', Colors.blueGrey),
                _buildDetailChip(
                    Icons.calendar_today_outlined,
                    job.postedDate != null
                        ? '${job.postedDate!.toLocal()}'.split(' ')[0]
                        : 'N/A',
                    Colors.grey
                ),
              ],
            ),
            const Divider(height: 25),

            // Description
            Text(
              "Description:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 5),
            Text(
              (job.description ?? 'No description provided.'),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.group_add_outlined, size: 20),
                label: const Text("View Interested Applicants"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (job.id != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ParentJobApplicationPage(
                          jobId: job.id!,
                          token: token,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('❌ This job has no ID.')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Detail Chip Helper ----------------
  Widget _buildDetailChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}