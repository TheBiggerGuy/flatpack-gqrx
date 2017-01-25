REPO=repo
APP=dk.gqrx.App
MANIFEST=$(APP).json

all: build bundle

clean:
	rm -rf app repo
	rm -f $(APP).flatpak

build:
	flatpak-builder --ccache --force-clean     --repo=$(REPO) --subject="git-`git log --pretty=format:'%h' -n 1`" app $(MANIFEST)

build-inc: clean
	flatpak-builder --ccache --keep-build-dirs --repo=$(REPO) --subject="git-`git log --pretty=format:'%h' -n 1`" app $(MANIFEST)

bundle:
	flatpak build-bundle $(REPO) $(APP).flatpak $(APP)

install:
	flatpak build-update-repo --prune --prune-depth=20 $(REPO)
	flatpak --user remote-add --no-gpg-verify --if-not-exists gqrx-local $(REPO)
	flatpak --user --verbose install gqrx-local $(APP)

uninstall:
	flatpak --user --verbose install gqrx-local $(APP)

update:
	flatpak update --user $(APP)

run-repo:
	flatpak run dk.gqrx.App

run-repo-gdb:
	flatpak run --devel --command='sh' $(APP)

run-builder:
	flatpak-builder --run app $(APP).json gqrx

run-builder-gdb:
	flatpak-builder --run ---allow=devel app $(MANIFEST) gdb gqrx

remotes:
	wget http://distribute.kde.org/kdeflatpak.asc
	cat kdeflatpak.asc | flatpak remote-add kde http://distribute.kde.org/flatpak-testing/ --gpg-import=- --if-not-exists | cat -
	rm kdeflatpak.asc*

deps:
	flatpak install $(ARGS) kde org.kde.Platform
	flatpak install $(ARGS) kde org.kde.Sdk
