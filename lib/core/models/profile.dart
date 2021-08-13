
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String id;
  final String name;
  final String mobile;
  final double walletAmount;
  final List<String> areas;

  Profile({
    required this.id,
    required this.name,
    required this.mobile,
    required this.areas,
    required this.walletAmount,
  });
  
  
  

  Profile copyWith({
    String? id,
    String? name,
    String? mobile,
    List<String>? areas,
    double? walletAmount
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      areas: areas ?? this.areas,
      walletAmount: walletAmount??this.walletAmount
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile': mobile,
      'areas': areas,
      'walletAmount':walletAmount
    };
  }

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return Profile(
      id: doc.id,
      name: map['name'],
      mobile: map['mobile'],
      areas: List<String>.from(map['areas']),
      walletAmount: map['walletAmount'],
    );
  }

  factory Profile.empty() {
    return Profile(
      id: '',
      name: '',
      mobile: '',
      areas: [],
      walletAmount: 0,
    );
  }
}
