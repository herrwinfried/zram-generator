# Zram Generator

Bu proje sizin için **deneysel** bir zram oluşturmak üzere tasarlanmıştır.

Grafik arayüz ALPHA versiyonundadır. İşlem başladığında bir bash açılmaz, arka planda işlenir, bu nedenle kontrol etmenin en kolay yolu "systemctl status zram-manual-script" kontrol etmektir. Hatırlanması gereken şey, eğer sisteminiz systemd kullanıyorsa çalışacaktır.

## Çalıştırmak

Dosyayı indirdiğinizde uygulamanın yazma izni olmayabilir, bu nedenle uygulamaya çalışması için izin verin. Terminal üzerinden yapmak istiyorsanız `sudo chmod +x ./Zram_Generator-x86_64.AppImage` komutunu kullanarak çalıştırma izni verin.

# Gereksinimler

`bash`,`systemd` ve `pkexec` sisteminizde kurulu ve aktif olmalıdır.
