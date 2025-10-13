


import 'package:dreamjob/entity/job_dto.dart';
import 'package:flutter/material.dart';

import '../service/job_service.dart'; // Adjust this path

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final JobService _jobService = JobService(); // Inject service manually
  List<JobDTO> _jobs = [];
  bool _loading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchMyJobs();
  }

  Future<void> _fetchMyJobs() async {
    try {
      final data = await _jobService.getMyJobs();
      setState(() {
        _jobs = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Failed to load jobs.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Job Posts'),
        backgroundColor: Colors.indigo,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMsg != null
          ? Center(child: Text(_errorMsg!, style: const TextStyle(color: Colors.red)))
          : _jobs.isEmpty
          ? const Center(child: Text('No jobs found.'))
          : ListView.builder(
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.work_outline, color: Colors.indigo),
              title: Text(job.title),
              subtitle: Text(job.description),
              trailing: Text('\$${job.salary.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}
