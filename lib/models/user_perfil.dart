class UserProfile {
  final String uid;
  final String email;
  final String? name;
  final String? photoURL;

  // Dirección
  final String? postal;
  final String? address;
  final String? city;
  final String? state;
  final String? country;

  // Banco
  final String? bankAccountNumber;
  final String? accountHolder;
  final String? swift;

  UserProfile({
    required this.uid,
    required this.email,
    this.name,
    this.photoURL,
    this.postal,
    this.address,
    this.city,
    this.state,
    this.country,
    this.bankAccountNumber,
    this.accountHolder,
    this.swift,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> d) {
    return UserProfile(
      uid: uid,
      email: d['email'] ?? '',
      name: d['nombre'],
      photoURL: d['photoURL'],
      postal: d['postal'],
      address: d['address'],
      city: d['city'],
      state: d['state'],
      country: d['country'],
      bankAccountNumber: d['bankAccountNumber'],
      accountHolder: d['accountHolder'],
      swift: d['swift'],
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    if (name != null) 'nombre': name,
    if (photoURL != null) 'photoURL': photoURL,
    if (postal != null) 'postal': postal,
    if (address != null) 'address': address,
    if (city != null) 'city': city,
    if (state != null) 'state': state,
    if (country != null) 'country': country,
    if (bankAccountNumber != null) 'bankAccountNumber': bankAccountNumber,
    if (accountHolder != null) 'accountHolder': accountHolder,
    if (swift != null) 'swift': swift,
  };
}
