BUSTED ?= busted
PYTHON ?= python3

.PHONY: test
test:
	$(BUSTED) --config-file=.busted

.PHONY: swatches
swatches:
	$(PYTHON) scripts/gen_swatch.py
