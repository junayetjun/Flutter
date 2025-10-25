

import 'package:ababydaycare/entity/education.dart';
import 'package:ababydaycare/entity/experience.dart';
import 'package:ababydaycare/entity/hobby.dart';
import 'package:ababydaycare/entity/language.dart';
import 'package:ababydaycare/entity/reference.dart';
import 'package:ababydaycare/entity/skill.dart';
import 'package:ababydaycare/entity/user.dart';

class Caregiver {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String address;
  final String dateOfBirth;
  final String photo;
  final User user;
  final List<Education> educations;
  final List<Reference> references;
  final List<Experience> experiences;
  final List<Hobby> hobbies;
  final List<Language> languages;
  final List<Skill> skills;


  Caregiver({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.address,
    required this.dateOfBirth,
    required this.photo,
    required this.user,
    required this.educations,
    required this.references,
    required this.experiences,
    required this.hobbies,
    required this.languages,
    required this.skills,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: json['dateOfBirth'] ?? '',
      photo: json['photo'] ?? '',
      user: User.fromJson(json['user']),
      educations: (json['educations'] as List?)?.map((e) => Education.fromJson(e)).toList() ?? [],
      references: (json['references'] as List?)?.map((e) => Reference.fromJson(e)).toList() ?? [],
      experiences: (json['experiences'] as List?)?.map((e) => Experience.fromJson(e)).toList() ?? [],
      hobbies: (json['hobbies'] as List?)?.map((e) => Hobby.fromJson(e)).toList() ?? [],
      languages: (json['languages'] as List?)?.map((e) => Language.fromJson(e)).toList() ?? [],
      skills: (json['skills'] as List?)?.map((e) => Skill.fromJson(e)).toList() ?? [],
    );
  }
}