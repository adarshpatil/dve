

# Dvé

Dvé is a memory system architecture to improve the reliability and performance of DRAM main memory. 


# Features:
- Mirrors memory on two different sockets of a multi socket NUMA system
- Uses cache coherence protocols (allow-based and deny-based) to provide Coherent Replication
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

3. Dvé coherence protocol appendix (generated using [ProtoGen](https://github.com/icsa-caps/ProtoGen))


--------------------------------------------------------------
The project title is derived from the Sankrit word (द्वे) which means "the two",
referring here to the dual benefits of replication.
