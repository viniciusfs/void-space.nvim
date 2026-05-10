BUSTED          ?= busted
PYTHON          ?= python3
VHS             ?= vhs
SCREENSHOT_FONT ?= JetBrainsMono Nerd Font Mono
SCREENSHOT_CFG  := $(CURDIR)/scripts/screenshots/nvim/config
SCREENSHOT_DATA := $(CURDIR)/scripts/screenshots/nvim/data

.PHONY: test
test:
	$(BUSTED) --config-file=.busted

.PHONY: swatches
swatches:
	$(PYTHON) scripts/gen_swatch.py

.PHONY: sync
sync:
	$(PYTHON) scripts/sync_palette.py

.PHONY: screenshots
screenshots: _screenshots-setup ## Generate plugin screenshots (requires: vhs, JetBrainsMono Nerd Font)
	@mkdir -p assets/screenshots
	@for tape in scripts/screenshots/tapes/*.tape; do \
	  [ -f "$$tape" ] || continue; \
	  echo "  → $$tape"; \
	  $(VHS) "$$tape"; \
	done
	@echo "Done — screenshots saved to assets/screenshots/"

.PHONY: screenshots-samples
screenshots-samples: _screenshots-setup ## Generate syntax screenshots for all files in samples/
	@SCREENSHOT_FONT="$(SCREENSHOT_FONT)" VHS="$(VHS)" \
	  bash scripts/screenshots/gen_samples.sh

.PHONY: _screenshots-setup
_screenshots-setup:
	@echo "Installing screenshot plugins (first run may take ~30s)..."
	@XDG_CONFIG_HOME="$(SCREENSHOT_CFG)" \
	 XDG_DATA_HOME="$(SCREENSHOT_DATA)" \
	 nvim --headless "+Lazy! install" +qa 2>/dev/null; true
	@echo "Plugins ready."
