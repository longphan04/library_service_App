String formatDate(DateTime date) {
  final months = [
    'tháng 1',
    'tháng 2',
    'tháng 3',
    'tháng 4',
    'tháng 5',
    'tháng 6',
    'tháng 7',
    'tháng 8',
    'tháng 9',
    'tháng 10',
    'tháng 11',
    'tháng 12',
  ];
  // dd tháng mm, yyyy
  return '${date.day} ${months[date.month - 1]}, ${date.year}';
}
