class Pengguna {
  final int id;
  final String namaLengkap;
  final String username;
  final int role;
  final String jabatan;
  final DateTime createdAt;

  Pengguna({
    required this.id,
    required this.username,
    required this.namaLengkap,
    required this.jabatan,
    required this.role,
    required this.createdAt,
  });

  Pengguna.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        username = map['username'] ?? '',
        createdAt = DateTime.tryParse(map['created_at']) ?? DateTime.now(),
        namaLengkap = map['nama_lengkap'] ?? '',
        jabatan = map['jabatan'] ?? '',
        role = map['role'] ?? 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'created_at': createdAt.toIso8601String(),
      'nama_lengkap': namaLengkap,
      'jabatan': jabatan,
      'role': role
    };
  }
}
