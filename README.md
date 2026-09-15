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

| Kule | Rolü | Özellik |
|---|---|---|
| Foton Tareti | Temel | Ucuz, hızlı ateş, düşük hasar, tek hedef |
| Plazma Topu | Ağır hasar | Yavaş, güçlü, zırh deler |
| Nova Havanı | Alan hasarı | Sürülere karşı patlama |
| Yerçekimi Kuyusu | Destek | Alanındaki düşmanları yavaşlatır |

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
  ui/          Arayüz
scripts/       GDScript kodları
  map/         Arka plan, yol, kule noktası, istasyon
  enemies/     Düşman davranışı ve EnemyData
  waves/       Dalga tablosu (wave_table.gd) ve dalga yöneticisi
  ui/          Arayüz
resources/
  enemies/     Düşman değerleri (.tres) — denge ayarı buradan
```
