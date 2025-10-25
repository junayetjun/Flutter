
import 'package:ababydaycare/entity/category.dart';
import 'package:ababydaycare/entity/job.dart';
import 'package:ababydaycare/entity/location.dart';
import 'package:ababydaycare/service/category_service.dart';
import 'package:ababydaycare/service/job_service.dart';
import 'package:ababydaycare/service/location_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date

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
  DateTime? _selectedDate;

  List<Location> _locations = [];
  List<Category> _categories = [];

  int? _selectedLocationId;
  int? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _selectedDate = DateTime.now(); // Default to today
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
        SnackBar(content: Text('⚠️ Failed to load data: $e')),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLocationId == null || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both location and category')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final selectedLocation =
      _locations.firstWhere((loc) => loc.id == _selectedLocationId);
      final selectedCategory =
      _categories.firstWhere((cat) => cat.id == _selectedCategoryId);

      final job = Job(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        salary: double.tryParse(_salaryController.text.trim()) ?? 0.0,
        jobType: _jobTypeController.text.trim(),
        postedDate: _selectedDate ?? DateTime.now(),
        location: selectedLocation,
        category: selectedCategory,
      );

      await _jobService.createJob(job);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Job posted successfully!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedLocationId = null;
        _selectedCategoryId = null;
        _jobTypeController.clear();
        _selectedDate = DateTime.now();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to post job: $e')),
      );
    }
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.pinkAccent),
      filled: true,
      fillColor: Colors.pink.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.pinkAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : 'Select Date';

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text('👶 New Enrollment'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.pinkAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Create a Enrollment',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _titleController,
                    decoration: _buildInputDecoration(
                        'Job Title', Icons.toys_outlined),
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter job title'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: _buildInputDecoration(
                        'Description', Icons.description_outlined),
                    maxLines: 3,
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter job description'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _salaryController,
                    decoration: _buildInputDecoration(
                        'Salary', Icons.attach_money_rounded),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Enter salary'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _jobTypeController.text.isNotEmpty
                        ? _jobTypeController.text
                        : null,
                    decoration: _buildInputDecoration(
                        'Service Type', Icons.child_care),
                    items: const [
                      DropdownMenuItem(
                          value: 'Daylong-Care',
                          child: Text('Daylong Care')),
                      DropdownMenuItem(
                          value: 'Part-Day-Care',
                          child: Text('Part-Day Care')),
                      DropdownMenuItem(
                          value: 'Others', child: Text('Others')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _jobTypeController.text = value ?? '';
                      });
                    },
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? 'Please select a service type'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    value: _selectedLocationId,
                    decoration: _buildInputDecoration(
                        'Location', Icons.location_on),
                    items: _locations
                        .map((loc) => DropdownMenuItem<int>(
                      value: loc.id,
                      child: Text(loc.name),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedLocationId = value),
                    validator: (value) =>
                    value == null ? 'Select a location' : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    decoration: _buildInputDecoration(
                        'Category', Icons.category),
                    items: _categories
                        .map((cat) => DropdownMenuItem<int>(
                      value: cat.id,
                      child: Text(cat.name),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCategoryId = value),
                    validator: (value) =>
                    value == null ? 'Select a category' : null,
                  ),
                  const SizedBox(height: 14),
                  // Date Picker
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: _buildInputDecoration(
                          'Posted Date', Icons.date_range),
                      child: Text(dateText),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.send_rounded,
                          color: Colors.white),
                      onPressed: _isLoading ? null : _submitJob,
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          'Post Job',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
