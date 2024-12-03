class Pdesign {
  String kks;
  String description;
  int revisionNo;
  int versionNo;
  String? filePath; // Dosya yolu için ekledik
  final String? fileName; // Dosya adı
  final int? userId; // Opsiyonel hale getirildi
  final String? createdDate; // Opsiyonel hale getirildi
  final int? pdId; // Opsiyonel hale getirildi



  Pdesign({
    required this.kks,
    required this.description,
    required this.revisionNo,
    required this.versionNo,
    this.filePath, // Opsiyonel hale getirildi
    this.fileName, // Dosya adı için yeni alan
    this.userId, // Otomatik atanan alan
    this.createdDate, // Otomatik atanan alan
    this.pdId, // Otomatik atanan alan
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
  factory Pdesign.fromJson(Map<String, dynamic> json) {
    return Pdesign(
      kks: json['kks'],
      description: json['description'],
      revisionNo: json['revisionNo'],
      versionNo: json['versionNo'],
      filePath: json['filePath'],
      fileName: json['fileName'], // Backend'den alınan dosya adı
      userId: json['userId'], // Otomatik atanan alan
      createdDate: json['createdDate'], // Otomatik atanan alan
      pdId: json['pdId'], // Otomatik atanan alan
    );
  }
}
