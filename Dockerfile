# Version JDK8

FROM centos:7
MAINTAINER Hareesh Thummala, hareesh5041@gmail.com

RUN yum install -y java-1.8.0-openjdk-devel wget git maven

# Create users and groups
RUN groupadd tomcat
RUN mkdir /opt/tomcat
RUN useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

# Download and install tomcat
RUN wget https://mirror.nodesdirect.com/apache/tomcat/tomcat-9/v9.0.46/bin/apache-tomcat-9.0.46.tar.gz
RUN tar -zxvf apache-tomcat-9.0.46.tar.gz -C /opt/tomcat --strip-components=1
RUN chgrp -R tomcat /opt/tomcat/conf
RUN chmod g+rwx /opt/tomcat/conf
RUN chmod g+r /opt/tomcat/conf/*
RUN chown -R tomcat /opt/tomcat/logs/ /opt/tomcat/temp/ /opt/tomcat/webapps/ /opt/tomcat/work/
RUN chgrp -R tomcat /opt/tomcat/bin
RUN chgrp -R tomcat /opt/tomcat/lib
RUN chmod g+rwx /opt/tomcat/bin
RUN chmod g+r /opt/tomcat/bin/*

RUN rm -rf /opt/tomcat/webapps/*
RUN cd /tmp && git clone https://github.com/Hareesh5041/CI-CD-using-Docker.git
RUN cd /tmp/CI-CD-using-Docker && mvn clean install
RUN cp /tmp/CI-CD-using-Docker/target/LoginWebApp-1.war /opt/tomcat/webapps/ROOT.war
RUN chmod 777 /opt/tomcat/webapps/ROOT.war

VOLUME /opt/tomcat/webapps
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
#
