import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 1.4

Item {
    property int checkInterval: plasmoid.configuration.checkInterval
    property bool cardIsOn: false

    Image {
        id: logo
        source: "grayscale-nvidia.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            if (mouse.button == Qt.LeftButton) {
                plasmoid.expanded = !plasmoid.expanded;
            }
        }
    }

    // Status checking
    PlasmaCore.DataSource {
        id: statusSource
        engine: 'executable'

        connectedSources: ['nvidia-smi -q -d POWER']

        onNewData: {
            var status = '';
            if (data['No devices were found'] > 0) {
                status = data.stderr;
                logo.source='error-nvidia.svg';
                cardIsOn = false;
                plasmoid.status = PlasmaCore.Types.ActiveStatus
            } else {
                status = data.stdout;
                logo.source = 'nvidia.svg';
                cardIsOn = true;
                plasmoid.status = PlasmaCore.Types.ActiveStatus

                while (endsWith(status,'\n'))
                    status = status.substr(0,status.length-1);

                if (status.toLowerCase().indexOf('error') > 0) {
                    logo.source = 'error-nvidia.svg';
                    cardIsOn = false;
                    plasmoid.status = PlasmaCore.Types.ActiveStatus
                } else if (status.toLowerCase().indexOf('power management') > 0) {
                    logo.source = 'nvidia.svg';
                    cardIsOn = true;
                    plasmoid.status = PlasmaCore.Types.ActiveStatus
                } else {
                    logo.source = 'grayscale-nvidia.svg';
                    cardIsOn = false;
                    plasmoid.status = PlasmaCore.Types.PassiveStatus
                }
            }
        }
        interval: checkInterval * 1000
    }

    function endsWith(string, substr) {
        return string.length >= substr.length && string.substr(string.length - substr.length) == substr;
    }

    onCheckIntervalChanged: {
        statusSource.interval = checkInterval * 1000;
        resultSource.interval = checkInterval * 1000;
    }

    // Temperature checking
    Text {
        id: tempText
        text: ''
        color: 'white'
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    PlasmaCore.DataSource {
        id: resultSource
        engine: 'executable'

        connectedSources: []

        onNewData: {
            var temperature = '';
            if (data['No devices were found'] > 0) {
                temperature = data.stderr;
            } else {
                var result = data.stdout;
                while (endsWith(result,'\n'))
                    result = result.substr(0, result.length - 1);

                var i = result.indexOf(':');
                if (i < 0) temperature=result;
                else {
                    var j = result.lastIndexOf(' ');
                    temperature = result.substr(i + 1, j - i - 1);
                }
            }
            tempText.text = temperature + '°C';
        }
        interval: checkInterval * 1000
    }

    onCardIsOnChanged:  {
        root.cardIsOn = cardIsOn;
        if (cardIsOn) {
            var url = Qt.resolvedUrl(".");
            var exec = url.substring(7,url.length);
            resultSource.connectedSources = ['python3 ' + exec + 'nvidia_info.py compact'];
        }
        else {
            resultSource.connectedSources = [];
            tempText.text = '';
        }
    }
}
