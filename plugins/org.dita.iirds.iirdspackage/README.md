# dita.iirds.iirdspackage

DITA-OT plugin for creating iiRDS packages from DITA maps

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


## Metadata Extraction modules

### `org.dita.iirds.mapper.IIRDSHandler`

This module extracts iiRDS metadata from attribute values in maps and topics. The attributes must be specialized from the DITA `props` attribute.

Attributes:

-  `iirds-product`
-  `iirds-component`
-  `product-feature`
-  `product-lifecycle-phase`
-  `document-type`
-  `event-type`
-  `event-code`
-  `information-subject`
-  `qualification-role`
-  `qualification-skilllevel`

The tokens of the attribute values are taken. When available, the tokens get resolved using the subject scheme of the map. The textual resprensations from the suject scheme are used as metadata entries.

Elements:

Elements are identified by their class attributes. The elements must be specialized from `+ topic/data iirds-d/iirds-data `. 

Attribute classes:

-  `+ topic/data iirds-d/iirds-data iirds-d/iirds-product `
-  `+ topic/data iirds-d/iirds-data iirds-d/iirds-component `
-  `+ topic/data iirds-d/iirds-data iirds-d/product-feature `
-  `+ topic/data iirds-d/iirds-data iirds-d/product-lifecycle-phase `
-  `+ topic/data iirds-d/iirds-data iirds-d/document-type `
-  `+ topic/data iirds-d/iirds-data iirds-d/information-subject `
-  `+ topic/data iirds-d/iirds-data iirds-d/qualification-role `
-  `+ topic/data iirds-d/iirds-data iirds-d/qualification-skilllevel `


#### Attributes Filtering

The attributes can be used both for filtering and classification.

The plugin  provides an additional pro-processing step, which provides attribute filtering for specialized filter attributes (such as the iiRDS related attrubutes, see above).

The module filters out filter attribute values from specialized filter attributes that do not match the applicable DITAVAL profile.

E.g. 

`<p iirds-product='T5-DH2 T3-X'>`

gets filtered to

`<p iirds-product='T5-DH2'>`

when only "T5-DH2" matches the filter, e.g. by the following DITAVAL profile:

	<?xml version="1.0" ?><val xmlns:dita-ot="http://dita-ot.sourceforge.net">
	<val>
 		<prop action="include" att="iirds-product" val="X5-DH2"></prop>
		<prop action="exclude" att="iirds-product"></prop>
	</val> 

#### Limitations
-  Attribute filtering and attribute metadata extraction do not support grouped values in filter attributes (e.g. `<p iirds-product="fan(T5-DH2 T3-X) ventilator(C2)">`).  
-  Attribute filtering does not support branch filtering.

The limitations will be addressed in future versions.


### `org.dita.iirds.mapper.OtherMetadataHandler`

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
 
