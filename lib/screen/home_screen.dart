import 'package:blood_donation/component/build_quick_action_card.dart';
import 'package:blood_donation/providers/auth_provider.dart';
import 'package:blood_donation/screen/donation_request_screen.dart';
import 'package:blood_donation/screen/find_donors_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            leading: SizedBox(),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFFF8A80)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),

                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'اهلا وسهلا',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white24,
                                  child: IconButton(
                                    icon: const Icon(Icons.notifications),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.white24,
                                  child: IconButton(
                                    tooltip: 'تسجيل الخروج',
                                    icon: const Icon(Icons.logout),
                                    color: Colors.white,
                                    onPressed: () async {
                                      await context
                                          .read<AuthProvider>()
                                          .signOut();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'دعنا نساعدك في العثور على المتبرعين بالدم بسهولة',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'دمك ينقذ حياة',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Color(0xFFE53935),

            pinned: true,
          ),

          SliverPadding(
            padding: EdgeInsetsGeometry.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "طلب تبرع عاجل",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Icon(
                            Icons.warning_rounded,
                            color: Color(0xFFE53935).withOpacity(0.8),
                            size: 30,
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      Text(
                        "عاجل: يحتاج الدم من نوع O+",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),

                      SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonationRequestScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE53935),
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),

                        child: Text(
                          "الرد على الطلب",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الخدمات السريعة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 12),

                    GridView.count(
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.4,

                      children: [
                        BuildQuickActionCard(
                          icon: Icons.local_hospital,
                          label: 'اقرب المتبرعين',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindDonorsScreen(),
                              ),
                            );
                          },
                        ),
                        BuildQuickActionCard(
                          icon: Icons.bloodtype,
                          label: 'طلب تبرع',
                          color: Colors.red,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DonationRequestScreen(),
                              ),
                            );
                          },
                        ),

                        BuildQuickActionCard(
                          icon: Icons.calendar_today,
                          label: 'طلباتي',
                          color: Colors.green,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindDonorsScreen(),
                              ),
                            );
                          },
                        ),
                        BuildQuickActionCard(
                          icon: Icons.location_on,
                          label: 'المدن القريبة',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FindDonorsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'المراكز القريبة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DonationRequestScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'عرض الكل',
                                style: TextStyle(
                                  color: Color(0xFFE53935).withOpacity(0.8),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: ListTile(
                                contentPadding: EdgeInsets.all(12),
                                leading: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE53935).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.local_hospital,
                                    color: Color(0xFFE53935),
                                  ),
                                ),
                                title: Text(
                                  'مستشفى المدينة ${index + 1} كم بعيد - مفتوح 24/7',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${2.1 * (index + 1)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE53935).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFFE53935),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonationRequestScreen()),
          );
        },
        backgroundColor: Color(0xFFE53935),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'تقديم طلب تبرع',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
