# Matthew Vaughn
# Feb 4, 2016

api_version="v2"
api_release="2.1.6"
sdk_version="1.1.0"

CC=
CFLAGS=
SOURCES = cyverse-customize
OBJ = cyverse-cli
PREFIX = $(HOME)

# Local installation

all: $(SOURCES)

foundation-cli: git-test
	git clone https://bitbucket.org/taccaci/foundation-cli
	rm -rf foundation-cli/.git

cyverse-base: foundation-cli
	mv foundation-cli $(OBJ)

cyverse-customize: cyverse-base
	cp -r src/templates $(OBJ)/
	cp -r src/scripts/* $(OBJ)/bin/

.PHONY: clean
clean:
	rm -rf $(OBJ)

.SILENT: install
install: $(OBJ)
	cp -fr $(OBJ) $(PREFIX)
	find $(PREFIX)/$(OBJ)/bin -type f ! -name '*.sh' -exec chmod a+rx {} \;
	rm -rf $(OBJ)
	echo "Installed in $(PREFIX)/$(OBJ)"

.SILENT: uninstall
uninstall:
	if [ -d $(PREFIX)/$(OBJ) ];then rm -rf $(PREFIX)/$(OBJ); echo "Uninstalled."; exit 0; fi

.SILENT: update
update: clean git-test
	git pull
	if [ $$? -eq 0 ] ; then echo "Now, run make && make install."; exit 0; fi

# Application tests
.SILENT: git-test
git-test:
	echo "Verifying that git is installed..."
	GIT_INFO=`git --version > /dev/null`
	if [ $$? -ne 0 ] ; then echo "Git not found or unable to be executed. Exiting." ; exit 1 ; fi
	git --version

.SILENT: docker-test
docker-test:
	echo "Verifying that docker is installed and reachable..."
	DOCKER_INFO=`docker info > /dev/null`
	if [ $$? -ne 0 ] ; then echo "Docker not found or unreachable. Exiting." ; exit 1 ; fi
	docker info

# Docker image

# Github release
.SILENT: dist
dist: cyverse-customize
	tar -czf "$(OBJ).tgz" $(OBJ)
	rm -rf $(OBJ)
	echo "Now, run 'git commit -a -m MESSAGE' to update the repository."

.SILENT: release
release:
	git diff-index --quiet HEAD
	if [ $$? -ne 0 ]; then echo "You have unstaged changes. Please commit or discard then re-run make clean && make release."; exit 0; fi
	git tag -a "v$(sdk_version)" -m "Cyverse SDK $(sdk_version). Requires Agave $(api_version)/$(api_release)."
	git push origin "v$(sdk_version)"

