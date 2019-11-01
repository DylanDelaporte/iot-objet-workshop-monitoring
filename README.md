# IoT-MonitoringSD

The service provide an efficient way to collect photo and audio
in real-time from a camera and microphone. Another repository contains the server-side
application which controls the service and every connected object.

## Setup

### Requirements ffmpeg

- FFMPEG
[Tutorial for Raspberry Pi](http://jollejolles.com/installing-ffmpeg-with-h264-support-on-raspberry-pi/)
- Python3

### Configure services

```console
cd /usr/local/bin
sudo git clone git@github.com:hiekata-lab/IoT-MonitoringSD.git

sudo cp monitoring-sd.service /etc/systemd/system
sudo systemctl enable monitoring-sd

sudo cp monitoring-sd-config.service /etc/systemd/system
sudo systemctl enable monitoring-sd-config

sudo reboot
```


## Future updates

- Deb package
- GPIO sensors
