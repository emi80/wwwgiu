.PHONY: all fulls thumbs tar

PROFILE_DIR = color_profiles
PROFILE = sRGB_v4_ICC_preference.icc
PHOTO_DIR = Disegno/definitive
PHOTOS = $(wildcard $(PHOTO_DIR)/*.png)
IMAGE_DIR = images
FULLS_DIR = $(IMAGE_DIR)/fulls
THUMBS_DIR = $(IMAGE_DIR)/thumbs
FULLS = $(PHOTOS:$(PHOTO_DIR)/%.png=$(FULLS_DIR)/%.jpg)
THUMBS = $(PHOTOS:$(PHOTO_DIR)/%.png=$(THUMBS_DIR)/%_low.jpg)

ifndef QUALITY
QUALITY = 25
endif

ifndef PROP
PROP = 25
endif

all: $(THUMBS)

fulls: $(FULLS)
thumbs: $(THUMBS)

#.SECONDARY: $(FULLS)

$(FULLS_DIR):
	@mkdir -p $@

$(THUMBS_DIR):
	@mkdir -p $@

$(FULLS_DIR)/%.jpg: $(PHOTO_DIR)/%.png $(FULLS_DIR)
	@echo "== Create $@"
	@convert -profile $(PROFILE_DIR)/$(PROFILE) -quality $(QUALITY) "$<" "$@"

$(THUMBS_DIR)/%_low.jpg: $(FULLS_DIR)/%.jpg $(THUMBS_DIR)
	@echo "== Create $@"
	@convert -resize $(PROP)% "$<" "$@"

tar:
	@tar czf upload.tar.gz css/ fonts/ images/ index.html js