
TARGET = DenyListReplication

MURPHIPATH = /home/tux/Desktop/murphi
INCLUDEPATH = ${MURPHIPATH}/include
SRCPATH = ${MURPHIPATH}/src
CFLAGS = -O2 -march=native     # Native architecture currently disabled due to verification server arch

all: ${TARGET}

${TARGET}: ${TARGET}.cpp
	g++ ${CFLAGS} -o ${TARGET} ${TARGET}.cpp -I${INCLUDEPATH}

${TARGET}.cpp: ${TARGET}.m
	${SRCPATH}/mu -b ${TARGET}.m

.PHONY: clean
clean:
	-rm -f ${TARGET} SSP_${TARGET} *.cpp
