import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property string creation_date_p
    property string modify_date_p
    property int mood_p
    property string title_p
    property string entry_p
    property int favorite_p
    property string hashtags_p
    property int rowid

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height + Theme.paddingLarge

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: header
                title: title_p.trim() !== "" ? title_p.trim() : parseDate(creation_date_p).toLocaleString(Qt.locale(), "dddd");
                description: parseDate(creation_date_p).toLocaleString(Qt.locale(), dateTimeFormat)
                _titleItem.truncationMode: TruncationMode.Fade
                _titleItem.maximumLineCount: 2
                _titleItem.wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                _titleItem.horizontalAlignment: Text.AlignRight
                // TODO show full title below if it is too long
            }

            Label {
                id: modDateLabel
                visible: modify_date_p !== ""
                anchors {
                    left: parent.left; leftMargin: Theme.horizontalPageMargin
                    right: parent.right; rightMargin: Theme.horizontalPageMargin
                }
                horizontalAlignment: Text.AlignRight
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
                text: modify_date_p !== "" ? qsTr("Last change: %1").arg(parseDate(modify_date_p).toLocaleString(Qt.locale(), dateTimeFormat)) : ""
            }

            Item {
                width: parent.width
                height: childrenRect.height

                IconButton {
                    id: favStar
                    anchors.right: parent.right
                    icon.source: favorite_p === 1 ? "image://theme/icon-m-favorite-selected" : "image://theme/icon-m-favorite"
                    onClicked: {} // TODO toggle favorite
                }

                Label {
                    anchors {
                        left: parent.left; leftMargin: Theme.horizontalPageMargin
                        right: favStar.left; rightMargin: Theme.paddingMedium
                        verticalCenter: favStar.verticalCenter
                    }

                    text: qsTr("mood: %1").arg(moodTexts[mood_p])
                    truncationMode: TruncationMode.Fade
                }
            }

            TextArea {
                id: entryArea
                visible: !moodImage.visible
                width: parent.width
                wrapMode: TextEdit.WordWrap
                // horizontalAlignment: Text.AlignJustify
                readOnly: true
                text: entry_p
            }

            TextArea {
                id: hashtagArea
                visible: !moodImage.visible
                width: parent.width
                font.pixelSize: Theme.fontSizeExtraSmall
                readOnly: true
                text: hashtags_p.length > 0 ? "# "+hashtags_p : ""
            }

            Item { visible: moodImage.visible; width: parent.width; height: Theme.paddingLarge }

            HighlightImage {
                id: moodImage
                visible: entry_p === "" && hashtags_p === ""
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(page.width, page.height)/4; height: width
                fillMode: Image.PreserveAspectFit
                color: Theme.primaryColor
                opacity: Theme.opacityLow
                source: "../images/mood-%1.png".arg(String(mood_p))
            }
        }
    }
}

