import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../models/transaction_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  String _type = AppConstants.expense;
  String? _categoryId;
  DateTime _selectedDate = DateTime.now();
  File? _receiptImage;
  String? _existingReceiptUrl;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<CategoryProvider>().fetchCategories());
    if (_isEditing) {
      final t = widget.transaction!;
      _amountCtrl.text = t.amount.toString();
      _noteCtrl.text = t.note ?? '';
      _type = t.type;
      _categoryId = t.categoryId;
      _selectedDate = t.date;
      _existingReceiptUrl = t.receiptUrl;
      _dateCtrl.text = DateFormat('dd MMM yyyy').format(_selectedDate);
    } else {
      _dateCtrl.text = DateFormat('dd MMM yyyy').format(_selectedDate);
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) setState(() => _receiptImage = File(picked.path));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')));
      return;
    }

    final txProvider = context.read<TransactionProvider>();
    final t = TransactionModel(
      id: _isEditing ? widget.transaction!.id : '',
      amount: double.parse(_amountCtrl.text.trim()),
      type: _type,
      categoryId: _categoryId!,
      date: _selectedDate,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      receiptUrl: _existingReceiptUrl,
    );

    bool success;
    if (_isEditing) {
      success = await txProvider.updateTransaction(t, newReceiptImage: _receiptImage);
    } else {
      success = await txProvider.addTransaction(t, receiptImage: _receiptImage);
    }

    if (success && mounted) Navigator.pop(context);
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(txProvider.errorMessage ?? 'Error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final catProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
          title: Text(_isEditing ? 'Edit Transaction' : 'Add Transaction')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               // type selector
              Row(
                children: [
                  Expanded(
                    child: _typeButton(
                        AppConstants.expense, 'Expense', AppTheme.expense),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _typeButton(
                        AppConstants.income, 'Income', AppTheme.income),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Amount
              CustomTextField(
                controller: _amountCtrl,
                label: 'Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                prefixIcon: const Icon(Icons.attach_money),
                validator: Validators.amount,
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: catProvider.categories
                    .map((c) => DropdownMenuItem(
                          value: c.id,
                          child: Text('${c.icon}  ${c.name}'),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _categoryId = v),
                validator: (v) => v == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 16),

              // Date
              CustomTextField(
                controller: _dateCtrl,
                label: 'Date',
                readOnly: true,
                onTap: _pickDate,
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              const SizedBox(height: 16),

              // Note
              CustomTextField(
                controller: _noteCtrl,
                label: 'Note (optional)',
                maxLines: 2,
                prefixIcon: const Icon(Icons.note_outlined),
              ),
              const SizedBox(height: 16),

              // Receipt image
              const Text('Receipt Image (optional)',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: _receiptImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_receiptImage!, fit: BoxFit.cover))
                      : _existingReceiptUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(_existingReceiptUrl!,
                                  fit: BoxFit.cover))
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_outlined,
                                    size: 36, color: AppTheme.textSecondary),
                                SizedBox(height: 8),
                                Text('Tap to add receipt',
                                    style: TextStyle(
                                        color: AppTheme.textSecondary)),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 28),

              CustomButton(
                label: _isEditing ? 'Update Transaction' : 'Add Transaction',
                onPressed: _save,
                isLoading: txProvider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String type, String label, Color color) {
    final isSelected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}