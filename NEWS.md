# eda4mldata 1.1.1

## New datasets

* Added `learning_graph`, a knowledge graph for skills-based learning in data 
  science. Based on the IC Data Science Competency Resource Guide (2023) with 
  structure inspired by Workera.ai's skills intelligence platform. The knowledge
  graph demonstrates graph theory concepts including directed acyclic graphs,
  bipartite structures, weighted edges, and path algorithms.

* Added individual `lg_*` tibble exports for convenient access to LearningGraph
  components:
  - Node tables: `lg_competencies`, `lg_skills`, `lg_work_roles`, `lg_courses`, 
    `lg_learners`
  - Edge tables: `lg_has_skill`, `lg_requires_skill`, `lg_prerequisite`, 
    `lg_course_prereq`, `lg_teaches`
  - Reference tables: `lg_proficiency_levels`, `lg_schema`

## Documentation

* Updated README with LearningGraph documentation and usage examples.

# eda4mldata 1.1.0

## New datasets
 
* Added `nb10`: Repeated weighings of NB10 standard weight from Freedman, 
  Pisani & Purves (2007), Chapter 6.

* Added polling and elections datasets from Freedman, Pisani & Purves (2007),
  Chapter 19: `lit_digest`, `truman_dewey`, `us_elections`.

* Added Portacaval shunt study data from Freedman, Pisani & Purves (2007),
  Chapter 1: `portacaval_studies`, `portacaval_survival`.

* Added Salk vaccine trial data from Freedman, Pisani & Purves (2007),
  Chapter 1: `salk_blind`, `salk_nfip`.

* Added UC Berkeley admissions data from Freedman, Pisani & Purves (2007),
  Chapter 1: `ucb_admissions`.

# eda4mldata 1.0.0

## Initial release

* `handedness`: Handedness counts by sex for chi-squared independence test.

* `mnist_example`, `mnist_train`, `mnist_test`: MNIST handwritten digit subsets.

* `oecd_bli`, `oecd_bli_indicators`: OECD Better Life Index (2015) data.

* `olympic_running`: Olympic track event winning times (1896–2016).

* `wine_quality`: Wine physicochemical properties and quality ratings.
