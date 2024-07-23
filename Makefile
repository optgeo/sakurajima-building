SRC_PATH = "../flatgeobuf-powerline/src/optimal_bvmap-v1.pmtiles"
EXTENT_PATH = "extent.geojson"
EXTRACT_PATH = "extract.pmtiles"
LAYER = "BldA"
ZOOM = 16
DST_DIR = "docs"

extract:
	pmtiles extract $(SRC_PATH) $(EXTRACT_PATH) --region=$(EXTENT_PATH)

decode:
	tippecanoe-decode -z $(ZOOM) -Z $(ZOOM) -l $(LAYER) $(EXTRACT_PATH) | \
	tippecanoe-json-tool > $(DST_DIR)/a.geojsons ; \
	ogr2ogr $(DST_DIR)/a1.shp $(DST_DIR)/a.geojsons; \
	ogr2ogr $(DST_DIR)/a.geojson $(DST_DIR)/a1.shp; \
	ogr2ogr $(DST_DIR)/a2.shp $(DST_DIR)/a1.shp -dialect sqlite -sql "SELECT ST_Union(geometry) FROM a1"; \
	ogr2ogr $(DST_DIR)/a2.geojson $(DST_DIR)/a2.shp
#	ogr2ogr -of "ESRI Shapefile" -dialect sqlite -sql "SELECT ST_Union(geometry) AS geometry FROM a1 GROUP BY geometry" $(DST_DIR)/a2.shp $(DST_DIR)/a1.shp
#	ogr2ogr -of GeoJSON -dialect sqlite -sql "SELECT ST_Union(geometry) AS geometry FROM a GROUP BY geometry" $(DST_DIR)/a.geojson $(DST_DIR)/a.geojsons; \
