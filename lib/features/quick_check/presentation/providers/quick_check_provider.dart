import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Raw price input string từ user (text trong TextField, chưa parse).
final priceInputProvider = StateProvider<String>((ref) => '');

/// Optional item name draft from Home, passed to Result copy.
final itemNameProvider = StateProvider<String>((ref) => '');
