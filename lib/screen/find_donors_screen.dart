import 'package:blood_donation/component/donor_card.dart';
import 'package:blood_donation/providers/donor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FindDonorsScreen extends StatelessWidget {
  const FindDonorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final donorsProvider = context.watch<DonorProvider>();
    final filteredDonors = donorsProvider.filteredDonors;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  gradient: LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFFF8A80)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const SafeArea(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'البحث عن المتبرعين',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const Text(
                  'تحديد نوع الدم والموقع للعثور على المتبرعين المناسبين',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: donorsProvider.bloodTypes.map((bloodType) {
                      final selected =
                          donorsProvider.selectedBloodGroup == bloodType;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(bloodType),
                          selected: selected,
                          selectedColor: const Color(0xFFE53935),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                          ),
                          onSelected: (value) => donorsProvider.setBloodGroup(
                            value ? bloodType : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: donorsProvider.selectedLocation,
                  decoration: InputDecoration(
                    labelText: 'تحديد الموقع',
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Color(0xFFE53935),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('جميع الأماكن'),
                    ),
                    ...donorsProvider.locations.map(
                      (location) => DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      ),
                    ),
                  ],
                  onChanged: donorsProvider.setLocation,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: donorsProvider.clearFilters,
                    icon: const Icon(Icons.filter_alt_off),
                    label: const Text('Clear filters'),
                  ),
                ),
                const SizedBox(height: 8),
                if (filteredDonors.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 76, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'No donors found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'جرب تعديل الفلاتر للعثور على المتبرعين المناسبين',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDonors.length,
                    itemBuilder: (context, index) =>
                        DonorCard(donor: filteredDonors[index]),
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
