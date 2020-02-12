#
# launcher: main script that communicates with remote server, starts data collecting process
# Author: Dylan Delaporte
# Github: https://github.com/DylanDelaporte

import threading
import requests
import json
import subprocess
import os
import yaml
import getmac
import logging

DIR_PATH = os.path.dirname(os.path.realpath(__file__))

os.chdir(DIR_PATH)

# log file
logging.basicConfig(filename="/var/log/monitoring-sd.log", level=logging.DEBUG)

config = {}
record = False

recording = False
backing_up = False


# each x seconds contacts the server to know what action to take
def ping_server():
    global PING_TIMER
    global PING_URL

    global MAC_ADDRESS

    global DATA_DIRECTORY
    global TEMPORARY_DIRECTORY

    global config
    global record

    global recording
    global backing_up

    logging.info("Ping server at {} from {}".format(PING_URL, MAC_ADDRESS))

    threading.Timer(PING_TIMER, ping_server).start()

    try:
        r = requests.post(url=PING_URL, data={"mac": MAC_ADDRESS})

        logging.debug("response from server: " + r.text)

        response = json.loads(r.text)

        config = response["config"]
        record = response["record"]
    except:
        logging.error("Request error during ping to server")

    if record:
        if not recording:
            recording = True
            backing_up = True

            logging.info("start recording")

            subprocess.Popen(["sudo", "record/video_start.sh", DATA_DIRECTORY, TEMPORARY_DIRECTORY])
            subprocess.Popen(["sudo", "record/microphones_start.sh", DATA_DIRECTORY, TEMPORARY_DIRECTORY])

            backup_data()

        logging.debug("recording")
    else:
        if recording:
            recording = False
            backing_up = False

            logging.info("stop recording")

            subprocess.Popen(["sudo", "record/video_stop.sh"])
            subprocess.Popen(["sudo", "record/microphones_stop.sh"])

        logging.debug("not recording")


# each x second, when the data collecting system is being used backup files into a zip file and upload it to the server
def backup_data():
    global BACKUP_TIMER
    global BACKUP_URL

    global MAC_ADDRESS

    global DATA_DIRECTORY
    global BACKUP_DIRECTORY
    global TEMPORARY_DIRECTORY

    logging.info("Backup data to server at {}".format(BACKUP_URL))

    logging.debug("backing_up: " + str(backing_up))

    if backing_up:
        threading.Timer(BACKUP_TIMER, backup_data).start()

        process = subprocess.Popen(
            "backup/backup.sh " + DATA_DIRECTORY + " " + BACKUP_DIRECTORY + " " + TEMPORARY_DIRECTORY, shell=True,
            stdout=subprocess.PIPE)
        (output, error) = process.communicate()
        process.wait()

        logging.debug(output)

        for entry in os.scandir(BACKUP_DIRECTORY):
            path_to_backup = BACKUP_DIRECTORY + "/" + entry.name

            if os.path.exists(path_to_backup):
                logging.info("Zip file {}".format(path_to_backup))

                with open(path_to_backup, "rb") as f:
                    requests.post(url=BACKUP_URL, data={"mac": MAC_ADDRESS}, files={"zipFile": f})
                    os.remove(path_to_backup)


try:
    logging.info("starting service")

    # read of the configuration file containing information of directory paths
    with open("hard-config.yml", 'r') as hard_config_file:
        hard_config = yaml.load(hard_config_file, Loader=yaml.FullLoader)

    DATA_DIRECTORY = hard_config["data_directory"]
    BACKUP_DIRECTORY = hard_config["backup_directory"]
    TEMPORARY_DIRECTORY = hard_config["temporary_directory"]

    if not os.path.exists(DATA_DIRECTORY):
        os.mkdir(DATA_DIRECTORY)

    if not os.path.exists(BACKUP_DIRECTORY):
        os.mkdir(BACKUP_DIRECTORY)

    if not os.path.exists(TEMPORARY_DIRECTORY):
        os.mkdir(TEMPORARY_DIRECTORY)

    # read of the configuration file containing information of the remote server
    with open("soft-config.yml", 'r') as soft_config_file:
        soft_config = yaml.load(soft_config_file, Loader=yaml.FullLoader)

    PING_URL = soft_config["ping_url"]
    PING_TIMER = soft_config["ping_timer"]

    BACKUP_URL = soft_config["backup_url"]
    BACKUP_TIMER = soft_config["backup_timer"]

    TIME_ZONE = soft_config["time_zone"]
    NTP_SERVER = soft_config["ntp_server"]

    MAC_ADDRESS = getmac.get_mac_address(interface="eth0")

    logging.info(str({"data_directory": DATA_DIRECTORY,
                      "backup_directory": BACKUP_DIRECTORY,
                      "ping_url": PING_URL,
                      "ping_timer": PING_TIMER,
                      "backup_url": BACKUP_URL,
                      "backup_timer": BACKUP_TIMER,
                      "mac_address": MAC_ADDRESS,
                      "time_zone": TIME_ZONE,
                      "ntp_server": NTP_SERVER}))

    # to ensure accurate timestamp the device is update with last timezone and date
    update_time_zone_process = subprocess.Popen(["sudo", "cp", "/usr/share/zoneinfo/" + TIME_ZONE, "/etc/localtime"],
            stdout=subprocess.PIPE)

    (update_time_zone_process_output, update_time_zone_process_error) = update_time_zone_process.communicate()
    update_time_zone_process.wait()

    logging.info(update_time_zone_process_output)

    update_ntp_process = subprocess.Popen(["sudo", "ntpdate", NTP_SERVER],
            stdout=subprocess.PIPE)

    (update_ntp_process_output, update_ntp_process_error) = update_ntp_process.communicate()
    update_ntp_process.wait()

    logging.info(update_ntp_process_output)

    ping_server()
except Exception as e:
    logging.error("Error")
    logging.error(e)
