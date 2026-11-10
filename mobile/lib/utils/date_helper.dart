class DateHelper {
  static const List<String> _hari = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  ];
  
  static const List<String> _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static String formatDateHistory(DateTime date) {
    // Format: "Rabu, 24 Mei"
    // weekday: 1 = Senin, 7 = Minggu
    int hariIndex = (date.weekday - 1) % 7;
    String hari = _hari[hariIndex];
    String bulan = _bulan[date.month - 1];
    
    return '$hari, ${date.day} $bulan';
  }

  static String formatTimeHistory(DateTime date) {
    // Format: "07:30"
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}