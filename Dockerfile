FROM jxta/vcp_client:rdm03
RUN pip install --no-cache notebook
ENV HOME=/tmp
