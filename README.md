# iot-object-workshop-monitoring

The service provide an efficient way to collect photo and audio
in real-time from a camera and microphone. Another repository contains the server-side
application which controls the service and every connected object.

## Setup

### Manual installation
#### Requirements

- FFMPEG
[Tutorial for Raspberry Pi](http://jollejolles.com/installing-ffmpeg-with-h264-support-on-raspberry-pi/)
- Python3

#### Commands
```$bash
cd /usr/local/bin
sudo git clone https://github.com/dylandelaporte/iot-objet-workshop-monitoring.git

cd iot-object-workshop-monitoring

sudo cp monitoring-sd.service /etc/systemd/system
sudo systemctl enable monitoring-sd

sudo cp monitoring-sd-config.service /etc/systemd/system
sudo systemctl enable monitoring-sd-config

sudo reboot
```

### Package installation
```$bash
wget https://github.com/dylandelaporte/iot-objet-workshop-monitoring/releases/download/1.0.0/object.deb
dpkg -i object.deb
```

### Configuration

Update the following file: `/usr/local/bin/iot-objet-workshop-monitoring/soft-config.yml`

#Timezones
https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
