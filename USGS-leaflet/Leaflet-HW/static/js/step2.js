// let's get this working
console.log("I'm working!");

var earthquakeURL = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson";
var tectonicPlatesURL = "https://raw.githubusercontent.com/fraxen/tectonicplates/master/GeoJSON/PB2002_boundaries.json";
var apiKey = "pk.eyJ1Ijoic2FyYWhmYXdzb24iLCJhIjoiY2p0bG8yejh0MHVkNTQ0cGc3NjZsaWpmdCJ9.tcdLC_jzDT7l7WkfdKe5GQ";



// get request to eartquake URL
d3.json(earthquakeURL, function(data) {

  // Give each feature a pop-up describing the magnitude, place and time of the earthquake
  var earthquakes = L.geoJSON(data, {
    onEachFeature: function(feature, layer) {
      layer.bindPopup("Magnitude: " + feature.properties.mag +"<br>Location: "+ feature.properties.place +
        "<hr><p>" + new Date(feature.properties.time) + "</p>");
    },
      
    // Create a GeoJSON layer containing the features array on the earthquakeData object
    pointToLayer: function (feature, latlng) {
      return new L.circle(latlng,
        {
        opacity: 1,
        fillOpacity: 1,
        fillColor: getColor(feature.properties.mag),
        color: "#000",
        radius: getRadius(feature.properties.mag),
        stroke: true,
        weight: 0.5
        })
    }
  });
  
  createMap(earthquakes);
});

function createMap(earthquakes) {

    // Define darkmap layer
    var darkmap = L.tileLayer("https://api.mapbox.com/styles/v1/mapbox/dark-v9/tiles/256/{z}/{x}/{y}?" +
      "access_token=pk.eyJ1Ijoic2FyYWhmYXdzb24iLCJhIjoiY2p0bG8yejh0MHVkNTQ0cGc3NjZsaWpmdCJ9.tcdLC_jzDT7l7WkfdKe5GQ");
  
    // Define a baseMap object to hold our base layers
    var baseMap = {
      "Dark Map": darkmap
    };

    // Creat a new layer for the tectonic plates
    var tectonicPlates = new L.LayerGroup();

    // Create overlay object to hold our overlay layer
    var overlayMaps = {
      "Earthquakes": earthquakes,
      "Tectonic Plates": tectonicPlates
    };

    // Create map with layers to display on load
    var map = L.map("map2", {
      center: [40.7, -94.5],
      zoom: 3,
      layers: [darkmap, earthquakes, tectonicPlates]
    }); 

    // add the fault lines
    d3.json(tectonicPlatesURL, function(plateData) {
      // Adding geoJSON data & style info to the tectonicPlates layer
      L.geoJson(plateData, {
        color: "#FF1493",
        weight: 2
      })
      .addTo(tectonicPlates);
  });

    // Add the layer control to the map
    L.control.layers(baseMap, overlayMaps, {
      collapsed: false
    }).addTo(map);

  // create a legend
  var legend = L.control({position: 'bottomleft'});

    legend.onAdd = function(map){
      var div = L.DomUtil.create('div', 'info legend'),
        grades = [0, 1, 2, 3, 4, 5],
        labels = [];

  // loop through density intervals and generate a label w/ colored square for each interval
    for (var i = 0; i < grades.length; i++) {
      div.innerHTML +=
        '<i style="background:' + getColor(grades[i] + 1) + '"></i> ' +
        grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
    }
    return div;
  };

  legend.addTo(map);
}
   
  // // determine the color of the marker based on the magnitude of the earthquake.
  // function getColor(magnitude) {
  //   switch (true) {
  //   case magnitude > 5:
  //     return "#ea2c2c";
  //   case magnitude > 4:
  //     return "#ea822c";
  //   case magnitude > 3:
  //     return "#ee9c00";
  //   case magnitude > 2:
  //     return "#eecc00";
  //   case magnitude > 1:
  //     return "#d4ee00";
  //   default:
  //     return "#98ee00";
  //   }
  // }

  // // This function determines the radius of the earthquake marker based on its magnitude.
  // // Earthquakes with a magnitude of 0 were being plotted with the wrong radius.
  // function getRadius(magnitude) {
  //   if (magnitude === 0) {
  //     return 1;
  //   }
  //   return magnitude * 4;
  // }

  //Create color range for the circle diameter 
  function getColor(d){
    return d > 5 ? "#ea2c2c":
    d  > 4 ? "#ea822c":
    d > 3 ? "#ee9c00":
    d > 2 ? "#eecc00":
    d > 1 ? "#d4ee00":
            "#98ee00";
  }

  //Change the maginutde of the earthquake by a factor of 25,000 for the radius of the circle. 
  function getRadius(value){
    return value*25000
  }