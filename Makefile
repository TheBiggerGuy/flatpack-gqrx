REPO=repo

all: build

clean:
	rm -rf app

build: clean
	flatpak-builder --ccache --require-changes --repo=$(REPO) app dk.gqrx.App.json

build-inc: clean
	flatpak-builder --ccache --keep-build-dirs --repo=$(REPO) app dk.gqrx.App.json

run:
	flatpak-builder --run app dk.gqrx.App.json gqrx

run-gdb:
	flatpak-builder --run app dk.gqrx.App.json gdb gqrx

remotes:
	wget http://distribute.kde.org/kdeflatpak.asc
	flatpak remote-add kde http://distribute.kde.org/flatpak-testing/ --gpg-import=kdeflatpak.asc --if-not-exists
	rm kdeflatpak.asc*

deps:
	flatpak install $(ARGS) kde org.kde.Platform
	flatpak install $(ARGS) kde org.kde.Sdk
