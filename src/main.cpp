#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QThread>
#include <QObject>

#include "./serializer.h"

int main(int argc, char *argv[])
{
    // For this example, wizard-generates single line code would be good enough,
    // but very soon it won't be enough for you anyway, so use this more detailed example from start
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    auto worker = new QThread;

    QScopedPointer<Serializer> serializer(new Serializer);
    view->rootContext()->setContextProperty("serializer", serializer.data());
    serializer->moveToThread(worker);

    QObject::connect(worker, SIGNAL(finished()), worker, SLOT(deleteLater()));
    worker->start();

    // That is how you can access version strings in C++. And pass them on to QML
    view->rootContext()->setContextProperty("appVersion", APP_VERSION);
    view->rootContext()->setContextProperty("appBuildNum", APP_BUILDNUM);

    view->engine()->addImportPath(SailfishApp::pathTo("qml/components").toString());
    view->setSource(SailfishApp::pathTo("qml/main.qml"));

    view->show();

    return app->exec();
}
