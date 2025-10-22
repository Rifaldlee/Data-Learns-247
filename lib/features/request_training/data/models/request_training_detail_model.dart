class RequestTrainingDetail {
  int? id;
  String? productName;
  String? dateCreated;
  String? status;
  String? namaProject;
  String? nilaiTraining;
  String? tanggalMulai;
  String? jumlahPeserta;
  String? tempatPelaksanaan;
  String? kontakPic;
  String? pesertaTraining;
  String? profilPeserta;
  List<Approvals>? approvals;

  RequestTrainingDetail({
    this.id,
    this.productName,
    this.dateCreated,
    this.status,
    this.namaProject,
    this.nilaiTraining,
    this.tanggalMulai,
    this.jumlahPeserta,
    this.tempatPelaksanaan,
    this.kontakPic,
    this.pesertaTraining,
    this.profilPeserta,
    this.approvals
  });

  RequestTrainingDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    dateCreated = json['date_created'];
    status = json['status'];
    namaProject = json['nama_project'];
    nilaiTraining = json['nilai_training'];
    tanggalMulai = json['tanggal_mulai'];
    jumlahPeserta = json['jumlah_peserta'];
    tempatPelaksanaan = json['tempat_pelaksanaan'];
    kontakPic = json['kontak_pic'];
    pesertaTraining = json['peserta_training'];
    profilPeserta = json['profil_peserta'];
    if (json['approvals'] != null) {
      approvals = <Approvals>[];
      json['approvals'].forEach((v) {
        approvals!.add(Approvals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['date_created'] = dateCreated;
    data['status'] = status;
    data['nama_project'] = namaProject;
    data['nilai_training'] = nilaiTraining;
    data['tanggal_mulai'] = tanggalMulai;
    data['jumlah_peserta'] = jumlahPeserta;
    data['tempat_pelaksanaan'] = tempatPelaksanaan;
    data['kontak_pic'] = kontakPic;
    data['peserta_training'] = pesertaTraining;
    data['profil_peserta'] = profilPeserta;
    if (approvals != null) {
      data['approvals'] = approvals!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Approvals {
  String? userId;
  String? name;
  String? status;
  String? note;

  Approvals({this.userId, this.name, this.status, this.note});

  Approvals.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    status = json['status'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['status'] = status;
    data['note'] = note;
    return data;
  }
}
