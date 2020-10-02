# dita-iiRDS
iiRDS extension plugins for DITA XML

This project provides two separate plugins for DITA-OT that may be combined or used individually:

* org.dita.iirds.rng: Specialization schemas implemented in Relax NG that extends DITA 1.3 topics and maps with attributes and elements for iiRDS-specific metadata.
*  org.dita.iirds.iirdspackage: Transformation plugin that generates iiRDS packages from DITA 1.3 content. This plugin works with or without the specialized elements and attributes defined in org.dita.iirds.rng. 

For information on integrating DITA-plugins into DITA-OT, see the DITA-OT documentation. 

#####Prerequisites for using the plugins:
* DITA-OT 2.5.x

## org.dita.iirds.rng

Currently, the plugin provides only schemas implemented in Relax NG. DTD support will be added in the future.

### Installing

1. Integrate the plugins into DITA-OT.
1. Integrate the Relax NG files for the elements and attributes into your map and topic shells. Do not forget to extend the @domains attribute.
1. Open a map or topic, add some iiRDS metadata attributes or iiRDS elements in <metadata>.

Sample shell files and template files are provided with the plugin. 

### Specialized elements and attributes

Simple metadata (i.e. key/value pairs) can be added via specialized filtering attributes. Values for the attributes can be controlled via a specialized subject scheme map. 
The subject scheme map provides additional attributes that provide a mapping to URIs in the generated RDF file in the iiRDS package.

Complex metadata (i.e. metadata that requires a combination of multiple values, for example, an event type and event code), are provided using specialized elements that are available both in topics and maps in <metadata>.
To control the content of such elements, a conref library may be used (templates will be provided in the future). 

## org.dita.iirds.iirdspackage: DITA-OT plugin for creating iiRDS packages from DITA maps

Usage:

* Supported DITA-OT version: 2.5 or later (tested with version 2.5.1)
* Installation: dita -install=<zip-filename of plugin>
* transtype: iirdspackage
* Set dita command line option for transformation: 

 `-Diirds.metadatahandler.class=org.dita.iirds.mapper.PIClassHandler` for extracting PI Class metadata from DITA files

`-Diirds.metadatahandler.class=org.dita.iirds.mapper.OtherMetadataHandler` for extracting iiRDS metadata from `othermeta` elments in DITA files
 
 `-Diirds.metadatahandler.class=org.dita.iirds.mapper.IIRDSHandler` (this is the default) for extracting metadata from the iiRDS domain using the specialized elements, in addition extract metadata from `othermeta` elements
 
* Use general HTML transformation parameters if needed (e.g. for specifying CSS files or custom XSLT to use)

The transformation creates one `<map name>.iirds` file in the output directory.


Sample command line for executing an iiRDS transformation:

    dita -f iirdspackage -i <map filename> -o <output directory> -Diirds.metadatahandler.class=org.dita.iirds.mapper.IIRDSHandler


### Metadata Extraction modules

#### `org.dita.iirds.mapper.IIRDSHandler`

This module extracts iiRDS metadata from attribute values in maps and topics. The attributes must be specialized from the DITA `props` attribute.

##### Attributes (incomplete list)

-  `iirds-product`
-  `iirds-component`
-  `product-feature`
-  `product-lifecycle-phase`
-  `document-type`
-  `information-subject`

The tokens of the attribute values are taken. When available, the tokens get resolved using the subject scheme of the map. The textual resprensations from the suject scheme are used as metadata entries.

##### Elements

Elements are identified by their class attributes. The elements must be specialized from `+ topic/data iirds-d/iirds-data `. 

Attribute classes (incomplete list):

-  `+ topic/data iirds-d/iirds-data iirds-d/event-type `
-  `+ topic/data iirds-d/iirds-data iirds-d/event-code `
-  `+ topic/data iirds-d/iirds-data iirds-d/qualification-role `
-  `+ topic/data iirds-d/iirds-data iirds-d/qualification-skilllevel `
-  `+ topic/data iirds-d/iirds-data iirds-d/content-lifecycle-status`


##### Attributes Filtering

The attributes can be used both for filtering and classification.

The plugin  provides an additional pro-processing step, which provides attribute filtering for specialized filter attributes (such as the iiRDS related attrubutes, see above).

The module filters out filter attribute values from specialized filter attributes that do not match the applicable DITAVAL profile.

E.g. 

`<p iirds-product='T5-DH2 T3-X'>`

gets filtered to

`<p iirds-product='T5-DH2'>`

when only "T5-DH2" matches the filter, e.g. by the following DITAVAL profile:

	<?xml version="1.0" ?>
	<val xmlns:dita-ot="http://dita-ot.sourceforge.net">
 		<prop action="include" att="iirds-product" val="X5-DH2"></prop>
		<prop action="exclude" att="iirds-product"></prop>
	</val> 

##### Limitations
-  Attribute filtering and attribute metadata extraction do not support grouped values in filter attributes (e.g. `<p iirds-product="fan(T5-DH2 T3-X) ventilator(C2)">`).  
-  Attribute filtering does not support branch filtering.

The limitations will be addressed in future versions.


#### `org.dita.iirds.mapper.OtherMetadataHandler`

This module extracts metadata from `<othermeta>` elements in maps and topics.
`<othermeta>` provides name/value pairs. The name identifies the iirds metadata field and the value serves as iiRDS metadata value, e.g.:

	<metadata>
		<othermeta name="Component" content="Rotor"/>
		<othermeta name="InformationSubject" content="Safety Instruction"/>
	</metadata>
  
Currently supported names are:

-  Product
-  Component
-  ProductFeature
-  ProductLifecyclePhase
-  InformationSubject
-  DocumentType
-  EventType
-  EventCode
-  QualificationRole
-  QualificationSkillLevel

The names are case insensitive.

Furthermore metadata gets extracted from `<prodname>` and `<component>` DITA elements (as identified by their DTIA classes).
 
