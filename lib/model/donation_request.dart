class DonationRequest {
  const DonationRequest({
    required this.bloodGroup,
    required this.hospital,
    required this.phone,
    required this.requesterId,
    this.location = '',
    this.notes = '',
    this.requesterName = '',
  });

  final String bloodGroup;
  final String hospital;
  final String phone;
  final String requesterId;
  final String location;
  final String notes;
  final String requesterName;

  Map<String, dynamic> toJson() => {
        'bloodGroup': bloodGroup,
        'hospital': hospital,
        'phone': phone,
        'location': location,
        'notes': notes,
        'requesterId': requesterId,
        'requesterName': requesterName,
        'status': 'pending',
      };
}
