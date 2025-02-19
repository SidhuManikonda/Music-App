import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myportifolio/OfflineMusic/music_controller.dart';
import 'package:myportifolio/services/auth_services.dart';
import 'package:myportifolio/services/chat_services.dart';

class AppControllers {
static final authController = Provider<AuthServices>((ref) => AuthServices());
static final chatController = Provider<ChatServices>((ref) => ChatServices());
static final ChangeNotifierProvider<MusicController>musicProvider=ChangeNotifierProvider<MusicController>((ref)=>MusicController());
}
