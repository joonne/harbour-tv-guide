TEMPLATE=app
# The name of your app binary (and it's better if you think it is the whole app name as it's referred to many times)
# Must start with "harbour-"
TARGET = harbour-tv-guide

# In the bright future this config line will do a lot of stuff to you
CONFIG += sailfishapp

SOURCES += main.cpp

DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += APP_BUILDNUM=\\\"$$RELEASE\\\"

OTHER_FILES = \
# You DO NOT want .yaml be listed here as Qt Creator's editor is completely not ready for multi package .yaml's
#
# Also Qt Creator as of Nov 2013 will anyway try to rewrite your .yaml whenever you change your .pro
# Well, you will just have to restore .yaml from version control again and again unless you figure out
# how to kill this particular Creator's plugin
#    ../rpm/harbour-tv-guide.yaml \
    ../rpm/harbour-tv-guide.spec \
    qml/main.qml \
    qml/pages/parser.js \
    qml/pages/Channel.qml \
    qml/pages/ProgramOverviewPage.qml \
    qml/pages/TVguidePage.qml \
    qml/cover/CoverPage.qml

INCLUDEPATH += $$PWD

DISTFILES += \
    qml/components/MoreIndicator.qml \
    qml/components/TextExpander.qml
