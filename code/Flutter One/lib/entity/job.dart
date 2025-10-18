import 'package:dreamjob/entity/category.dart';
import 'package:dreamjob/entity/location.dart';

class Job {
  final String title;
  final String description;
  final double salary;
  final String jobType;
  final DateTime postedDate;
  final Category? category;
  final Location? location;

  Job({
    required this.title,
    required this.description,
    required this.salary,
    required this.jobType,
    required this.postedDate,
    this.category,
    this.location,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'],
      description: json['description'],
      salary: (json['salary'] as num).toDouble(),
      jobType: json['jobType'],
      postedDate: DateTime.parse(json['postedDate']),
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      location: json['location'] != null ? Location.fromJson(json['location']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'salary': salary,
      'jobType': jobType,
      'postedDate': postedDate.toIso8601String(),
      if (category != null) 'category': category!.toJson(),
      if (location != null) 'location': location!.toJson(),
    };
  }
}
