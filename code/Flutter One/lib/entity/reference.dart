

class Reference {
  int? id;
  String? name;
  String? contact;
  String? relation;

  Reference({this.id, this.name, this.contact, this.relation});

  Reference.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    relation = json['relation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['relation'] = this.relation;
    return data;
  }
}
