class AppUser {
  final String id;
  final String email;
  final String name;
  final String role; // 'manager' or 'worker'

  AppUser({required this.id, required this.email, required this.name, required this.role});

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'role': role,
      };

  factory AppUser.fromMap(String id, Map<String, dynamic> m) => AppUser(
        id: id,
        email: (m['email'] ?? '') as String,
        name: (m['name'] ?? (m['email'] ?? '')) as String,
        role: (m['role'] ?? 'worker') as String,
      );
}
