all:
	$(MAKE) -C hypervisor
	$(MAKE) -C attack

clean:
	$(MAKE) -C hypervisor clean
	$(MAKE) -C attack clean

.PHONY: all clean
