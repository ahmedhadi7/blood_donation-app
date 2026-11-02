import 'package:blood_donation/data/firestore_donation_request_repository.dart';
import 'package:blood_donation/model/donation_request.dart';
import 'package:blood_donation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonationRequestScreen extends StatefulWidget {
  const DonationRequestScreen({super.key});

  @override
  State<DonationRequestScreen> createState() => _DonationRequestScreenState();
}

class _DonationRequestScreenState extends State<DonationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBloodGroup;
  bool _showBloodGroupError = false;
  bool _isSaving = false;
  final FirestoreDonationRequestRepository _requestRepository =
      FirestoreDonationRequestRepository();

  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> bloodTypes = const [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void dispose() {
    _hospitalController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget bTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.red.shade400),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    final hasBloodGroup = selectedBloodGroup != null;

    setState(() => _showBloodGroupError = !hasBloodGroup);

    if (!isFormValid || !hasBloodGroup) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إكمال الحقول المطلوبة قبل المتابعة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = context.read<AuthProvider>().user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تسجيل الدخول قبل إرسال طلب التبرع')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final request = DonationRequest(
        bloodGroup: selectedBloodGroup!,
        hospital: _hospitalController.text.trim(),
        phone: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        notes: _notesController.text.trim(),
        requesterId: user.uid,
        requesterName: user.displayName ?? '',
      );

      await _requestRepository.createRequest(request);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال طلب التبرع وحفظه بنجاح'),
          backgroundColor: Colors.green,
        ),
      );

      _formKey.currentState?.reset();
      _hospitalController.clear();
      _locationController.clear();
      _phoneController.clear();
      _notesController.clear();
      setState(() {
        selectedBloodGroup = null;
        _showBloodGroupError = false;
      });
    } on FirebaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.code == 'permission-denied'
                ? 'رفضت قواعد أمان Firestore حفظ الطلب. تحقق من قواعد قاعدة البيانات.'
                : 'تعذر حفظ الطلب (${error.code}). حاول مرة أخرى.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء حفظ الطلب. حاول مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            floating: false,
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ارسال طلب تبرع بالدم',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'ساعد في العثور على المتبرعين المناسبين من خلال إرسال طلبك',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
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
                Text(
                  'اختر نوع الدم المطلوب',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: bloodTypes.length,
                  itemBuilder: (context, index) {
                    final bloodType = bloodTypes[index];
                    final isSelected = selectedBloodGroup == bloodType;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBloodGroup = bloodType;
                          _showBloodGroupError = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE53935)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _showBloodGroupError && !isSelected
                                ? Colors.red
                                : (isSelected
                                      ? const Color(0xFFE53935)
                                      : Colors.grey.shade400),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            bloodType,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (_showBloodGroupError) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'يرجى اختيار فصيلة الدم',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تفاصيل الطلب',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      bTextFormField(
                        controller: _hospitalController,
                        label: 'اسم المستشفى *',
                        icon: Icons.local_hospital,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'يرجى إدخال اسم المستشفى';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      bTextFormField(
                        controller: _phoneController,
                        label: 'رقم الهاتف *',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty)
                            return 'يرجى إدخال رقم الهاتف';
                          if (value.trim().length < 7)
                            return 'يرجى إدخال رقم هاتف صحيح';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      bTextFormField(
                        controller: _locationController,
                        label: 'الموقع (اختياري)',
                        icon: Icons.location_on,
                      ),
                      const SizedBox(height: 16),
                      bTextFormField(
                        controller: _notesController,
                        label: 'ملاحظات إضافية (اختياري)',
                        icon: Icons.note,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isSaving ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isSaving
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'قم بإرسال طلب التبرع',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
