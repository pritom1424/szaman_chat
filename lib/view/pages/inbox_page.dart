import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szaman_chat/data/models/message_model.dart';
import 'package:szaman_chat/utils/components/app_vars.dart';
import 'package:szaman_chat/utils/constants/app_colors.dart';
import 'package:szaman_chat/utils/credential/UserCredential.dart';
import 'package:szaman_chat/utils/view_models/view_models.dart';
import 'package:szaman_chat/view/widgets/inboxpage/inbox_messages_widget.dart';
import 'package:szaman_chat/view/widgets/inboxpage/input_inbox_widget.dart';

class InboxPage extends ConsumerWidget {
  final String fId, fName;
  final String userimageUrl;
  const InboxPage(this.fId, this.fName, this.userimageUrl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widthSize = 0.5;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        // automaticallyImplyLeading: true,
        titleSpacing: 0,
        leadingWidth: 50,
        title: Container(
          width: AppVars.screenSize.width * (widthSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FittedBox(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ) /* (ref.read(authViewModel).userId == "")
                      ? CircleAvatar(
                          backgroundImage:
                              AssetImage(ImagePath.proPicPlaceholderPath))
                      : FutureBuilder(
                          future: Provider.of<EmployeeProfileController>(
                                  context,
                                  listen: false)
                              .getEmployeeProfile(ApiLinks.employeeProfileLink,
                                  UserCredential.userid!),
                          builder: (ctx, snap) {
                            if (!snap.hasData) {
                              return CircleAvatar(
                                backgroundImage:
                                    AssetImage(ImagePath.proPicPlaceholderPath),
                              );
                            } else {
                              if (snap.data!.image == null) {
                                return CircleAvatar(
                                  backgroundImage: AssetImage(
                                      ImagePath.proPicPlaceholderPath),
                                );
                              }
                              return CircleAvatar(
                                backgroundImage: NetworkImage(
                                    "https://hrms.szamantech.com/storage/employee/${snap.data!.image}"),
                              );
                            }
                          }), */
                      )),
              Text(
                "Name",
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Color.fromARGB(255, 226, 204, 195),
        child: (Usercredential.id == null || Usercredential.token == null)
            ? Text("no data found")
            : Column(
                children: [
                  StreamBuilder(
                      stream: ref.read(inboxpageViewModel).getAllMessagesStream(
                          Usercredential.token!, Usercredential.id!, fId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: AppVars.screenSize.height,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return SizedBox.shrink();
                        }

                        return Expanded(
                            child: InboxMessagesWidget(
                          messages: snapshot.data!,
                        ));
                      }),
                  InputInboxWidget(
                    fId: fId,
                    fName: fName,
                    userUrl: userimageUrl,
                  )
                ],
              ),
      ),
    );
  }
}
