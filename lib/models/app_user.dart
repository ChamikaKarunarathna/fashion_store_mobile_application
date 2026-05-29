import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String fullName;
  final String? photoUrl;
  final String? phone;
  final String? address;
  final String? city;
  final String? zip;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.photoUrl,
    this.phone,
    this.address,
    this.city,
    this.zip,
    this.createdAt,
    this.updatedAt,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      id: doc.id,
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      phone: data['phone'],
      address: data['address'],
      city: data['city'],
      zip: data['zip'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'phone': phone,
      'address': address,
      'city': city,
      'zip': zip,
      'updatedAt': FieldValue.serverTimestamp(),
      // We don't overwrite createdAt in toMap to avoid resetting it
    };
  }
}
