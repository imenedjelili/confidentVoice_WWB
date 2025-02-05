

class User {
  final int id;
  final String email;
  final String birthDate;
  final String gender;
  final String password;
  final String fullName;
  final String createdAt;

  const User({
    required this.id,
    required this.email,
    required this.birthDate,
    required this.gender,
    required this.password,
    required this.fullName,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      email: map['email'] as String,
      birthDate: map['birth_date'] as String,
      gender: map['gender'] as String,
      password: map['password'] as String,
      fullName: map['full_name'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'birth_date': birthDate,
      'gender': gender,
      'password': password,
      'full_name': fullName,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, birthDate: $birthDate, gender: $gender, password: $password, fullName: $fullName, createdAt: $createdAt}';
  }
}
