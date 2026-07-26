import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

MouseArea {
    id: root

    implicitWidth: deviceRow.implicitWidth + 8
    implicitHeight: Appearance.sizes.barHeight
    hoverEnabled: !Config.options.bar.tooltips.clickToShow
    acceptedButtons: Qt.NoButton

    function deviceIcon(model) {
        const name = model.toLowerCase();
        if (name.includes("mouse") || name.includes("aerox") || name.includes("rival"))
            return "mouse";
        if (name.includes("headset") || name.includes("arctis"))
            return "headphones";
        return "devices_other";
    }

    RowLayout {
        id: deviceRow
        anchors.centerIn: parent
        spacing: 5

        Repeater {
            model: OpenSeries.batteryDevices

            RowLayout {
                required property var modelData
                readonly property bool disconnected: modelData.chargingState.toLowerCase() === "disconnected"
                readonly property bool lowBattery: !disconnected && modelData.percentage < 25
                spacing: 1

                MaterialSymbol {
                    Layout.alignment: Qt.AlignVCenter
                    text: root.deviceIcon(modelData.model)
                    iconSize: Appearance.font.pixelSize.small
                    color: lowBattery
                        ? Appearance.m3colors.m3error
                        : Appearance.colors.colOnLayer0
                }

                MaterialSymbol {
                    Layout.alignment: Qt.AlignVCenter
                    visible: modelData.chargingState === "Charging" || disconnected
                    text: disconnected ? "link_off" : "bolt"
                    fill: 1
                    iconSize: Appearance.font.pixelSize.smaller
                    color: disconnected ? Appearance.colors.colSubtext : Appearance.colors.colOnLayer0
                }

                StyledText {
                    Layout.alignment: Qt.AlignVCenter
                    visible: !disconnected
                    text: `${Math.round(modelData.percentage)}%`
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: lowBattery
                        ? Appearance.m3colors.m3error
                        : Appearance.colors.colOnLayer0
                }
            }
        }
    }

    OpenSeriesPopup {
        hoverTarget: root
    }
}
