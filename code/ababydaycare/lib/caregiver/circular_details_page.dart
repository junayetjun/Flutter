import 'package:ababydaycare/DTO/job_dto.dart';
import 'package:ababydaycare/service/apply_service.dart';
import 'package:ababydaycare/service/auth_service.dart';
import 'package:ababydaycare/service/job_service.dart';
import 'package:flutter/material.dart';

// ------------------------------------------------------
// --- THEME CONSTANTS (Sky Blue & Coral Pink) ---
// ------------------------------------------------------
const Color kPrimaryColor = Color(0xFF5D9CEC);
const Color kAccentColor = Color(0xFFFF8C94);
const Color kBackgroundLight = Color(0xFFF7F9FC);
const Color kTextDark = Color(0xFF2C3E50);
const Color kCardBackground = Colors.white;

class JobDetailsPage extends StatefulWidget {
  final int jobId;

  const JobDetailsPage({Key? key, required this.jobId}) : super(key: key);

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  JobDTO? job;
  final JobService _jobService = JobService();
  final ApplyService _applyService = ApplyService();
  final AuthService _authService = AuthService();

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJob();
  }

  Future<void> _fetchJob() async {
    try {
      final fetchedJob = await _jobService.getJobById(widget.jobId);
      setState(() {
        job = fetchedJob;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load job details.';
        isLoading = false;
      });
      debugPrint('❌ Error fetching job: $e');
    }
  }

  Future<void> _applyJob(int jobId, int parentId) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        _showDialog('Login Required', 'Please log in to apply for this job.');
        return;
      }

      final applyPayload = {
        "job": {"id": jobId},
        "parent": {"id": parentId}
      };

      final result = await _applyService.createApplication(applyPayload, token);
      debugPrint('✅ Application successful: ${result.toJson()}');
      _showDialog('Application Successful', 'You have successfully applied!');
    } catch (e) {
      debugPrint('❌ Application failed: $e');
      _showDialog('Application Failed', 'Something went wrong. Please try again.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: kPrimaryColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kPrimaryColor)),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(errorMessage!,
              style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(job?.title ?? 'Details about Announcement'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: kTextDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEBF5FC), Color(0xFFFDF0F2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 90, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Profile Image ---
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage: (job?.photo != null && job!.photo!.isNotEmpty)
                        ? NetworkImage('http://localhost:8085/images/parent/${job!.photo!}')
                        : const AssetImage('http://localhost:8085/images/parent/') as ImageProvider,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- Job Title & Info ---
              Center(
                child: Text(
                  job?.title ?? 'Job Title',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: kTextDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  job?.location?.name ?? 'Unknown Location',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),


              const SizedBox(height: 24),

              // --- Job Details Card ---
              _buildInfoCard(
                title: "Circular Description",
                content: job?.description ?? 'No description provided.',
                icon: Icons.description_rounded,
              ),
              const SizedBox(height: 16),

              // --- Salary & Type ---
              Row(
                children: [
                  Expanded(
                    child: _buildMiniInfoCard(
                      icon: Icons.payments_rounded,
                      label: "Salary",
                      value: job?.salary != null
                          ? "\$${job!.salary!.toStringAsFixed(2)}"
                          : "Negotiable",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMiniInfoCard(
                      icon: Icons.access_time_rounded,
                      label: "Type",
                      value: job?.jobType ?? "Flexible",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Employer Info ---
              _buildInfoCard(
                title: "Parent Information",
                icon: Icons.person_rounded,
                contentWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEmployerRow("Parent", job?.parentName),
                    _buildEmployerRow("Contact", job?.contactPerson),
                    _buildEmployerRow("Email", job?.email),
                    _buildEmployerRow("Phone", job?.phone),
                    _buildEmployerRow("Child", job?.childName),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- Apply Button ---
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (job?.id != null && job?.parentId != null) {
                      _applyJob(job!.id, job!.parentId!);
                    } else {
                      _showDialog('Invalid Job', 'Job or Parent ID is missing.');
                    }
                  },
                  icon: const Icon(Icons.send_rounded, color: Colors.white),
                  label: const Text(
                    "I am Interested",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: kPrimaryColor.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // --- Reusable UI Widgets ---
  // ------------------------------------------------------

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    String? content,
    Widget? contentWidget,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: kAccentColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kTextDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (contentWidget != null)
            contentWidget
          else
            Text(
              content ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
            ),
        ],
      ),
    );
  }

  Widget _buildMiniInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kAccentColor, size: 28),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(fontWeight: FontWeight.bold, color: kTextDark)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildEmployerRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600, color: kTextDark)),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
