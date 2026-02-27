import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class CloudinaryService {
  /// Uploads [image] using an unsigned upload preset.
  /// No API secret is ever included in the mobile app.
  Future<String> uploadReceipt(File image) async {
    final uri = Uri.parse(AppConstants.cloudinaryUploadUrl);

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = AppConstants.cloudinaryUploadPreset
      ..fields['folder'] = 'expense_tracker/receipts'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      throw Exception('Cloudinary upload failed: $responseBody');
    }

    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    return json['secure_url'] as String;
  }
}