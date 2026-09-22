import '../shared/utils/avatar_helper.dart';
import '../shared/utils/date_formatter.dart';

class NksUserModel {
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? name;
  final String? email;
  final String? phone;
  final int? gender; // 0 | 1
  final String? dob; // yyyy-mm-dd or dd/mm/yyyy
  final String? pob;
  final String? idNumber;
  final String? idDate;
  final String? idPlace;
  final String? cccdFront;
  final String? cccdBack;
  final String? province;
  final String? website;
  final String? intro;
  final String? avatar;

  NksUserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.pob,
    this.idNumber,
    this.idDate,
    this.idPlace,
    this.cccdFront,
    this.cccdBack,
    this.province,
    this.website,
    this.intro,
    this.avatar,
  });

  String get fullName {
    final first = firstname?.trim() ?? '';
    final last = lastname?.trim() ?? '';
    final combined = '$first $last'.trim();
    if (combined.isNotEmpty) return combined;
    if (name != null && name!.trim().isNotEmpty) return name!.trim();
    return email ?? 'Thành viên StudyDeck';
  }

  String get displayDob {
    return DateFormatter.toDisplayDate(dob);
  }

  String get displayCccdDate {
    return DateFormatter.toDisplayDate(idDate);
  }

  String? get formattedAvatarUrl {
    return AvatarHelper.formatUrl(avatar);
  }

  factory NksUserModel.fromJson(Map<String, dynamic> json) {
    int? parseGender(dynamic g) {
      if (g is num) return g.toInt();
      if (g is String) {
        final s = g.trim().toLowerCase();
        if (s == '1' || s == 'female' || s == 'nu' || s == 'nữ') return 1;
        if (s == '0' || s == 'male' || s == 'nam') return 0;
        return int.tryParse(s);
      }
      return null;
    }

    String? parseProvince(dynamic p) {
      if (p is String) return p;
      if (p is Map<String, dynamic>) {
        return (p['name'] as String?) ?? (p['title'] as String?);
      }
      return null;
    }

    final first = json['firstname'] as String? ?? json['first_name'] as String?;
    final last = json['lastname'] as String? ?? json['last_name'] as String?;
    final rawName = json['name'] as String? ?? json['fullname'] as String? ?? json['full_name'] as String?;

    return NksUserModel(
      id: (json['id'] as num?)?.toInt(),
      firstname: first,
      lastname: last,
      name: rawName ?? (first != null || last != null ? '$first $last'.trim() : null),
      email: json['email'] as String?,
      phone: json['phone'] as String? ?? json['phonenumber'] as String? ?? json['mobile'] as String?,
      gender: parseGender(json['gender']),
      dob: json['dob'] as String? ?? json['formatedDob'] as String? ?? json['date_of_birth'] as String? ?? json['birthday'] as String?,
      pob: json['pob'] as String? ?? json['place_of_birth'] as String? ?? json['birthplace'] as String?,
      idNumber: json['id_number'] as String? ?? json['number'] as String? ?? json['cccd_number'] as String? ?? json['id_card'] as String?,
      idDate: json['id_date'] as String? ?? json['formatedCccdDate'] as String? ?? json['cccd_date'] as String? ?? json['date'] as String?,
      idPlace: json['id_place'] as String? ?? json['place'] as String? ?? json['cccd_place'] as String?,
      cccdFront: json['cccd_front'] as String? ?? json['id_front'] as String? ?? json['front'] as String?,
      cccdBack: json['cccd_back'] as String? ?? json['id_back'] as String? ?? json['back'] as String?,
      province: parseProvince(json['province'] ?? json['city']),
      website: json['website'] as String? ?? json['url'] as String? ?? json['link'] as String?,
      intro: json['intro'] as String? ?? json['bio'] as String? ?? json['description'] as String?,
      avatar: json['avatar'] as String? ?? json['avatar_url'] as String? ?? json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'pob': pob,
      'id_number': idNumber,
      'id_date': idDate,
      'id_place': idPlace,
      'cccd_front': cccdFront,
      'cccd_back': cccdBack,
      'province': province,
      'website': website,
      'intro': intro,
      'avatar': avatar,
    };
  }
}
