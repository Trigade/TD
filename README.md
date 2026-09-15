# Carinae

Eta Carinae yörüngesindeki araştırma istasyonunu, Carina Nebulası'ndan gelen düşman dalgalarına karşı savunduğun bir tower defense oyunu. Godot 4 ile geliştiriliyor.

## Çalıştırma

Godot 4.7 ile `project.godot` dosyasını aç ve **F5**'e bas.

## İlk sürüm (MVP) kapsamı

- Tek harita, tek sabit yol, sabit kule noktaları
- 4 kule tipi, her biri 3 seviye (temel + 2 yükseltme), satışta %70 iade
- Dalga sistemi (10–15 dalga), para kazanma, can sayısı
- Geometrik grafikler (çizimler sonradan eklenecek)
- Hedef platformlar: Windows ve macOS
- Kontroller: sadece sol tık + ESC (MacBook trackpad dostu)

## Kuleler

| Kule | Rolü | Fiyat | Hasar | Atış/sn | Menzil | Özellik |
|---|---|---|---|---|---|---|
| Foton Tareti | Temel | 50 | 12 | 3 | 220 | Ucuz, hızlı ateş, tek hedef |
| Yerçekimi Kuyusu | Destek | 80 | 3 | 1.5 | 170 | Menzildeki herkesi 1 sn %45 yavaşlatır |
| Plazma Topu | Ağır hasar | 100 | 70 | 0.6 | 260 | Zırhı tamamen deler |
| Nova Havanı | Alan hasarı | 120 | 30 | 0.7 | 240 | 90 px yarıçapta patlar |

Değerler ilk tahminlerdir; denge ayarı `resources/towers/*.tres` dosyalarından yapılır.

## Düşmanlar

| Düşman | Özellik |
|---|---|
| Keşif Dronu | Normal hız, normal can |
| Sürü | Kalabalık, hızlı, zayıf |
| Zırhlı Kruvazör | Yavaş; zırh her vuruştan sabit hasar düşer |
| Boss | Son dalga (isteğe bağlı) |

## Klasör yapısı

```
scenes/        Sahneler (.tscn)
  map/         Harita parçaları (kule noktası vb.)
  enemies/     Düşman sahnesi
  towers/      Kule ve mermi sahneleri
  ui/          Arayüz ve inşa menüsü
scripts/       GDScript kodları
  map/         Arka plan, yol, kule noktası, istasyon
  enemies/     Düşman davranışı ve EnemyData
  towers/      Kule, mermi ve TowerData
  waves/       Dalga tablosu (wave_table.gd) ve dalga yöneticisi
  ui/          Arayüz ve inşa menüsü (menüdeki kule listesi build_menu.gd içinde)
resources/
  enemies/     Düşman değerleri (.tres) — denge ayarı buradan
  towers/      Kule değerleri (.tres)
```
