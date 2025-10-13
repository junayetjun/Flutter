

class Experience {
  int? id;
  String? company;
  String? position;
  String? fromDate;
  String? toDate;
  String? description;

  Experience(
      {this.id,
        this.company,
        this.position,
        this.fromDate,
        this.toDate,
        this.description});

  Experience.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    company = json['company'];
    position = json['position'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company'] = this.company;
    data['position'] = this.position;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['description'] = this.description;
    return data;
  }
}