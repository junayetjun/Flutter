


class Language {
  int? id;
  String? name;
  String? proficiency;

  Language({this.id, this.name, this.proficiency});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    proficiency = json['proficiency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['proficiency'] = this.proficiency;
    return data;
  }
}