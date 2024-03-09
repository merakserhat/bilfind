import 'dart:math';

class UtilFunctions {
  static String formatTimeElapsed(DateTime commentDateTime) {
    Duration difference = DateTime.now().difference(commentDateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      int weeks = (difference.inDays / 7).floor();
      return '${weeks}w';
    }
  }

  static String generateRandomString() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    String result = '';

    for (int i = 0; i < 8; i++) {
      result += chars[random.nextInt(chars.length)];
    }

    return result;
  }
}
