import QtQuick 2.9
import QtQuick.Window 2.3

Window {
 visible: true; width: 640; height: 480; title: qsTr("Jogo Da Velha")
 property string backgroundColor: "#f7f6ee"; property string pieceColor: "#fff7b5"
 property string pieceBorderColor: "#f9e6bd"
 property int mainCellWidth: 80; property int mainCellHeight: 80
 property int mainCellWidthSpace: 10; property int mainCellHeightSpace: 10
 property int mainGrid: 3; property string xColor: "#8f7d55"; property string oColor: "#fdf7e9"
 property variant gridValues: ({}); property int currentPlayer: 0; property string won: ""; property int count: 0
 color: backgroundColor
 Component.onCompleted: newGame()
 function newGame() {
  var j, k
  for (k=0;k<mainGrid;k++)
   for (j=0;j<mainGrid;j++) {
    gridValues[j*mainGrid+k]=""
    gridValues[j+","+k]=""
   }
  won=""; currentPlayer=0; count=0
 }
 function checkGame(i,x,y) {
  if (won!=="") return
  if (typeof gridValues[i]=="undefined" || gridValues[i]==="") {
   gridValues[x+","+y]=gridValues[i]=(currentPlayer==0)?"O":"X"
   currentPlayer=(currentPlayer==0)?1:0
   count++
  }
  var j, k, tipo
  for (k=0;k<2;k++) {
   tipo=(k===0)?"O":"X"
   for (j=0;j<mainGrid;j++) {
    won=((gridValues[j+","+0]===tipo && gridValues[j+","+1]===tipo && gridValues[j+","+2]===tipo)
      || (gridValues[0+","+j]===tipo && gridValues[1+","+j]===tipo && gridValues[2+","+j]===tipo))?tipo:won;
   }
   won=(won===tipo || (gridValues["0,0"]===tipo && gridValues["1,1"]===tipo && gridValues["2,2"]===tipo)
                   || (gridValues["0,2"]===tipo && gridValues["1,1"]===tipo && gridValues["2,0"]===tipo))?tipo:won;
  }
  won=(count==mainGrid*mainGrid && won==="")?"-":won
 }
 Item
 {
  id: gridParent
  anchors.fill: parent
  GridView
  {
   Text { y: -60; text: "Current Player "+((currentPlayer==0)?"O":"X"); font.pixelSize: 32; color: xColor }
   Text { y: parent.height+2; visible: (won!==""); text: (won==="-")?"Tie":"Player "+won+" won!"; font.pixelSize: 32; color: xColor
    Rectangle { x: parent.width+8; width: 120; height: 40; radius: 8
     Text { anchors.centerIn: parent; text: "Restart"; font.pixelSize: 32 }
     MouseArea { anchors.fill: parent; onClicked: newGame() } } }
   anchors.centerIn: parent; interactive: false
   width: (mainCellWidth+mainCellWidthSpace)*mainGrid; height: (mainCellHeight+mainCellHeightSpace)*mainGrid
   cellWidth: (mainCellWidth+mainCellWidthSpace); cellHeight: (mainCellHeight+mainCellHeightSpace)
   model: mainGrid*mainGrid
   delegate: Rectangle {
    property string currentText: (count>-1 && typeof gridValues[index]!="undefined")?gridValues[index]:""
    x: mainCellWidthSpace/2; y: mainCellHeightSpace/2; width: mainCellWidth; height: mainCellHeight
    color: pieceColor; border.width: 1; border.color: pieceBorderColor
    MouseArea { anchors.fill: parent; onClicked: checkGame(index,Math.floor(index/3),index%3) }
    Text { color: xColor; text: currentText; font.pixelSize: 68; anchors.centerIn: parent }
    Text { color: xColor; text: currentText; font.pixelSize: 60; anchors.centerIn: parent }
    Text { color: (text=="O")?oColor:xColor; text: currentText; font.pixelSize: 64; anchors.centerIn: parent }
   }
  }
 }
}
