#ARG IMAGE=containers.intersystems.com/intersystems/irishealth:2023.2.0.204.0
ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2023.2.0.204.0
FROM $IMAGE

USER root

WORKDIR /opt/app
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/app
   
USER ${ISC_PACKAGE_MGRUSER}

COPY  Setup.cls .
COPY patientdata patientdata
#COPY  src src
COPY  iris.script .

# run iris and initial 
RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly 