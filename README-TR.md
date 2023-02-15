# Zram Generator

Bu proje sizin için **deneysel** bir zram oluşturmak üzere tasarlanmıştır.

Grafik arayüz ALPHA versiyonundadır. İşlem başladığında bir bash açılmaz, arka planda işlenir, bu nedenle kontrol etmenin en kolay yolu "systemctl status zram-manual-script" kontrol etmektir. Hatırlanması gereken şey, eğer sisteminiz systemd kullanıyorsa çalışacaktır.

# Gereksinimler

`bash`,`systemd` ve `pkexec` sisteminizde kurulu ve aktif olmalıdır.
