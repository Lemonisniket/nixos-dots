import QtQuick
import Quickshell
import Quickshell.Io
import "."
import ".."

Item {
    id: launcherWrapper
    width: 64
    height: parent ? parent.height : 30
    anchors.verticalCenter: parent ? parent.verticalCenter : undefined
    property bool menuOpen: false
    Rectangle {
        id: launcherBtn
        width: 44
        height: 30
        radius: 15
        color: Theme.primary
        anchors.centerIn: parent
        Text {
            anchors.centerIn: parent
            text: "󰅀"
            font.family: "Google Sans Flex"
            font.pixelSize: 16
            color: Theme.fgPrimary
            rotation: launcherWrapper.menuOpen ? 180 : 0
            Behavior on rotation { 
                NumberAnimation { 
                    duration: 400
                    easing.type: Easing.OutBack
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.color = Qt.lighter(Theme.primary, 1.2)
            onExited: parent.color = Theme.primary
            onClicked: {
                const proc = Qt.createQmlObject('import Quickshell.Io; Process {}', launcherWrapper);
                proc.command = ["wofi", "--show", "drun"];
                proc.running = true;
                launcherWrapper.menuOpen = true;
                launcherWrapper.menuOpen = false;
           }
        }
    }
    SequentialAnimation {
        running: launcherWrapper.menuOpen
        NumberAnimation {
            target: launcherBtn
            property: "scale"
            to: 0.9
            duration: 100
        }
        NumberAnimation {
            target: launcherBtn
            property: "scale"
            to: 1.0
            duration: 100
        }
        ScriptAction {
            script: launcherWrapper.menuOpen = false
        }
    }
}
