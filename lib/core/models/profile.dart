import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String id;
  final String name;
  final String mobile;
  final double walletAmount;
  final List<String> areas;
  final List<String> pendingAreas;
  final List<String> rejectedAreas;
  Profile({
    required this.id,
    required this.name,
    required this.mobile,
    required this.areas,
    required this.walletAmount,
    required this.pendingAreas,
    required this.rejectedAreas,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? mobile,
    List<String>? areas,
    List<String>? pendingAreas,
    List<String>? rejectedAreas,
    double? walletAmount,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      areas: areas ?? this.areas,
      walletAmount: walletAmount ?? this.walletAmount,
      pendingAreas: pendingAreas ?? this.pendingAreas,
      rejectedAreas: rejectedAreas ?? this.rejectedAreas,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'areas': areas,
      'walletAmount': walletAmount,
      'pendingAreas': pendingAreas,
      'rejectedAreas': rejectedAreas,
    };
  }

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Profile(
      id: doc.id,
      name: map['name'],
      mobile: map['mobile'],
      areas: List<String>.from(map['areas']),
      walletAmount: map['walletAmount'].toDouble(),
      pendingAreas: List<String>.from(map['pendingAreas']),
      rejectedAreas: List<String>.from(map['rejectedAreas']),
    );
  }

  factory Profile.empty() {
    return Profile(
      id: '',
      name: '',
      mobile: '',
      areas: [],
      walletAmount: 0,
      pendingAreas: [],
      rejectedAreas: [],
    );
  }
}
