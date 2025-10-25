

import 'package:ababydaycare/entity/category.dart';
import 'package:ababydaycare/entity/location.dart';

class Job {
  int? id;
  String? title;
  String? description;
  double? salary;
  String? jobType;
  DateTime? postedDate;
  Category? category;
  Location? location;

  Job({
    this.id,
    this.title,
    this.description,
    this.salary,
    this.jobType,
    this.postedDate,
    this.category,
    this.location,
  });

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    salary = json['salary'] != null ? (json['salary'] as num).toDouble() : null;
    jobType = json['jobType'];
    postedDate = json['postedDate'] != null ? DateTime.parse(json['postedDate']) : null;
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['salary'] = salary;
    data['jobType'] = jobType;
    data['postedDate'] = postedDate?.toIso8601String();
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}
