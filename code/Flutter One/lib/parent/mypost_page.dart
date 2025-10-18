import 'package:dreamjob/entity/job.dart';
import 'package:dreamjob/parent/parent_job_application_page.dart';
import 'package:dreamjob/service/authservice.dart';
import 'package:dreamjob/service/job_service.dart';
import 'package:flutter/material.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  late Future<List<Job>> _futureJobs;
  String? _token; // store token here
  bool _loadingToken = true;

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
      // handle no token found (not logged in)
      setState(() {
        _loadingToken = false;
      });
      // optionally redirect to login or show error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingToken) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_token == null) {
      return Scaffold(
        body: Center(
          child: Text(
            '❌ No valid auth token found. Please login.',
            style: TextStyle(fontSize: 16, color: Colors.red.shade700),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text("📋 Appointments Requests"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Job>>(
          future: _futureJobs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.pinkAccent),
                  SizedBox(height: 16),
                  Text("Loading your jobs...", style: TextStyle(fontSize: 16)),
                ],
              );
            } else if (snapshot.hasError) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '⚠️ Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  '🚫 You have not posted any jobs yet.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            } else {
              final jobs = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "📋 Appointments Requests",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Total: ${jobs.length}",
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Subject")),
                          DataColumn(label: Text("Time")),
                          DataColumn(label: Text("Remuneration")),
                          DataColumn(label: Text("Description")),
                          DataColumn(label: Text("Posted Date")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: jobs.map((job) {
                          return DataRow(
                            cells: [
                              DataCell(Text(job.title)),
                              DataCell(Text(job.jobType ?? 'N/A')),
                              DataCell(Text("\$${job.salary}")),
                              DataCell(Text(
                                job.description.length > 60
                                    ? "${job.description.substring(0, 60)}..."
                                    : job.description,
                              )),
                              DataCell(Text(
                                '${job.postedDate.toLocal()}'.split(' ')[0],
                              )),
                              DataCell(
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.group),
                                      label: const Text("Interested"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.pinkAccent,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        textStyle:
                                        const TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () {
                                        if (job.id != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ParentJobApplicationPage(
                                                    jobId: job.id!,
                                                    token: _token!, // use loaded token here
                                                  ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  '❌ This job has no ID.'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
