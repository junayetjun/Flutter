import 'package:dreamjob/entity/job_dto.dart';
import 'package:flutter/material.dart';
import 'package:dreamjob/service/job_service.dart';
import 'package:dreamjob/service/category_service.dart';
import 'package:dreamjob/service/location_service.dart';
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
    setState(() => isLoading = true);
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
      debugPrint('Error initializing data: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  Future<void> _filterJobs() async {
    setState(() => isLoading = true);
    try {
      final filteredJobs = await _jobService.searchJobs(
        categoryId: selectedCategoryId,
        locationId: selectedLocationId,
      );

      setState(() {
        jobs = filteredJobs;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error filtering jobs: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to filter jobs: $e')),
      );
    }
  }

  Widget _buildDropdowns() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: const InputDecoration(labelText: "Select Category"),
            value: selectedCategoryId,
            items: categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedCategoryId = value);
              _filterJobs();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<int>(
            isExpanded: true,
            decoration: const InputDecoration(labelText: "Select Location"),
            value: selectedLocationId,
            items: locations.map((location) {
              return DropdownMenuItem<int>(
                value: location.id,
                child: Text(location.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedLocationId = value);
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: ListTile(
        title: Text(
          job.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.description.length > 80
                    ? '${job.description.substring(0, 80)}...'
                    : job.description,
              ),
              const SizedBox(height: 4),
              Text("Salary: \$${job.salary.toStringAsFixed(2)}"),
              Text(
                "Location: ${job.location.name}",
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                "Posted on: ${job.postedDate.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
        onTap: () {
          // TODO: Navigate to job detail page
        },
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
