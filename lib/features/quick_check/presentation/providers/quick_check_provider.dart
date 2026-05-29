import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Raw price input string từ user (text trong TextField, chưa parse).
final priceInputProvider = StateProvider<String>((ref) => '');
