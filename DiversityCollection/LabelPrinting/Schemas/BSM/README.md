
# Label Printing BSM XSLT Schemas
This directory contains XSLT schema files used to generate labels at the BSM Institute.
The schema files include templates for handling label layout, fonts, and printing options. They reference the shared templates from `Templates/LabelTemplates.xslt`.

## List of XSLT Files
- **`BSM_Collection.xslt`**
- **`BSM_Collection_2.xslt`**:
  - Based on BSMCollection.xslt
  - Added a new call-template named SubstrateUnitsInRows to handle substrate-specific rows.
  - Adjusted page break logic (starting at line 224) to improve label formatting.
  - Replaced $FontTaxonName with $FontSmall for UnitsInRows and SubstrateUnitsInRows for better readability.
  - Introduced @media print styles to prevent page breaks inside div elements.
  - Added <div> tags for better control over layout and printing behavior.
- **`BSM_Collection_Lichen.xslt`**:
  - Based on BSM_Collection_2.xslt
  - Adjusted FontTaxonName size to 12pt
  - Inventar. No. added and M-number set to bold:
    - The inventory number is removed from the transaction title. Since this is always located at the end of the transaction title, everything that comes after Inv. Num. is inserted (including the "Inv. Num.").
    - The inserted code is designed so that if there is no transaction title or no "Inv. Num." in it, everything works as usual.
  - Abbreviation of first names in the `./Units/MainUnit/Identifications/Identification/Agent` field removed and replaced with FirstName
  - `./CollectionSpecimen/OriginalNotes` and  `./CollectionSpecimen/AdditionalNotes` removed.

## Dependencies
- **`Templates/LabelTemplates.xslt`**:
  - A shared template file included in `BSMCollection.xslt` for common label formatting.


