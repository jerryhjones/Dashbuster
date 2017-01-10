INFOPLIST_FILE=Info.plist
SOURCES=\
	main.m ibboApp.m BlockbusterSession.m Queue.m PreferencesView.m QueueItem.m ShippedView.m Search.m SearchResultsView.m \
		AccountDetailsView.m MovieCell.m QueuedView.m CustomTable.m RSSListView.m RSS.m \
		RSSDetailView.m AboutView.m AboutPrefsCell.m TapLabel.m SearchCell.m CoverArtDownloader.m DetailDownloader.m SearchBoxView.m \
		SmallAdView.m
		
PLATFORM=iPhoneFOSS
DEV=/Developer/Platforms/${PLATFORM}.platform/Developer
SDK=$DEV/SDKs/${PLATFORM}1.1.sdk
CC=/Developer/Platforms/iPhoneFOSS.platform/Developer/bin/arm-apple-darwin-gcc
LD=$(CC)
LDFLAGS = -framework CoreFoundation -framework CoreFoundation -framework Foundation \
 -framework UIKit  -framework LayerKit  -framework CoreGraphics  -framework IOKit \
 -framework GraphicsServices  -framework CoreSurface -framework SystemConfiguration \
 -framework OfficeImport -framework WebKit -lobjc -mmacosx-version-min=10.1 \
 -L"/Developer/Platforms/iPhoneFOSS.platform/Developer/SDKs/iPhoneFOSS1.1.sdk/usr/lib" \
 -F"/Developer/Platforms/iPhoneFOSS.platform/Developer/SDKs/iPhoneFOSS1.1.sdk/System/Library/Frameworks" \
 -F"/Developer/Platforms/iPhoneFOSS.platform/Developer/SDKs/iPhoneFOSS1.1.sdk/System/Library/PrivateFrameworks"
CFLAGS = -I"/Developer/Platforms/iPhoneFOSS.platform/Developer/SDKs/iPhoneFOSS1.1.sdk/include" -fsigned-char
PRODUCT_NAME=Dashbuster


WRAPPER_NAME=$(PRODUCT_NAME).app
EXECUTABLE_NAME=$(PRODUCT_NAME)
SOURCES_ABS=$(addprefix $(SRCROOT)/,$(SOURCES))
INFOPLIST_ABS=$(addprefix $(SRCROOT)/,$(INFOPLIST_FILE))
OBJECTS=\
	$(patsubst %.c,%.o,$(filter %.c,$(SOURCES))) \
	$(patsubst %.cc,%.o,$(filter %.cc,$(SOURCES))) \
	$(patsubst %.cpp,%.o,$(filter %.cpp,$(SOURCES))) \
	$(patsubst %.m,%.o,$(filter %.m,$(SOURCES))) \
	$(patsubst %.mm,%.o,$(filter %.mm,$(SOURCES)))
OBJECTS_ABS=$(addprefix $(CONFIGURATION_TEMP_DIR)/,$(OBJECTS))
APP_ABS=$(BUILT_PRODUCTS_DIR)/$(WRAPPER_NAME)
PRODUCT_ABS=$(APP_ABS)/$(EXECUTABLE_NAME)

all: $(PRODUCT_ABS)
all: install

$(PRODUCT_ABS): $(APP_ABS) $(OBJECTS_ABS)
	$(LD) $(LDFLAGS) -o $(PRODUCT_ABS) $(OBJECTS_ABS)

$(APP_ABS): $(INFOPLIST_ABS)
	mkdir -p $(APP_ABS)
	cp $(INFOPLIST_ABS) $(APP_ABS)/

$(CONFIGURATION_TEMP_DIR)/%.o: $(SRCROOT)/%.m
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

install: $(PRODUCT_ABS)

#	scp -r /Users/jerry/iPhone/iPhoneHome/build/Release/Dashbuster.app/Dashbuster root@10.0.1.3:/Applications/Dashbuster.app


clean:
	echo rm -f $(OBJECTS_ABS)
	echo rm -rf $(APP_ABS)