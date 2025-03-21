# Test Equipment
This python module allows the user to control the following test equipment via a
USB connection. The test_equipment python module is primarily aimed at providing
an easy way of interfacing with test equipment.

## DC Power Supplies

- HMP2030 PSU
- TENMA 72-2550 PSU
- ETMXXXXP

The psu_ctrl command line tool is installed when this python package is installed.
It is not aimed at being a fully functional tool to control the power supplies but
to provide example code that details how a user may incorporate PSU control into
their applications.

Before using psu_ctrl to control power supplies the configuration must be set using
the 'psu_ctrl -c' command line options. This should be executed with the power supply
connected to the PC. The user should then set parameter 1 to set the power supply
type connected and set parameter 2 to set the PSU connection string.

Once configured the user can turn PSU outputs on/off and set voltages and current
limits.

Command line help is available for the psu_ctrl command line tool as shown below.

```
usage: psu_ctrl.py [-h] [-d] [-c] [-v VOLTS] [-a AMPS] [-o OUTPUT] [--on] [--off] [-r]

A description of what it does.

optional arguments:
  -h, --help            show this help message and exit
  -d, --debug           Enable debugging.
  -c, --config          Configure the PSU parameters.
  -v VOLTS, --volts VOLTS
                        Set PSU voltage (default=3.3).
  -a AMPS, --amps AMPS  Set PSU current limit (default=1.0).
  -o OUTPUT, --output OUTPUT
                        The PSU output to use (default=1).
  --on                  Turn the output on.
  --off                 Turn the output off.
  -r, --read            Read the output current/power.

Supported Power Supplies
Type   Description
0      Dummy PSU
1      HMP2030 PSU
2      TENMA 72-2550 PSU
3      ETMXXXXP
```

# Digital Multimeters

### R&S HM8112-3 Precision Multimeter

The dmm_hm8112 command provides an interface to this meter via a US port.

```
dmm_hm8112 -h
usage: dmm_hm8112 [-h] [-d] [-l] [--port PORT] [-s] [-f FUNCTION] [-p PARAMETER] [-g]

A command line interface to a R&S (Hameg) 8112-3 6.5 digit precision multimeter.

options:
  -h, --help            show this help message and exit
  -d, --debug           Enable debugging.
  -l, --list_args       List the valid commands.
  --port PORT           The serial port to use. If left blank the first serial port found will be used.
  -s, --send            Send a command to the meter.
  -f FUNCTION, --function FUNCTION
                        The required function.
  -p PARAMETER, --parameter PARAMETER
                        The parameter passed to the function.
  -g, --get             Read any data being sent on the serial port.
```

### OWON AC/DC Clamp Ammeter

The cm2100b command provides an interface to this meter via bluetooth.

```
cm2100b -h
usage: cm2100b [-h] [-d] [-m MAC] [-r] [-l]

An interface to the CM2100B current clamp DMM.

options:
  -h, --help         show this help message and exit
  -d, --debug        Enable debugging.
  -m MAC, --mac MAC  The bluetooth MAC address of the CM2100B meter.
  -r, --read         Read values from the CM2100B over bluetooth.
  -l, --list         List bluetooth devices.
```

### Shelly 1PM Plus 16A Smart Metering Switch

This device can be used as test equipment to turn on/off AC mains loads and to measure the voltage and current.

The command line help for this tool is shown below.

```
shelly -h
usage: shelly [-h] [-d] -a ADDRESS [--on] [--off] [-s] [-c] [--volts] [--amps] [-p PORT] [-m MAC] [--reset_cal_v] [--reset_cal_c]

Shelly 1PM Plus device interface.

options:
  -h, --help            show this help message and exit
  -d, --debug           Enable debugging.
  -a ADDRESS, --address ADDRESS
                        The address of the Shelly 1PM Plus unit on the LAN.
  --on                  Turn Shelly 1PM Plus on.
  --off                 Turn Shelly 1PM Plus off.
  -s, --stats           Read the state from the Shelly 1PM Plus unit.
  -c, --calibrate       Perform the Shelly 1PM Plus module calibration. This will update a local config file with the voltage and current offsets for the connected Shelly 1PM Plus module.
  --volts               Only calibrate voltage.
  --amps                Only calibrate amps.
  -p PORT, --port PORT  The serial port to which a R&S 8112-3 Precision Multimeter. This is used to calibrate the AC voltage.
  -m MAC, --mac MAC     The bluetooth MAC address of the OWON CM2100B meter used to read the AC current value. This is used to calibrate the AC current.
  --reset_cal_v         Reset voltage calibration offset to 0.0 volts.
  --reset_cal_c         Reset current calibration offset to 0.0 amps.
```

#### Shelly 1PM Plus Calibration.

If this device is to be used as test equipment it will need to be calibrated. The calibration process requires the following equipment.

- 2kW fan heater.
- R&S HM8112-3 Precision Multimeter to measure the AC voltage.
- OWON AC/DC Clamp Ammeter to measure the current.

The Shelly 1PM Plus should be connected with the fan heater connected to it's output, the 'R&S HM8112-3 Precision Multimeter' should be connected to measure the voltage and the 'OWON AC/DC Clamp Ammeter' should be 'clamped' across the Live wire between the 'Shelly 1PM Plus' unit and the fan heater.

To calibrate the 'Shelly 1PM Plus' you need the following information.

 --mac: The MAC address is the bluetooth MAC address of the 'OWON AC/DC Clamp Ammeter'. The cm2100b -l command can be used to obtain this as shown below.

```
cm2100b -l
INFO:  Scanning for CM2100B bluetooth devices...
INFO:  CM2100B MAC address: A6:C0:80:EF:82:35
```

 -p: This is the USB serial port that the 'R&S HM8112-3 Precision Multimeter' is connected to.

 -a: This is the IP address of the 'Shelly 1PM Plus' module on your WiFi network.

Once you have this information the following command can be used to calibrate the Shelly unit.

```
shelly --mac A6:C0:80:EF:82:35 -p /dev/ttyUSB0 -c -a 192.168.0.36
INFO:  Loaded config from /home/pja/.config/Shelly1PMPlus.cfg
INFO:  Saved config to /home/pja/.config/Shelly1PMPlus.cfg
INFO:  Existing voltage calibration offset = -0.864 volts.
INFO:  Existing current calibration offset = 0.053 amps.
INPUT: Are you sure you wish to overwrite the existing calibration offsets ? [y]/[n]: y
INFO:  Connecting to CM2100B AC/DC Clamp Meter.
INFO:  Connecting to: A6:C0:80:EF:82:35
INFO:  Connected: Took 1.6 seconds.
INFO:  Connected to CM2100B AC/DC Clamp Meter.
INFO:  Saved config to /home/pja/.config/Shelly1PMPlus.cfg
INFO:  shellyplus1pm-e465b8f174b8: Reset the amps calibration offset to 0.0 volts.
INFO:  Load current = 0.00 Amps.
INFO:  Waiting for load current to reach 5 amps.
INFO:  Load current = 1.72 Amps.
INFO:  Waiting for load current to reach 5 amps.
INFO:  Load current = 8.20 Amps.
INFO:  Load current = 8.47 Amps.
INFO:  Load current = 8.48 Amps.
INFO:  Load current = 8.47 Amps.
INFO:  Load current = 8.46 Amps.
INFO:  Load current is stable at 8.46 amps.
INFO:  CM2100B AC Amps = 8.450, Shelly 1PM Plus AC Amps = 8.431, delta=0.0190, secs left = 60
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.431, delta=0.0090, secs left = 59
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.431, delta=0.0090, secs left = 59
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0010, secs left = 59
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 58
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 58
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 57
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.393, delta=0.0270, secs left = 57
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.379, delta=0.0410, secs left = 57
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.379, delta=0.0410, secs left = 56
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.379, delta=0.0410, secs left = 55
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.379, delta=0.0310, secs left = 55
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.372, delta=0.0380, secs left = 54
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.372, delta=0.0380, secs left = 54
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.372, delta=0.0380, secs left = 53
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.372, delta=0.0380, secs left = 53
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.369, delta=0.0410, secs left = 52
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.369, delta=0.0410, secs left = 52
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.369, delta=0.0310, secs left = 52
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.369, delta=0.0310, secs left = 51
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.369, delta=0.0410, secs left = 51
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.366, delta=0.0440, secs left = 50
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.366, delta=0.0440, secs left = 50
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.366, delta=0.0340, secs left = 50
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.366, delta=0.0340, secs left = 49
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.362, delta=0.0380, secs left = 48
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.362, delta=0.0380, secs left = 48
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.362, delta=0.0380, secs left = 47
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.362, delta=0.0380, secs left = 47
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.360, delta=0.0400, secs left = 46
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.360, delta=0.0300, secs left = 46
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.360, delta=0.0300, secs left = 46
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.360, delta=0.0300, secs left = 45
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.350, delta=0.0400, secs left = 45
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.350, delta=0.0400, secs left = 44
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.350, delta=0.0400, secs left = 44
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.350, delta=0.0500, secs left = 43
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.350, delta=0.0500, secs left = 43
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.360, delta=0.0400, secs left = 42
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.360, delta=0.0400, secs left = 42
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.360, delta=0.0300, secs left = 41
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.360, delta=0.0300, secs left = 41
INFO:  CM2100B AC Amps = 8.390, Shelly 1PM Plus AC Amps = 8.354, delta=0.0360, secs left = 40
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.354, delta=0.0460, secs left = 40
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.354, delta=0.0460, secs left = 39
INFO:  CM2100B AC Amps = 8.400, Shelly 1PM Plus AC Amps = 8.354, delta=0.0460, secs left = 39
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.354, delta=0.0560, secs left = 39
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.367, delta=0.0430, secs left = 38
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.367, delta=0.0430, secs left = 38
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.367, delta=0.0430, secs left = 37
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.367, delta=0.0530, secs left = 37
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.377, delta=0.0430, secs left = 36
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.377, delta=0.0330, secs left = 36
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.377, delta=0.0430, secs left = 35
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.377, delta=0.0430, secs left = 35
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.378, delta=0.0320, secs left = 34
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.378, delta=0.0320, secs left = 34
INFO:  CM2100B AC Amps = 8.410, Shelly 1PM Plus AC Amps = 8.378, delta=0.0320, secs left = 33
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.378, delta=0.0420, secs left = 33
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.380, delta=0.0400, secs left = 33
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.380, delta=0.0400, secs left = 32
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.380, delta=0.0400, secs left = 31
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.380, delta=0.0600, secs left = 31
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.380, delta=0.0500, secs left = 31
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 30
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 30
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 29
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 29
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 28
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 28
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 27
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 27
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 26
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 26
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 25
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.391, delta=0.0390, secs left = 25
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.391, delta=0.0390, secs left = 24
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.391, delta=0.0390, secs left = 24
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.391, delta=0.0390, secs left = 23
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 23
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 22
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 22
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 21
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 21
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 20
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 19
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 19
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.391, delta=0.0390, secs left = 19
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.391, delta=0.0390, secs left = 18
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.391, delta=0.0290, secs left = 18
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.391, delta=0.0290, secs left = 17
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.391, delta=0.0390, secs left = 17
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.390, delta=0.0400, secs left = 16
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.390, delta=0.0400, secs left = 16
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.390, delta=0.0400, secs left = 16
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.390, delta=0.0400, secs left = 15
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.392, delta=0.0380, secs left = 14
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.392, delta=0.0380, secs left = 14
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.392, delta=0.0380, secs left = 14
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.392, delta=0.0380, secs left = 13
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 12
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 12
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 11
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 11
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.397, delta=0.0430, secs left = 11
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 10
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 10
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.397, delta=0.0430, secs left = 9
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.397, delta=0.0430, secs left = 9
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.400, delta=0.0400, secs left = 8
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.400, delta=0.0400, secs left = 8
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.400, delta=0.0400, secs left = 7
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.399, delta=0.0410, secs left = 7
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.399, delta=0.0410, secs left = 6
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.399, delta=0.0310, secs left = 6
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.399, delta=0.0310, secs left = 5
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 5
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 4
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.398, delta=0.0420, secs left = 4
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.398, delta=0.0420, secs left = 3
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.398, delta=0.0420, secs left = 3
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 2
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 2
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 1
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.398, delta=0.0420, secs left = 1
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 1
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.399, delta=0.0310, secs left = 0
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.399, delta=0.0410, secs left = -0
INFO:  shellyplus1pm-e465b8f174b8: Max current measurement error = 0.0600 amps.
INFO:  Load current = 8.43 Amps.
INFO:  Load current = 8.43 Amps.
INFO:  Load current = 8.44 Amps.
INFO:  Load current = 8.44 Amps.
INFO:  Load current = 8.44 Amps.
INFO:  Load current is stable at 8.44 amps.
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.400, delta=0.0400, secs left = 59
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.400, delta=0.0400, secs left = 59
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.402, delta=0.0380, secs left = 58
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.402, delta=0.0380, secs left = 58
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.402, delta=0.0380, secs left = 57
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.402, delta=0.0380, secs left = 57
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 56
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 56
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 55
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 55
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.406, delta=0.0340, secs left = 54
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.406, delta=0.0340, secs left = 54
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.406, delta=0.0340, secs left = 53
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.406, delta=0.0340, secs left = 53
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 52
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 52
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 51
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.403, delta=0.0370, secs left = 51
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.401, delta=0.0390, secs left = 50
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.401, delta=0.0390, secs left = 50
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.401, delta=0.0290, secs left = 50
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.401, delta=0.0290, secs left = 49
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 48
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 48
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 48
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 47
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 46
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 46
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 45
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 45
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 44
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 44
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 43
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 43
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 42
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 42
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 41
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.398, delta=0.0320, secs left = 41
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 40
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 40
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 39
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.396, delta=0.0340, secs left = 39
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 38
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 38
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 37
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.395, delta=0.0450, secs left = 37
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.402, delta=0.0380, secs left = 37
INFO:  CM2100B AC Amps = 8.440, Shelly 1PM Plus AC Amps = 8.402, delta=0.0380, secs left = 36
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.402, delta=0.0280, secs left = 36
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.402, delta=0.0280, secs left = 35
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.402, delta=0.0280, secs left = 35
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 34
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 34
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 33
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.397, delta=0.0330, secs left = 33
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.394, delta=0.0260, secs left = 32
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.394, delta=0.0260, secs left = 32
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 32
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 31
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 31
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 30
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 30
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.393, delta=0.0270, secs left = 30
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 29
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 29
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 28
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 28
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 27
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.394, delta=0.0360, secs left = 27
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 26
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 26
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 25
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 25
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 24
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 24
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 23
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 22
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 22
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 21
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 21
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 20
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 20
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 19
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 19
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 18
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 18
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 17
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.386, delta=0.0340, secs left = 17
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.388, delta=0.0320, secs left = 16
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.388, delta=0.0320, secs left = 16
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.388, delta=0.0320, secs left = 15
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.388, delta=0.0320, secs left = 15
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 14
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 14
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 13
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.387, delta=0.0330, secs left = 13
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 12
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 12
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 11
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.390, delta=0.0400, secs left = 11
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 10
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 10
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 9
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.393, delta=0.0370, secs left = 9
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 8
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 8
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 7
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.395, delta=0.0350, secs left = 7
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.393, delta=0.0270, secs left = 6
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.393, delta=0.0270, secs left = 6
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.393, delta=0.0270, secs left = 5
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.393, delta=0.0270, secs left = 5
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 4
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 4
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 3
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.390, delta=0.0300, secs left = 3
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.392, delta=0.0280, secs left = 2
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.392, delta=0.0280, secs left = 2
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.392, delta=0.0280, secs left = 1
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.392, delta=0.0280, secs left = 1
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.391, delta=0.0290, secs left = 0
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.391, delta=0.0290, secs left = -0
INFO:  Saved config to /home/pja/.config/Shelly1PMPlus.cfg
INFO:  shellyplus1pm-e465b8f174b8: Saved current calibration offset = 0.03346721311475374 amps.
INFO:  Load current = 8.42 Amps.
INFO:  Load current = 8.42 Amps.
INFO:  Load current = 8.42 Amps.
INFO:  Load current = 8.42 Amps.
INFO:  Load current = 8.42 Amps.
INFO:  Load current is stable at 8.42 amps.
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.423, delta=-0.0035, secs left = 59
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.423, delta=-0.0035, secs left = 59
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.423, delta=-0.0035, secs left = 58
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.423, delta=0.0065, secs left = 58
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 57
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 57
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 56
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 56
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.428, delta=0.0015, secs left = 55
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.428, delta=0.0015, secs left = 55
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.428, delta=0.0015, secs left = 54
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.428, delta=0.0015, secs left = 54
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 53
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 53
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.429, delta=-0.0095, secs left = 52
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.429, delta=-0.0095, secs left = 52
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 51
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 51
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 50
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 50
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 49
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 49
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.429, delta=-0.0095, secs left = 48
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 48
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.429, delta=-0.0095, secs left = 48
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 47
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 47
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 47
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 46
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 46
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 46
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 45
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 45
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 44
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.429, delta=0.0005, secs left = 44
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 43
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 43
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 42
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 42
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.430, delta=-0.0005, secs left = 41
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.430, delta=-0.0005, secs left = 41
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.430, delta=-0.0005, secs left = 40
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.430, delta=-0.0005, secs left = 40
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 39
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 39
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 38
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 37
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 37
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 36
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 36
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 35
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 35
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 34
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 34
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 33
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 33
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 32
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 32
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 31
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 31
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 30
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 30
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 29
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 29
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 28
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 28
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.433, delta=-0.0035, secs left = 27
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.433, delta=-0.0035, secs left = 27
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.433, delta=-0.0035, secs left = 26
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.433, delta=-0.0135, secs left = 26
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 25
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 25
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 24
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 24
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 23
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 23
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 22
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 22
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.427, delta=0.0025, secs left = 22
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 21
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 21
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.431, delta=-0.0015, secs left = 20
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.428, delta=-0.0085, secs left = 19
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.428, delta=-0.0085, secs left = 19
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.428, delta=-0.0085, secs left = 18
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.428, delta=-0.0085, secs left = 18
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 17
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 17
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 16
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 16
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 15
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 15
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 14
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.427, delta=-0.0075, secs left = 14
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 13
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 13
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 12
INFO:  CM2100B AC Amps = 8.420, Shelly 1PM Plus AC Amps = 8.425, delta=-0.0055, secs left = 12
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 11
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 11
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 10
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 10
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 9
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 9
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 8
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 8
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 7
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 7
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 6
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.432, delta=-0.0025, secs left = 6
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 5
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 5
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 4
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.435, delta=-0.0055, secs left = 4
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 3
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 3
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 2
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.434, delta=-0.0045, secs left = 2
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.437, delta=-0.0075, secs left = 1
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.437, delta=-0.0075, secs left = 1
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.437, delta=-0.0075, secs left = 0
INFO:  CM2100B AC Amps = 8.430, Shelly 1PM Plus AC Amps = 8.437, delta=-0.0075, secs left = -0
INFO:  shellyplus1pm-e465b8f174b8: Max current measurement error = -0.0135 amps.
INFO:  Disconnected from CM2100B AC/DC Clamp Meter.
INFO:  Saved config to /home/pja/.config/Shelly1PMPlus.cfg
INFO:  shellyplus1pm-e465b8f174b8: Reset the voltage calibration offset to 0.0 volts.
INFO:  HM8112-3 AC volts = 251.240, Shelly 1PM Plus AC Volts = 252.000, delta=-0.760, secs left = 59
INFO:  HM8112-3 AC volts = 251.232, Shelly 1PM Plus AC Volts = 252.000, delta=-0.768, secs left = 58
INFO:  HM8112-3 AC volts = 251.210, Shelly 1PM Plus AC Volts = 252.000, delta=-0.790, secs left = 57
INFO:  HM8112-3 AC volts = 251.217, Shelly 1PM Plus AC Volts = 252.000, delta=-0.783, secs left = 56
INFO:  HM8112-3 AC volts = 251.184, Shelly 1PM Plus AC Volts = 252.000, delta=-0.816, secs left = 55
INFO:  HM8112-3 AC volts = 250.489, Shelly 1PM Plus AC Volts = 252.000, delta=-1.511, secs left = 54
INFO:  HM8112-3 AC volts = 250.136, Shelly 1PM Plus AC Volts = 250.900, delta=-0.764, secs left = 53
INFO:  HM8112-3 AC volts = 250.160, Shelly 1PM Plus AC Volts = 250.900, delta=-0.740, secs left = 52
INFO:  HM8112-3 AC volts = 250.309, Shelly 1PM Plus AC Volts = 251.100, delta=-0.791, secs left = 51
INFO:  HM8112-3 AC volts = 250.378, Shelly 1PM Plus AC Volts = 251.100, delta=-0.722, secs left = 50
INFO:  HM8112-3 AC volts = 250.378, Shelly 1PM Plus AC Volts = 251.200, delta=-0.822, secs left = 49
INFO:  HM8112-3 AC volts = 250.369, Shelly 1PM Plus AC Volts = 251.200, delta=-0.831, secs left = 48
INFO:  HM8112-3 AC volts = 250.293, Shelly 1PM Plus AC Volts = 251.100, delta=-0.807, secs left = 47
INFO:  HM8112-3 AC volts = 250.349, Shelly 1PM Plus AC Volts = 251.100, delta=-0.751, secs left = 46
INFO:  HM8112-3 AC volts = 250.454, Shelly 1PM Plus AC Volts = 251.300, delta=-0.846, secs left = 45
INFO:  HM8112-3 AC volts = 250.426, Shelly 1PM Plus AC Volts = 251.300, delta=-0.874, secs left = 44
INFO:  HM8112-3 AC volts = 250.487, Shelly 1PM Plus AC Volts = 251.300, delta=-0.813, secs left = 43
INFO:  HM8112-3 AC volts = 250.482, Shelly 1PM Plus AC Volts = 251.300, delta=-0.818, secs left = 42
INFO:  HM8112-3 AC volts = 250.454, Shelly 1PM Plus AC Volts = 251.200, delta=-0.746, secs left = 41
INFO:  HM8112-3 AC volts = 250.486, Shelly 1PM Plus AC Volts = 251.200, delta=-0.714, secs left = 40
INFO:  HM8112-3 AC volts = 250.443, Shelly 1PM Plus AC Volts = 251.200, delta=-0.757, secs left = 39
INFO:  HM8112-3 AC volts = 250.470, Shelly 1PM Plus AC Volts = 251.200, delta=-0.730, secs left = 38
INFO:  HM8112-3 AC volts = 250.423, Shelly 1PM Plus AC Volts = 251.300, delta=-0.877, secs left = 37
INFO:  HM8112-3 AC volts = 250.379, Shelly 1PM Plus AC Volts = 251.300, delta=-0.921, secs left = 36
INFO:  HM8112-3 AC volts = 250.327, Shelly 1PM Plus AC Volts = 251.100, delta=-0.773, secs left = 35
INFO:  HM8112-3 AC volts = 250.423, Shelly 1PM Plus AC Volts = 251.100, delta=-0.677, secs left = 34
INFO:  HM8112-3 AC volts = 250.399, Shelly 1PM Plus AC Volts = 251.200, delta=-0.801, secs left = 33
INFO:  HM8112-3 AC volts = 250.397, Shelly 1PM Plus AC Volts = 251.200, delta=-0.803, secs left = 32
INFO:  HM8112-3 AC volts = 250.394, Shelly 1PM Plus AC Volts = 251.200, delta=-0.806, secs left = 31
INFO:  HM8112-3 AC volts = 250.390, Shelly 1PM Plus AC Volts = 251.200, delta=-0.810, secs left = 30
INFO:  HM8112-3 AC volts = 250.388, Shelly 1PM Plus AC Volts = 251.200, delta=-0.812, secs left = 29
INFO:  HM8112-3 AC volts = 250.387, Shelly 1PM Plus AC Volts = 251.200, delta=-0.813, secs left = 28
INFO:  HM8112-3 AC volts = 250.220, Shelly 1PM Plus AC Volts = 251.000, delta=-0.780, secs left = 27
INFO:  HM8112-3 AC volts = 250.256, Shelly 1PM Plus AC Volts = 251.000, delta=-0.744, secs left = 26
INFO:  HM8112-3 AC volts = 250.257, Shelly 1PM Plus AC Volts = 251.100, delta=-0.843, secs left = 25
INFO:  HM8112-3 AC volts = 250.151, Shelly 1PM Plus AC Volts = 251.100, delta=-0.949, secs left = 24
INFO:  HM8112-3 AC volts = 250.112, Shelly 1PM Plus AC Volts = 250.900, delta=-0.788, secs left = 23
INFO:  HM8112-3 AC volts = 250.183, Shelly 1PM Plus AC Volts = 250.900, delta=-0.717, secs left = 22
INFO:  HM8112-3 AC volts = 250.174, Shelly 1PM Plus AC Volts = 251.000, delta=-0.826, secs left = 21
INFO:  HM8112-3 AC volts = 250.152, Shelly 1PM Plus AC Volts = 251.000, delta=-0.848, secs left = 20
INFO:  HM8112-3 AC volts = 250.077, Shelly 1PM Plus AC Volts = 250.900, delta=-0.823, secs left = 19
INFO:  HM8112-3 AC volts = 249.943, Shelly 1PM Plus AC Volts = 250.900, delta=-0.957, secs left = 18
INFO:  HM8112-3 AC volts = 250.028, Shelly 1PM Plus AC Volts = 250.800, delta=-0.772, secs left = 17
INFO:  HM8112-3 AC volts = 250.066, Shelly 1PM Plus AC Volts = 250.800, delta=-0.734, secs left = 16
INFO:  HM8112-3 AC volts = 250.094, Shelly 1PM Plus AC Volts = 250.900, delta=-0.806, secs left = 15
INFO:  HM8112-3 AC volts = 250.093, Shelly 1PM Plus AC Volts = 250.900, delta=-0.807, secs left = 14
INFO:  HM8112-3 AC volts = 250.071, Shelly 1PM Plus AC Volts = 250.900, delta=-0.829, secs left = 13
INFO:  HM8112-3 AC volts = 250.052, Shelly 1PM Plus AC Volts = 250.900, delta=-0.848, secs left = 12
INFO:  HM8112-3 AC volts = 249.975, Shelly 1PM Plus AC Volts = 250.800, delta=-0.825, secs left = 11
INFO:  HM8112-3 AC volts = 249.957, Shelly 1PM Plus AC Volts = 250.800, delta=-0.843, secs left = 10
INFO:  HM8112-3 AC volts = 250.001, Shelly 1PM Plus AC Volts = 250.800, delta=-0.799, secs left = 9
INFO:  HM8112-3 AC volts = 249.976, Shelly 1PM Plus AC Volts = 250.800, delta=-0.824, secs left = 8
INFO:  HM8112-3 AC volts = 250.027, Shelly 1PM Plus AC Volts = 250.800, delta=-0.773, secs left = 7
INFO:  HM8112-3 AC volts = 250.134, Shelly 1PM Plus AC Volts = 250.800, delta=-0.666, secs left = 6
INFO:  HM8112-3 AC volts = 250.079, Shelly 1PM Plus AC Volts = 250.900, delta=-0.821, secs left = 5
INFO:  HM8112-3 AC volts = 250.112, Shelly 1PM Plus AC Volts = 250.900, delta=-0.788, secs left = 4
INFO:  HM8112-3 AC volts = 250.178, Shelly 1PM Plus AC Volts = 251.000, delta=-0.822, secs left = 3
INFO:  HM8112-3 AC volts = 250.196, Shelly 1PM Plus AC Volts = 251.000, delta=-0.804, secs left = 2
INFO:  HM8112-3 AC volts = 250.195, Shelly 1PM Plus AC Volts = 251.000, delta=-0.805, secs left = 1
INFO:  HM8112-3 AC volts = 250.153, Shelly 1PM Plus AC Volts = 251.000, delta=-0.847, secs left = 0
INFO:  HM8112-3 AC volts = 250.089, Shelly 1PM Plus AC Volts = 250.900, delta=-0.811, secs left = -1
INFO:  shellyplus1pm-e465b8f174b8: Max voltage measurement error = -1.5110 volts.
INFO:  HM8112-3 AC volts = 250.086, Shelly 1PM Plus AC Volts = 250.900, delta=-0.814, secs left = 59
INFO:  HM8112-3 AC volts = 250.078, Shelly 1PM Plus AC Volts = 250.900, delta=-0.822, secs left = 58
INFO:  HM8112-3 AC volts = 249.969, Shelly 1PM Plus AC Volts = 250.900, delta=-0.931, secs left = 57
INFO:  HM8112-3 AC volts = 249.907, Shelly 1PM Plus AC Volts = 250.900, delta=-0.993, secs left = 56
INFO:  HM8112-3 AC volts = 249.932, Shelly 1PM Plus AC Volts = 250.800, delta=-0.868, secs left = 55
INFO:  HM8112-3 AC volts = 249.884, Shelly 1PM Plus AC Volts = 250.800, delta=-0.916, secs left = 54
INFO:  HM8112-3 AC volts = 250.120, Shelly 1PM Plus AC Volts = 250.800, delta=-0.680, secs left = 53
INFO:  HM8112-3 AC volts = 250.083, Shelly 1PM Plus AC Volts = 250.800, delta=-0.717, secs left = 52
INFO:  HM8112-3 AC volts = 250.084, Shelly 1PM Plus AC Volts = 250.900, delta=-0.816, secs left = 51
INFO:  HM8112-3 AC volts = 250.118, Shelly 1PM Plus AC Volts = 250.900, delta=-0.782, secs left = 50
INFO:  HM8112-3 AC volts = 250.186, Shelly 1PM Plus AC Volts = 251.000, delta=-0.814, secs left = 49
INFO:  HM8112-3 AC volts = 250.191, Shelly 1PM Plus AC Volts = 251.000, delta=-0.809, secs left = 48
INFO:  HM8112-3 AC volts = 250.124, Shelly 1PM Plus AC Volts = 251.000, delta=-0.876, secs left = 47
INFO:  HM8112-3 AC volts = 250.125, Shelly 1PM Plus AC Volts = 251.000, delta=-0.875, secs left = 46
INFO:  HM8112-3 AC volts = 250.152, Shelly 1PM Plus AC Volts = 251.000, delta=-0.848, secs left = 45
INFO:  HM8112-3 AC volts = 249.986, Shelly 1PM Plus AC Volts = 251.000, delta=-1.014, secs left = 44
INFO:  HM8112-3 AC volts = 249.986, Shelly 1PM Plus AC Volts = 250.700, delta=-0.714, secs left = 43
INFO:  HM8112-3 AC volts = 250.046, Shelly 1PM Plus AC Volts = 250.700, delta=-0.654, secs left = 42
INFO:  HM8112-3 AC volts = 249.895, Shelly 1PM Plus AC Volts = 250.800, delta=-0.905, secs left = 41
INFO:  HM8112-3 AC volts = 249.917, Shelly 1PM Plus AC Volts = 250.800, delta=-0.883, secs left = 40
INFO:  HM8112-3 AC volts = 249.911, Shelly 1PM Plus AC Volts = 250.800, delta=-0.889, secs left = 39
INFO:  HM8112-3 AC volts = 249.827, Shelly 1PM Plus AC Volts = 250.800, delta=-0.973, secs left = 38
INFO:  HM8112-3 AC volts = 249.904, Shelly 1PM Plus AC Volts = 250.700, delta=-0.796, secs left = 37
INFO:  HM8112-3 AC volts = 249.905, Shelly 1PM Plus AC Volts = 250.700, delta=-0.795, secs left = 36
INFO:  HM8112-3 AC volts = 249.909, Shelly 1PM Plus AC Volts = 250.700, delta=-0.791, secs left = 35
INFO:  HM8112-3 AC volts = 249.862, Shelly 1PM Plus AC Volts = 250.700, delta=-0.838, secs left = 34
INFO:  HM8112-3 AC volts = 249.860, Shelly 1PM Plus AC Volts = 250.700, delta=-0.840, secs left = 33
INFO:  HM8112-3 AC volts = 249.866, Shelly 1PM Plus AC Volts = 250.700, delta=-0.834, secs left = 32
INFO:  HM8112-3 AC volts = 249.808, Shelly 1PM Plus AC Volts = 250.600, delta=-0.792, secs left = 31
INFO:  HM8112-3 AC volts = 249.857, Shelly 1PM Plus AC Volts = 250.600, delta=-0.743, secs left = 30
INFO:  HM8112-3 AC volts = 249.813, Shelly 1PM Plus AC Volts = 250.700, delta=-0.887, secs left = 29
INFO:  HM8112-3 AC volts = 249.729, Shelly 1PM Plus AC Volts = 250.700, delta=-0.971, secs left = 28
INFO:  HM8112-3 AC volts = 249.691, Shelly 1PM Plus AC Volts = 250.500, delta=-0.809, secs left = 27
INFO:  HM8112-3 AC volts = 249.639, Shelly 1PM Plus AC Volts = 250.500, delta=-0.861, secs left = 26
INFO:  HM8112-3 AC volts = 249.616, Shelly 1PM Plus AC Volts = 250.400, delta=-0.784, secs left = 25
INFO:  HM8112-3 AC volts = 249.696, Shelly 1PM Plus AC Volts = 250.400, delta=-0.704, secs left = 24
INFO:  HM8112-3 AC volts = 249.671, Shelly 1PM Plus AC Volts = 250.500, delta=-0.829, secs left = 23
INFO:  HM8112-3 AC volts = 249.460, Shelly 1PM Plus AC Volts = 250.500, delta=-1.040, secs left = 22
INFO:  HM8112-3 AC volts = 249.043, Shelly 1PM Plus AC Volts = 250.100, delta=-1.057, secs left = 21
INFO:  HM8112-3 AC volts = 249.005, Shelly 1PM Plus AC Volts = 250.100, delta=-1.095, secs left = 20
INFO:  HM8112-3 AC volts = 249.093, Shelly 1PM Plus AC Volts = 249.900, delta=-0.807, secs left = 19
INFO:  HM8112-3 AC volts = 249.093, Shelly 1PM Plus AC Volts = 249.900, delta=-0.807, secs left = 18
INFO:  HM8112-3 AC volts = 249.090, Shelly 1PM Plus AC Volts = 249.900, delta=-0.810, secs left = 17
INFO:  HM8112-3 AC volts = 249.064, Shelly 1PM Plus AC Volts = 249.900, delta=-0.836, secs left = 16
INFO:  HM8112-3 AC volts = 249.045, Shelly 1PM Plus AC Volts = 249.800, delta=-0.755, secs left = 15
INFO:  HM8112-3 AC volts = 249.188, Shelly 1PM Plus AC Volts = 249.800, delta=-0.612, secs left = 14
INFO:  HM8112-3 AC volts = 249.267, Shelly 1PM Plus AC Volts = 250.100, delta=-0.833, secs left = 13
INFO:  HM8112-3 AC volts = 249.342, Shelly 1PM Plus AC Volts = 250.100, delta=-0.758, secs left = 12
INFO:  HM8112-3 AC volts = 249.482, Shelly 1PM Plus AC Volts = 250.200, delta=-0.718, secs left = 11
INFO:  HM8112-3 AC volts = 249.501, Shelly 1PM Plus AC Volts = 250.200, delta=-0.699, secs left = 10
INFO:  HM8112-3 AC volts = 249.440, Shelly 1PM Plus AC Volts = 250.300, delta=-0.860, secs left = 9
INFO:  HM8112-3 AC volts = 249.357, Shelly 1PM Plus AC Volts = 250.300, delta=-0.943, secs left = 8
INFO:  HM8112-3 AC volts = 249.430, Shelly 1PM Plus AC Volts = 250.200, delta=-0.770, secs left = 7
INFO:  HM8112-3 AC volts = 249.425, Shelly 1PM Plus AC Volts = 250.200, delta=-0.775, secs left = 6
INFO:  HM8112-3 AC volts = 249.339, Shelly 1PM Plus AC Volts = 250.300, delta=-0.961, secs left = 5
INFO:  HM8112-3 AC volts = 249.205, Shelly 1PM Plus AC Volts = 250.300, delta=-1.095, secs left = 4
INFO:  HM8112-3 AC volts = 249.158, Shelly 1PM Plus AC Volts = 250.000, delta=-0.842, secs left = 3
INFO:  HM8112-3 AC volts = 249.200, Shelly 1PM Plus AC Volts = 250.000, delta=-0.800, secs left = 2
INFO:  HM8112-3 AC volts = 249.237, Shelly 1PM Plus AC Volts = 250.100, delta=-0.863, secs left = 1
INFO:  HM8112-3 AC volts = 249.172, Shelly 1PM Plus AC Volts = 250.100, delta=-0.928, secs left = 0
INFO:  HM8112-3 AC volts = 249.234, Shelly 1PM Plus AC Volts = 250.000, delta=-0.766, secs left = -1
INFO:  Saved config to /home/pja/.config/Shelly1PMPlus.cfg
INFO:  shellyplus1pm-e465b8f174b8: Saved voltage calibration offset = -0.8409344262295091 amps.
INFO:  HM8112-3 AC volts = 249.242, Shelly 1PM Plus AC Volts = 249.259, delta=-0.017, secs left = 59
INFO:  HM8112-3 AC volts = 249.279, Shelly 1PM Plus AC Volts = 249.259, delta=0.020, secs left = 58
INFO:  HM8112-3 AC volts = 249.314, Shelly 1PM Plus AC Volts = 249.259, delta=0.055, secs left = 57
INFO:  HM8112-3 AC volts = 249.362, Shelly 1PM Plus AC Volts = 249.359, delta=0.003, secs left = 56
INFO:  HM8112-3 AC volts = 249.341, Shelly 1PM Plus AC Volts = 249.359, delta=-0.018, secs left = 55
INFO:  HM8112-3 AC volts = 249.372, Shelly 1PM Plus AC Volts = 249.359, delta=0.013, secs left = 54
INFO:  HM8112-3 AC volts = 249.378, Shelly 1PM Plus AC Volts = 249.359, delta=0.019, secs left = 53
INFO:  HM8112-3 AC volts = 249.392, Shelly 1PM Plus AC Volts = 249.359, delta=0.033, secs left = 52
INFO:  HM8112-3 AC volts = 249.287, Shelly 1PM Plus AC Volts = 249.359, delta=-0.072, secs left = 51
INFO:  HM8112-3 AC volts = 249.295, Shelly 1PM Plus AC Volts = 249.259, delta=0.036, secs left = 50
INFO:  HM8112-3 AC volts = 249.472, Shelly 1PM Plus AC Volts = 249.259, delta=0.213, secs left = 49
INFO:  HM8112-3 AC volts = 249.496, Shelly 1PM Plus AC Volts = 249.459, delta=0.037, secs left = 48
INFO:  HM8112-3 AC volts = 249.472, Shelly 1PM Plus AC Volts = 249.459, delta=0.013, secs left = 47
INFO:  HM8112-3 AC volts = 249.412, Shelly 1PM Plus AC Volts = 249.359, delta=0.053, secs left = 46
INFO:  HM8112-3 AC volts = 249.827, Shelly 1PM Plus AC Volts = 249.359, delta=0.468, secs left = 45
INFO:  HM8112-3 AC volts = 249.829, Shelly 1PM Plus AC Volts = 249.859, delta=-0.030, secs left = 44
INFO:  HM8112-3 AC volts = 249.784, Shelly 1PM Plus AC Volts = 249.859, delta=-0.075, secs left = 43
INFO:  HM8112-3 AC volts = 249.751, Shelly 1PM Plus AC Volts = 249.759, delta=-0.008, secs left = 42
INFO:  HM8112-3 AC volts = 249.868, Shelly 1PM Plus AC Volts = 249.759, delta=0.109, secs left = 41
INFO:  HM8112-3 AC volts = 249.934, Shelly 1PM Plus AC Volts = 249.959, delta=-0.025, secs left = 40
INFO:  HM8112-3 AC volts = 249.913, Shelly 1PM Plus AC Volts = 249.959, delta=-0.046, secs left = 39
INFO:  HM8112-3 AC volts = 249.826, Shelly 1PM Plus AC Volts = 249.859, delta=-0.033, secs left = 38
INFO:  HM8112-3 AC volts = 249.697, Shelly 1PM Plus AC Volts = 249.859, delta=-0.162, secs left = 37
INFO:  HM8112-3 AC volts = 249.634, Shelly 1PM Plus AC Volts = 249.659, delta=-0.025, secs left = 36
INFO:  HM8112-3 AC volts = 249.667, Shelly 1PM Plus AC Volts = 249.659, delta=0.008, secs left = 35
INFO:  HM8112-3 AC volts = 249.719, Shelly 1PM Plus AC Volts = 249.759, delta=-0.040, secs left = 34
INFO:  HM8112-3 AC volts = 249.798, Shelly 1PM Plus AC Volts = 249.759, delta=0.039, secs left = 33
INFO:  HM8112-3 AC volts = 249.806, Shelly 1PM Plus AC Volts = 249.859, delta=-0.053, secs left = 32
INFO:  HM8112-3 AC volts = 249.985, Shelly 1PM Plus AC Volts = 249.859, delta=0.126, secs left = 31
INFO:  HM8112-3 AC volts = 249.820, Shelly 1PM Plus AC Volts = 249.759, delta=0.061, secs left = 30
INFO:  HM8112-3 AC volts = 249.771, Shelly 1PM Plus AC Volts = 249.759, delta=0.012, secs left = 29
INFO:  HM8112-3 AC volts = 249.701, Shelly 1PM Plus AC Volts = 249.659, delta=0.042, secs left = 28
INFO:  HM8112-3 AC volts = 249.595, Shelly 1PM Plus AC Volts = 249.659, delta=-0.064, secs left = 27
INFO:  HM8112-3 AC volts = 249.569, Shelly 1PM Plus AC Volts = 249.559, delta=0.010, secs left = 26
INFO:  HM8112-3 AC volts = 249.522, Shelly 1PM Plus AC Volts = 249.559, delta=-0.037, secs left = 25
INFO:  HM8112-3 AC volts = 249.427, Shelly 1PM Plus AC Volts = 249.459, delta=-0.032, secs left = 24
INFO:  HM8112-3 AC volts = 249.517, Shelly 1PM Plus AC Volts = 249.459, delta=0.058, secs left = 23
INFO:  HM8112-3 AC volts = 249.587, Shelly 1PM Plus AC Volts = 249.559, delta=0.028, secs left = 22
INFO:  HM8112-3 AC volts = 249.616, Shelly 1PM Plus AC Volts = 249.559, delta=0.057, secs left = 21
INFO:  HM8112-3 AC volts = 249.563, Shelly 1PM Plus AC Volts = 249.559, delta=0.004, secs left = 20
INFO:  HM8112-3 AC volts = 249.557, Shelly 1PM Plus AC Volts = 249.559, delta=-0.002, secs left = 19
INFO:  HM8112-3 AC volts = 249.549, Shelly 1PM Plus AC Volts = 249.559, delta=-0.010, secs left = 18
INFO:  HM8112-3 AC volts = 249.680, Shelly 1PM Plus AC Volts = 249.559, delta=0.121, secs left = 17
INFO:  HM8112-3 AC volts = 249.684, Shelly 1PM Plus AC Volts = 249.659, delta=0.025, secs left = 16
INFO:  HM8112-3 AC volts = 249.538, Shelly 1PM Plus AC Volts = 249.659, delta=-0.121, secs left = 15
INFO:  HM8112-3 AC volts = 249.576, Shelly 1PM Plus AC Volts = 249.559, delta=0.017, secs left = 14
INFO:  HM8112-3 AC volts = 249.618, Shelly 1PM Plus AC Volts = 249.559, delta=0.059, secs left = 13
INFO:  HM8112-3 AC volts = 249.660, Shelly 1PM Plus AC Volts = 249.659, delta=0.001, secs left = 12
INFO:  HM8112-3 AC volts = 249.532, Shelly 1PM Plus AC Volts = 249.659, delta=-0.127, secs left = 11
INFO:  HM8112-3 AC volts = 249.402, Shelly 1PM Plus AC Volts = 249.359, delta=0.043, secs left = 10
INFO:  HM8112-3 AC volts = 249.394, Shelly 1PM Plus AC Volts = 249.359, delta=0.035, secs left = 9
INFO:  HM8112-3 AC volts = 249.325, Shelly 1PM Plus AC Volts = 249.359, delta=-0.034, secs left = 8
INFO:  HM8112-3 AC volts = 249.345, Shelly 1PM Plus AC Volts = 249.359, delta=-0.014, secs left = 7
INFO:  HM8112-3 AC volts = 249.203, Shelly 1PM Plus AC Volts = 249.159, delta=0.044, secs left = 6
INFO:  HM8112-3 AC volts = 249.260, Shelly 1PM Plus AC Volts = 249.159, delta=0.101, secs left = 5
INFO:  HM8112-3 AC volts = 249.422, Shelly 1PM Plus AC Volts = 249.459, delta=-0.037, secs left = 4
INFO:  HM8112-3 AC volts = 249.301, Shelly 1PM Plus AC Volts = 249.459, delta=-0.158, secs left = 3
INFO:  HM8112-3 AC volts = 249.181, Shelly 1PM Plus AC Volts = 249.159, delta=0.022, secs left = 2
INFO:  HM8112-3 AC volts = 249.179, Shelly 1PM Plus AC Volts = 249.159, delta=0.020, secs left = 1
INFO:  HM8112-3 AC volts = 249.197, Shelly 1PM Plus AC Volts = 249.159, delta=0.038, secs left = 0
INFO:  HM8112-3 AC volts = 249.283, Shelly 1PM Plus AC Volts = 249.159, delta=0.124, secs left = -1
INFO:  shellyplus1pm-e465b8f174b8: Max voltage measurement error = 0.4679 volts.
INFO:  Un calibrated current error = 0.05999999999999872 amps.
INFO:  Calibrated current error    = -0.013467213114754628 amps.
INFO:  The calibration process improved the current reading accuracy by 446 %.
INFO:  Un calibrated Voltage error = -1.5109999999999957 volts
INFO:  Calibrated Voltage error    = 0.46793442622950465 volts
INFO:  The calibration process improved the voltage reading accuracy by 323 %.
INFO:  Shelly 1PM Plus config file: /home/username/.config/Shelly1PMPlus.cfg
```

Note !!!
The calibration data is stored in a  local file (~/.config/Shelly1PMPlus.cfg) in JSON format.