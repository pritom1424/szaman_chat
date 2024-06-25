import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/provider/auth_vm.dart';
import 'package:szaman_chat/provider/inbox_page_vm.dart';
import 'package:szaman_chat/provider/inbox_page_vm_group.dart';
import 'package:szaman_chat/provider/navpage_vm.dart';
import 'package:szaman_chat/provider/profile_vm.dart';
import 'package:szaman_chat/provider/user_vm.dart';

final navpageViewModel =
    ChangeNotifierProvider<NavpageViewModel>((ref) => NavpageViewModel());
final inboxpageViewModel =
    ChangeNotifierProvider<InboxPageVm>((ref) => InboxPageVm());
final inboxpageGroupViewModel =
    ChangeNotifierProvider<InboxPageVmGroup>((ref) => InboxPageVmGroup());

final authViewModel = ChangeNotifierProvider<AuthVm>((ref) => AuthVm());

final profileViewModel =
    ChangeNotifierProvider<ProfileVm>((ref) => ProfileVm());

final userViewModel =
    ChangeNotifierProvider<UserViewModel>((ref) => UserViewModel());
