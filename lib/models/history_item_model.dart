class HistoryItem {
  final String checkIn;
  final String checkOut;
  final String checkInAddress;
  final String checkOutAddress;
  final String status;
  final String alasanIzin;

  HistoryItem({
    required this.checkIn,
    required this.checkOut,
    required this.checkInAddress,
    required this.checkOutAddress,
    required this.status,
    required this.alasanIzin,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      checkInAddress: json['check_in_address'] ?? '',
      checkOutAddress: json['check_out_address'] ?? '',
      status: json['status'] ?? '',
      alasanIzin: json['alasan_izin'] ?? '',
    );
  }
}
