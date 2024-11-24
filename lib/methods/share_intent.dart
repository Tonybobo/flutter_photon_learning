import 'package:receive_sharing_intent/receive_sharing_intent.dart';

handleSharingIntent() async {
  ReceiveSharingIntent instance = ReceiveSharingIntent.instance;
  List<SharedMediaFile> fileList = await instance.getInitialMedia();
  if (fileList.isNotEmpty) {
    return (true, "file");
  }
  return (false, "");
}
