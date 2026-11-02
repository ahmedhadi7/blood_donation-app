import 'package:blood_donation/model/donor.dart';


class DonorRepository {
  List<Donor> getDonors() => const [
    Donor(
      id: 'demo-1',
      name: 'علي حسن',
      bloodGroup: 'A+',
      location: 'بغداد',
      availability: true,
      lastDonated: 'قبل شهرين',
      contact: '07700000001',
    ),
    Donor(
      id: 'demo-2',
      name: 'سارة أحمد',
      bloodGroup: 'O+',
      location: 'الكوت',
      availability: true,
      lastDonated: 'قبل 3 أشهر',
      contact: '07700000002',
    ),
    Donor(
      id: 'demo-3',
      name: 'مصطفى كريم',
      bloodGroup: 'B+',
      location: 'بغداد',
      availability: false,
      lastDonated: 'قبل أسبوعين',
      contact: '07700000003',
    ),
    Donor(
      id: 'demo-4',
      name: 'نور سامي',
      bloodGroup: 'O-',
      location: 'موصل',
      availability: true,
      lastDonated: 'قبل 5 أشهر',
      contact: '07700000004',
    ),
    Donor(
      id: 'demo-5',
      name: 'زيد عمر',
      bloodGroup: 'AB+',
      location: 'أربيل',
      availability: true,
      lastDonated: 'قبل شهر',
      contact: '07700000005',
    ),
    Donor(
      id: 'demo-6',
      name: 'مريام خالد',
      bloodGroup: 'A-',
      location: 'الكوت',
      availability: false,
      lastDonated: 'قبل 4 أشهر',
      contact: '07700000006',
    ),
  ];
}
