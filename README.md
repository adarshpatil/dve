
# ![Dve thumb](http://timewarp.adarshpatil.in/images/projects/dve/dve-thumb.png) Dvé: Coherent Replication Protocol

Dvé is a memory system architecture to improve the reliability and performance of DRAM main memory. This repository contains all artifacts used to experimentally evaluate Dvé.

**Full project details at [https://adar.sh/dve](https://adar.sh/dve) and in our upcoming ISCA '21 paper. If you are using Dvé for your work, please cite:**

# Features of Dvé:
- Replicates memory on two different sockets of a multi socket NUMA system
![NUMA Replication](http://timewarp.adarshpatil.in/images/projects/dve/numa-replication.jpg)
- Modifies NUMA cache coherence communication by introducing replica directory to permit local replica access 
![Coherent Replication](http://timewarp.adarshpatil.in/images/projects/dve/coherent-replication.jpg) <br/>
<sub>(Figure shows coherence communications in (a) Baseline NUMA (b) Dvé (c) Logical View)</sub>
- Proposes two protocol families — allow-based and deny-based — to achieve Coherent Replication 
- Protocol Optimizations to further improve performance 
	- Speculative replica access
	- Coarse-grained replica directory
	- Sampling based dynamic protocol


# Repository contents
1.  gem5 based implementation of Coherent Replication (forked from [VANDAL/SynchroTrace-gem5](https://github.com/VANDAL/SynchroTrace-gem5))\
	The repo contains implementation of the baseline, proposed protocols and a variant of Intel's Mirroring implementation.
	 - numa-baseline: multi-socket NUMA baseline configuration
	 - deny-based protocol implementation
	 - allow-based protocol implementation
	 - intel-intel-ch-replication: An extention of Intel's Address Range Partial Mirroring implementation with read requests load balanced between both channels (requests are alternated between channels)

2. Trace generator (forked from [VANDAL/prism](https://github.com/VANDAL/prism))

3. Coherence protocol [specification](https://github.com/adarshpatil/dve/blob/master/Dve-ISCA21-Appendix.pdf) in table format.

4. Murphi [model](https://github.com/adarshpatil/dve/tree/master/murphi-model) for allow-based and deny-based protocol (generated using [ProtoGen](https://github.com/icsa-caps/ProtoGen))

--------------------------------------------------------------
The title of the project is derived from the Sankrit word (द्वे) which means "the two",
referring here to the dual benefits of replication.
