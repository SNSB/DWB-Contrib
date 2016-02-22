This import schema was used for the import of digitised herbarium sheets from the Munich herbarium within the framework of the project Global Plants Initiative.
This data can be accessed in the following website: https://plants.jstor.org/

The import table includes the following information:
-	Specimen Acc. No.
- Location (Country, collection date, locality description, altitude)
- Identifications (up to three possible identifications containing: typification, identification date, responsible and reference)
- Collector name (up to eight possible collectors)

This import schema was created based on the original organization of the data. For a further successful use of this schema, please keep in mind that interface settings e.g. CollectionID or ProjectID should be adapted to your installation, as well as other settings like prefixes, postfixes, splitters or filters.

Please check 'BSMgpiplantscoll_Import_Explanation.pdf' for further details about the import settings of each column. 
Schedule for import of tab-separated text files into DiversityCollection
Target within DiversityCollection: Specimen
Schedule version: 	1	Database version: 	02.05.41
Lines:	2 - 18	First line contains column definition: 	✔
Encoding:	Unicode	Language:	de

File columns
Pos.	Name	Table	Column	Example	Transformed
0	AccNo
	CollectionSpecimen. 	AccessionNumber	M-0028945	
1	Withhold reason
	CollectionSpecimen. 	DataWithholdingReason	GPI: not completed	
2	CollDay
	CollectionEvent. 	CollectionDay		
3	CollMonth
	CollectionEvent. 	CollectionMonth	5	
4	CollYear
	CollectionEvent. 	CollectionYear	1898	
5	CollDateSuppl
	CollectionEvent. 	CollectionDateSupplement	1898-10-	
6	Country
	CollectionEvent. 	CountryCache	United States	
7	LocalityDesc
	CollectionEvent. 	LocalityDescription	Pahroi Range Nevada.; 4000-5000 ft.	
8	HabitatDesc
	CollectionEvent. 	HabitatDescription	Felsen.	
9	NamedArea
	CollectionEventLocalisation_5. 	Location1	United States	
10	AltFrom
	CollectionEventLocalisation_7. 	Location1		
11	AltTo
	CollectionEventLocalisation_7. 	Location2		
12	ExsiccataSer
	CollectionSpecimen. 	ExsiccataAbbreviation		
13	ExsiccNo
	IdentificationUnit_1. 	ExsiccataNumber		
14	OrigNotes
	CollectionSpecimen. 	OriginalNotes		
15	AddNotes
	CollectionSpecimen. 	AdditionalNotes		
16	InternalNotes
	CollectionSpecimen. 	InternalNotes	LAPI newfasc M_359	
17	Problems
	CollectionSpecimen. 	Problems		
18	TaxGroup
	IdentificationUnit_1. 	TaxonomicGroup	plant	
19	Family
	IdentificationUnit_1. 	FamilyCache	Rosaceae	
20	TaxName1
	Identification_1_1. 	TaxonomicName	Purpusia saxosa Brandegee	
21	DetDay1
	Identification_1_1. 	IdentificationDay		
22	DetMonth1
	Identification_1_1. 	IdentificationMonth	2	
23	DetYear1
	Identification_1_1. 	IdentificationYear	2001	
			Transformations:	
	
Translate	Into
Esser,H.	
24	TypeStatus1
	Identification_1_1. 	TypeStatus	isotype	
25	TypeNotes1
	Identification_1_1. 	TypeNotes		
26	Reference1
	Identification_1_1. 	ReferenceTitle	Bot. Gaz. 27: 447. 1899	
27	DeterminerName1
	Identification_1_1. 	ResponsibleName	Schneckenburger, St.	
28	TaxName2
	Identification_1_2. 	TaxonomicName	Ivesia arizonica (Eastw. ex J.T.Howell) Ertter	
29	DetDay2
	Identification_1_2. 	IdentificationDay	20	
30	DetMonth2
	Identification_1_2. 	IdentificationMonth	3	
31	DetYear2
	Identification_1_2. 	IdentificationYear	2015	
32	TypeStatus2
	Identification_1_2. 	TypeStatus	not a type	
33	TypeNotes2
	Identification_1_2. 	TypeNotes		
34	Reference2
	Identification_1_2. 	ReferenceTitle		
35	DeterminerName2
	Identification_1_2. 	ResponsibleName	Montes de Oca, P.	
36	Collection
	CollectionSpecimenPart_1. 	CollectionID	M-VascularPlants	
37	Material category
	CollectionSpecimenPart_1. 	MaterialCategory	herbarium sheets	
			Transformations:	
	
Translate	Into
	
herbarium sheet	herbarium sheets
38	StorLocDivColl
	CollectionSpecimenPart_1. 	StorageLocation	Ivesia arizonica (Eastw. ex J.T.Howell) Ertter	
	IdentificationUnit_1. 	LastIdentificationCache	Ivesia arizonica (Eastw. ex J.T.Howell) Ertter	
39	Collector1
	CollectionAgent_1. 	CollectorsName	Purpus, C.A.	
40	CollNo1
	CollectionAgent_1. 	CollectorsNumber	6305	
41	Collector2
	CollectionAgent_2. 	CollectorsName		
42	Collector3
	CollectionAgent_3. 	CollectorsName		
43	Collector4
	CollectionAgent_4. 	CollectorsName		
44	Collector5
	CollectionAgent_5. 	CollectorsName		
45	Collector6
	CollectionAgent_6. 	CollectorsName		
46	Collector7
	CollectionAgent_7. 	CollectorsName		
47	Collector8
	CollectionAgent_8. 	CollectorsName		
48	TaxName3
	Identification_1_3. 	TaxonomicName		
49	TypeStatus3
	Identification_1_3. 	TypeStatus		
50	TypeNotes3
	Identification_1_3. 	TypeNotes		
51	Reference3
	Identification_1_3. 	ReferenceTitle		
52	DeterminerName3
	Identification_1_3. 	ResponsibleName		
53	DetDay3
	Identification_1_3. 	IdentificationDay		
54	DetMonth3
	Identification_1_3. 	IdentificationMonth		
55	DetYear3
	Identification_1_3. 	IdentificationYear		

Interface settings
Table	Table alias	Column	Value
CollectionProject	CollectionProject_1	ProjectID	904
	CollectionProject_2	ProjectID	921
CollectionSpecimenPart	CollectionSpecimenPart_1	CollectionID	M-VascularPlants
Identification	Identification_1_1	IdentificationSequence	2
	Identification_1_1	IdentificationCategory	determination
	Identification_1_2	IdentificationSequence	3
	Identification_1_2	IdentificationCategory	determination
	Identification_1_3	IdentificationSequence	1
	Identification_1_3	IdentificationCategory	determination
IdentificationUnitInPart	IdentificationUnitInPart_1_1	DisplayOrder	1
