import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/provider/navpage_vm.dart';

final navpageViewModel =
    ChangeNotifierProvider<NavpageViewModel>((ref) => NavpageViewModel());
