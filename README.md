
# ![Dve thumb](http://timewarp.adarshpatil.in/images/projects/dve/dve-thumb.png) Dvé: Coherent Replication Protocol

Dvé is a memory system architecture to improve the reliability and performance of DRAM main memory. This repository contains all artifacts used to experimentally evaluate Dvé.

**More details in the [ISCA '21 paper](https://conferences.computer.org/iscapub/pdfs/ISCA2021-4ghucdBnCWYB7ES2Pe4YdT/333300a526/333300a526.pdf) and at [https://adar.sh/dve](https://adar.sh/dve). If you are using Dvé for your work, please cite:**

```
@inproceedings{dve-isca21,
	author = {Patil, Adarsh and Nagarajan, Vijay and Balasubramonian, Rajeev and Oswald, Nicolai},
	title = {Dvé: Improving DRAM Reliability andPerformance On-Demand via Coherent Replication},
	year = {2021},
	publisher = {IEEE Press},
	booktitle = {Proceedings of the ACM/IEEE 48th Annual International Symposium on Computer Architecture},
	pages = {526–539},
	numpages = {14},
	keywords = {Memory Systems, DRAM, Reliability, Coherence},
	location = {Virtual Event},
	series = {ISCA '21}
}
```

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

4. [Murphi model](https://github.com/adarshpatil/dve/tree/master/murphi-model) for allow-based and deny-based protocol (generated using [ProtoGen](https://github.com/icsa-caps/ProtoGen))

--------------------------------------------------------------
The title of the project is derived from the Sankrit word (द्वे) which means "the two",
referring here to the dual benefits of replication.
