# NYC Taxi Pickup Location Clusters

The data for this application is taken from a kaggle competition (https://www.kaggle.com/c/nyc-taxi-trip-duration), that contains data about taxi rides in New York City for the year of 2016. For this app, we will only use the data for June. 

In this app, we cluster the pickup locations based on their coordinates using K-means clustering. The number of clusters is an input that a user can specify.

TODO: Add instructions for downloading and filtering the data.

## Required Libraries

```
install.packages(c('shiny', 'dplyr', 'leaflet'))
```