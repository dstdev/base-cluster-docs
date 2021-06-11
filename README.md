# base-cluster-docs
Base template for cluster documentation using sphyinx

# Usage
## Build Requirements
* Python >= 3.9
* mkdocs
* mkdocs-material


## Building

```
git clone git@github.com:dstdev/base-cluster-docs.git
cd base-cluster-docs
poetry install
mkdocs build
```

## Development

MK Docs provides a development server which can be used to build and serve locally.

```
mkdocs serve
```

# Reference
* [Markdown Syntax](https://spec.commonmark.org/)
* [Myst Parser](https://myst-parser.readthedocs.io/en/latest)
* [Theme](https://sphinx-themes.org/sample-sites/sphinx-material/)
* [NERSC](https://gitlab.com/NERSC/nersc.gitlab.io/-/blob/main/docs/services/bbcp.md)
