# ETL Project
This project's purpose is to work with a partner to find multiple datasets or data sources and load them together for future analysis. We (Sarah & Paul) discovered a shared interest in understanding health patterns across the US, so this interest guided our search. We worked together to create a database of US mortality data and census identifiers that are easy to use together in order to look up specific data for future analyses.


## 1. Extract
### Mortality Data
We found data on Mortality Rates in the United States from CDC.gov: https://wonder.cdc.gov/controller/datarequest/D140 We decided to export this dataset based on:

* County code
* ICD Chapter (type of death)
* Death count
* Population of county
The data exported as a txt file. We read the txt file into pandas like it is a csv, using "\t" to indicate the tab delimited separations between the data cells.

### Census Planning Database
The 2015 Planning Database (https://www.census.gov/research/data/planning_database/2015/) contains selected 2010 Census and selected 2009-2013 5-year American Community Survey (ACS) estimates. Data are provided at both the census block group and the tract levels of geography. The Planning Database (PDB) assembles a range of housing, demographic, socioeconomic, and census operational data that can be used for survey and census planning. In addition to variables extracted from the census and ACS databases, operational variables include the 2010 Census Mail Return Rate for each block group and tract.

### Web Scraping of Wikipedia
In looking through the Census Planning Database, it did not have a state abbreviation (which some datasets use as identifiers). Wikipedia has a List of U.S. State Abbreviations (https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations) that includes the Census abbreviation along with ISO, United States Postal Code, and United States Coast Guard abbreviations. ISO 3166 is a standard published by the International Organization for Standardization (ISO) that defines codes for the names of countries, dependent territories, special areas of geographical interest, and their principal subdivisions (e.g., provinces or states). Thus, if any additional datasets have other state abbreviations, the new potential universal database can include those as well.


## 2. Transform
### Mortality Data
A lot of filtering was done manually on the CDC website to select which data we wanted to include. There was also a record limit on how much data could be downloaded at once, so it took a few tries to narrow down our selections in order to download applicable information in one file. The file was downloaded as a txt and we were able to read it into the jupyter notebook with `read_csv` separated by tabs.

### Census Planning Database
First, we removed all of the housing and demographic data to only identify the geographic identifiers. In examining the Census Planning Database, the census block group (12-digit census identifier) was incomplete for a majority of the rows. However, the other geographic identifiers (e.g., county code, tract number, block group number) were all correct, so by adding the necessary preceding zeros when needed (e.g., turning a county code of 1 to 001), we could build to the 12-digit census block group from that data. 

We also created the FIPS. The Federal Information Processing Standard Publication 6-4 (FIPS 6-4) was a five-digit Federal Information Processing Standards code which uniquely identified counties and county equivalents in the United States, certain U.S. possessions, and certain freely associated states.We also created columns for FIPS, Census Block Group, and Census Tract with no preceding zeros because some data sources will omit the preceding zero (e.g., CDC Wonder Data drops the preceding zero). Also, some datasets when read into python or mysql will drop the zero. After getting all the data, we did some minor re-orderingof the data to make more logical sense.

### Web Scraping of Wikipedia
After using pandas to scrape the Wikipedia url, we located the appropriate table and it was not pretty. So, data munging involved dropping rows, renaming columns, dropping columns, resetting the index (twice), and removing rows with extraneous data (e.g., Midway Islands, Micronesia). With the web scraping and the census planning database, we merged on full state name. From there, we removed a duplicate column and renamed another.

## 3. Load
We established a local connection to one of our mySQL databases and used a `database.to_sql` formula to load in each pandas dataset into the mongoDB. Afterwareds, we query each of the 2 large datasets loaded to check that the data was properly transferred. We chose mongoDB because it was really easy to add any type of data to the unstructured database platform. Now that all the data we extracted and cleaned is in a database, it will make things a lot simpler for future analyses when we are looking to query all sorts of data in order to understand mortality data across the nation and shed light on patterns that exist.

### Future/Why This is Chosen

With the universal census database with geographic identifiers, a wide variety of datasets can become comparable. 
* Department of Homeland Security location of hospitals, public health systems, nursing homes, and gold bullion repository locations.
* Department of Health and Human Services health shortage areas, stroke mortality by county, and state drug utilization levels.
* Census data in every way, shape, or form.
* Federal Communications Commission data on internet speed connectivity by census tract (to help measure the digital divide between urban and rural areas).

And, of course, with the CDC wonder mortality data that is based on ICD-10 codes, we can see if and where anybody died from being struck by a duck, subsequent encounter (ICD-10 W61.62XD).

