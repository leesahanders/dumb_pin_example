# Pins example 

This is a very simple example of using pins a couple ways: 

- Inside a shiny app 
- Scheduled in a quarto document 
- Pushing/pulling from the developers local computer 

Each method using a Connect server that is hosting the pins. Enjoy!

## Resources 

Refer to the Connect documentation on pins here: <https://pins.rstudio.com/>

Refer to the pins documentation here: <https://docs.posit.co/connect/user/pins/>

## Renv 

### Fast installs with pak 

Parallelize your package installs (particularly useful for monstrous bioconductor packages) using pak with renv. pak will natively use parallelization for the install, making it a ton faster: `options(renv.config.pak.enabled=TRUE)`

### Update your renv version into your lock file before doing a restore

Use `renv::record("renv@1.0.7")` to record renv 1.0.7 in the lockfile.

### Workflow 

The R package upgrade workflow:

```r
# record the current dependencies in a file called renv.lock
renv::snapshot()

# upgrade your packages 
renv::upgrade()

# if an upgrade goes astray, revert the lockfile
renv::revert(commit = "abc123")

# and restore the previous environment
renv::restore()
```

Check our repository with: `options('repos')`

```bash
> options("repos")
$repos
                                                        CRAN 
"https://pkg.current.posit.team/cran/__linux__/jammy/latest" 
attr(,"RStudio")
[1] TRUE
```

Restore our packages with: `renv::restore()`

Check our repository with: `options('repos')`

```bash
> options('repos')
$repos
                                         CRAN 
"https://p3m.dev/cran/__linux__/jammy/latest" 
```

If we want to reference a different repository we can either: 

- `options(repos = c(RSPM = "https://pkg.current.posit.team/cran/__linux__/jammy/latest"))` then `renv::restore(rebuild=TRUE)`
- `renv::restore(repos="https://pkg.current.posit.team/cran/__linux__/jammy/latest", rebuild=TRUE)`

### Bioconductor

For bioconductor: 

- `options(repos=c(BiocManager::repositories()))`
- `renv::init(bioconductor=TRUE)`

```r
# Set the biocmanager repo url 
options(repos=c(BiocManager::repositories()))

# use the latest-available Bioconductor release
renv::init(bioconductor = TRUE)

# use a specific version of Bioconductor
renv::init(bioconductor = "3.14")
```

Some useful Bioconductor commands and tricks: <https://solutions.posit.co/envs-pkgs/bioconductor/index.html#problem-statement> and <https://pkgs.rstudio.com/renv/articles/bioconductor.html>. 

### Here are some debugging commands that would be useful to run

- Add more detail to logging: `options(renv.download.trace = TRUE)`
- Running a diagnostic: `renv::diagnostics(project = NULL)`
- Checking the library location (check this from inside a renv project): `renv::paths$library()`
- Checking the users install location (check this while OUTSIDE of an renv project): `.libPaths()`
- One more thing to check - is the location the packages are being installed a sharedrive? If so can we check with IT how the drive was mounted? Mounting with `noexec` can create some weird issues. They'd check `/etc/fstab` to see if the home directories are mounted with noexec.

### Gather up the system dependencies needed to support a renv project: 

Read the renv.lock file (e.g. like https://forum.posit.co/t/compare-two-renv-projects/145574/2) and then use pak::pkg_sysreqs() to list out missing system requirements (cf. https://pak.r-lib.org/reference/pkg_sysreqs.html)

## Something else? 

https://positpbc.slack.com/archives/CFLAY27EH/p1738882936657449?thread_ts=1738882549.340409&cid=CFLAY27EH

### Troubleshooting Mass installs

Mass: https://positpbc.slack.com/archives/C04280LRVQT/p1727808491050659?thread_ts=1727803940.584719&cid=C04280LRVQT 

### Removing renv and creating a new renv 

Completely removing renv from a project should always be a last resort. If needed, the way to cleanly delete a project renv is to remove renv.lock, the project's renv/ folder, and the renv entries in the project's .Rprofile.


Instead of manually deleting the `renv/` files, the most streamlined and official method is to use the built-in `renv` functions designed for this purpose.The workflow for creating a new project from the template should be:  

1. Open the new project - the old `renv` environment from the template will activate as expected.
2. Run `renv::deactivate(clean = TRUE)` in the console. This command is the clean way to remove `renv` from a project. It removes the auto-loader from the `.Rprofile` and deletes the project's private library.
3. Restart the R session. This is a crucial step to ensure the old environment is fully unloaded.
4. Run `renv::init()`. This will now behave as if it's a brand new project. It will:
    - Discover the correct, current repository URLs from the R session's configuration (`getOption("repos")`).
    - Scan the project's `.R`, `.Rmd`, and `.qmd` files to find package dependencies.
    - Install those packages and build a brand new `renv.lock` file with the correct URLs and package versions.
    
### Resources

Get started with renv in the RStudio IDE: https://docs.posit.co/ide/user/ide/guide/environments/r/renv.html

You should be using renv: https://www.youtube.com/watch?v=GwVx_pf2uz4
