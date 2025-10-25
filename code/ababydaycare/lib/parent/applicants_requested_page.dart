import 'package:ababydaycare/DTO/apply_dto.dart';
import 'package:flutter/material.dart';
import '../service/apply_service.dart';

class ParentJobApplicationPage extends StatefulWidget {
  final int jobId;
  final String token; // 🔐 Required for the API call

  const ParentJobApplicationPage({
    Key? key,
    required this.jobId,
    required this.token,
  }) : super(key: key);

  @override
  State<ParentJobApplicationPage> createState() => _ParentJobApplicationPageState();
}

class _ParentJobApplicationPageState extends State<ParentJobApplicationPage> {
  List<ApplyDTO> applications = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchApplications();
  }

  void fetchApplications() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // ✅ Call with token
      final result = await ApplyService().getApplicationsForJob(widget.jobId, widget.token);
      setState(() {
        applications = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = '❌ Failed to load applications';
        isLoading = false;
      });
      print(e);
    }
  }

  void viewDetails(int caregiverId) {
    Navigator.pushNamed(context, '/cdetails/$caregiverId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👥 Interested"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.blue.shade50,
        child: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent),
        )
            : errorMessage != null
            ? Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        )
            : applications.isEmpty
            ? const Center(
          child: Text("🚫 No applicants found for this job."),
        )
            : ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final app = applications[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(app.caregiverName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Job: ${app.jobTitle}"),
                    Text("Parent: ${app.parentName}"),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => viewDetails(app.caregiverId),
              ),
            );
          },
        ),
      ),
    );
  }
}
