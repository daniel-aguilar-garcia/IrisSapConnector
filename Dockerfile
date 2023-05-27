ARG IMAGE=intersystemsdc/iris-community:2020.3.0.221.0-zpm
ARG IMAGE=intersystemsdc/iris-community:2020.4.0.524.0-zpm
ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

USER root   


WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

## SAP RFC LIBRARIES - START
ENV SAPNWRFC_HOME=/opt/irisapp/nwrfcsdk
ENV LD_LIBRARY_PATH=/opt/irisapp/nwrfcsdk/lib
ENV PYTHONPATH=/opt/irisapp/nwrfcsdk

COPY nwrfcsdk.conf /opt/irisapp/nwrfcsdk.conf
COPY sapnwrfc.cfg /opt/irisapp/sapnwrfc.cfg
COPY nwrfcsdk /opt/irisapp/nwrfcsdk
COPY nwrfcsdk/lib /usr/irissys/bin
RUN pip3 install --target /usr/irissys/mgr/python/ pyrfc
RUN pip3 install --target /usr/irissys/mgr/python/ configparser
## SAP RFC LIBRARIES - END

COPY  src src
COPY module.xml module.xml
COPY iris.script /tmp/iris.script





RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
    
