

import 'package:flutter/material.dart';
import 'package:dreamjob/service/job_service.dart';
import 'package:dreamjob/service/category_service.dart';
import 'package:dreamjob/service/location_service.dart';
import 'package:dreamjob/entity/job_dto.dart';
import 'package:dreamjob/entity/category.dart';
import 'package:dreamjob/entity/location.dart';

class CaregiverHome extends StatefulWidget {
  const CaregiverHome({super.key});

  @override
  State<CaregiverHome> createState() => _CaregiverHomeState();
}

class _CaregiverHomeState extends State<CaregiverHome> {
  final JobService _jobService = JobService();
  final CategoryService _categoryService = CategoryService();
  final LocationService _locationService = LocationService();

  List<JobDTO> jobs = [];
  List<Category> categories = [];
  List<Location> locations = [];

  int? selectedCategoryId;
  int? selectedLocationId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final fetchedCategories = await _categoryService.fetchCategories();
      final fetchedLocations = await _locationService.getAllLocations();
      final fetchedJobs = await _jobService.getAllJobs();

      setState(() {
        categories = fetchedCategories;
        locations = fetchedLocations;
        jobs = fetchedJobs;
        isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _filterJobs() async {
    try {
      final filteredJobs = await _jobService.searchJobs(
        categoryId: selectedCategoryId,
        locationId: selectedLocationId,
      );

      setState(() {
        jobs = filteredJobs;
      });
    } catch (e) {
      print('Error filtering jobs: $e');
    }
  }

  Widget _buildDropdowns() {
    return Row(
      children: [
        Expanded(
          child: DropdownButton<int>(
            isExpanded: true,
            hint: const Text("Select Category"),
            value: selectedCategoryId,
            items: categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategoryId = value;
              });
              _filterJobs();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButton<int>(
            isExpanded: true,
            hint: const Text("Select Location"),
            value: selectedLocationId,
            items: locations.map((location) {
              return DropdownMenuItem<int>(
                value: location.id,
                child: Text(location.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedLocationId = value;
              });
              _filterJobs();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobCard(JobDTO job) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(job.photo),
          onBackgroundImageError: (_, __) {},
        ),
        title: Text(job.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.description),
            Text("Salary: \$${job.salary}"),
            Text("Posted on: ${job.postedDate.toLocal().toString().split(' ')[0]}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Job Listings'),
        backgroundColor: Colors.indigo,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _initializeData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDropdowns(),
              const SizedBox(height: 20),
              Expanded(
                child: jobs.isEmpty
                    ? const Center(child: Text("No jobs found"))
                    : ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    return _buildJobCard(jobs[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
