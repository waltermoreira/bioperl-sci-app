FROM sci-apps-base

MAINTAINER Walter Moreira <wmoreira@tacc.utexas.edu>

RUN yum groupinstall -y 'Development Tools'
RUN yum install -y perl perl-devel perl-Archive-Tar perl-YAML perl-CPAN expat-devel

ENV PERL_MM_USE_DEFAULT 1
RUN perl -MCPAN -e 'install Test::More'

WORKDIR /root

RUN curl -LO http://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/CPAN-Meta-Requirements-2.126.tar.gz && \
    tar zxf CPAN-Meta-Requirements-2.126.tar.gz

WORKDIR CPAN-Meta-Requirements-2.126

RUN find . -exec touch {} \; && \
    perl Makefile.PL && \
    make all && \
    make test && \
    make install

RUN perl -MCPAN -e 'install Module::Build DBI DBD::mysql DBD::SQLite DBD::Pg'

WORKDIR /root

RUN curl -LO http://bioperl.org/DIST/BioPerl-1.6.1.tar.bz2 && \
    tar jxf BioPerl-1.6.1.tar.bz2

WORKDIR BioPerl-1.6.1

RUN perl Build.PL
RUN ./Build install

RUN yum reinstall -y glibc-common