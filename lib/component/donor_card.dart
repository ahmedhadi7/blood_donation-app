import 'package:blood_donation/component/info_chip.dart';
import 'package:blood_donation/model/donor.dart';
import 'package:flutter/material.dart';

class DonorCard extends StatelessWidget {
  const DonorCard({super.key, required this.donor});

  final Donor donor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(donor.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: donor.availability ? const Color(0xFFE53935) : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(donor.availability ? 'متاح' : 'غير متاح',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              InfoChip(icon: Icons.bloodtype, text: donor.bloodGroup),
              InfoChip(icon: Icons.location_on, text: donor.location),
            ]),
            const SizedBox(height: 12),
            Text(' اخر تبرع: ${donor.lastDonated}',
              style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: donor.availability ? () => _showContactDialog(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('اتصل بالمتبرع'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Contact Donor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact Number:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SelectableText(donor.contact,
              style: const TextStyle(fontSize: 16, color: Color(0xFFE53935))),
            const SizedBox(height: 16),
            const Text('Contact the donor using this number.'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Close')),
        ],
      ),
    );
  }
}
