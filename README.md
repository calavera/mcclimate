# McClimate

McClimate complexity is an algorithm that measures the complexity of mathematical formulas inside Ruby method definitions.

- The minimum score that a method can have is 1.
- For every use of the four main arithmatic operators (+, -, * and /), the algorithm adds 1 to the score.
- For every literal number, the algorithm adds 1 to the score.

## Installation

McClimate uses Rugged to interact with git repositories. Unfortunately, there has not been any release in 10 months.
Rugged's development branch has a lot of improvements that have not been released yet.

The scripts in this repository use Bundler to make sure the Rugged and LibGit2 versions are correct.
If you want to install McClimate as a gem, you'll need to make sure the versions for those two dependencies are properly installed.

## Usage

### Calculating complexity

The script `bin/complexity` calculates the McClimate score for a given git project. It also accepts a second argument to indicate
the git SHA referencing the tree that we want to analize.

Example:

```
$ bin/complexity path/to/git/repo
```

```
$ bin/complexity path/to/git/repo SHA
```

#### Displaying Results

`bin/complexity` shows you a warning message for every method with complexity higher than 10.
Methods with score lower than 10 are not displayed, but they are still stored in the [cache](#Caching results) for future references.

### Caching results

`bin/complexity` caches its results inside temporal files. Those files store serialized data with the score for every method found.
The cache is stored in the global temporal directory defined by your operating system, but it can be overrided setting the environment variable `MCCLIMATE_CACHE`.

## Benchmarks

The folder `bench` includes several benchmarks used to measure the performance of the complexity algorithm.
These benchmarks don't produce any output, they use the basic reporter that doesn't print to stdout.

Eeach benchmark is a self executed script, that you can run like this:

```
$ bench/bench_self_score
```
