class WD {
  String kks;
  String description;
  int revisionNo;
  int versionNo;
  String? filePath; // Dosya yolu için ekledik
  final String? fileName; // Dosya adı
  final int? userId; // Opsiyonel hale getirildi
  final String? createdDate; // Opsiyonel hale getirildi
  final int? wdId; // Opsiyonel hale getirildi



  WD({
    required this.kks,
    required this.description,
    required this.revisionNo,
    required this.versionNo,
    this.filePath, // Opsiyonel hale getirildi
    this.fileName, // Dosya adı için yeni alan
    this.userId, // Otomatik atanan alan
    this.createdDate, // Otomatik atanan alan
    this.wdId, // Otomatik atanan alan
  });

  // Convert WD object to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'kks': kks,
      'description': description,
      'revisionNo': revisionNo,
      'versionNo': versionNo,
    };
  }

  // Parse WD object from JSON
  factory WD.fromJson(Map<String, dynamic> json) {
    return WD(
      kks: json['kks'],
      description: json['description'],
      revisionNo: json['revisionNo'],
      versionNo: json['versionNo'],
      filePath: json['filePath'],
      fileName: json['fileName'], // Backend'den alınan dosya adı
      userId: json['userId'], // Otomatik atanan alan
      createdDate: json['createdDate'], // Otomatik atanan alan
      wdId: json['wdId'], // Otomatik atanan alan
    );
  }
}
