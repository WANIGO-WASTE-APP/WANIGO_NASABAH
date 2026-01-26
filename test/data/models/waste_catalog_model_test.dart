import 'package:flutter_test/flutter_test.dart';
import 'package:wanigo_nasabah/data/models/waste_catalog_model.dart';

void main() {
  group('WasteCatalogModel Parsing', () {
    final Map<String, dynamic> sampleJson = {
      "success": true,
      "message": "Katalog sampah berhasil diambil",
      "data": {
        "bank_sampah": {
          "id": 1,
          "nama": "Bank Sampah Surabaya Bersih",
          "alamat": "Jl. Raya Darmo No. 123, Wonokromo",
          "tanggal_setoran": null,
          "status_operasional": "Aktif",
          "nomor_telepon": "031-5678901"
        },
        "katalog_sampah": [
          {
            "id": 6,
            "bank_sampah_id": 1,
            "sub_kategori_sampah_id": 13,
            "kategori_sampah": 0,
            "nama_item_sampah": "Kertas HVS",
            "harga_per_kg": "1500.00",
            "deskripsi_item_sampah": "Kertas HVS bekas",
            "cara_pemilahan": null,
            "cara_pengemasahan": null,
            "gambar_item_sampah": null,
            "status_aktif": true,
            "created_at": "2026-01-23T16:09:39.000000Z",
            "updated_at": "2026-01-23T16:09:39.000000Z",
            "kategori_utama": "kering",
            "sub_kategori": {
              "id": 13,
              "bank_sampah_id": 2,
              "kategori_sampah_id": 1,
              "kategori_sampah": {
                "id": 1,
                "nama_kategori": "Sampah Kering",
                "kode_kategori": "kering",
                "deskripsi":
                    "Sampah kering adalah sampah yang tidak mengandung air dan dapat didaur ulang",
                "icon": null,
                "created_at": "2026-01-14T08:08:59.000000Z",
                "updated_at": "2026-01-14T08:08:59.000000Z"
              },
              "nama_sub_kategori": "Kertas",
              "kode_sub_kategori": "SK-001",
              "slug": "kertas",
              "deskripsi": "Kertas bekas, koran, majalah, buku",
              "icon": "paper",
              "warna": "#8BC34A",
              "urutan": 1,
              "status_aktif": true,
              "is_active": true,
              "created_at": "2026-01-23T13:06:40.000000Z",
              "updated_at": "2026-01-23T13:06:40.000000Z"
            },
            "harga_format": "Rp 1.500",
            "gambar_url": "http://api.wanigo.id/images/default-waste-item.png"
          }
        ],
        "sub_kategori_list": [
          {
            "id": 3,
            "nama_sub_kategori": "Kertas",
            "kode_sub_kategori": "SK-001",
            "warna": "#8BC34A",
            "jumlah_item": 1
          }
        ],
        "info_kategori": {"jumlah_kering": 11, "jumlah_basah": 2}
      }
    };

    test('should parse WasteCatalogResponse from JSON', () {
      final response = WasteCatalogResponse.fromJson(sampleJson);

      expect(response.success, true);
      expect(response.message, "Katalog sampah berhasil diambil");
      expect(response.data, isNotNull);

      final data = response.data!;
      expect(data.bankSampah, isNotNull);
      expect(data.bankSampah!.id, 1);
      expect(data.katalogSampah.length, 1);
      expect(data.subKategoriList.length, 1);
      expect(data.infoKategori, isNotNull);

      final item = data.katalogSampah.first;
      expect(item.namaItemSampah, "Kertas HVS");
      expect(item.hargaFormat, "Rp 1.500");
      expect(item.subKategori, isNotNull);
      expect(item.subKategori!.namaSubKategori, "Kertas");
      expect(item.subKategori!.kategoriSampah, isNotNull);
      expect(item.subKategori!.kategoriSampah!.namaKategori, "Sampah Kering");

      expect(data.subKategoriList.first.namaSubKategori, "Kertas");
      expect(data.infoKategori!.jumlahKering, 11);
    });
  });
}
