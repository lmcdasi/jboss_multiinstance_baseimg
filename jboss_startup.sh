#!/usr/bin/env bash

#Start all jboss instances
for jboss in $(ls -d /home/jinstance*); do
	INSTANCE_UNAME=$(grep ${jboss} /etc/passwd | awk -F':' '{print $1}')
	su - ${INSTANCE_UNAME} -c "cd ${jboss}/jboss_instance/bin; source env.sh; ${JBOSS_HOME}/bin/standalone.sh &"
done

/usr/bin/env bash
