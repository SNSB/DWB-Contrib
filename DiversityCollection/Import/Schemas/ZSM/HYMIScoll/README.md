These import schemas allow the import of specimens (ZSMpiscescoll_01_Import_Specimen_Schema.xml) and to match the tissues to the related specimens (ZSMpiscescoll_01_Import_TissueToSpecimen_Schema.xml).

The import table for the import of specimens (ZSMpiscescoll_01_Import_Specimen_Table.txt) includes information about:

- Accession number
- DNA feld number
- Identification: Family, subfamily, genus, species, author, type status, determinator
- Event: Country, location, habitat, coordinates, drainage, altitude, depth
- Donator, collectors and collecting method

The import table for the import of tissues (ZSMpiscescoll_01_Import_TissueToSpecimen_Table.txt) includes information about:

- Accession number
- Tissue number
- Preparation method
- Processings

Any other information that is not included in the defined columns should be added to the free columns at the right side of the table. The import schema should be updated/modified in order to import this addition.

These import schemas were created based on the original organization of the data. For a further successful use of this schema, please keep in mind that interface settings e.g. CollectionID, ProjectID, ProcessingID should be adapted to your installation, as well as other settings like prefixes, postfixes, splitters or filters.

The settings for the import of the specimen are described below:

