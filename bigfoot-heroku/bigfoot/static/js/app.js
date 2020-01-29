/* data route */

function buildPlot() {
  var url = "/data";

  d3.json(url).then(function(response) {

    console.log(response);
    var trace = {
      type: "scatter",
      mode: "lines",
      name: "Bigfoot Sightings",
      x: response.map(data => data.year),
      y: response.map(data => data.sightings)
    };

    var data = [trace];

    var layout = {
      title: "Bigfoot Sightings Per Year",
      xaxis: {
        type: "date"
      },
      yaxis: {
        autorange: true,
        type: "linear"
      }
    };

    Plotly.newPlot("plot", data, layout);
  });

}

buildPlot();
