

import 'package:ababydaycare/entity/category.dart';
import 'package:ababydaycare/entity/location.dart';

class JobDTO {
  final int id;
  final String? title;
  final String? description;
  final double? salary;
  final String? jobType;
  final DateTime? postedDate;

  final Category? category;
  final Location? location;

  // Parent Info
  final int? parentId;
  final String? parentName;
  final String? contactPerson;
  final String? email;
  final String? phone;
  final String? childName;
  final String? photo;

  JobDTO({
    required this.id,
    this.title,
    this.description,
    this.salary,
    this.jobType,
    this.postedDate,
    this.category,
    this.location,
    this.parentId,
    this.parentName,
    this.contactPerson,
    this.email,
    this.phone,
    this.childName,
    this.photo,
  });

  factory JobDTO.fromJson(Map<String, dynamic> json) {
    Location? parsedLocation;

    final loc = json['location'];
    if (loc != null) {
      if (loc is Map<String, dynamic>) {
        parsedLocation = Location(
          id: loc['id'] ?? 0,
          name: loc['name'] ?? loc['city'] ?? '', // supports both "name" or "city"
        );
      } else if (loc is String) {
        parsedLocation = Location(id: 0, name: loc);
      } else if (loc is int) {
        parsedLocation = Location(id: loc, name: '');
      }
    }

    return JobDTO(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      salary: json['salary'] != null ? (json['salary'] as num).toDouble() : null,
      jobType: json['jobType'],
      postedDate: json['postedDate'] != null ? DateTime.parse(json['postedDate']) : null,
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      location: parsedLocation,
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
      'postedDate': postedDate?.toIso8601String(),
      'category': category?.toJson(),
      'location': location?.toJson(),
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
