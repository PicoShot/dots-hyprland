pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool installed: false
    property var batteryDevices: []
    readonly property bool available: installed && batteryDevices.length > 0

    function refresh() {
        if (installed && !statusProcess.running)
            statusProcess.running = true;
    }

    Process {
        id: availabilityProcess
        running: true
        command: ["which", "openseries"]

        onExited: (exitCode, exitStatus) => {
            root.installed = exitCode === 0;
            if (root.installed)
                root.refresh();
            else
                root.batteryDevices = [];
        }
    }

    Process {
        id: statusProcess
        command: ["openseries", "status", "--json"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const devices = JSON.parse(text);
                    root.batteryDevices = devices
                        .filter(device => device.battery
                            && device.capabilities?.includes("BatteryStatus")
                            && Number.isFinite(Number(device.battery.levelPercentage)))
                        .map(device => ({
                            id: device.id,
                            model: device.model,
                            percentage: Math.max(0, Math.min(100, Number(device.battery.levelPercentage))),
                            chargingState: device.battery.chargingState ?? "Unknown"
                        }));
                } catch (error) {
                    console.warn(`[OpenSeries] Could not parse device status: ${error.message}`);
                    root.batteryDevices = [];
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0)
                root.batteryDevices = [];
        }
    }

    Timer {
        interval: 30000
        repeat: true
        running: root.installed
        onTriggered: root.refresh()
    }
}
