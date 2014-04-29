PAPER_DIR = doc/paper
# CODE_DIR = doc/paper

.PHONY: paper

paper:
	$(MAKE) -C $(PAPER_DIR) open

clean:
	$(MAKE) -C $(PAPER_DIR) clean
## 	$(MAKE) -C $(CODE_DIR) clean
