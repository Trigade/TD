# Carinae

Eta Carinae yörüngesindeki araştırma istasyonunu, Carina Nebulası'ndan gelen düşman dalgalarına karşı savunduğun bir tower defense oyunu. Godot 4 ile geliştiriliyor.

## Çalıştırma

Godot 4.7 ile `project.godot` dosyasını aç ve **F5**'e bas.

## Oyun akışı

Ana menü → **Oyna** → bölüm seç → zorluk seç → oyun. Harita açılınca dalgalar beklemededir:
oyuncu **Dalgayı başlat** diyene kadar düşman gelmez. İlk dalgadan sonra sonraki dalgalar aralarda
geri sayımla gelir ve erken çağrılabilir. Duraklatma ve sonuç ekranlarından **Bölüm seç** ile geri dönülür.

### Bölümler ve zorluk

| Bölüm | Yol | Dalga | Karakter | Ek para | Düşman / boss canı |
|---|---|---|---|---|---|
| 1. Eta Yörüngesi | 3280 px | 13 | Dengeli giriş | — | ×1.0 / ×1.0 |
| 2. Nebula Geçidi | 3140 px | 13 | Zırhlılar erken gelir | +100 | ×1.1 / ×1.0 |
| 3. Kıvrım Kuşağı | 4760 px | 13 | Sürü ve kuluçka akını | +60 | ×1.45 / ×1.45 |
| 4. Toz Sütunları | 3880 px | 13 | Zırhlı kruvazör filoları | +100 | ×1.05 / ×0.95 |
| 5. Eta'nın Kalbi | 6320 px | 15 | 9. dalgada boss, finalde iki boss | +150 | ×1.75 / ×1.3 |

Bölüm çarpanları zorluk çarpanıyla birlikte uygulanır (`LevelData.enemy_health_multiplier`,
`boss_health_multiplier`). Boss çarpanı ayrıdır; aksi halde istasyona ulaşan boss oyunu anında
bitirdiği için bölümün zorluğu "ya hep ya hiç" oluyordu.

| Zorluk | Can | Para | Düşman canı |
|---|---|---|---|
| Kolay | 30 | 150 | ×0.8 |
| Normal | 20 | 100 | ×1.0 |
| Zor | 18 | 100 | ×1.1 |

Her bölüm, bir öncekinden en az 1 yıldız alınınca açılır.

### Seçenekler

Ana menüden ve duraklatma ekranından açılır. Ana ses, müzik ve efekt seviyeleri ile tam ekran
ayarı `user://settings.cfg` dosyasına kaydedilir ve açılışta uygulanır. Sesler `default_bus_layout.tres`
içindeki **Master / Music / SFX** yollarına bağlanır; ses dosyaları eklendiğinde ayarlar hazır olacak.

### Yıldızlar

Kalan canın oranına göre: %90 ve üstü 3 yıldız, %50 ve üstü 2 yıldız, kazanmak 1 yıldız.
Her bölüm-zorluk çifti için en iyi sonuç `user://progress.cfg` dosyasına kaydedilir.

## Kontroller

Oyun sadece sol tık ve ESC ile oynanır (MacBook trackpad dostu).

- **Sol tık:** Boş kule noktasına tıkla → kule inşa et. Kurulu kuleye tıkla → yükselt veya sat.
- **ESC:** Açık menüyü kapatır; menü yoksa oyunu duraklatır; duraklatma ekranında oyuna döner.
- **Duraklat** (sağ üst): ESC ile aynı duraklatma ekranı; oradan **Seçenekler** açılabilir.
- **2x** (sağ üst): Basılıyken oyun iki kat hızlı akar.
- **Dalgayı başlat** (sağ üst): Oyun açıldığında ilk dalga beklemededir; kuleleri kurduktan sonra bu butonla başlatırsın.
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
| Kuluçka | 160 | 75 | 2 | 5 | 2 | Ölünce yerinde 4 Sürü çıkar (aynı dalga gücüyle) |
| **Eta Canavarı** (boss) | 2000 | 32 | 8 | 250 | 50 | 7 sn'de bir EMP yayar: 260 px içindeki kuleler 2.5 sn ateş edemez. Ekranda ayrı can çubuğu vardır. |

Tablodaki canlar 1. dalga değerleridir; düşman canı her dalgada %16 artar (13. boss dalgasında 2.92 kat).
Oyun 13 dalgadır; 13. dalga Eta Canavarı ve eskortlarından oluşan **boss dalgasıdır**.

## Ekonomi ve zorluk

- Başlangıç: 20 can, 100 para
- Gelir: öldürme ödülleri + her dalga sonunda **15 + 5 × dalga numarası** bonus
- Can artışı `WaveManager.health_growth_per_wave`, bonus `main.gd` içindeki sabitlerden ayarlanır

### Denge simülasyonu

`tools/balance_sim.gd` oyunu farklı oyuncu stratejileriyle baştan sona oynar. Proje klasöründe:

```
godot --headless --fixed-fps 60 --quit-after 120000 --path . --script tools/balance_sim.gd -- karma
```

Stratejiden sonra geçici ayar verilebilir:
`level=2 difficulty=zor boss_hp=1800 growth=0.16 lives=18 money_bonus=100`.
Kule noktaları yolu kapsama oranına göre sıralandığı için aynı plan her haritada çalışır.

Güncel sonuçlar (kalan can / kaybedilen dalga):

| Strateji | Bölüm 1 Kolay | Bölüm 1 Normal | Bölüm 1 Zor | Bölüm 2 Normal | Bölüm 2 Zor |
|---|---|---|---|---|---|
| `hic` (kulesiz) | — | 3. dalga | — | 2. dalga | — |
| `nova_yukselt` (tek tip) | — | 7. dalga | — | — | — |
| `foton_yukselt` (tek tip) | — | 11. dalga | — | 12. dalga | — |
| `karma` (önce Foton) | 30 can | 17 can | 10. dalga | 2 can | 8. dalga |
| `karma_plazma` (erken Plazma) | 30 can | 17 can | 5 can | 19 can | 17 can |

Hedef tutmuş sayılır: tek tip kule hiçbir bölümü bitiremiyor, Normal iyi oyunla kazanılıyor,
Zor ise ancak zırhlılara erken hazırlanan planla geçiliyor.
Simülasyon sonunda boss.un kalan canını ve istasyona sızan düşmanları da yazar.

Tüm bölümler, Normal zorluk (kalan can / kaybedilen dalga):

| Strateji | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| `karma` (önce Foton) | 17 can | 8. dalga | 13. dalga (boss) | 5. dalga | 14. dalga |
| `karma_plazma` (erken Plazma) | 17 can | 19 can | 11 can | 11 can | 10 can |

Kolay'da önce Foton diken plan da 3, 4 ve 5. bölümleri kazanır. Zor'da 3–5. bölümleri sabit
planlar geçemiyor; bu bölümler haritaya göre kule seçmeyi (ör. 3. bölümde Nova) gerektiren uzman seviyesidir.

## Klasör yapısı

```
scenes/        Sahneler (.tscn)
  levels/      Bölüm haritaları (yol, kule noktaları, istasyon)
  map/         Harita parçaları (kule noktası vb.)
  enemies/     Düşman sahnesi
  towers/      Kule ve mermi sahneleri
  ui/          Arayüz ve inşa menüsü
scripts/       GDScript kodları
  core/        Game singleton.ı, LevelData ve DifficultyData
  map/         Arka plan, yol, kule noktası, istasyon
  enemies/     Düşman davranışı ve EnemyData
  towers/      Kule, mermi ve TowerData
  effects/     Patlama ve dalga halkası efekti
  waves/       Bölüm dalga tabloları (level_01_waves.gd, level_02_waves.gd) ve dalga yöneticisi
  ui/          Üst bar, dalga afişi, bildirimler, inşa ve kule menüleri, duraklatma/sonuç ekranı
resources/
  levels/      Bölüm tanımları (.tres)
  difficulties/ Zorluk tanımları (.tres)
  ui/          Carina teması (carina_theme.tres) — tüm panel ve butonların görünümü
  enemies/     Düşman değerleri (.tres) — denge ayarı buradan
  towers/      Kule değerleri (.tres)
```
