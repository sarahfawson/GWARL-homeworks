#################################################
# Climate App
# Now that you have completed your initial analysis, design a Flask 
# api based on the queries that you have just developed.
#################################################
import numpy as np
import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from flask import Flask, jsonify
import datetime as dt
import pandas as pd

#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

Base = automap_base()
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)

#################################################
# Flask Routes
#################################################

@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"""<b>Available Routes:</b>
        <br/>
        <br/>
        List of Precipitation Values:<br/>
        /api/v1.0/precipitation<br/>
        <br/>
        List of Station numbers:<br/>
        /api/v1.0/stations<br/>
        <br/>
        Temperature Observations:<br/>
        /api/v1.0/tobs"""
    )

@app.route("/api/v1.0/precipitation")
def precip():
    """Convert the query results to a Dictionary using date as the key and prcp as the value. \
        Return the JSON representation of your dictionary."""
    session = Session(engine)

    # Query the dates and precipitation observations from the last year.
    last_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()
    last_year = dt.date(2017, 8, 23) - dt.timedelta(days=365)
    rain = session.query(Measurement.date, Measurement.prcp).\
        filter(Measurement.date > last_year).\
        order_by(Measurement.date).all()

    # Create a list of dicts with `date` and `prcp` as the keys and values
    rain_totals = []
    for r in rain:
        row = {}
        row["date"] = rain[0]
        row["prcp"] = rain[1]
        rain_totals.append(row)

    return jsonify(rain_totals)
    
################################################

@app.route("/api/v1.0/stations")
def stations():
    """Return a JSON list of stations from the dataset."""
    session = Session(engine)

    # Query all stations
    stations_query = session.query(Station.name, Station.station)
    stations = pd.read_sql(stations_query.statement, stations_query.session.bind)
    return jsonify(stations.to_dict())

################################################

@app.route("/api/v1.0/tobs")
def tobs():
    """Query for the dates and temperature observations from a year from the last data point. \
        Return a JSON list of Temperature Observations (tobs) for the previous year."""
    session = Session(engine)
    # Query the dates and temperature observations for the last year of data
    # store the query results to a dictionary using `date` as the key and `tobs` as the value
    # Return the jsonified dictionary
    last_date = session.query(Measurement.date).order_by(Measurement.date.desc()).first()
    last_year = dt.date(2017, 8, 23) - dt.timedelta(days=365)
    temperature = session.query(Measurement.date, Measurement.tobs).\
        filter(Measurement.date > last_year).\
        order_by(Measurement.date).all()

    # Create a list of dicts with `date` and `tobs` as the keys and values
    temperature_totals = []
    for t in temperature:
        row = {}
        row["date"] = temperature[0]
        row["tobs"] = temperature[1]
        temperature_totals.append(row)

    return jsonify(temperature_totals)

################################################

@app.route("/api/v1.0/<start>")
def trip1(start):
    """Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start or start-end range.\
        When given the start only, calculate TMIN, TAVG, and TMAX for all dates greater than and equal to the start date."""
    # my trip timeline
    trip_start = ('2019-05-20')
    trip_end = ('2019-05-28')
    # convert to dt format  
    start_date= dt.datetime.strptime(trip_start, '%Y-%m-%d')
    # go back one year(two years, due to dataset end date) from start date  
    comparison = dt.timedelta(days=730)
    start = (start_date-comparison)

    trip_data = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(Measurement.date >= start).all()
    trip = list(np.ravel(trip_data))
    return jsonify(trip)

################################################

@app.route("/api/v1.0/<start>/<end>")
def trip2(start,end):
    """Return a JSON list of the minimum temperature, the average temperature, and the max temperature for a given start or start-end range.\
        When given the start and the end date, calculate the TMIN, TAVG, and TMAX for dates between the start and end date inclusive."""
    # my trip timeline
    trip_start = ('2019-05-20')
    trip_end = ('2019-05-28')
    # convert to dt format  
    start_date= dt.datetime.strptime(trip_start, '%Y-%m-%d')
    end_date= dt.datetime.strptime(trip_end,'%Y-%m-%d')

    # 2 years prior
    comparison  = dt.timedelta(days=730)
    start = (start_date-comparison)
    end = (end_date-comparison)

    trip_data = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).\
        filter(Measurement.date >= start).filter(Measurement.date <= end).all()
    trip = list(np.ravel(trip_data))
    return jsonify(trip)
    
################################################

if __name__ == '__main__':
    app.run(debug=True)
