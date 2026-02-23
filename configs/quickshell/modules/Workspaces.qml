import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../"

Row {
    id: wsRoot
    spacing: 8
    height: 32
    property var screen: null 
    Repeater {
        model: Array.from(Hyprland.workspaces.values).sort((a, b) => a.id - b.id)
        delegate: Rectangle {
            id: wsRect
            width: isFocused ? 32 : 12
            height: 12
            radius: 6
            color: isFocused ? Theme.primary : "transparent"
            border.color: Theme.primary
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
            readonly property bool isFocused: Hyprland.focusedWorkspace === modelData
            Behavior on width { NumberAnimation { duration: 250; easing.type: Easing.OutQuint } }
            Text {
                anchors.centerIn: parent
                text: modelData.id
                font.family: "Google Sans Flex"
                font.pixelSize: 10
                font.weight: Font.Black
                color: Theme.fgPrimary
                visible: isFocused
            }
            TapHandler { onTapped: modelData.focus() }
        }
    }
}
