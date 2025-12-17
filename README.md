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
   <td style="text-align:left;"> `lg_competencies` </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> Seven data science competency areas from the IC CRG framework </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_course_prereq` </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Course prerequisite edges (course → course) with rationale </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_courses` </td>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Fifteen courses providing complete coverage of all skills </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_has_skill` </td>
   <td style="text-align:right;"> 41 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Learner skill edges (learner → skill) with proficiency level </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_learners` </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Six fictional learner profiles with varying backgrounds </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_prerequisite` </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Skill prerequisite edges (skill → skill) for conceptual dependencies </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_proficiency_levels` </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> Five-level proficiency scale (None through Master) with guidance </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_requires_skill` </td>
   <td style="text-align:right;"> 25 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Work role skill requirements (role → skill) with minimum proficiency </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_schema` </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Knowledge graph schema defining node types, edge types, and constraints </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_skills` </td>
   <td style="text-align:right;"> 18 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> Eighteen knowledge and skill areas (KSAs) from the data science competency framework </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_teaches` </td>
   <td style="text-align:right;"> 19 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Course teaching edges (course → skill) with proficiency ceiling </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lg_work_roles` </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> Three work roles: Data Analyst, Data Scientist, AI/ML Specialist </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `lit_digest` </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> 1936 Literary Digest poll predictions vs. actual result </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `mnist_example` </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Sample (10 images; 7,840 rows in long format) MNIST handwritten digit images (one per digit 0:9) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `mnist_test` </td>
   <td style="text-align:right;"> 1,000 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Subset (1000 images; 784,000 rows in long format) of the MNIST test database of handwritten digits, in long format </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `mnist_train` </td>
   <td style="text-align:right;"> 1,000 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> Subset (1000 images; 784,000 rows in long format) of the MNIST training database of handwritten digits, in long format </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `nb10` </td>
   <td style="text-align:right;"> 100 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:left;"> Repeated weighings of a standard weight (deficit in micrograms below 10g) </td>
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
   <td style="text-align:left;"> `portacaval_studies` </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> Study counts by design type and reported improvement level </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `portacaval_survival` </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Survival rates comparing randomized vs. non-randomized designs </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `salk_blind` </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:left;"> Randomized controlled double-blind trial results </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `salk_nfip` </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> NFIP observed-control design results </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `truman_dewey` </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:left;"> 1948 election polling predictions vs. actual result </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `ucb_admissions` </td>
   <td style="text-align:right;"> 24 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:left;"> Graduate admissions by department and sex (Simpson's paradox) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> `us_elections` </td>
   <td style="text-align:right;"> 14 </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:left;"> Gallup poll accuracy for US presidential elections (1952:2004) </td>
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

### LearningGraph Knowledge Graph

The `learning_graph` object is a knowledge graph for skills-based learning in data science, based on the IC Data Science Competency Resource Guide (2023) with structure inspired by Workera.ai\'s skills intelligence platform. It demonstrates graph theory concepts including directed acyclic graphs, bipartite structures, weighted edges, and path algorithms.

The knowledge graph contains five node types (skills, courses, learners, work roles, competencies) and five edge types (has_skill, requires_skill, prerequisite, course_prereq, teaches). The complete object is available as `learning_graph`, with individual components exported as `lg_*` tibbles for convenience.
```r
data(learning_graph)

# Structure overview
names(learning_graph)
#> [1] "metadata"           "proficiency_levels" "nodes"              "edges"

# Access nodes
names(learning_graph$nodes)
#> [1] "competencies" "skills"       "work_roles"   "courses"      "learners"

# Access edges
names(learning_graph$edges)
#> [1] "has_skill"      "requires_skill" "prerequisite"   "course_prereq"  "teaches"

# Example: view skills
learning_graph$nodes$skills
#> # A tibble: 18 × 6
#>    skill_id skill_tag          skill_name             cmp_id k_or_s description
#>       <int> <chr>              <chr>                   <int> <chr>  <chr>
#>  1        1 algorithms         Algorithms                  1 k      Knowledge of designing...
#>  2        2 programming        Programming                 1 s      Skill in programming...
#> ...

# Or use individual exports
data(lg_skills)
data(lg_prerequisite)
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

|Topic                   |Source                          |
|:-----------------------|:-------------------------------|
|Handedness by Sex       |[Freedman, Pisani, Purves (4e)](https://doi.org/10.1177/001316447903900237)|
|LearningGraph           |[IC DSci-CRG & Workera.ai](https://www.dni.gov/)|
|MNIST subsets           |[Yann LeCun's MNIST Database](http://yann.lecun.com/exdb/mnist/)|
|NB10 Repeated Weighings |[Freedman, Pisani, Purves (4e)](https://wwnorton.com/books/9780393929720)|
|OECD Better Life Index  |[OECD Better Life Index (2015)](https://www.oecdbetterlifeindex.org/)|
|Olympics                |[Olympics.com via tsibbledata](https://olympics.com/en/sports/athletics/)|
|Polling and Elections   |[Freedman, Pisani, Purves (4e)](https://wwnorton.com/books/9780393929720)|
|Portacaval Shunt        |[Freedman, Pisani, Purves (4e)](https://wwnorton.com/books/9780393929720)|
|Salk Vaccine Trial      |[Freedman, Pisani, Purves (4e)](https://wwnorton.com/books/9780393929720)|
|UC Berkeley Admissions  |[Freedman, Pisani, Purves (4e)](https://wwnorton.com/books/9780393929720)|
|Wine Quality            |[UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/wine+quality)|

## Related

- [EDA for Machine Learning](https://github.com/tthrall/eda4ml) — the companion textbook

## Citations

If you use these datasets, please cite the original sources:

**Handedness by Sex**
> Freedman, D., Pisani, R., & Purves, R. (2007) *Statistics* (4th ed.). W.W. Norton & Company

**LearningGraph**
> Office of the Director of National Intelligence (2023) *Competency Resource Guide for Data Science* (UNCLASSIFIED) Structure inspired by Workera.ai skills intelligence platform https://workera.ai/

**MNIST subsets**
> LeCun, Y., Cortes, C., & Burges, C. J. C. (1998) The MNIST database of handwritten digits http://yann.lecun.com/exdb/mnist/

**NB10 Repeated Weighings**
> Freedman, D., Pisani, R., & Purves, R. (2007) *Statistics* (4th ed.), Ch. 6, Sec. 1. W.W. Norton & Company

**OECD Better Life Index**
> OECD (2015). OECD Better Life Index https://www.oecdbetterlifeindex.org/

**Olympics**
> tsibbledata: Diverse Datasets for 'tsibble' https://cran.r-project.org/package=tsibbledata

**Polling and Elections**
> Freedman, D., Pisani, R., & Purves, R. (2007) *Statistics* (4th ed.), Ch. 19. W.W. Norton & Company

**Portacaval Shunt**
> Freedman, D., Pisani, R., & Purves, R. (2007) *Statistics* (4th ed.), Ch. 1, Sec. 2. W.W. Norton & Company

**Salk Vaccine Trial**
> Freedman, D., Pisani, R., & Purves, R. (2007) *Statistics* (4th ed.), Ch. 1, Sec. 1. W.W. Norton & Company

**UC Berkeley Admissions**
> Freedman, D., Pisani, R., & Purves, R. (2007) *Statistics* (4th ed.), Ch. 1, Sec. 4. W.W. Norton & Company Also: Bickel, P. J., Hammel, E. A., & O'Connell, J. W. (1975) *Science*, 187(4175), 398-404

**Wine Quality**
> Cortez, P., Cerdeira, A., Almeida, F., Matos, T., & Reis, J. (2009) Modeling wine preferences by data mining from physicochemical properties *Decision Support Systems*, 47(4), 547-553 https://doi.org/10.1016/j.dss.2009.05.016


## License

MIT License
