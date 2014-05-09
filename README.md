# McClimate

McClimate complexity is an algorithm that measures the complexity of mathematical formulas inside Ruby method definitions.

- The minimum score that a method can have is 1.
- For every use of the four main arithmatic operators (+, -, * and /), the algorithm adds 1 to the score.
- For every literal number, the algorithm adds 1 to the score.

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

`bin/complexity` caches its results inside temporal files. Those files store json data with the score for every method found.
The cache is stored in the global temporal directory defined by your operating system, but it can be overrided setting the environment variable `MCCLIMATE_CACHE`.
