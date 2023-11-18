.PHONY: build config serve-local-index create-pip-index clean
########## CONFIGURATION ##########
PIP_INDEX_URL=https://think-and-dev.github.io/riscv-python-wheels/pip-index/
PIP_TRUSTED_HOST = think-and-dev.github.io
PIP_OUTPUT_REL_DIR = ./wheels
PIP_REQUIREMENTS_FILE = packages-to-build.requirements.txt
PIP_INDEX_DIR = pip-index
WHL_BINARY_BASE_URL = https://raw.githubusercontent.com/think-and-dev/riscv-python-wheels/main/wheels
LOCAL_INDEX_PORT = 8000
TMP_LOCAL_INDEX_DIR = ./local-pip-index
########## END CONFIGURATION ##########

# Build task
build:
	@${MAKE} config
	
	@########## BUILDING WHEELS ##########
	@echo "Building packages..."
	@echo "  Creating docker image for cartesi wheel builder..."
	docker build --tag cartesi-wheel-builder:latest -f ./CartesiWheelBuilder.Dockerfile .

	@echo "  Executing builder container to build wheels on ${PIP_REQUIREMENTS_FILE} requirements file"
	docker run -v ${PWD}:/opt/cartesi/dapp --platform=linux/riscv64 cartesi-wheel-builder:latest pip wheel -r ${PIP_REQUIREMENTS_FILE} -w ${PIP_OUTPUT_REL_DIR} --extra-index-url ${PIP_INDEX_URL}  --trusted-host ${PIP_TRUSTED_HOST}

	@${MAKE} create-pip-index

# Creates the files for the pip index
create-pip-index:
	@echo "Creating wheels pip index files..."
	./scripts/create-pip-index.sh ${PIP_OUTPUT_REL_DIR} ${PIP_INDEX_DIR} ${WHL_BINARY_BASE_URL}

# Clean task
clean:
	@echo "Cleaning up..."
	rm -rf ${PIP_INDEX_DIR}

# Serve local index task
serve-local-index:
	@echo "Removing local wheels pip index..."
	rm -rf ${TMP_LOCAL_INDEX_DIR}
	@echo "Creating local wheels pip index..."
	@./scripts/create-pip-index.sh ${PIP_OUTPUT_REL_DIR} ${TMP_LOCAL_INDEX_DIR} "http://localhost:${LOCAL_INDEX_PORT}/wheels"
	@echo "Creating link to wheels folder in local index..."
	@ln -s ${PWD}/${PIP_OUTPUT_REL_DIR} ${TMP_LOCAL_INDEX_DIR}/wheels
	@echo "Serving local pip index..."
	./scripts/serve-local-index.sh ${TMP_LOCAL_INDEX_DIR} ${LOCAL_INDEX_PORT}

# Show configuration
config:
	@echo Configuration: 
	@echo "	PIP_INDEX_URL=${PIP_INDEX_URL}"
	@echo "	PIP_OUTPUT_REL_DIR=${PIP_OUTPUT_REL_DIR}"
	@echo "	PIP_REQUIREMENTS_FILE=${PIP_REQUIREMENTS_FILE}"
	@echo "	PIP_INDEX_DIR=${PIP_INDEX_DIR}"
	@echo "	WHL_BINARY_BASE_URL=${WHL_BINARY_BASE_URL}"
	@echo "	LOCAL_INDEX_PORT=${LOCAL_INDEX_PORT}"
	@echo "	TMP_LOCAL_INDEX_DIR=${TMP_LOCAL_INDEX_DIR}"

# Default task
all: build 


