

import 'package:flutter/material.dart';
import 'package:dreamjob/entity/job_dto.dart';
import 'package:dreamjob/service/job_service.dart';
import 'package:dreamjob/service/apply_service.dart';
import 'package:dreamjob/service/authservice.dart';

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
      print('❌ Error fetching job: $e');
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
      print('✅ Application successful: ${result.toJson()}');
      _showDialog('Application Successful', 'You have successfully applied!');
    } catch (e) {
      print('❌ Application failed: $e');
      _showDialog('Application Failed', 'Something went wrong. Please try again.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Job Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Job Details')),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(job?.title ?? 'Job Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  job?.photo ?? '',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/default-parent.png',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),

            Text(job?.title ?? '', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(job?.description ?? 'No description', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),

            if (job?.salary != null)
              Text('Salary: \$${job!.salary!.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            if (job?.jobType != null)
              Text('Type: ${job!.jobType}', style: TextStyle(fontSize: 16)),
            if (job?.postedDate != null)
              Text('Posted: ${job!.postedDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(color: Colors.grey)),

            SizedBox(height: 16),

            Divider(),

            Text('Employer Info', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 4),
            Text('Parent: ${job?.parentName ?? 'N/A'}'),
            Text('Contact: ${job?.contactPerson ?? 'N/A'}'),
            Text('Email: ${job?.email ?? 'N/A'}'),
            Text('Phone: ${job?.phone ?? 'N/A'}'),
            Text('Child: ${job?.childName ?? 'N/A'}'),

            SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (job?.id != null && job?.parentId != null) {
                    _applyJob(job!.id, job!.parentId!);
                  } else {
                    _showDialog('Invalid Job', 'Job or Parent ID is missing.');
                  }
                },
                child: Text('Apply'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
