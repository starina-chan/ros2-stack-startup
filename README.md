# ros2-stack-startup

System-wide systemd service that starts a robot's ROS 2 stack at boot, without anyone needing to log in.

The included files are an example for an AgileX LIMO. Edit them to fit your robot.

| File                    | Installed to                                | Purpose                                                                                                  |
| ----------------------- | ------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `stack_startup.sh`      | `/usr/local/bin/stack_startup.sh`           | Shell script that runs your launch files in order (example: LIMO bringup, rosbridge and Nav2)            |
| `stack_startup.service` | `/etc/systemd/system/stack_startup.service` | Systemd service that runs `stack_startup.sh` as your user once the network is online (example: `agilex`) |

## Installation

Installs as a system-wide service in `/etc/systemd/system`. Run these from the repo root:

```bash
sudo cp stack_startup.sh /usr/local/bin/stack_startup.sh
sudo cp stack_startup.service /etc/systemd/system/stack_startup.service
sudo systemctl daemon-reload
sudo systemctl enable --now stack_startup.service
```

## Features

- Runs your ROS 2 launch files automatically at boot
- Waits for the network to be online before starting
- Restarts the stack on failure after 5 seconds
- Stops cleanly with `SIGINT`, like pressing Ctrl+C

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
