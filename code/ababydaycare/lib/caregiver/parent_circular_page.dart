
import 'package:ababydaycare/DTO/job_dto.dart';
import 'package:ababydaycare/caregiver/caregiver_profile.dart';
import 'package:ababydaycare/caregiver/circular_details_page.dart';
import 'package:ababydaycare/entity/category.dart';
import 'package:ababydaycare/entity/location.dart';
import 'package:ababydaycare/service/category_service.dart';
import 'package:ababydaycare/service/job_service.dart';
import 'package:ababydaycare/service/location_service.dart';
import 'package:flutter/material.dart';

// ====================================================================
// --- SKY BLUE & BABY PINK THEME CONSTANTS ---
const Color primaryColor = Color(0xFF87CEEB);
const Color primaryLight = Color(0xFFE0F7FA);
const Color primaryDark = Color(0xFF0077B6);
const Color accentColor = Color(0xFFFFB6C1);
const Color accentLight = Color(0xFFFDE4E6);
const Color backgroundColor = Color(0xFFFAFAFA);

const double kPadding = 16.0;
const double kBorderRadius = 12.0;
// ====================================================================

class CaregiverHome extends StatefulWidget {
  final Map<String, dynamic> profile;

  const CaregiverHome({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  State<CaregiverHome> createState() => _CaregiverHomeState();
}

class _CaregiverHomeState extends State<CaregiverHome> {
  final JobService _jobService = JobService();
  final LocationService _locationService = LocationService();
  final CategoryService _categoryService = CategoryService();

  List<JobDTO> _jobs = [];
  List<Location> _locations = [];
  List<Category> _categories = [];

  // FIX 1: State variable to hold the current Caregiver's profile data
  Map<String, dynamic>? _caregiverProfileMap;

  int? _selectedLocationId;
  int? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final fetchedJobs = await _jobService.getAllJobs();
      final fetchedLocations = await _locationService.getAllLocations();
      final fetchedCategories = await _categoryService.getAllCategories();

      // FIX 2: Fetch the current caregiver's profile (You need to implement this service call)
      // Assuming you have a service method to get the current user's profile map:
      // final profileData = await _jobService.getCurrentCaregiverProfile();
      // Replace the line below with the actual service call:
      final profileData = {'name': 'Current Caregiver', 'user': {'email': 'test@example.com'}};


      if (mounted) {
        setState(() {
          _jobs = fetchedJobs;
          _locations = fetchedLocations;
          _categories = fetchedCategories;
          // Assign the fetched profile map
          _caregiverProfileMap = profileData;
        });
      }
    } catch (e) {
      debugPrint('Initialization error: $e');
      if (mounted) {
        _showSnackBar('Failed to load initial data. Please try again.', const Color(0xFFE57373));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _filterJobs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final filtered = await _jobService.searchJobs(
        categoryId: _selectedCategoryId,
        locationId: _selectedLocationId,
      );
      if (mounted) setState(() => _jobs = filtered);
    } catch (e) {
      debugPrint('Filter error: $e');
      if (mounted) {
        _showSnackBar('An error occurred while filtering jobs.', const Color(0xFFE57373));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, [Color? color]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color ?? accentColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHeaderAndFilter() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kBorderRadius * 2),
          bottomRight: Radius.circular(kBorderRadius * 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x10000000),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(kPadding, MediaQuery.of(context).padding.top + 20, kPadding, kPadding * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button + Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: primaryDark),
                onPressed: () {
                  // Since CaregiverProfile navigated here using pushReplacement,
                  // we must use pushReplacement again to go back without stack issues.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      // Use the profile map passed to this widget
                      builder: (context) => CaregiverProfile(profile: widget.profile),
                    ),
                  );
                },
              ),
              const Text(
                "Welcome Home! 🏡",
                style: TextStyle(
                    color: primaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 48), // Placeholder for alignment
            ],
          ),

          const SizedBox(height: 4),
          const Text(
            "Find Your Trusted Customer",
            style: TextStyle(
                color: Colors.black87,
                fontSize: 26,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Filter Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildCategoryDropdown(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildLocationDropdown(),
                ),
              ),
              SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  onPressed: _filterJobs,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    padding: const EdgeInsets.all(0),
                    elevation: 5,
                  ),
                  child: const Icon(Icons.search_rounded),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String labelText,
    required List<DropdownMenuItem<int?>> items,
    required Function(int?) onChanged,
    required int? value,
  }) {
    return DropdownButtonFormField<int?>(
      value: value,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: primaryColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: primaryDark),
        filled: true,
        fillColor: primaryLight.withOpacity(0.5),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  Widget _buildCategoryDropdown() {
    return _buildDropdown(
      labelText: "Category",
      value: _selectedCategoryId,
      items: [
        const DropdownMenuItem<int?>(value: null, child: Text("All Services", style: TextStyle(color: Colors.grey))),
        ..._categories.map((cat) => DropdownMenuItem<int?>(
          value: cat.id,
          child: Text(cat.name, overflow: TextOverflow.ellipsis),
        )),
      ],
      onChanged: (value) => setState(() => _selectedCategoryId = value),
    );
  }

  Widget _buildLocationDropdown() {
    return _buildDropdown(
      labelText: "Location",
      value: _selectedLocationId,
      items: [
        const DropdownMenuItem<int?>(value: null, child: Text("All Areas", style: TextStyle(color: Colors.grey))),
        ..._locations.map((loc) => DropdownMenuItem<int?>(
          value: loc.id,
          child: Text(loc.name, overflow: TextOverflow.ellipsis),
        )),
      ],
      onChanged: (value) => setState(() => _selectedLocationId = value),
    );
  }

  Widget _buildJobListing() {
    if (_jobs.isEmpty && !_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_busy_rounded, size: 60, color: accentColor),
              const SizedBox(height: 10),
              const Text("Oops! No matches found.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text("Try adjusting your filters or search a broader area.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(kPadding),
      itemCount: _jobs.length,
      itemBuilder: (context, index) => _buildJobCard(_jobs[index]),
    );
  }

  Widget _buildJobCard(JobDTO job) {
    return Card(
      margin: const EdgeInsets.only(bottom: kPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius)),
      color: Colors.white,
      elevation: 6,
      child: InkWell(
        onTap: () {
          debugPrint('Tapped on ${job.title}');
        },
        borderRadius: BorderRadius.circular(kBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        // NOTE: Ensure your backend path is correct, this looks like a Parent image URL
                        'http://localhost:8085/images/parent/${job.photo ?? ''}',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: primaryLight,
                            child: const Icon(Icons.person_rounded, size: 40, color: primaryDark),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: kPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title ?? 'Caregiver Position',
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: primaryDark),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.location_on_rounded, job.location?.name ?? 'Unknown Location', accentColor),
                        _buildInfoRow(Icons.access_time_filled, job.jobType ?? 'Flexible', Colors.grey.shade600),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border_rounded, color: accentColor, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
              const Divider(height: 25, thickness: 1, color: primaryLight),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: accentLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      job.salary != null ? "\$${job.salary!.toStringAsFixed(2)}/hr" : 'Negotiable',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: accentColor),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (job.id != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsPage(jobId: job.id!),
                          ),
                        );
                      } else {
                        _showSnackBar("Job ID not available.", Colors.orange);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 3,
                    ),
                    child: const Text("View Profile"),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: RefreshIndicator(
        onRefresh: _initializeData,
        color: primaryColor,
        child: Column(
          children: [
            _buildHeaderAndFilter(),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryColor))
                  : _buildJobListing(),
            ),
          ],
        ),
      ),
    );
  }
}