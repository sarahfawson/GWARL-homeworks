// The code for the chart is wrapped inside a function that
// automatically resizes the chart
function makeResponsive() {

    // if the SVG area isn't empty when the browser loads,
    // remove it and replace it with a resized version of the chart
    var svgArea = d3.select("body").select("svg");

    // clear svg is not empty
    if (!svgArea.empty()) {
        svgArea.remove();
    }

    // Set up the chart
    // ==========================================
    var svgWidth = 800;
    var svgHeight = 500;

    var margin = {
        top: 20,
        right: 40,
        bottom: 60,
        left: 100
    };

    var width = svgWidth - margin.left - margin.right;
    var height = svgHeight - margin.top - margin.bottom;


    // Create an SVG wrapper, append an SVG group that will hold our chart,
    // and shift the latter by left and top margins.
    var svg = d3.select("#scatter")
        .append("svg")
        .attr("width", svgWidth)
        .attr("height", svgHeight)
        .attr("class", "chart");

    // append group element
    var chartGroup = svg.append("g")
        .attr("transform", `translate(${margin.left}, ${margin.top})`);

    // Parse and format the data
    // ============================================
        
    // Read in CSV
    d3.csv("assets/data/data.csv").then(function(journoData) {
        console.log(journoData);

        // parse data
        journoData.forEach(function(data) {
            data.healthcare = +data.healthcare;
            data.poverty = +data.poverty;
            data.age = +data.age;
            data.income = +data.income;
            data.smokes = +data.smokes;
            data.healthcareLow = +data.healthcareLow;
        });

        // Create Scales for the range of data
        //=============================================
        var xLinearScale = d3.scaleLinear()
            .domain([0, d3.max(journoData, d => d.healthcare)])
            .range([height, 0]);

        var yLinearScale = d3.scaleLinear()
            .domain([0, d3.max(journoData, d => d.poverty)])
            .range([height, 0]);

        // Create Axes
        // =============================================
        var bottomAxis = d3.axisBottom(xLinearScale);
        var leftAxis = d3.axisLeft(yLinearScale);
        
        // Append the axes to the chartGroup 
        // ==============================================
        chartGroup.append("g")
            .attr("transform", `translate(0, ${height})`)
            .call(bottomAxis);

        chartGroup.append("g")
            .call(leftAxis);

        // Defining the circles on the chart
        var circlesGroup = chartGroup.selectAll("circle")
            .data(journoData)
            .enter()
            .append("circle")
            .attr("cx", d => xLinearScale(d.healthcare))
            .attr("cy", d => xLinearScale(d.poverty))
            .attr('r', "10")
            .attr("fill", "hotpink")
            .style("opacity", "0.8")
            ;


        // Define a tooltip
        var toolTip = d3.tip()
        .attr("class", "tooltip")
        .html(function(d){
            return (`Healthcare: ${d.healthcare}<br>Poverty Level: ${d.poverty}`);
        });

        chartGroup.call(toolTip);


        // Add an onmouseover and onmouseout event to display a tooltip
        // ========================================================
        circlesGroup.on("click", function(data) {
            toolTip.show(data, this);
          })
            // onmouseout event
            .on("mouseout", function(data, index) {
              toolTip.hide(data);
            });   


        // Text for y-axis
        chartGroup.append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 0 - margin.left + 40)
            .attr("x", 0 - (chartHeight))
            .attr("dy", "1em")
            .attr("class", "axisText")
            .text("Population in Fair or Poor Health (%)")

        // Text for x-axis
        chartGroup.append("text")
            .attr("transform", "translate(" + (chartWidth/2) + ", " + (chartHeight + margin.top + 20) + ")")
            .attr("class", "axisText")
            .style("text-anchor", "middle")
            .text("Population in Poverty (%)");

        // Text for title
        // chartGroup.append("text")
        //     .style("text-anchor", "center")
        //     .attr("class", "axisText")
        //     .text("Correlation of Health vs. Poverty in USA");
    })
};

// When the browser loads, makeResponsive() is called.
makeResponsive();

// When the browser window is resized, makeResponsive() is called.
d3.select(window).on("resize", makeResponsive);