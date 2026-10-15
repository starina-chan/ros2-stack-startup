# ros2-stack-startup

A set of systemd templates that start your robot's ROS 2 stack at boot with no login, bring up the CAN bus, restart the stack if it crashes, and stop it cleanly.

The included files are an example for an AgileX LIMO and an AgileX SCOUT Mini. Edit them to fit your robot.

| File                     | Installed to                                  | Purpose                                                                                                              |
| ------------------------ | --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `stack_startup.sh`       | `/usr/local/bin/stack_startup.sh`             | Shell script that runs your launch files in order (example: LIMO bringup, rosbridge and Nav2)                        |
| `stack_startup.service`  | `/etc/systemd/system/stack_startup.service`   | Systemd service that runs `stack_startup.sh` as your user once the network is online (example: `agilex`)             |
| `80-can-bringup.network` | `/etc/systemd/network/80-can-bringup.network` | Brings up `can0` at 500 kbit/s at boot and recovers from bus-off after 100 ms (optional, example: AgileX SCOUT Mini) |

## Installation

Installs as a system-wide service in `/etc/systemd/system`. Run these from the repo root:

```bash
sudo cp stack_startup.sh /usr/local/bin/stack_startup.sh
sudo cp stack_startup.service /etc/systemd/system/stack_startup.service
sudo systemctl daemon-reload
sudo systemctl enable --now stack_startup.service
```

### CAN bus (optional)

Only needed if your robot talks over CAN. The file is read by `systemd-networkd`, which is disabled by default on Ubuntu, so enable it too:

```bash
sudo cp 80-can-bringup.network /etc/systemd/network/80-can-bringup.network
sudo systemctl enable --now systemd-networkd
```

`systemd-networkd` only manages interfaces matched by a `.network` file, so it won't interfere with NetworkManager.

`RestartSec=100ms` restarts `can0` automatically 100 ms after it goes bus-off (too many bus errors), so the robot recovers without a reboot.

## Features

- Runs your ROS 2 launch files automatically at boot
- Waits for the network to be online before starting
- Restarts the stack on failure after 5 seconds
- Stops cleanly with `SIGINT`, like pressing Ctrl+C
- Optionally brings up the CAN bus at boot

## Usage

```bash
# check status
systemctl status stack_startup.service

# check logs
journalctl -u stack_startup.service -f

# restart service
sudo systemctl restart stack_startup.service

# start service
sudo systemctl start stack_startup.service

# stop service
sudo systemctl stop stack_startup.service
```
