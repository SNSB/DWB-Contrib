### Anpassungen für die Ausgabe per HUGO

- Installation von HUGO: <https://gohugo.io/getting-started/quick-start/>
  - als Theme <https://themes.gohugo.io/themes/hugo-theme-relearn/>
    - Befehl hierfür: ```git submodule add https://github.com/McShelby/hugo-theme-relearn.git themes/relearn```

- Übersetzung der *.html Seiten mit pandoc in *.md
- Aufbau einer Ordnerstruktur die dem Index der chm Datei entspricht
- Das Basisdokument der Ordner wird in die Ordner verschoben und in _index.md umbenannt
  - Dort im Frontmatter steht der Titel der im Menü angezeigt wird, e.g.: 
    ```nativ 
    --- 
    title: Installation 
    ---  
    ```
- Überarbeitung der md Dateien
  - Korrektur der Bildverweise 
    - Ordner mit den Bildern in den Ordner static kopieren
    - von e.g.  ```![](img/...) in ![](/img/...)```
    - ACHTUNG - Case sensitiv. Namen müssen stimmen
    - Icons gegebenenfalls freistellen für Darkmode
  - Entfernung aller störenden Formatierungsangaben
  - Entfernung der Kopfzeile (Überschrift wird von HUGO automatisch erzeugt)
- Korrektur der internen Verweise
  - ändern von 
    ```
    [![](/img/IcoVideoDe.png?classes=inline)](http://media.snsb.info/Tutorials/DiversityAgents/Editing/OeffentlicheKontaktdaten.webm)
    ```
    zu
    ```
    [{{% icon icon="fas fa-video" %}}](http://media.snsb.info/Tutorials/DiversityAgents/Editing/OeffentlicheKontaktdaten.webm)
    ```
  - ansonsten wird das Bild gezeigt statt das Video zu starten
  - weitere Icons unter <https://fontawesome.com/v5/search?o=r&m=free>
  - ändern von
    ```
    [Contact](Contact.htm)
    ```
    zu
    ```
    [Contact](/manual/DiversityAgents/editingdata/contact)
    ```


- Logo
  - hierfür das Logo in den Ordner static kopieren
  - im Ordner layouts einen Ordner partials anlegen
  - dort eine Datei logo.html anlegen
    - in dieser auf das Logo verweisen e.g.: 
        ```
        <h4><b>DiversityAgents</b></h4>
        <img src="/DA_4D.svg">
        ```
- favicon: Datei favicon.ico in der Ordner static kopieren

- Konfiguration - in hugo.toml:
  
    ```native
    baseURL = "http://www.diversityworkbench.de/manual/DiversityAgents/"
    languageCode = "en-us"
    title = "DiversityAgents"
    theme = "relearn"

    [outputs]
        home = ["HTML", "RSS", "SEARCH", "SEARCHPAGE"]
        section = ["HTML", "RSS", "PRINT"]
        page = ["HTML", "RSS", "PRINT"]

    [params]
        themeVariant = [ "auto", "blue" ]
    ```

- Start des Testservers:
  - mit einem Terminal in das Verzeichnis des Projekts wechseln 
  - dort ```hugo server ``` eingeben.
    - bei Problem mit Sonderzeichen: den Inhalt der Datei config.toml in hugo.toml kopieren und config.toml löschen (beide sollten wenn vorhanden UTF8 sein - werden machmal als UTF16 angelegt - dieses dann nach UTF8 ändern)
  - Im Browser an die angegebene Adresse navigieren, e.g. ```localhost:1313```
