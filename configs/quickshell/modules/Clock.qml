import QtQuick
import Quickshell
import "../"

Rectangle {
    id: clockModule
    implicitWidth: clockText.contentWidth + 24 
    height: 32
    radius: 12
    
    color: Theme.surface 
    border.color: Theme.primary
    border.width: 1

    Text {
        id: clockText
        anchors.centerIn: parent
        font.family: "Google Sans Flex"
        font.pixelSize: 14
        font.weight: Font.Medium
        
        color: Theme.fgSurface 
        
        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                let d = new Date();
                clockText.text = Qt.formatDateTime(d, "HH:mm") + "  •  " + Qt.formatDateTime(d, "dd MMM");
            }
        }
    }
}
