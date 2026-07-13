# 📈 Gelir ve Refah Analizörü (Preston Curve Analyzer)

Bu platform, ülkelerin kişi başına düşen güncel gelir düzeyleri ile yaşam beklentileri arasındaki ekonometrik ilişkiyi ampirik olarak incelemek ve **Preston Eğrisi** hipotezini test etmek amacıyla **R Shiny** framework'ü kullanılarak SaaS mimarisinde geliştirilmiş interaktif bir veri analizi ve görselleştirme sistemidir.

🚀 **Canlı Uygulama Linki:** [Gelir ve Refah Analizörü](https://receptanii.shinyapps.io/gelir-ve-refah-analizatoru/)

---

## 🔬 İstatistiki ve Teknik Altyapı

Platform, sisteme yüklenen veri setleri üzerinde eş zamanlı olarak şu analitik süreçleri yürütmektedir:
* **Dinamik Veri Görselleştirme:** Ülkelerin yıllara sari gelişimini interaktif kabarcık (Bubble) ve trend grafikleriyle izleme.
* **Korelasyon Analizi:** Doğrusal ve logaritmik dönüşümlü korelasyon katsayılarının hesaplanması.
* **Ekonometrik Modelleme:** Logaritmik regresyon modelleri üzerinden R-Kare (açıklayıcılık oranı) tespiti ve Preston Eğrisi hipotezinin otomatik istatistiksel yorumlanması.

## 📊 Örnek Veri Seti Entegrasyonu

Uygulamanın test edilebilmesi için güncel verilerden oluşan bir örnek veri seti sistem mimarisine entegre edilmiştir. Repoda yer alan `refah_analizi_ornek_veri.xlsx` dosyası, platform üzerindeki indirme butonu vasıtasıyla doğrudan indirilip sisteme yüklenebilmektedir.

---
*Bu yazılım platformunun tüm mimari tasarımı, kodlaması ve istatistiksel modelleme altyapısı **Recep Semih Tanı**'ya aittir. © 2026*
