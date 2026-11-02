import 'package:blood_donation/data/donor_repository.dart';
import 'package:blood_donation/model/donor.dart';
import 'package:flutter/foundation.dart';

class DonorProvider extends ChangeNotifier {
  DonorProvider({DonorRepository? repository})
    : _repository = repository ?? DonorRepository() {
    _donors = _repository.getDonors();
  }

  final DonorRepository _repository;
  late final List<Donor> _donors;
  String? _selectedBloodGroup;
  String? _selectedLocation;

  String? get selectedBloodGroup => _selectedBloodGroup;
  String? get selectedLocation => _selectedLocation;

  List<String> get bloodTypes => const [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  List<String> get locations => const ['مستشفي يغداد', ' مستشفي الكندي', 'مستشفى ابن سينا', 'مستشفى اليرموك'];

  List<Donor> get donors => List.unmodifiable(_donors);

  List<Donor> get filteredDonors => _donors.where((donor) {
    final matchesBlood =
        _selectedBloodGroup == null || donor.bloodGroup == _selectedBloodGroup;
    final matchesLocation =
        _selectedLocation == null || donor.location == _selectedLocation;
    return matchesBlood && matchesLocation;
  }).toList();

  void setBloodGroup(String? value) {
    if (_selectedBloodGroup == value) return;
    _selectedBloodGroup = value;
    notifyListeners();
  }

  void setLocation(String? value) {
    if (_selectedLocation == value) return;
    _selectedLocation = value;
    notifyListeners();
  }

  void clearFilters() {
    _selectedBloodGroup = null;
    _selectedLocation = null;
    notifyListeners();
  }
}
