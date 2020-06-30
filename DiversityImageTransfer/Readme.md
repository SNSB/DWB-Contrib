# DWB ImageTransferScript 

The Diversity Workbench (=DWB) ImageTransferScript is a script for processing and importing images/media to the DiversityCollection DB and archiving originals to a local storage as well as writing a script for transfering files to a backup server.

For more infrastructure information see [multimedia data-flow at SNSB-IT-center](https://ides.snsb.info/wiki/Multimedia-Datenfluss_am_SNSB_IT-Zentrum)

1. [Prerequisite](#prerequisite)
    1. [DiversityCollection](#diversitycollection)
    1. [FileServer Working Directories](#fileserver-working-directories)
    1. [Parameter Settings](#parameter-settings)
    1. [Special Project Settings](#special-project-settings)
    1. [External Software](#external-software)
    1. [DB User Rights](#db-user-rights)
1. [Run](#run)
1. [Functions](#functions)
    1. ['ProcessImage'](#processImage)
    1. ['ConvertImage( [array] $ConversionParameters )'](#convertImage)
    1. ['TransferFilesToWebServer( [string] $ScpFile)'](#transferFilesToWebServer)
    1. ['SqlProjectDir (), SqlCommands ()'](#sqlProjectDir)
1. [Examples](#examples)


# Prerequisite

## DiversityCollection
DWB ImageTransferScript is a script for processing and importing images and media to the DiversityCollection database. For more information see [DiversityCollection](https://diversityworkbench.net/Portal/DiversityCollection). 

## FileServer Working Directories

- 'ImageTransfer' directory: 
Copy all new images to the transfer directory of the corresponding Project. The name of the projects transfer directory always has to end with '_Transfer'. E.g. if you want to import new images to Project2, copy all new images to '\ImageTransfer\Project2_Transfer'

```sh
drive:ImageImport\ImageTransfer\
drive:ImageImport\ImageTransfer\Project1_Transfer
drive:ImageImport\ImageTransfer\Project2_Transfer
...
```

- 'Archive' directory: 
The script copies all original images to the corresponding Project directory. (local archive)
```sh
drive:Archive\Pictures\Original
drive:Archive\Pictures\Original\Project1
drive:Archive\Pictures\Original\Project2
...
```
- 'SnsbPictures' directory on web server: 
The script copies all processed images (web and thumbnails) to this directory. DWB-Client access!
```sh
drive:SnsbPictures\
drive:SnsbPictures\Project1
drive:SnsbPictures\Project2
drive:SnsbPictures\Project2\web
drive:SnsbPictures\Project2\pre6
...
```

- 'SnsbMedia' directory on web server: 
DWB-Client access for all non-image media files
```sh
drive:SnsbMedia\
drive:SnsbMedia\Project1
drive:SnsbMedia\Project2
drive:SnsbMedia\Project2\web
...
```
## Parameter Settings
Before starting set all parameters according to your infrastructure:
 * ServerIP
 * Database settings
 * License info
 * Picture and Media Server
 * File transfer settings (e.g. cygwin)
 * Backup settings (e.g. IBM Spectrum Protect)
 * ExifTool, ImageMagick settings
 * ImageProcessing Drive definitions
 * Internal flags for project based import processing
 * Email notifications (get Error and Success notifications)
 * Set the counter variable for a maximal number of allowed errors
 ```sh
 if ( ++$Counter -gt 9 )
{
	# too many error Emails, error exit
	exit 1
}
 ```  

## Special Project Settings
You may define special project settings in the script - starting at section "Special PROJECT SETTINGS" (line 342) until section "Function definitions".

## External Software

* ImageMagick:
For image conversion (Apache 2.0 license). 

* ExifTool:
For reading image metadata (GPL 1+/Artistic License)

* Cygwin:
For file transfer to webserver

* SQL-Client, SQLcommand: 
For database import

! Note: Change to your installation path!

## DB user rights
You need to have full access rights to the DWB Databases. Save your SQL password within a file and set $SQL_PWFILE variable within script:
```sh
$SQL_PWFILE = "C:\YourPath\Sqlpw.txt"

```
# Run

Starting the ImageTransfer script by calling ImageTransfer.ps1 with up to 4 arguments 
```sh
 'ImageTransfer.ps1 Project Filename (Subdirectory) (Flags)'
 ``` 
* Project: (required) name of your project. This defines the name of your transfer and target directory as well as the association to the database
* Filename: (required) name of imagefile. Wildcards are possible before extension, e.g. *.jpg
* Subdirectory: if fixed subdirectory is requested, else put a '-'
* Flags: 11 bit sized flag:
```sh
UPDATE_DATABASE_FLAG                1
BACKUP_ORIGINAL_FILES               01
RENAME_ORIGINAL_FILES               001
TRANSFER_TO_WEB_SERVER_FLAG         0001
CHECK_WEB_SERVER_FILE_FLAG          00001
COMPARE_WEB_FILE_FLAG               000001
IMAGE_CONVERSION_FLAG               0000001
REMOVE_IMAGE_FROM_TRANSFER_DIR_FLAG 00000001
REMOVE_LOCAL_WEB_FILES              000000001
CREATE_SYMBOLIC_LINKS               0000000001
READ_EXIF_INFO                      00000000001
```


# Functions

## 'ProcessImage()'

* checks for valid filename 
* creates the SQL_AccessionNumber 
* rename filename (format: Accessionnumber_RecordDate_Timestamp)
* backup original files to archive (local archive) 
* write a backup script for long term backup)
* create symbolic links 
* convert images to web/preview files
* update database
## 'ConvertImage( [array] $ConversionParameters )'
* Convert original image according to conversion parameters (ImageMagick) 
* Copy to target directory

## 'TransferFilesToWebServer( [string] $ScpFile)'
* Transfer image data to the web-server

## 'SqlProjectDir (), SqlCommands ()'
* Update SQL database: Insert Image-URLs accroding to project and accessionnumber  

# Examples

* __Import everything for all jpg images within directory 'ExampleProject_Transfer':__
```sh
C:\ImageTransfer\ImageTransfer.ps1 ExampleProject *.jpg - "11111111111"
```
* __Import without Archive and SymLinks for all tif images within directory 'ExampleProject_Transfer':__
```sh
C:\ImageTransfer\ImageTransfer.ps1 ExampleProject *.tif - "10110011001" 
```
* __Import only DB entries:__
```sh
C:\ImageTransfer\ImageTransfer.ps1 ExampleProject *.jpg - "10100001001"
```
* __Import without DB entries:__
```sh
C:\ImageTransfer\ImageTransfer.ps1 ExampleProject *.jpg - "01111111111"
```




