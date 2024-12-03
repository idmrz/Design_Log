class Letter {
  String letterNo;
  String letterDate; // 'yyyy-MM-dd' formatında String olarak gönderiyoruz
  String description;
  String category;
  String? filePath; // Dosya yolu için ekledik
  final String? fileName; // Dosya adı
  final int? userId; // Opsiyonel hale getirildi
  final String? createdDate; // Opsiyonel hale getirildi
  final int? letterId; // Opsiyonel hale getirildi

  Letter({
    required this.letterNo,
    required this.letterDate,
    required this.description,
    required this.category,
    this.filePath, // Opsiyonel hale getirildi
    this.fileName, // Dosya adı için yeni alan
    this.userId, // Otomatik atanan alan
    this.createdDate, // Otomatik atanan alan
    this.letterId, // Otomatik atanan alan

  });

  // Convert WD object to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'letterNo': letterNo,
      'letterDate': letterDate, // Format yyyy-MM-dd olarak gönderilir
      'description': description,
      'category': category,
    };
  }

  // Parse WD object from JSON
  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      letterDate: json['letterDate'], // Expecting 'yyyy-MM-dd' format
      letterNo: json['letterNo'],
      description: json['description'],
      category: json['category'],
      filePath: json['filePath'],
      fileName: json['fileName'], // Backend'den alınan dosya adı
      userId: json['userId'], // Otomatik atanan alan
      createdDate: json['createdDate'], // Otomatik atanan alan
      letterId: json['letterId'], // Otomatik atanan alan
    );
  }
}
