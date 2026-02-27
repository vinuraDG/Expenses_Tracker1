import 'dart:io';
import 'package:flutter/material.dart';
import '../core/services/cloudinary_service.dart';
import '../core/services/firestore_service.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  List<TransactionModel> _transactions = [];
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = false;
  String? _errorMessage;

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  DateTime get selectedMonth => _selectedMonth;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Dashboard
  double get totalIncome => _transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _transactions
      .where((t) => t.isExpense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  //Month navigation
  Future<void> changeMonth(DateTime month) async {
    _selectedMonth = month;
    await fetchTransactions();
  }

  //CRUD operations
  Future<void> fetchTransactions() async {
    _setLoading(true);
    try {
      _transactions =
          await _firestoreService.getTransactions(month: _selectedMonth);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> addTransaction(TransactionModel t, {File? receiptImage}) async {
    _setLoading(true);
    try {
      String? receiptUrl;
      if (receiptImage != null) {
        receiptUrl = await _cloudinaryService.uploadReceipt(receiptImage);
      }
      final data = t.toMap();
      if (receiptUrl != null) data['receiptUrl'] = receiptUrl;
      final ref = await _firestoreService.addTransaction(data);
      _transactions.insert(
          0, t.copyWith(id: ref.id, receiptUrl: receiptUrl));
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateTransaction(TransactionModel t,
      {File? newReceiptImage}) async {
    _setLoading(true);
    try {
      String? receiptUrl = t.receiptUrl;
      if (newReceiptImage != null) {
        receiptUrl = await _cloudinaryService.uploadReceipt(newReceiptImage);
      }
      final data = t.toMap();
      if (receiptUrl != null) data['receiptUrl'] = receiptUrl;
      await _firestoreService.updateTransaction(t.id, data);
      final index = _transactions.indexWhere((tx) => tx.id == t.id);
      if (index != -1) {
        _transactions[index] = t.copyWith(receiptUrl: receiptUrl);
      }
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteTransaction(String id) async {
    _setLoading(true);
    try {
      await _firestoreService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}