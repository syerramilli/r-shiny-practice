# Movie Explorer

This is an attempt in recreating the movie explorer app at https://shiny.posit.co/r/gallery/interactive-visualizations/movie-explorer/. Instead of using `ggvis`, I use `plotly` to generate the scatter plot. The data is a subset of data from [OMDb](http://www.omdbapi.com/), which in turn is from IMDb and Rotten Tomatoes. The data is saved in a SQLite database `movies.db` that can be accessed from [here](https://github.com/rstudio/shiny-examples/tree/main/051-movie-explorer).

## Required libraries

```
shiny
dplyr
plotly
RSQLite
```