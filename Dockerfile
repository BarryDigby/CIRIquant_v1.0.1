FROM python:2.7-onbuild
COPY . /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y unzip

# download and extract all needed software
RUN wget https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2 
RUN tar -xvf bwa-0.7.17.tar.bz2 && rm bwa-0.7.17.tar.bz2

RUN wget https://iweb.dl.sourceforge.net/project/ciri/CIRIquant/CIRIquant_v1.0.1.tar.gz
RUN tar -xvf CIRIquant_v1.0.1.tar.gz && rm CIRIquant_v1.0.1.tar.gz

RUN wget https://github.com/samtools/samtools/archive/1.9.zip
RUN unzip 1.9.zip && rm 1.9.zip

RUN wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip
RUN unzip hisat2-2.1.0-Linux_x86_64.zip && rm hisat2-2.1.0-Linux_x86_64.zip

RUN wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-2.0.3.tar.gz
RUN tar -xvf stringtie-2.0.3.tar.gz && rm stringtie-2.0.3.tar.gz
RUN wget https://github.com/samtools/htslib/archive/1.9.zip
RUN unzip 1.9.zip && rm 1.9.zip

# bwa
WORKDIR /usr/src/app/bwa-0.7.17
RUN make && ln -s $PWD/bwa /bin

# hisat
WORKDIR /usr/src/app/hisat2-2.1.0
RUN ln -s $PWD/hisat2-build $PWD/hisat2-build-{s,l} $PWD/hisat2-inspect-{s,l} $PWD/hisat2-align-{s,l} $PWD/hisat2 /bin

# stringtie
WORKDIR /usr/src/app/stringtie-2.0.3
RUN make clean release && ln -s $PWD/stringtie /bin

# htslib
WORKDIR /usr/src/app/htslib-1.9
RUN autoreconf && ./configure && make && make install

# samtools
WORKDIR /usr/src/app/samtools-1.9
RUN autoreconf && ./configure && make && make install
RUN ln -s $PWD/samtools /bin

# CIRIQuant
WORKDIR /usr/src/app/CIRIquant
RUN python setup.py install

# Create soft link link to Travis's location for things to work: 
RUN mkdir -p /home/travis/miniconda/envs/CIRIquant/ && ln -s /bin /home/travis/miniconda/envs/CIRIquant/

# Ignore line that changes permissions
RUN sed -i '113s/^/#/' /usr/local/lib/python2.7/site-packages/CIRIquant-1.0.1-py2.7.egg/CIRIquant/main.py

WORKDIR /usr/src/app
CMD ["/bin/bash"]
ENV PYTHON_EGG_CACHE=/tmp

# Start Fresh for Picard Tools

FROM java:7

RUN apt-get update
RUN apt-get install -y zip wget

# We'll be working in /opt from now on
WORKDIR /opt
RUN wget https://github.com/broadinstitute/picard/releases/download/1.122/picard-tools-1.122.zip
RUN unzip picard-tools-1.122.zip && rm -f picard-tools-1.122.zip

# Link the picard tools to /opt/picard
RUN ln -s picard-tools-1.122 picard
