import 'package:flutter/material.dart';
import 'package:dreamjob/entity/category.dart';
import 'package:dreamjob/entity/location.dart';
import 'package:dreamjob/service/category_service.dart';
import 'package:dreamjob/service/location_service.dart';
import 'package:dreamjob/service/job_service.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitted = false;

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _postedDateController = TextEditingController();

  // Dropdown selections
  Location? _selectedLocation;
  Category? _selectedCategory;
  String? _selectedJobType;

  String? successMessage;
  String? errorMessage;

  // Data lists
  List<Location> _locations = [];
  List<Category> _categories = [];
  bool _isLoadingData = true;

  // Services
  final LocationService _locationService = LocationService();
  final CategoryService _categoryService = CategoryService();
  final JobService _jobService = JobService();

  @override
  void initState() {
    super.initState();
    _loadLocationsAndCategories();
  }

  Future<void> _loadLocationsAndCategories() async {
    try {
      final locs = await _locationService.getAllLocations();
      final cats = await _categoryService.fetchCategories();
      setState(() {
        _locations = locs;
        _categories = cats;
        _isLoadingData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingData = false;
        errorMessage = 'Failed to load support data: $e';
      });
    }
  }

  void _submit() {
    setState(() {
      _isSubmitted = true;
      successMessage = null;
      errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final formValue = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'salary': double.tryParse(_salaryController.text) ?? 0.0,
      'jobType': _selectedJobType,
      'postedDate': _postedDateController.text,
      'location': {'id': _selectedLocation?.id},
      'category': {'id': _selectedCategory?.id},
    };

    _jobService.createJob(formValue).then((res) {
      setState(() {
        successMessage = 'Job posted successfully!';
        errorMessage = null;
        _isSubmitted = false;
      });
      _formKey.currentState!.reset();
      // Clear controllers and selections
      _titleController.clear();
      _descriptionController.clear();
      _salaryController.clear();
      _postedDateController.clear();
      _selectedLocation = null;
      _selectedCategory = null;
      _selectedJobType = null;
    }).catchError((err) {
      setState(() {
        successMessage = null;
        errorMessage = 'Failed to post job: $err';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
      ),
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create New Job',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                    validator: (value) {
                      if (_isSubmitted && (value == null || value.isEmpty)) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),

                  // Description
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                    validator: (value) {
                      if (_isSubmitted && (value == null || value.isEmpty)) {
                        return 'Description is required';
                      }
                      return null;
                    },
                  ),

                  // Salary
                  _buildTextField(
                    controller: _salaryController,
                    label: 'Salary',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (!_isSubmitted) return null;
                      final num? val = num.tryParse(value ?? '');
                      if (val == null || val < 0) {
                        return 'Salary must be positive';
                      }
                      return null;
                    },
                  ),

                  // Job Type dropdown
                  _buildJobTypeDropdown(),

                  // Posted Date
                  _buildTextField(
                    controller: _postedDateController,
                    label: 'Posted Date',
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        _postedDateController.text = picked.toIso8601String()
                            .split('T')
                            .first;
                      }
                    },
                    validator: (value) {
                      if (_isSubmitted && (value == null || value.isEmpty)) {
                        return 'Posted Date is required';
                      }
                      return null;
                    },
                  ),

                  // Location dropdown
                  _buildLocationDropdown(),

                  // Category dropdown
                  _buildCategoryDropdown(),

                  const SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (successMessage != null)
                    _buildAlert(successMessage!, Colors.green),
                  if (errorMessage != null)
                    _buildAlert(errorMessage!, Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<Location>(
        decoration: const InputDecoration(
          labelText: 'Location',
          border: OutlineInputBorder(),
        ),
        value: _selectedLocation,
        items: _locations
            .map((loc) => DropdownMenuItem<Location>(
            value: loc, child: Text(loc.name)))
            .toList(),
        onChanged: (loc) {
          setState(() {
            _selectedLocation = loc;
          });
        },
        validator: (value) {
          if (_isSubmitted && value == null) {
            return 'Please pick a location';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<Category>(
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        value: _selectedCategory,
        items: _categories
            .map((cat) =>
            DropdownMenuItem<Category>(value: cat, child: Text(cat.name)))
            .toList(),
        onChanged: (cat) {
          setState(() {
            _selectedCategory = cat;
          });
        },
        validator: (value) {
          if (_isSubmitted && value == null) {
            return 'Please pick a category';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildJobTypeDropdown() {
    const jobTypes = [
      'Daylong-Care',
      'Part-Day-Care',
      'Others',
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Job Type',
          border: OutlineInputBorder(),
        ),
        value: _selectedJobType,
        items: jobTypes
            .map((jt) => DropdownMenuItem<String>(value: jt, child: Text(jt)))
            .toList(),
        onChanged: (val) {
          setState(() {
            _selectedJobType = val;
          });
        },
        validator: (value) {
          if (_isSubmitted && (value == null || value.isEmpty)) {
            return 'Job Type is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: onTap != null,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildAlert(String message, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
