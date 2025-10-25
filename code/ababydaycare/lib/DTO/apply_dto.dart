

class ApplyDTO {
  final int id;
  final int jobId;
  final String jobTitle;
  final int parentId;
  final String parentName;
  final int caregiverId;
  final String caregiverName;

  ApplyDTO({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.parentId,
    required this.parentName,
    required this.caregiverId,
    required this.caregiverName,
  });

  // From JSON factory
  factory ApplyDTO.fromJson(Map<String, dynamic> json) {
    return ApplyDTO(
      id: json['id'],
      jobId: json['jobId'],
      jobTitle: json['jobTitle'],
      parentId: json['parentId'],
      parentName: json['parentName'],
      caregiverId: json['caregiverId'],
      caregiverName: json['caregiverName'],
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'jobTitle': jobTitle,
      'parentId': parentId,
      'parentName': parentName,
      'caregiverId': caregiverId,
      'caregiverName': caregiverName,
    };
  }
}
