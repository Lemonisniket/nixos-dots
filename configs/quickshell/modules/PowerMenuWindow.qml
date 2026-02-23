import QtQuick
import Quickshell
import Quickshell.Wayland
import ".."

PanelWindow {
    id: menuRoot 
    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.keyboardFocus: WlrLayershell.OnDemand
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    Item {
        anchors.fill: parent
        focus: menuRoot.visible
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                menuRoot.visible = false;
            }
        }
        Rectangle {
            id: background
            anchors.fill: parent
            color: "black"
            opacity: 0.4   
            MouseArea {
                anchors.fill: parent
                onClicked: menuRoot.visible = false
            }
        }
        Rectangle {
            id: body
            anchors.centerIn: parent
            width: 260
            height: 320
            color: Theme.surface
            radius: 40
            Grid {
                anchors.centerIn: parent
                columns: 2
                spacing: 20
                PowerButton {
                    icon: "󰐥"
                    label: "Power"
                    onClicked: Quickshell.exec(["shutdown", "now"])
                }
                PowerButton {
                    icon: "󰜉"
                    label: "Restart"
                    onClicked: Quickshell.exec(["reboot"])
                }
                PowerButton {
                    icon: "󰍃"
                    label: "Logout"
                    onClicked: Quickshell.exec(["hyprctl", "dispatch", "exit"])
                }
                PowerButton {
                    icon: "󰖔"
                    label: "Switch"
                    onClicked: Quickshell.exec(["loginctl", "lock-session"])
                }
            }
        }
    }
    onVisibleChanged: {
        if (visible) {
            menuRoot.contentItem.forceActiveFocus();
        }
    }
    component PowerButton: Column {
        property string icon: ""
        property string label: ""
        signal clicked()
        spacing: 10
        width: 100 
        Rectangle {
            width: 94; height: 94; radius: 47 
            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.rgba(Theme.primary.r, Theme.primary.g, Theme.primary.b, 0.15)
            Text {
                anchors.centerIn: parent
                text: icon
                font.pixelSize: 36
                color: Theme.primary
            }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    clicked();
                    menuRoot.visible = false;
                }
                onEntered: parent.opacity = 0.6
                onExited: parent.opacity = 1.0
            }
        }
        Text {
            text: label
            color: Theme.fgSurface
            font.pixelSize: 15
            font.weight: Font.DemiBold
            font.family: "Google Sans Flex"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
