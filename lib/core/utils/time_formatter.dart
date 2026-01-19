class TimeFormatter {
  static String formatRemainingTime(DateTime expiresAt) {
    final DateTime now = DateTime.now().toUtc();
    final Duration diff = expiresAt.difference(now);
    if (diff.isNegative) {
      return "Đã hết hạn";
    }

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(diff.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(diff.inSeconds.remainder(60));

    if (diff.inDays > 0) {
      return "${diff.inDays} ngày, ${twoDigits(diff.inHours.remainder(24))}:$twoDigitMinutes:$twoDigitSeconds";
    }

    return "${twoDigits(diff.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
