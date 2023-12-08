import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/UserModel/UserDetailsProvider.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

Future sendEmail({
  required String name,
required String fromemail,
  required String toemail,
required String subject,
required String message,
}) async {
  final serviceId = 'service_i5qodic';
  final templateId = 'template_cnn9enr';
  final userId = '4wqiXQSAqS7jo6TTL';

  // Load the image from assets and convert it to base64
  final ByteData imageData = await rootBundle.load('assets/burger.jpeg');
  final List<int> bytes = imageData.buffer.asUint8List();
  final String base64Image = base64Encode(bytes);

  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  final response = await http.post(
      url,
    headers: {
        'origin': 'http://localhost',
       'Content-Type': 'application/json',
    },
    body: json.encode({
        'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
          'user_name': name,
        'user_email': fromemail,
        'to_email': toemail,
        'user_subject': subject,
        'user_message': message,
      }
    })
  );

  print(response.body);
}
