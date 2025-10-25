import 'package:flutter/material.dart';
import '../entity/location.dart';
import '../service/location_service.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({Key? key}) : super(key: key);

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final LocationService _locationService = LocationService();

  List<Location> _locations = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    try {
      final locations = await _locationService.getAllLocations();
      setState(() => _locations = locations);
    } catch (e) {
      _showError('Failed to fetch locations: $e');
    }
  }

  Future<void> _addLocation() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      try {
        // The service should handle ID assignment and return a complete Location.
        final newLocation = await _locationService.createLocation(
          _nameController.text.trim(),
        );

        setState(() {
          _locations.add(newLocation);
          _nameController.clear();
        });

        _showMessage('Location added successfully');
      } catch (e) {
        _showError('Failed to add location: $e');
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _deleteLocation(int id) async {
    try {
      await _locationService.deleteLocation(id);
      setState(() {
        _locations.removeWhere((loc) => loc.id == id);
      });
      _showMessage('Location deleted');
    } catch (e) {
      _showError('Failed to delete location: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Add Locations'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Form Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Location Name',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.place_outlined),
                        ),
                        validator: (value) =>
                        value == null || value.trim().isEmpty
                            ? 'Please enter a location name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _addLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _loading
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'Add Location',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Locations List Section
            Expanded(
              child: _locations.isEmpty
                  ? const Center(
                child: Text(
                  'No locations added yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.separated(
                itemCount: _locations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final loc = _locations[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: const Icon(Icons.location_on_outlined, color: Colors.indigo),
                      title: Text(loc.name),
                      subtitle: Text('ID: ${loc.id}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          _deleteLocation(loc.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
