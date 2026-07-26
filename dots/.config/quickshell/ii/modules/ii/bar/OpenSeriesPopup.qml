import qs.modules.common
import qs.services
import QtQuick
import QtQuick.Layouts

StyledPopup {
    id: root

    function deviceIcon(model) {
        const name = model.toLowerCase();
        if (name.includes("mouse") || name.includes("aerox") || name.includes("rival"))
            return "mouse";
        if (name.includes("headset") || name.includes("arctis"))
            return "headphones";
        return "devices_other";
    }

    Column {
        anchors.centerIn: parent
        spacing: 12

        Repeater {
            model: OpenSeries.batteryDevices

            Column {
                required property var modelData
                spacing: 8

                StyledPopupHeaderRow {
                    icon: root.deviceIcon(modelData.model)
                    label: modelData.model
                }

                Column {
                    spacing: 4

                    StyledPopupValueRow {
                        icon: "battery_android_full"
                        label: Translation.tr("Battery")
                        value: `${Math.round(modelData.percentage)}%`
                    }

                    StyledPopupValueRow {
                        icon: modelData.chargingState === "Charging" ? "bolt" : "power"
                        label: Translation.tr("Status:")
                        value: modelData.chargingState
                    }
                }
            }
        }
    }
}
