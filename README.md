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

# poetry was used to manage the package dependencies
poetry install

# pip version
pip install -r requirements.txt

mkdocs build
```

## Development

MK Docs provides a development server which can be used to build and serve locally.

```
mkdocs serve
```

If the macro's plugin is enabled, real-time building is unavailable and has to be rebuilt each time a change is made manually.  You can then serve the files directly using the python simple http server.

```
mkdocs build
cd site
python -m http.server 8000 --bind 127.0.0.1
```

Now you can go to your web browser to http://localhost:8000 and the docs should be there.

### Poetry

```
#Generate requirements file
poetry export -f requirements.txt > requirements.txt
```


# Reference
* [Markdown Syntax](https://spec.commonmark.org/)
* [MKDocs](https://www.mkdocs.org/)
* [MKDocs Material](https://squidfunk.github.io/mkdocs-material/)
* [NERSC](https://gitlab.com/NERSC/nersc.gitlab.io/-/blob/main/docs/services/bbcp.md)
