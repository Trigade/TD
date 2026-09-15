# Carinae

Eta Carinae yörüngesindeki araştırma istasyonunu, Carina Nebulası'ndan gelen düşman dalgalarına karşı savunduğun bir tower defense oyunu. Godot 4 ile geliştiriliyor.

## Çalıştırma

Godot 4.7 ile `project.godot` dosyasını aç ve **F5**'e bas.

## Kontroller

Oyun sadece sol tık ve ESC ile oynanır (MacBook trackpad dostu).

- **Sol tık:** Boş kule noktasına tıkla → kule inşa et. Kurulu kuleye tıkla → yükselt veya sat.
- **ESC:** Açık menüyü kapatır; menü yoksa oyunu duraklatır; duraklatma ekranında oyuna döner.
- **Duraklat** (sağ üst): ESC ile aynı duraklatma ekranı.
- **Dalgayı çağır** (sağ üst, geri sayım sırasında): Sıradaki dalgayı hemen başlatır, kalan her saniye için +3 para verir.

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

Tablo 1. seviye değerlerini gösterir. Her kulenin 3 seviyesi vardır; her seviye ayrı bir `.tres`
dosyasıdır (`photon_turret.tres` → `photon_turret_2.tres` → `photon_turret_3.tres`) ve `next_level`
alanıyla bir sonrakine bağlanır. Bir seviyenin `cost` değeri o seviyeye yükseltme fiyatıdır.
Satışta toplam harcamanın %70'i geri verilir.

Değerler ilk tahminlerdir; denge ayarı `resources/towers/*.tres` dosyalarından yapılır.

## Düşmanlar

| Düşman | Can | Hız | Zırh | Ödül | Can kaybı | Özellik |
|---|---|---|---|---|---|---|
| Keşif Dronu | 60 | 110 | 0 | 5 | 1 | Temel düşman |
| Sürü | 25 | 170 | 0 | 3 | 1 | Kalabalık, hızlı, zayıf |
| Zırhlı Kruvazör | 300 | 60 | 10 | 20 | 3 | Zırh her vuruştan sabit hasar düşer (en az 1 hasar geçer) |

Tablodaki canlar 1. dalga değerleridir; düşman canı her dalgada %15 artar (12. dalgada 2.65 kat).

## Ekonomi ve zorluk

- Başlangıç: 20 can, 100 para
- Gelir: öldürme ödülleri + her dalga sonunda **15 + 5 × dalga numarası** bonus
- Can artışı `WaveManager.health_growth_per_wave`, bonus `main.gd` içindeki sabitlerden ayarlanır

### Denge simülasyonu

`tools/balance_sim.gd` oyunu farklı oyuncu stratejileriyle baştan sona oynar. Proje klasöründe:

```
godot --headless --fixed-fps 60 --quit-after 120000 --path . --script tools/balance_sim.gd -- karma
```

Güncel sonuçlar ve hedefler:

| Strateji | Oynayış | Sonuç | Hedef |
|---|---|---|---|
| `hic` | Kule dikmez | 3. dalgada kayıp | Erken kaybetmeli |
| `nova_yukselt` | Sadece Nova + yükseltme | 5. dalgada kayıp | Tek tip kule yetmemeli |
| `plazma_yukselt` | Sadece Plazma + yükseltme | 8. dalgada kayıp | Tek tip kule yetmemeli |
| `foton` | Sadece 1. seviye Foton | 9. dalgada kayıp | Orta dalgalarda kaybetmeli |
| `foton_yukselt` | Sadece Foton + yükseltme | 11. dalgada kayıp | Son dalgalarda zorlanmalı |
| `karma` | 4 kuleyi planlı kullanır | Zafer, 14 can | Biraz can kaybederek kazanmalı |

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
  effects/     Patlama ve dalga halkası efekti
  waves/       Dalga tablosu (wave_table.gd) ve dalga yöneticisi
  ui/          Üst bar, dalga afişi, bildirimler, inşa ve kule menüleri, duraklatma/sonuç ekranı
resources/
  ui/          Carina teması (carina_theme.tres) — tüm panel ve butonların görünümü
  enemies/     Düşman değerleri (.tres) — denge ayarı buradan
  towers/      Kule değerleri (.tres)
```
