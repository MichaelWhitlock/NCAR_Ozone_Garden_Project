TESTER = document.getElementById('tester');
TESTER2 = document.getElementById('tester3');

var line1 = {
x: [140, 200, 220, 240],
y: [10, 30, 70, 60],
  type: 'scatter',
  name: '2018'
};
//var line2 = {
//  x: [140, 157, 200, 220, 240],
//  y: [16, 5,30, 40, 32],
//  type: 'scatter',
//  name: '2019'
//};
var data = [line1, line2];
var layout = {title: 'NCAR Mesa Lab: Coneflower',
            xaxis: {
                  title: 'Day Of Year',
                  titlefont: {
                  family: 'Arial, sans-serif',
                  size: 18,
                  color: 'grey'
                },},
             yaxis: {
                  title: 'Proportion Of Injured Leaves',
                  titlefont: {
                  family: 'Arial, sans-serif',
                  size: 18,
                  color: 'grey'
                },} };

//bar chart code

var line3 = {
  x: ['150', '156', '163', '174', '177', '182', '190', '196', '217', '225'],
  y: [20, 14, 23, 30, 23, 34, 45, 32, 12, 13],
  name: 'SF Zoo',
  type: 'bar'
};
var line4 = {
  x: ['150', '156', '163', '174', '177', '182', '190', '196', '217', '225'],
  y: [20, 14, 23, 12, 34, 15, 14, 23, 45, 50],
  name: 'SF Zoo',
  type: 'bar'
};

var layout2 = {barmode: 'stack', title: 'NCAR Mesa Lab: Coneflower',
            xaxis: {
                  title: 'Day Of Year',
                  titlefont: {
                  family: 'Arial, sans-serif',
                  size: 18,
                  color: 'grey'
                },},
             yaxis: {
                  title: 'Proportion Of Injured Leaves',
                  titlefont: {
                  family: 'Arial, sans-serif',
                  size: 18,
                  color: 'grey'
                },
                }};

var data2 = [line3,line4];



Plotly.newPlot('tester', data, layout, {displayModeBar: false});
Plotly.newPlot('tester3', data2, layout2, {displayModeBar: false});

