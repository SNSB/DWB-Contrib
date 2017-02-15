This import schema allows the update of taxa in DiversityTaxonNames with its Red List parameter provided in the file downloaded here: http://www.bfn.de/fileadmin/BfN/roteliste/Dokumente/Rote_Liste_D.zip

For the import, it was necessary to include a new column providing the NameID in DiversityTaxonNames in order to allow the update.
The import table includes the following information:

-	Red list category
- Responsibility of Germany
- Current population trend
- Long-term population trend
- Short-term population trend
- Risk
- Special cases
- Latest evidence
- German common name
-	Neobiota

This import schema was created based on the original organization of the data. For a further successful use of this schema, please note that interface settings e.g. ProjectID (TaxonNameList and TaxonNameProject) or AnalysisID should be adapted to your installation, as well as other settings like prefixes, postfixes, splitters or filters. 

Any other information that is not included in the defined columns should be added to the free columns at the right side of the table. The import schema should be updated/modified in order to import this addition.

The settings for the import are described below:



