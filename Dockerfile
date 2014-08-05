FROM sci-apps-base

MAINTAINER Walter Moreira <wmoreira@tacc.utexas.edu>

ENV _APP Bioperl
ENV _VERSION 1.6.923
ENV _LICENSE Perl Artistic License
ENV _AUTHOR ___

ADD usage.txt /docs/bioperl/usage.txt
ADD intro.txt /docs/bioperl/intro.txt
ADD examples.txt /docs/bioperl/examples.txt
ADD demo.pl /examples/demo.pl

RUN yum groupinstall -y 'Development Tools'
RUN yum install -y perl mysql perl-devel perl-Archive-Tar perl-YAML perl-CPAN expat-devel

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
    make install && \
    rm -rf /root/CPAN-Meta-Requirements*

RUN perl -MCPAN -e 'install Module::Build' && \
    perl -MCPAN -e 'install DBI' && \
    perl -MCPAN -e 'install DBD::mysql' && \
    perl -MCPAN -e 'install DBD::SQLite' && \
    perl -MCPAN -e 'install DBD::Pg'

WORKDIR /root

RUN curl -LO http://bioperl.org/DIST/BioPerl-1.6.1.tar.bz2 && \
    tar jxf BioPerl-1.6.1.tar.bz2

WORKDIR BioPerl-1.6.1

RUN perl Build.PL && \
    ./Build install && \
    rm -rf /root/BioPerl-1.6.1.tar.bz2

RUN yum reinstall -y glibc-common
