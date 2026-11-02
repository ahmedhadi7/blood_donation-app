class Donor {
  const Donor({
    required this.id,
    required this.name,
    required this.bloodGroup,
    required this.location,
    required this.availability,
    required this.lastDonated,
    required this.contact,
  });

  final String id;
  final String name;
  final String bloodGroup;
  final String location;
  final bool availability;
  final String lastDonated;
  final String contact;

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bloodGroup: json['bloodGroup']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      availability: json['availability'] == true,
      lastDonated: json['lastDonated']?.toString() ?? '',
      contact: json['contact']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bloodGroup': bloodGroup,
        'location': location,
        'availability': availability,
        'lastDonated': lastDonated,
        'contact': contact,
      };
}
