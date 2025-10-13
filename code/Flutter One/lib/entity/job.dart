
class Job {
  final int id;
  final String title;
  final String description;
  final String location;
  final double salary;
  final String jobType;
  final DateTime postedDate;

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.postedDate,
  });

  // Factory constructor to create a Job from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      salary: (json['salary'] as num).toDouble(),
      jobType: json['jobType'],
      postedDate: DateTime.parse(json['postedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['location'] = location;
    data['salary'] = salary;
    data['jobType'] = jobType;
    data['postedDate'] = postedDate.toIso8601String();
    return data;
  }

}
