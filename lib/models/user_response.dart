class User {
  final String email;
  final String name;
  final String uid;
  final String? phone;
  final String? dob;
  final String? subscriptionPlan;
  final bool active;

  User({
    required this.email,
    required this.name,
    required this.uid,
    this.phone,
    this.dob,
    this.subscriptionPlan,
    required this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      uid: json['uid'] ?? '',
      phone: json['phone'],
      dob: json['dob'],
      subscriptionPlan: json['subscriptionPlan'],
      active: json['active'] as bool? ?? false,
    );
  }
}