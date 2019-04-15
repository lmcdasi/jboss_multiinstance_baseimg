#!/usr/bin/env bash -f

#Instance no cannot be greater than 100 - see port assignment
export INSTANCE_NO="${instance_no:-1}"

export JBOSS_HOME="${jboss_home:-/opt/jboss/wildfly-16.0.0.Final}"
export JBOSS_HOME_INSTANCE="${HOME}/jboss_instance"

export RUN_CONF="${JBOSS_HOME_INSTANCE}/bin/standalone.conf"

export JBOSS_BASE_DIR="${JBOSS_HOME_INSTANCE}"
export JBOSS_CONFIG_DIR="${JBOSS_HOME_INSTANCE}/configuration"
export JBOSS_LOG_DIR="${JBOSS_HOME_INSTANCE}/log"

export JBOSS_BIND_ADDRESS=${JBOSS_BIND_ADDRESS:-localhost}
export JBOSS_BIND_ADDRESS_MANAGEMENT=${JBOSS_BIND_ADDRESS_MANAGEMENT:-localhost}

#Base jboss port numbers. We can define up to 100 instances 0-99
export TXN_RECOVERY_ENVIRONMENT_PORT=${TXN_RECOVERY_ENVIRONMENT_PORT:-6000}
export TXN_STATUS_MANAGER_PORT=${TXN_STATUS_MANAGER_PORT:-7000}
export JBOSS_AJP_PORT=${JBOSS_AJP_PORT:-8000}
export JBOSS_HTTP_PORT=${JBOSS_HTTP_PORT:-8100}
export JBOSS_HTTPS_PORT=${JBOSS_HTTPS_PORT:-8200}
export JBOSS_MANAGEMENT_HTTP_PORT=${JBOSS_MANAGEMENT_HTTP_PORT:-9100}
export JBOSS_MANAGEMENT_HTTPS_PORT=${JBOSS_MANAGEMENT_HTTPS_PORT:-9200}

#Start jboss in background
export LAUNCH_JBOSS_IN_BACKGROUND=true
