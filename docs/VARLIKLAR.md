# Carinae — Görsel ve Ses Varlık Listesi

Bu liste, geometrik şekillerin yerine geçecek çizimleri ve oyuna eklenecek sesleri tanımlar.
**Öncelik** sütunu: **1** = oyunun hissini en çok değiştirenler (önce bunlar), **2** = sonra, **3** = olursa güzel.

Hazırladığın dosyaları aşağıdaki klasör ve isimlerle `assets/` altına koyarsan oyuna bağlamak kolay olur.
İsimleri değiştirmen gerekirse sorun değil, bana listeyi söylemen yeterli.

---

## Genel kurallar

### Çizimler
- **Format:** PNG, **şeffaf arka plan**
- **Bakış açısı:** Tam yukarıdan (top-down)
- **Yön:** Dönen her şey (namlular, düşmanlar, mermiler) **sağa bakacak** şekilde çizilmeli (0°). Oyun kendisi döndürür.
- **Boyutlar:** Aşağıdakiler önerilen boyutlardır; oyun ekranda küçültür. Daha büyük çizip küçültmek kaliteyi artırır, ama oranı koru.
- **Stil:** Carina Nebulası teması — koyu uzay, turuncu/pas tozu, turkuaz iyonize gaz, macenta. Kuleler **soğuk/parlak** (turkuaz, yeşil, altın, mor), düşmanlar **sıcak** (kırmızı, turuncu, pembe) renklerde olursa ekranda kolay ayırt edilir.

### Sesler
- **Efektler:** WAV (veya OGG), 44.1 kHz, mono, mümkünse 1 saniyeden kısa
- **Müzik:** OGG, 44.1 kHz, stereo, **kesintisiz döngü** yapabilecek şekilde (sonu başına bağlanmalı)
- **Seviye:** Tepe noktası -1 dB'yi geçmesin; efektlerin birbirine göre ses seviyesi yakın olsun
- Sık çalan sesler (foton atışı, vurulma) **kısa ve yumuşak** olmalı, yoksa kulak yorar. Aynı sesin 2–3 hafif farklı versiyonu varsa (ör. `photon_shot_1/2/3`) oyun rastgele seçer ve tekrar hissi azalır.

---

## 1. Çizimler

### 1.1 Kuleler — `assets/sprites/towers/`

Her kule için **taban** ve **namlu** ayrı çizilir: taban sabit durur, namlu hedefe döner.
3 seviye görsel olarak ayırt edilebilmeli (büyüyen namlu, ek parçalar, daha parlak ışıklar vb.).

| Dosya | Boyut | Açıklama | Öncelik |
|---|---|---|---|
| `photon_1_base.png` … `photon_3_base.png` | 128×128 | Foton Tareti tabanı (turkuaz, kare gövde) | 1 |
| `photon_1_turret.png` … `photon_3_turret.png` | 128×128 | İnce, hızlı namlu; merkez noktası görselin ortasında | 1 |
| `plasma_1_base.png` … `plasma_3_base.png` | 128×128 | Plazma Topu tabanı (yeşil, altıgen, ağır görünümlü) | 1 |
| `plasma_1_turret.png` … `plasma_3_turret.png` | 128×128 | Kalın, kısa top namlusu | 1 |
| `nova_1_base.png` … `nova_3_base.png` | 128×128 | Nova Havanı tabanı (altın, sekizgen) | 1 |
| `nova_1_turret.png` … `nova_3_turret.png` | 128×128 | Geniş ağızlı havan namlusu | 1 |
| `gravity_1.png` … `gravity_3.png` | 128×128 | Yerçekimi Kuyusu (mor, namlusuz); ortada dönen bir çekirdek hissi | 1 |
| `gravity_core.png` | 64×64 | Kuyunun ortasında sürekli dönecek çekirdek (opsiyonel ayrı parça) | 3 |

### 1.2 Düşmanlar — `assets/sprites/enemies/`

Sağa bakacak şekilde. İstersen 2–4 karelik hareket animasyonu (ör. `scout_1.png`, `scout_2.png`) yapabilirsin; tek kare de yeterli.

| Dosya | Boyut | Açıklama | Öncelik |
|---|---|---|---|
| `scout.png` | 64×64 | Keşif Dronu — küçük, hızlı, üçgenimsi keşif gemisi | 1 |
| `swarm.png` | 40×40 | Sürü — çok küçük, böceğimsi dron | 1 |
| `cruiser.png` | 96×96 | Zırhlı Kruvazör — kalın zırh plakalı, yavaş, iri gemi | 1 |
| `brood.png` | 80×80 | Kuluçka — içinde sürüler taşıyan, kabarık/organik görünümlü gemi | 1 |
| `boss_eta.png` | 192×192 | Eta Canavarı (boss) — dev, tehditkâr; ortasında EMP yayan parlayan bir çekirdek | 1 |
| `boss_eta_core.png` | 96×96 | Boss çekirdeği, ayrı çizilirse dönerek parlar | 3 |

### 1.3 Mermiler ve efektler — `assets/sprites/effects/`

| Dosya | Boyut | Açıklama | Öncelik |
|---|---|---|---|
| `photon_bolt.png` | 32×12 | Foton mermisi — ince turkuaz ışık çizgisi | 2 |
| `plasma_bolt.png` | 48×20 | Plazma mermisi — kalın yeşil enerji topu | 2 |
| `nova_shell.png` | 32×32 | Nova mermisi — altın renkli yuvarlak mermi | 2 |
| `explosion_01.png` … `explosion_08.png` | 128×128 | Patlama animasyonu, 8 kare | 2 |
| `death_small_01.png` … `death_small_06.png` | 64×64 | Küçük düşman ölüm patlaması, 6 kare | 2 |
| `muzzle_flash.png` | 48×48 | Namlu parlaması | 3 |
| `emp_ring.png` | 256×256 | Boss EMP dalgası halkası (oyun büyütür) | 3 |
| `slow_ring.png` | 64×64 | Yavaşlatılmış düşmanın etrafındaki mor halka | 3 |
| `spark.png` | 16×16 | Genel kıvılcım/parçacık | 3 |

### 1.4 Harita — `assets/sprites/maps/`

| Dosya | Boyut | Açıklama | Öncelik |
|---|---|---|---|
| `level_01_background.png` | 1920×1080 | 1. bölüm arka planı. **Yol çizmeden** sadece uzay/nebula | 1 |
| `level_02_background.png` | 1920×1080 | 2. bölüm arka planı, farklı renk tonunda nebula | 2 |
| `path_tile.png` | 128×128 | Yol dokusu, kenarları birbirine **kesintisiz eklenebilir** (tileable) | 2 |
| `tower_slot.png` | 96×96 | Boş kule noktası (inşa platformu) | 1 |
| `tower_slot_hover.png` | 96×96 | Üzerine gelinmiş hali (daha parlak) | 2 |
| `station.png` | 256×256 | Eta Carinae araştırma istasyonu (savunulan hedef) | 1 |

> İstersen yolu ayrı doku yerine doğrudan arka plan çizimine de işleyebilirsin; o durumda sana her bölümün yol koordinatlarını gönderirim.

### 1.5 Arayüz — `assets/sprites/ui/`

| Dosya | Boyut | Açıklama | Öncelik |
|---|---|---|---|
| `logo.png` | 1024×400 | Ana menüdeki "CARINAE" logosu | 1 |
| `icon.png` | 1024×1024 | Oyun/uygulama ikonu | 1 |
| `menu_background.png` | 1920×1080 | Ana menü arka planı (logo ayrı) | 2 |
| `level_01_preview.png`, `level_02_preview.png` | 480×270 | Bölüm seçme ekranındaki önizleme resimleri | 2 |
| `icon_lives.png` | 64×64 | Can ikonu | 2 |
| `icon_money.png` | 64×64 | Para ikonu | 2 |
| `icon_wave.png` | 64×64 | Dalga ikonu | 2 |
| `star_full.png`, `star_empty.png` | 64×64 | Dolu / boş yıldız | 1 |
| `icon_lock.png` | 64×64 | Kilitli bölüm | 2 |
| `icon_speed.png` | 64×64 | 2x hız | 3 |
| `icon_pause.png` | 64×64 | Duraklat | 3 |
| `panel.png` | 64×64 | Panel arka planı, **9-slice** (köşeleri bozulmadan esneyecek) | 3 |
| `button_normal.png`, `button_hover.png`, `button_pressed.png`, `button_disabled.png` | 64×64 | Buton arka planları, 9-slice | 3 |

**Yazı tipi (opsiyonel):** Türkçe karakterleri (ç ğ ı İ ö ş ü) destekleyen, ücretsiz lisanslı (OFL) bir bilim kurgu fontu seçebilirsin — ör. *Exo 2*, *Orbitron* (başlıklar için), *Rajdhani*. TTF/OTF dosyası yeterli.

---

## 2. Sesler

### 2.1 Kuleler — `assets/audio/sfx/towers/`

| Dosya | Açıklama | Öncelik |
|---|---|---|
| `photon_shot.wav` | Foton atışı — çok kısa, hafif "pew"; saniyede 3–4 kez çalar | 1 |
| `plasma_shot.wav` | Plazma atışı — derin, dolgun enerji patlaması | 1 |
| `nova_launch.wav` | Nova fırlatma — boğuk "tümp" | 1 |
| `nova_explosion.wav` | Nova patlaması — orta büyüklükte patlama | 1 |
| `gravity_pulse.wav` | Yerçekimi dalgası — alçak frekanslı "vuuum" | 1 |

### 2.2 Düşmanlar — `assets/audio/sfx/enemies/`

| Dosya | Açıklama | Öncelik |
|---|---|---|
| `enemy_hit.wav` | Vurulma — çok kısa metalik tık (çok sık çalar, çok hafif olmalı) | 2 |
| `enemy_death_small.wav` | Keşif dronu / sürü ölümü — küçük patlama | 1 |
| `enemy_death_large.wav` | Kruvazör / kuluçka ölümü — büyük patlama | 1 |
| `brood_split.wav` | Kuluçka bölünmesi — kabuk çatlaması + sürülerin çıkışı | 2 |
| `station_hit.wav` | Düşman istasyona ulaştı — kısa alarm/darbe (can kaybı) | 1 |

### 2.3 Boss — `assets/audio/sfx/boss/`

| Dosya | Açıklama | Öncelik |
|---|---|---|
| `boss_warning.wav` | Boss dalgası başlarken uyarı sireni (2–3 sn) | 1 |
| `boss_emp.wav` | EMP dalgası — elektrik boşalması, "bzzzt" | 1 |
| `boss_death.wav` | Boss ölümü — uzun, büyük patlama (2–3 sn) | 1 |
| `tower_disabled.wav` | Kule EMP ile devre dışı kaldı — kısa "güç kesildi" sesi | 2 |

### 2.4 Oyun akışı — `assets/audio/sfx/game/`

| Dosya | Açıklama | Öncelik |
|---|---|---|
| `tower_build.wav` | Kule inşası — mekanik kurulma sesi | 1 |
| `tower_upgrade.wav` | Yükseltme — yükselen, olumlu ton | 1 |
| `tower_sell.wav` | Satış — para/jeton sesi | 1 |
| `not_enough_money.wav` | Yetersiz para — kısa, yumuşak hata sesi | 2 |
| `wave_start.wav` | Dalga başlangıcı — kısa uyarı/boru | 1 |
| `wave_cleared.wav` | Dalga temizlendi — kısa olumlu ton | 2 |
| `early_call.wav` | Dalgayı erken çağırma | 3 |
| `victory.wav` | Zafer müziği (3–5 sn jingle) | 1 |
| `defeat.wav` | Yenilgi müziği (3–5 sn jingle) | 1 |
| `star_1.wav`, `star_2.wav`, `star_3.wav` | Sonuç ekranında yıldızlar tek tek dolarken, her biri bir ton yukarı | 2 |

### 2.5 Arayüz — `assets/audio/sfx/ui/`

| Dosya | Açıklama | Öncelik |
|---|---|---|
| `button_hover.wav` | Butonun üzerine gelme — çok hafif | 3 |
| `button_click.wav` | Buton tıklama | 2 |
| `menu_open.wav` | Menü/panel açılma | 3 |
| `menu_close.wav` | Menü/panel kapanma | 3 |

### 2.6 Müzik — `assets/audio/music/`

| Dosya | Süre | Açıklama | Öncelik |
|---|---|---|---|
| `menu_theme.ogg` | 1–2 dk döngü | Ana menü — sakin, gizemli, uzay ambiyansı | 1 |
| `battle_theme.ogg` | 2–3 dk döngü | Oyun içi — ritmik ama dikkat dağıtmayan | 1 |
| `boss_theme.ogg` | 1–2 dk döngü | Boss dalgası — gergin, yoğun | 2 |

---

## Özet

| Kategori | Öncelik 1 | Toplam |
|---|---|---|
| Kule çizimleri | 21 | 22 |
| Düşman çizimleri | 5 | 6 |
| Mermi/efekt çizimleri | 0 | 9 kalem (animasyon kareleriyle ~22 dosya) |
| Harita çizimleri | 3 | 6 |
| Arayüz çizimleri | 4 | 14 kalem |
| Ses efektleri | 17 | 29 kalem |
| Müzik | 2 | 3 |

**Başlamak için önerim:** Önce 1. öncelikli **kuleler, düşmanlar, istasyon, kule noktası, 1. bölüm arka planı** ve 1. öncelikli **sesler**. Bunlar geldiğinde oyunun görünümü ve hissi büyük ölçüde değişir; geri kalanını adım adım ekleriz.
