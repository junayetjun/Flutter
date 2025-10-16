import 'package:dreamjob/entity/category.dart';
import 'package:dreamjob/entity/job_dto.dart';
import 'package:dreamjob/entity/location.dart';
import 'package:dreamjob/service/category_service.dart';
import 'package:dreamjob/service/job_service.dart';
import 'package:dreamjob/service/location_service.dart';
import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  final JobService _jobService = JobService();
  final LocationService _locationService = LocationService();
  final CategoryService _categoryService = CategoryService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();

  List<Location> _locations = [];
  List<Category> _categories = [];

  int? _selectedLocationId;
  int? _selectedCategoryId;
  bool _isLoading = false;

  // Example required parent info - Replace with actual data source or inputs
  final int yourParentId = 123;
  final String yourParentName = "Parent Company";
  final String yourContactPerson = "John Doe";
  final String yourEmail = "contact@parentcompany.com";
  final String yourPhone = "+1234567890";
  final String yourChildName = "Child Entity";
  final String yourPhotoUrl = "https://example.com/photo.jpg";

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final locations = await _locationService.getAllLocations();
      final categories = await _categoryService.getAllCategories();

      setState(() {
        _locations = locations;
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
    }
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedLocationId == null || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select location and category')),
      );
      return;
    }

    // Get the selected Category and Location objects by ID
    final selectedLocation = _locations.firstWhere((loc) => loc.id == _selectedLocationId);
    final selectedCategory = _categories.firstWhere((cat) => cat.id == _selectedCategoryId);

    final job = JobDTO(
      id: 0, // New job, so id can be 0 or null based on your backend requirements
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      salary: double.tryParse(_salaryController.text) ?? 0.0,
      jobType: _jobTypeController.text.trim(),
      postedDate: DateTime.now(),
      location: selectedLocation,
      category: selectedCategory,
      parentId: yourParentId,
      parentName: yourParentName,
      contactPerson: yourContactPerson,
      email: yourEmail,
      phone: yourPhone,
      childName: yourChildName,
      photo: yourPhotoUrl,
    );

    setState(() => _isLoading = true);
    try {
      await _jobService.createJob(job); // Make sure your JobService accepts JobDTO
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Job posted successfully!')),
      );
      _formKey.currentState!.reset();
      setState(() {
        _selectedLocationId = null;
        _selectedCategoryId = null;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to post job: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a New Job'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) => value!.isEmpty ? 'Enter job title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Enter job description' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salary'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter salary' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jobTypeController,
                decoration: const InputDecoration(labelText: 'Job Type (e.g., Full-time)'),
                validator: (value) => value!.isEmpty ? 'Enter job type' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedLocationId,
                decoration: const InputDecoration(labelText: 'Location'),
                items: _locations
                    .map((loc) => DropdownMenuItem<int>(
                  value: loc.id,
                  child: Text(loc.name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedLocationId = value);
                },
                validator: (value) => value == null ? 'Select location' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((cat) => DropdownMenuItem<int>(
                  value: cat.id,
                  child: Text(cat.name),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategoryId = value);
                },
                validator: (value) => value == null ? 'Select category' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitJob,
                  child: const Text('Post Job'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
