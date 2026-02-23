import QtQuick
import Quickshell
import Quickshell.Wayland
import "./modules"

ShellRoot {
    id: root
    PowerMenuWindow {
        id: globalPowerMenu
        visible: false
    }
    PanelWindow {
        id: bigBar
        screen: Quickshell.screens[0]
        anchors {
            top: true
            left: true
            right: true
        }
        WlrLayershell.layer: WlrLayershell.Top
        implicitHeight: 40
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            color: Theme.surface
            Item {
                anchors.fill: parent
                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8
                    Launcher { }
                    Workspaces { screen: bigBar.screen }
                }
                Clock { 
                    anchors.centerIn: parent 
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                    width: 32; height: 32
                    color: "transparent" 
                    Text {
                        anchors.centerIn: parent
                        text: "󰐥"
                        font.pixelSize: 18
                        color: Theme.primary
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: globalPowerMenu.visible = !globalPowerMenu.visible
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
