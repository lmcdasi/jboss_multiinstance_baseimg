This image is based on JBoss with OpenJDK and provides OpenJDK 11 (JDK)

It includes:

-- wildfly version 16.0.0.Final

-- setup scripts for jboss multi-instance

-- startup script to start all jboss multi-instances

Setup scripts:

   -- env.sh : set's the JBOSS environment variables of a jboss instance
   -- standalone.conf : setups the RUN_CONF of a jboss instance
   -- setup.sh : configures all jboss instances
   
Startup script:
   -- jboss_startup.sh

Run the image in detached mode using '-d', then exec running container in bash
   
