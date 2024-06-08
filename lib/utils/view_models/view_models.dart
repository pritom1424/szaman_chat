import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/provider/auth_vm.dart';
import 'package:szaman_chat/provider/inbox_page_vm.dart';
import 'package:szaman_chat/provider/navpage_vm.dart';

final navpageViewModel =
    ChangeNotifierProvider<NavpageViewModel>((ref) => NavpageViewModel());
final inboxpageViewModel =
    ChangeNotifierProvider<InboxPageVm>((ref) => InboxPageVm());

final authViewModel = ChangeNotifierProvider<AuthVm>((ref) => AuthVm());
