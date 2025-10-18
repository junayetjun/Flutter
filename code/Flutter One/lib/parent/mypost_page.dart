import 'package:dreamjob/entity/job_dto.dart';
import 'package:dreamjob/service/job_service.dart';
import 'package:flutter/material.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  late Future<List<JobDTO>> _futureJobs;

  @override
  void initState() {
    super.initState();
    _futureJobs = JobService().getMyJobs(); // Fetch jobs using JobDTO service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📋 My Job Posts"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: FutureBuilder<List<JobDTO>>(
        future: _futureJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '⚠️ Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
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
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      job.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(job.location?.name ?? 'Unknown'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(job.salary.toString()),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${job.postedDate.toLocal()}'.split(' ')[0]),
                          ],
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to detailed page if needed
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
