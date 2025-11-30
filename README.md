# eda4mldata

Companion R package for the textbook *Exploratory Data Analysis for Machine Learning* by Tony Thrall.
## Installation

You can install the development version of eda4mldata from GitHub:
```r
# install.packages("remotes")
remotes::install_github("tthrall/eda4mldata")
```

## Datasets

The package provides the following datasets:

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Dataset </th>
   <th style="text-align:right;"> Observations </th>
   <th style="text-align:right;"> Variables </th>
   <th style="text-align:left;"> Description </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> `handedness` </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Handedness counts by sex for chi-squared independence test </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `mnist_example` </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Sample MNIST handwritten digit images (one per digit 0:9) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `mnist_test` </td>
   <td style="text-align:right;"> 1,000 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Subset (1000 images) of the MNIST test database of handwritten digits, in long format </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `mnist_train` </td>
   <td style="text-align:right;"> 1,000 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Subset (1000 images) of the MNIST training database of handwritten digits, in long format </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `oecd_bli` </td>
   <td style="text-align:right;"> 36 </td>
   <td style="text-align:right;"> 26 </td>
   <td style="text-align:left;"> OECD Better Life indicators by country (2015) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `oecd_bli_indicators` </td>
   <td style="text-align:right;"> 24 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Metadata for OECD Better Life indicators </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `olympic_running` </td>
   <td style="text-align:right;"> 312 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> Olympic track event winning times (1896:2016) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `wine_quality` </td>
   <td style="text-align:right;"> 6,497 </td>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:left;"> Wine physicochemical properties and quality ratings </td>
  </tr>
</tbody>
</table>

### Handedness Data

Handedness counts by sex from Freedman, Pisani & Purves (2007), used to illustrate chi-squared tests for independence.
```r
library(eda4mldata)
data(handedness)
handedness
#> # A tibble: 6 × 3
#>   sex    hnd   count
#>   <chr>  <chr> <int>
#> 1 male   right   934
#> 2 male   left    113
#> 3 male   ambi     20
#> 4 female right  1070
#> 5 female left     92
#> 6 female ambi      8
```

### MNIST Handwritten Digits

Sample images from the MNIST database of handwritten digits, useful for demonstrating image data and dimension reduction.
```r
data(mnist_example)
data(mnist_train)
data(mnist_test)

# mnist_example contains one image per digit (0-9)
# mnist_train and mnist_test contain 1000 images each
dim(mnist_train)
#> [1] 1000    5
```

### OECD Better Life Index

Well-being indicators for 36 countries across 11 dimensions (housing, income, jobs, education, environment, health, etc.).
```r
data(oecd_bli)
data(oecd_bli_indicators)

# See available indicators
oecd_bli_indicators$indicator
#>  [1] "Stakeholder Engagement"    "Voter Turnout"
#>  [3] "Air Pollution"             "Water Quality"
#> ...
```

### Olympic Running Data

Fastest running times for Olympic track events from 1896 to 2016, for men and women across seven distances.
```r
data(olympic_running)
head(olympic_running)
#> # A tibble: 6 × 4
#>    year length sex   time
#>   <int>  <int> <chr> <dbl>
#> 1  1896    100 male   12
#> ...
```

### Wine Quality Data

Physicochemical measurements for Portuguese Vinho Verde wines, with quality ratings from expert tasters.
```r
data(wine_quality)
dim(wine_quality)
#> [1] 6497   13
```

## Data Sources

|Topic                  |Source                          |
|:----------------------|:-------------------------------|
|Handedness by Sex      |[Freedman, Pisani, Purves (4e)](https://doi.org/10.1177/001316447903900237)|
|MNIST subsets          |[Yann LeCun's MNIST Database](http://yann.lecun.com/exdb/mnist/)|
|OECD Better Life Index |[OECD Better Life Index (2015)](https://www.oecdbetterlifeindex.org/)|
|Olympics               |[Olympics.com via tsibbledata](https://olympics.com/en/sports/athletics/)|
|Wine Quality           |[UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality)|

## Related

- [EDA for Machine Learning](https://github.com/tthrall/eda4ml) — the companion textbook

## Citations

If you use these datasets, please cite the original sources:

**Handedness by Sex** > Freedman, D., Pisani, R., & Purves, R. (2007) *Statistics* (4th ed.). W.W. Norton & Company
**MNIST subsets** > LeCun, Y., Cortes, C., & Burges, C. J. C. (1998) The MNIST database of handwritten digits http://yann.lecun.com/exdb/mnist/
**OECD Better Life Index** > OECD (2015). OECD Better Life Index https://www.oecdbetterlifeindex.org/
**Olympics** > tsibbledata: Diverse Datasets for 'tsibble' https://cran.r-project.org/package=tsibbledata
**Wine Quality** > Cortez, P., Cerdeira, A., Almeida, F., Matos, T., & Reis, J. (2009) Modeling wine preferences by data mining from physicochemical properties *Decision Support Systems*, 47(4), 547:553 https://doi.org/10.1016/j.dss.2009.05.016

## License

MIT License
