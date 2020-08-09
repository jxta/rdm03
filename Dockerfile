FROM jxta/vcp_client:20190826-ssl
RUN pip install --no-cache notebook
ARG NB_USER jovyan
ARG NB_UID 1000
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
