import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property int length; // in full seconds
    property int fps: 30;

    property double fpm: 60/delaySeconds;
    property int totalFrames: fpm*totalTime

    property double frameSizeRaw: frameWidth*frameHeigh*3

    property double frameSizeEstimate: frameSizeRaw*estimateRatio(jpegQuality)

    property int delaySeconds: lapseDelay.value
    property int totalTime: lapseTime.value

    property int frameWidth: 1920;
    property int frameHeigh: 1080;

    property int jpegQuality: frameQuality.value;

    allowedOrientations: Orientation.All

    // XXX: This needs a bit of thinking...
    function estimateRatio(i) {
        var r=i/100/2.1;

        return r;
    }

    function setFrameSize(i) {
        console.debug("FS:"+i)
        switch (i+1) {
        case 1: // 3280x2464
            frameWidth=3280;
            frameHeigh=2464;
            break;
        case 2: // 2592x1944
            frameWidth=2592;
            frameHeigh=1944;
            break;
        case 3:
            frameWidth=1920;
            frameHeigh=1080;
            break;
        case 4:
            frameWidth=1280;
            frameHeigh=720;
            break;
        case 5:
            frameWidth=800;
            frameHeigh=600;
            break;
        case 6:
            frameWidth=640;
            frameHeigh=480;
            break;
        }
    }

    function setFPS(i) {
        console.debug("FPS:"+i)
        switch (i+1) {
        case 1:
            return 60;
        case 2:
            return 50;
        case 3:
            return 30;
        case 4:
            return 25;
        case 5:
            return 24;
        case 6:
            return 15;
        case 7:
            return 12;
        }
        return 30;
    }

    function getTotalTime(i) {
        if (i<60)
            return i+":s";
        var m=Math.floor(i/60);
        var s=i%60;
        return m+":m "+s+" :s";
    }

    function getEstimatedSize(i) {
        return i.toPrecision(2);
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: page.width
            spacing: Theme.paddingSmall

            PageHeader {
                title: qsTr("Timelapse Calculator")
            }

            DetailItem {
                label: "Time"
                value: getTotalTime(Math.round(totalFrames/fps))
            }

            DetailItem {
                label: "Frames"
                value: totalFrames
            }

            DetailItem {
                label: "Frame size estimate"
                value: getEstimatedSize(frameSizeEstimate/1024/1024) + "MB"
            }

            DetailItem {
                label: "Storage"
                value: Math.round(totalFrames*frameSizeEstimate/1024/1024) + "MB"
            }

            Slider {
                id: lapseDelay
                value: 5
                label: "Delay (Seconds)"
                minimumValue: 1
                maximumValue: 60
                stepSize: 1
                valueText: value
                width: parent.width
            }

            Slider {
                id: lapseTime
                value: 60
                label: "Total time (Minutes)"
                minimumValue: 5
                maximumValue: 360
                stepSize: 5
                valueText: value
                width: parent.width
            }

            ComboBox {
                id: videoFPS
                label: "FPS"
                menu: ContextMenu {
                    MenuItem { text: "60" }
                    MenuItem { text: "50" }
                    MenuItem { text: "30" }
                    MenuItem { text: "25" }
                    MenuItem { text: "24" }
                    MenuItem { text: "15" }
                    MenuItem { text: "12" }
                }
                onCurrentIndexChanged: {
                    fps=setFPS(currentIndex)
                }
                Component.onCompleted: currentIndex=3
            }

            ComboBox {
                id: videoSize
                label: "Frame size"
                menu: ContextMenu {
                    MenuItem { text: "3280x2464 (8Mpx, Full Frame)" }
                    MenuItem { text: "2592x1944 (5Mpx, Full Frame)" }
                    MenuItem { text: "1920x1080 (FHD)" }
                    MenuItem { text: "1280x720 (HD)" }
                    MenuItem { text: "800x600" }
                    MenuItem { text: "640x480" }
                }
                onCurrentIndexChanged: setFrameSize(currentIndex)
                Component.onCompleted: currentIndex=2
            }

            Slider {
                id: frameQuality
                value: 85
                label: "JPEG Quality"
                minimumValue: 1
                maximumValue: 100
                valueText: value
                stepSize: 1
                width: parent.width
            }
        }
    }
}

