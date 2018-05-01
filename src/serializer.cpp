#include "serializer.h"

#include <QFile>
#include <QJsonArray>
#include <QJsonDocument>
#include <QTextStream>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

Serializer::Serializer(QObject *parent) : QObject(parent)
{
    readState();
}

Serializer::~Serializer()
{
    writeState();
}

void Serializer::readState()
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + "state.json";
    QFile loadFile(path);

    if (!loadFile.open(QIODevice::ReadOnly)) {
        qWarning("Couldn't open state file.");
        m_state = QJsonObject();
    }

    m_state = (QJsonDocument::fromJson(loadFile.readAll())).object();
}

void Serializer::writeState() const
{
    QString path = QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator() + "state.json";
    QFile saveFile(path);

    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning("Couldn't open save file.");
        return;
    }

    QJsonDocument saveDoc(m_state);
    saveFile.write(saveDoc.toJson());

    return;
}

void Serializer::setState(QJsonObject state)
{
    m_state = state;
}

QJsonObject Serializer::getState()
{
    return m_state;
}
