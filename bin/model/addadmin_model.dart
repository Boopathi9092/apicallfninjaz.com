class AddAdmineData {
  String? name;
  String? password;
  List<Datas>? datas;

  AddAdmineData({this.name, this.password, this.datas});

  AddAdmineData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    password = json['password'];
    if (json['datas'] != null) {
      datas = <Datas>[];
      json['datas'].forEach((v) {
        datas!.add(new Datas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['password'] = this.password;
    if (this.datas != null) {
      data['datas'] = this.datas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Datas {
  String? name;
  String? age;
  String? email;

  Datas({this.name, this.age, this.email});

  Datas.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['email'] = this.email;
    return data;
  }
}
