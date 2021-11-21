import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 1.4

Item {
    id: fullRepr
    property bool onlyIfOn: plasmoid.configuration.onlyIfOn

    width: 410
    height: 280

    PlasmaCore.DataSource {
        id: dataSource
        engine: 'executable'
        connectedSources:[]

        onNewData: {
            cardData.text = data.stdout;
        }
    }

    ScrollView {
        anchors.fill: parent

        Text {
            id: cardData
            font.family: 'monospace'
            textFormat: Text.MarkdownText
            color: PlasmaCore.ColorScope.textColor;
        }
    }

    ListView {
        id: data

        model: PlasmaCore.DataModel {
                dataSource: dataSource
        }
    }

    Connections {
        target: plasmoid
        onExpandedChanged: {
            if (plasmoid.expanded) {
                if (root.cardIsOn || !onlyIfOn) {
                    cardData.text = 'Loading...';
                    var url = Qt.resolvedUrl(".");
                    var exec = url.substring(7, url.length);
                    dataSource.connectedSources = ['python3 ' + exec + 'nvidia_info.py full']
                }
                else {
                    cardData.text = 'Your settings allow showing the info\nonly if the card is on.';
                }
            }
            else {
                dataSource.connectedSources = [];
            }
        }
    }
}
