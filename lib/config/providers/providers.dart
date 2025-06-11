import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bool que almacena si se ha cambiado el swipe
final swipeChangedProvider = StateProvider<bool>((ref) => false);

/// Bool que almacena si se ha cambiado los seguidos
final followingChangedProvider = StateProvider<int>((ref) => 0);