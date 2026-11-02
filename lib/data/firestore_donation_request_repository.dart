import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blood_donation/model/donation_request.dart';

class FirestoreDonationRequestRepository {
  FirestoreDonationRequestRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<String> createRequest(DonationRequest request) async {
    final document = await _firestore.collection('donation_requests').add({
      ...request.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return document.id;
  }
}
