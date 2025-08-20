#ifndef JOYSTICKRECEIVER_H
#define JOYSTICKRECEIVER_H

#include <QObject>

class JoystickReceiver : public QObject
{
    Q_OBJECT
public:
    explicit JoystickReceiver(QObject *parent = nullptr);

signals:
};

#endif // JOYSTICKRECEIVER_H
