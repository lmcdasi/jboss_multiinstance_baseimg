#!/usr/bin/env bash

logger -t "jboss_multi-instance" "Jboss total no. of instances set to: ${TOTAL_JBOSS_INSTANCES}"
if [ ${TOTAL_JBOSS_INSTANCES} -lt 1 ]; then
   logger -t "jboss_multi-instance" "Invalid no. of jboss instances. Exiting..."
   exit -1
fi

# For each jboss instance create and setup an user for each instance
for no in 1 ${TOTAL_JBOSS_INSTANCES}; do
	INSTANCE_HOME="/home/jinstance${no}"
	useradd -m -d ${INSTANCE_HOME=} -s /bin/bash jinstance${no}
	echo "jinstance${no}:jinstance${no}" | chpasswd
	echo "jinstance${no} ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
	usermod -a -G jboss jinstance${no}
	
	pushd ${INSTANCE_HOME}

	echo "#JBOSS instance number" >> .bashrc
	echo "export instance_no=${no}" >> .bashrc
        echo "#JBOSS bind address - using hostname" >> .bashrc
        echo 'export JBOSS_BIND_ADDRESS=$(hostname)' >> .bashrc
	
	JBOSS_INSTANCE_HOME="${INSTANCE_HOME}/jboss_instance"
	mkdir -p ${JBOSS_INSTANCE_HOME}/bin/
	cp /root/env.sh ${JBOSS_INSTANCE_HOME}/bin/
	cp /root/standalone.conf ${JBOSS_INSTANCE_HOME}/bin/.
	
	mkdir -p ${JBOSS_INSTANCE_HOME}/configuration
	# replace the standalone.xml with any other xml conf file
	cp ${JBOSS_HOME}/standalone/configuration/standalone.xml ${JBOSS_INSTANCE_HOME}/configuration/.
	cp ${JBOSS_HOME}/standalone/configuration/logging.properties ${JBOSS_INSTANCE_HOME}/configuration/.
	cp ${JBOSS_HOME}/standalone/configuration/mgmt-*.properties ${JBOSS_INSTANCE_HOME}/configuration/.
	cp ${JBOSS_HOME}/standalone/configuration/application-*.properties ${JBOSS_INSTANCE_HOME}/configuration/.

	# patch up the files in order to sustain multi-instances
	sed -i '/name="txn-recovery-environment"/c\       <socket-binding name="txn-recovery-environment" port="${jboss.txn.recovery.environment:4712}"/>' ${JBOSS_INSTANCE_HOME}/configuration/standalone.xml
	sed -i '/name="txn-status-manager"/c\       <socket-binding name="txn-status-manager" port="${jboss.txn.status.manager:4712}"/>' ${JBOSS_INSTANCE_HOME}/configuration/standalone.xml
	sed -i "/handler.FILE.fileName/c\handler.FILE.fileName=/home/jinstance${no}/jboss_instance/log/server.log" ${JBOSS_INSTANCE_HOME}/configuration/logging.properties
	
	mkdir -p ${JBOSS_INSTANCE_HOME}/data
	mkdir -p ${JBOSS_INSTANCE_HOME}/deployments
	mkdir -p ${JBOSS_INSTANCE_HOME}/lib/ext
	mkdir -p ${JBOSS_INSTANCE_HOME}/log
	mkdir -p ${JBOSS_INSTANCE_HOME}/tmp/auth
	
	chown -R jinstance${no}:jinstance${no} ${INSTANCE_HOME}
	
	# Add mgmt & app user realms
	sudo -u jinstance${no} -- bash -c "export JAVA_OPTS=\"-Djboss.server.config.user.dir=${JBOSS_INSTANCE_HOME}/configuration\"; ${JBOSS_HOME}/bin/add-user.sh ${APP_USER}${no} ${APP_USER_PASSWD}${no} && ${JBOSS_HOME}/bin/add-user.sh -a ${MGMT_USER}${no} ${MGMT_USER_PASSWD}${no}"

	popd
done
