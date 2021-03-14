

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
1.  gem5 implementation (forked from VANDAL/SynchroTrace-gem5)
	Branches 
	 - numa-baseline: multi-socket NUMA baseline configuration
	 - blacklist: deny-list protocol implementation
	 - whitelist: allow-based protocol implementation
	 - intel-intel-ch-replication:  Intel's Address Range Partial Mirroring implementation with read requests load balanced between both channels (requests are alternated between channels)

 2. Trace generator (forked from VANDAL/prism)

3. Dvé coherence protocol appendix (generated using ProtoGen)


--------------------------------------------------------------
The project title is derived from the Sankrit word (द्वे) which means "the two",
referring here to the dual benefits of replication.
