# Python riscv 64 wheels builder

These scripts allow the generation of riscv wheels to be used as python requirements in the cartesi dapps. The project contains a Makefile with several tasks related to building and managing Python wheels for a RISC-V platform, in the context of building Cartesi Dapps

The available tasks are:

-   build: Builds the Python wheels based on the requirements specified in the PIP_REQUIREMENTS_FILE. It uses a docker image to make all the builds specified.
-   create-pip-index: Creates the necessary files for the pip index, including the wheel files and the index HTML file.
-   clean: Cleans up the pip index directory.
-   serve-local-index: Serves a local pip index using the generated wheel files.
-   config: Displays the current configuration values.

The configuration variables are:

-   `PIP_INDEX_URL`: The URL of the pip index where the wheel files will be uploaded. Defaults to `https://think-and-dev.github.io/riscv-python-wheels/pip-index/`
-   `PIP_TRUSTED_HOST`: The trusted host for the pip index. Defaults to `think-and-dev.github.io`
-   `PIP_OUTPUT_REL_DIR`: The relative directory where the wheel files will be stored. Defaults to `./wheels`
-   `PIP_REQUIREMENTS_FILE`: The file containing the Python package requirements. Defaults to `packages-to-build.requirements.txt`
-   `PIP_INDEX_DIR`: The directory where the pip index files will be stored. Defaults to `pip-index`
-   `WHL_BINARY_BASE_URL`: The base URL for the binary wheel files. Defaults to `https://raw.githubusercontent.com/think-and-dev/riscv-python-wheels/main/wheels`
-   `LOCAL_INDEX_PORT`: The port number for serving the local pip index. Defaults to `8000`
-   `TMP_LOCAL_INDEX_DIR`: The temporary directory for the local pip index. Defaults to `./local-pip-index`

In order to modify the variables used, include the new variables in the make task call. For example:

```bash
    make build PIP_REQUIREMENTS_FILE=../mycustomproject/requirements.txt
```

## Build task usage

1. Complete python requirements file with the needed packages
2. Build the requirements by calling the build task

```bash
    make build
```

## Contributing

### How to Contribute

1. Fork the repository.
2. Create a branch for your contribution.
3. Add the wheels you wish to contribute in the `wheels` folder.
    - Wheels can be built using the `build` task.
4. Execute the `create-pip-index` task to generate the pip index.
5. Submit a pull request.

> [!WARNING]
> Ensure that the wheels are placed in the `wheels` folder, and that the `create-pip-index` task was run, so the wheel can be easily installed.
