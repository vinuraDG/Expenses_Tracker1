import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/firestore_constants.dart';
import '../../models/category_model.dart';
import '../../models/transaction_model.dart';

class FirestoreService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;


  /// Safe UID getter
  String get _uid {

    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return user.uid;
  }


  /// Base references
  DocumentReference get _userDoc =>
      _db
          .collection(FirestoreConstants.usersCollection)
          .doc(_uid);


  CollectionReference get _categoriesRef =>
      _userDoc.collection(
        FirestoreConstants.categoriesCollection,
      );


  CollectionReference get _transactionsRef =>
      _userDoc.collection(
        FirestoreConstants.transactionsCollection,
      );


  // =====================================================
  // CATEGORY METHODS
  // =====================================================

  Future<List<CategoryModel>> getCategories() async {

    try {

      final snap = await _categoriesRef
          .orderBy(FirestoreConstants.fieldName)
          .get();

      return snap.docs
          .map(
            (doc) => CategoryModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

    } catch (e) {

      throw Exception("Failed to load categories: $e");
    }
  }


  /// Real-time categories stream (BEST PRACTICE)
  Stream<List<CategoryModel>> categoriesStream() {

    return _categoriesRef
        .orderBy(FirestoreConstants.fieldName)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => CategoryModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }


  Future<DocumentReference> addCategory(
      Map<String, dynamic> data) async {

    data['createdAt'] = FieldValue.serverTimestamp();

    return await _categoriesRef.add(data);
  }


  Future<void> updateCategory(
      String id,
      Map<String, dynamic> data) async {

    data['updatedAt'] = FieldValue.serverTimestamp();

    await _categoriesRef.doc(id).update(data);
  }


  Future<void> deleteCategory(String id) async {

    await _categoriesRef.doc(id).delete();
  }



  // =====================================================
  // TRANSACTION METHODS
  // =====================================================

  Future<List<TransactionModel>> getTransactions({
    DateTime? month,
  }) async {

    try {

      Query query = _transactionsRef.orderBy(
        FirestoreConstants.fieldDate,
        descending: true,
      );


      if (month != null) {

        final start =
            DateTime(month.year, month.month, 1);

        final end =
            DateTime(month.year, month.month + 1, 1);

        query = query
            .where(
              FirestoreConstants.fieldDate,
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(start),
            )
            .where(
              FirestoreConstants.fieldDate,
              isLessThan:
                  Timestamp.fromDate(end),
            );
      }


      final snap = await query.get();


      return snap.docs
          .map(
            (doc) => TransactionModel.fromMap(
              doc.id,
              doc.data() as Map<String, dynamic>,
            ),
          )
          .toList();

    } catch (e) {

      throw Exception("Failed to load transactions: $e");
    }
  }



  /// Real-time transaction stream (RECOMMENDED)
  Stream<List<TransactionModel>> transactionsStream() {

    return _transactionsRef
        .orderBy(
          FirestoreConstants.fieldDate,
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TransactionModel.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }



  Future<DocumentReference> addTransaction(
      Map<String, dynamic> data) async {

    data['createdAt'] = FieldValue.serverTimestamp();

    return await _transactionsRef.add(data);
  }



  Future<void> updateTransaction(
      String id,
      Map<String, dynamic> data) async {

    data['updatedAt'] = FieldValue.serverTimestamp();

    await _transactionsRef.doc(id).update(data);
  }



  Future<void> deleteTransaction(String id) async {

    await _transactionsRef.doc(id).delete();
  }

}