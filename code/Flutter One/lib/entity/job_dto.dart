

import 'package:dreamjob/entity/category.dart';
import 'package:dreamjob/entity/location.dart';

class JobDTO {
  final int id;
  final String title;
  final String description;
  final double salary;
  final String jobType;
  final DateTime postedDate;

  final Category category;
  final Location location;

  // Parent Info
  final int parentId;
  final String parentName;
  final String contactPerson;
  final String email;
  final String phone;
  final String childName;
  final String photo;

  JobDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.salary,
    required this.jobType,
    required this.postedDate,
    required this.category,
    required this.location,
    required this.parentId,
    required this.parentName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.childName,
    required this.photo,
  });

  factory JobDTO.fromJson(Map<String, dynamic> json) {
    return JobDTO(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      salary: (json['salary'] as num).toDouble(),
      jobType: json['jobType'],
      postedDate: DateTime.parse(json['postedDate']),
      category: Category.fromJson(json['category']),
      location: Location.fromJson(json['location']),
      parentId: json['parentId'],
      parentName: json['parentName'],
      contactPerson: json['contactPerson'],
      email: json['email'],
      phone: json['phone'],
      childName: json['childName'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'salary': salary,
      'jobType': jobType,
      'postedDate': postedDate.toIso8601String(),
      'category': category.toJson(),
      'location': location.toJson(),
      'parentId': parentId,
      'parentName': parentName,
      'contactPerson': contactPerson,
      'email': email,
      'phone': phone,
      'childName': childName,
      'photo': photo,
    };
  }
}
