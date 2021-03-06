# Use latest jboss/base-jdk:11 image as base
FROM jboss/base-jdk:11

LABEL version="1.0"
LABEL descpription="Jboos Wildfly multi-instance setup.\
Base example with 2 instances that can be extended up to 100"
LABEL maintainer="lmcdasi@yahoo.com"

# Set WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 16.0.0.Final
ENV WILDFLY_SHA1 287c21b069ec6ecd80472afec01384093ed8eb7d
ENV JBOSS_HOME /opt/jboss/wildfly-16.0.0.Final
# Set the total no of instances - max 100 instances
ENV TOTAL_JBOSS_INSTANCES 2
# Set base for mgmt & app user realms
ENV MGMT_USER mgmtinstance
ENV MGMT_USER_PASSWD MgmtInstance#
ENV APP_USER appinstance
ENV APP_USER_PASSWD AppInstance#

USER root

# Add the WildFly distribution to /opt/jboss, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:jboss ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

# Add extra pkgs
RUN yum install -y sudo \
    && yum install -y net-tools.x86_64

# Copy setup scripts
COPY setup.sh /root/.
COPY env.sh /root/.
COPY standalone.conf /root/.
COPY jboss_startup.sh /root/.

# Create & setup standalone jboss instances
RUN chmod +x /root/setup.sh \
    && /root/setup.sh
RUN chmod +x /root/jboss_startup.sh

# Expose a range of ports to cover all 100 jboss instances
EXPOSE 7000-9999

# Set the default command to run on boot
# This will boot WildFly standalone for each instance
CMD ["/root/jboss_startup.sh"]

