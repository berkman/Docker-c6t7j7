FROM centos:6
MAINTAINER Mike Berkman <mberkman@cisco.com>

#ENV TOMCAT_VERSION 7.0.61
#ENV JRE_VERSION 7u79
ENV JAVA_HOME /apps/java/current
ENV CATALINA_HOME /apps/tomcat/current

RUN yum -y install tar ln wget; yum -y clean all

RUN wget -q http://mirror.symnds.com/software/Apache/tomcat/tomcat-7/v7.0.61/bin/apache-tomcat-7.0.61.tar.gz
RUN wget -q --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jre-7u79-linux-x64.tar.gz

# JAVA SETUP
RUN mkdir -p /apps/java/ && \
	tar -zxf jre-7u79-linux-x64.tar.gz && \
	mv /jre1.7.0_79 /apps/java/ && \
	rm -f /jre-7u79-linux-x64.tar.gz && \
	ln -s /apps/java/jre1.7.0_79 /apps/java/current && \
	chown -R root: /apps/java/

# TOMCAT SETUP
RUN mkdir -p /apps/tomcat/
RUN tar -zxf apache-tomcat-7.0.61.tar.gz
RUN mv /apache-tomcat-7.0.61 /apps/tomcat/
RUN rm -f /apache-tomcat-7.0.61.tar.gz
RUN ln -s /apps/tomcat/apache-tomcat-7.0.61 /apps/tomcat/current
RUN chmod +x /apps/tomcat/current/bin/*.sh
RUN rm /apps/tomcat/current/bin/*.bat

#DELETE/HARDEN TOMCAT
#RUN rm -rf /apps/tomcat/current/webapps/*

RUN yum erase tar ln wget -y

EXPOSE 8080
CMD ["/apps/tomcat/current/bin/catalina.sh", "run"]
