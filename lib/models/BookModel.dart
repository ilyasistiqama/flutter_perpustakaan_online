// ignore_for_file: file_names, non_constant_identifier_names

class BookModel {
  int? id;
  String? kode_buku;
  int? category_id;
  String? judul;
  String? slug;
  String? penerbit;
  String? pengarang;
  String? tahun;
  int? stok;
  String? path;
  BookModel({this.kode_buku, this.category_id, this.judul, this.slug, this.penerbit, this.pengarang, this.tahun, this.stok, this.path});
}