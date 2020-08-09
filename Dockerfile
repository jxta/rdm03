FROM jxta/vcp_client:20190826-ssl
# RUN pip install --no-cache notebook
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

WORKDIR ${HOME}
