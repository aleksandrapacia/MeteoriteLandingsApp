# MeteoriteLandingsApp
#### Interactive app written in R to discover the data on meteorite landings
1. Data description
The Meteorite Landings dataset from Kaggle contains information about known meteorites that fell to Earth or were later discovered. The data originates from The Meteoritical Society and is made available by NASA. The collection includes, among others, meteorite names, their unique identifiers, classification (type of meteorite), mass in grams, the year of impact or discovery, and information on whether the meteorite was observed falling ("fell") or was only discovered ("found"). The dataset also contains geographic data, such as the latitude and longitude of the discovery site, which allows for the analysis of meteorite distribution across the globe.
2. Data specification
Here is the translation of the dataset information into English:

A) Number of columns – 10, number of rows – 45716

B) Column names:

name – name of the meteorite

id – unique identifier (integer)

nametype – type of name (e.g., "Valid" for a standard meteorite or "Relict" for highly degraded fragments)

recclass – meteorite classification

mass (g) – mass of the meteorite in grams

fall – whether the meteorite was observed falling ("Fell") or only found ("Found")

year – year of impact or discovery (often stored as date/text, the year must be extracted)

reclat – latitude of the discovery site

reclong – longitude of the discovery site

GeoLocation – combination of coordinates (e.g., "(lat, long)")

3. Libraries
-shiny
-leaflet
-dplyr
-ggplot2
-bslib
-DT

4. Overview and functionality
a. Statistics
This tab presents basic descriptive statistics for the currently selected data. It displays the total number of meteorites, the number of records with a "Valid" status, the average meteorite mass, the mass of the heaviest object, and the oldest and newest landing years. All values are dynamic and update according to filters applied via the year range slider (selection of year range and landing type).
<img width="468" height="235" alt="image" src="https://github.com/user-attachments/assets/d39db80c-096d-4e75-b5d8-88a7b38e856a" />

b. Map
This tab enables the analysis of the spatial distribution of meteorites across the globe. Blue represents meteorites found after impact, while red represents those that were observed during their fall.
<img width="468" height="233" alt="image" src="https://github.com/user-attachments/assets/8bd8f124-232a-4844-bf6a-6a6be7aa5a89" />

c. Mass Distribution
This tab contains a histogram showing the mass distribution of meteorites. The chart represents the relationship between the number of meteorites and their specific falling mass. Users can choose between a linear or logarithmic scale for the mass axis, which facilitates the analysis of data with high variance.
<img width="468" height="234" alt="image" src="https://github.com/user-attachments/assets/3ff3e84e-676a-473b-9d97-80bbe029ec86" />

d. Number of Landings
This tab shows how the number of registered meteorite landings has changed over time. Different scales can be adjusted.
<img width="410" height="206" alt="image" src="https://github.com/user-attachments/assets/918ead9b-da6a-48d9-98e5-6e97519d95ea" />

e. Table
This tab contains an interactive table with complete data for meteorites meeting the selected criteria. Users can sort the data, browse through pages, and analyze detailed information about individual meteorites.
<img width="468" height="235" alt="image" src="https://github.com/user-attachments/assets/32457e78-82ac-4d0f-92c3-d614d59ed622" />


### Created in collaboration with: https://github.com/kasiakk216
