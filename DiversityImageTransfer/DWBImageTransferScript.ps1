# #######################################################################################
#
# ImageProcessing script
#
# #######################################################################################
#
# VARIABLES TO BE SET BY USER
#
$global:ServerIP 	= "111.222.33.44"                   ##### Server IP: Transfer, Processing, Picture and Archive directories
#
# Database settings:
#
# read password from file:
$SQL_PWFILE 		= "C:\ImageTransfer\password.txt"   ##### File containing Password for login to SQL database
$SQL_USER 			= "Sqluser"                         ##### User name for login to SQL database
$SQL_PASSWORD 		= ""                                ##### Password will be set later on from Password file content
$SQL_COMMAND_PROG 	= "sqlcmd"
$SQL_SERVER 		= "123.123.123.123,1234"            ##### Server IP: SQL database server
$SQL_DATABASE_NAME 	= "DiversityCollection"             ##### Preset Collection database name
$SQL_PROJECTS_DATABASE_NAME = "DiversityProjects"       ##### Preset Projects database name
#
# Set BSM license info 
#
$SQL_IPR = "My first Company, Germany"
$SQL_LicenseType = "CC BY-SA 4.0"
$SQL_LicenseHolder = "My second Company"
$SQL_LicenseURI = "https://creativecommons.org/licenses/by-sa/4.0"
#
# Set picture and other media servers
#
$WebServer 			= 'pictures.server.de'              ##### Web address of picture server
$WebServerMedia  	= 'media.server.de'                 ##### Web address of other media server
#
# Set constants
#
$UNDERSCORE = "_"
$BLANK = " "
$MINUS = "-"
$maxDigits = 8
#
# Wait time and number of trials in case of connection error
$WAIT_TIME_ON_CONNECTION_ERROR 	= 5
$REPEAT_ON_CONNECTION_ERROR 	= 5
#
# Execution programs
#
# File transfer to webserver (via Windows-Share)
# 
$DIFF_PROC_EXE 		= 'C:/cygwin/bin/diff.exe'
#
# Backup (Tivoli)                                       ##### Set backup program path (Linux style), name (Windows style) and arguments
#
$BACKUP_PROG_DIR 	= "`"C:\Program Files\Tivoli\TSM\baclient`""
$BACKUP_PROG_EXE 	= "`"C:/Program Files/Tivoli/TSM/baclient/dsmc.exe`""
$BACKUP_ARGS_EXE 	= " -NoNewWindow -Wait -Verbose -ArgumentList `"archive -optfile=dsm_BSM_ARCHIVE2.opt -description='ImageArchive' " 
#
# Email notification
#
$emailFrom 		 	= "FileTransfer@server.de"          ##### EMail notification sender
$emailTo   		 	= "Myself@server.de"                ##### EMail notification recipient
$emailSmtpServer 	= "mailout.server.de"               ##### EMail out server
#
# ExifTool
#
$EXIF_PROG_EXE 	= 'C:/Program Files/ExifTool/exiftool.exe'
$global:ExifInfoStr = " "
$global:ExifCreateDate = ""
$global:SQL_Description = " "
#
# Image conversion program Image Magick (with different versions depending on installation of used computer)
#
$CONVERT_PROG_EXE 	= 'C:/Program Files/ImageMagick-6.8.9-Q16/convert.exe'
if( -not $( Test-Path "$CONVERT_PROG_EXE" -PathType Leaf ) )
{
    # if not exists, change path for BSM7
    $CONVERT_PROG_EXE 	= 'C:/Program Files/ImageMagick-6.5.7-Q16/convert.exe'
    if( -not $( Test-Path "$CONVERT_PROG_EXE" -PathType Leaf ) )
    {
        # if not exists, change path for BSM5
    	$CONVERT_PROG_EXE 	= 'C:/Program Files (x86)/ImageMagick-6.5.5-Q16/convert.exe'
    }    
}
#
#
#=================================================================
#
# FLAGS FOR EXECUTION TO BE SET BY USER
#
$UseExtendedName	= $false           # allow all following characters until underscore
$UseExtendedAccNr   = $false
$UseExifCreateDate  = $true            # use date from EXIF string to rename pictures
$TruncateExifData   = $false           # truncate EXIF string if it is too long for sqlcmd arguments
$CreateNewDataSet   = $false
$SetLicenseInfo     = $false
$AssignToExternalIdentifier = $false
$InsertMinus		= $true
$SubdirFixedLength  = $false
$ConvertToUpperCase = $true
$TrimAccNrToDigits  = 0
#
# Set TRUE when working in StorageUnit ONLY!!
$WorkOnImageStorage = $true
#
# Obsolete when working in StorageUnit ONLY!!
$ArchiveOnImageStorage = $true
#
# Image Processing Drive definitions
#
if ($WorkOnImageStorage)
{
	$InputDrive = "//$global:ServerIP/ImageImport/"
	$ArchiveDrive = "//$global:ServerIP/"
    $ArchiveOnImageStorage = $false
}
else
{
	$InputDrive = "D:/"
	$ArchiveDrive = "D:/"
}
#
#
#==================================================
# COMMAND LINE ARGUMENTS
#==================================================
#
#==================================================
# Preset Project name (first argument)
$ProjectName		= 'TESTcoll'  
#==================================================
#
# Project Target Directory if different from ProjectName
$ProjectTargetDir   = ''
# e.g. different Target dir:
# $ProjectName		= 'TESTcoll'  
# $ProjectTargetDir = 'TESTsubcoll'
#
#
if ( $args.Length -gt 0)
{
	if (($args[0]).ToString() -eq "?")
	{
		echo ""
		echo "usage: .\ImageTransfer Project Filename (Subdirectory) (Flags)"
		echo ""
		echo "Flags: ''11111111111''"
		echo ""
		echo "UPDATE_DATABASE_FLAG                     1"
		echo "BACKUP_ORIGINAL_FILES                    01"
		echo "RENAME_ORIGINAL_FILES                    001"
		echo "TRANSFER_TO_WEB_SERVER_FLAG              0001"
		echo "CHECK_WEB_SERVER_FILE_FLAG               00001"
		echo "COMPARE_WEB_FILE_FLAG                    000001"
		echo "IMAGE_CONVERSION_FLAG                    0000001"
		echo "REMOVE_IMAGE_FROM_TRANSFER_DIR_FLAG      00000001"
		echo "REMOVE_LOCAL_WEB_FILES                   000000001"
		echo "CREATE_SYMBOLIC_LINKS                    0000000001"
		echo "READ_EXIF_INFO                           00000000001"
		echo ""
		exit 0
	}
	$ProjectName	= ($args[0]).ToString()
}
#
# e.g. Other settings according to project name
#
if ( $ProjectName.StartsWith("ABC") )
{
	$SetLicenseInfo = $true
}
if ( $ProjectName.StartsWith("OTHER") )
{
    $SQL_IPR = "Other Company"
    $SQL_LicenseHolder = "Other Subcompany"
	$SetLicenseInfo = $true
}
#
#==================================================
# Preset Image file name (second argument)
$InputFileName		= "*.jpg"
#==================================================
# NOTE: Wildcards for Extensions like "*.*" are not permitted!!
#
if ( $args.Length -gt 1 -and $args[1] -ne "-")
{
	$InputFileName	= $args[1]
}
#
# Special handling if script is used by web service
# Directory path for MediaService Trace messages, if $trace is enabled
#
$MEDIASERVICE = "D:/ImageTransfer/MediaService_Transfer"
#
# Extension for Debug/Script output files to avoid access by multiple processes at the same time
#
$FileExt			= ""
$global:traceFile = $MEDIASERVICE + "/Debug1" + $FileExt + ".out"
#
#==================================================
# Preset User name (third argument)
$MediaUserName		= "Test"
#==================================================
# Argument is only needed if image should be stored in defined subdirectory
# To create automated subdirectories, set to "-"
#
$UseName = $false
if ( $args.Length -gt 2 -and $args[2] -ne "-" )
{
	$MediaUserName	= $args[2]
	$UseName = $true
}
#
#==================================================
# Preset  execution control flags (fourth argument)
$Flags = "11111111111"
#==================================================
# Default: Every option is set: "1111111111" 
#
if ( $args.Length -gt 3 -and $args[3] -ne "-" )
{
	$Flags	= $args[3]
}
#
#
# CONSTANTS definition
# --------------------
# 
# execution control flags							# Flag:
$UPDATE_DATABASE_FLAG 					= $true		# "1"
$BACKUP_ORIGINAL_FILES					= $true		# "01"
$RENAME_ORIGINAL_FILES					= $true		# "001"
$TRANSFER_TO_WEB_SERVER_FLAG 			= $true		# "0001"
$CHECK_WEB_SERVER_FILE_FLAG 			= $true		# "00001"
$COMPARE_WEB_FILE_FLAG 					= $true		# "000001"
$IMAGE_CONVERSION_FLAG 					= $true		# "0000001"
$REMOVE_IMAGE_FROM_TRANSFER_DIR_FLAG 	= $true		# "00000001"
$REMOVE_LOCAL_WEB_FILES					= $true		# "000000001"
$CREATE_SYMBOLIC_LINKS					= $true		# "0000000001"		<-- $true (if "no-date"-filenames)
$READ_EXIF_INFO							= $true		# "00000000001"
#
$trace = $false										# <-- do not trace execution in Debug file
$listAddr = $true
#
# Set execution control flags if argument has been transmitted
#
if ($Flags.Length -gt 0)
{
	if ($Flags.Length -gt 0 -and $Flags[0] -eq '0')
	{
		$UPDATE_DATABASE_FLAG 					= $false
	}
	if ($Flags.Length -gt 1 -and $Flags[1] -eq '0')
	{
		$BACKUP_ORIGINAL_FILES					= $false
	}
	if ($Flags.Length -gt 2 -and $Flags[2] -eq '0')
	{
		$RENAME_ORIGINAL_FILES					= $false
	}
	if ($Flags.Length -gt 3 -and $Flags[3] -eq '0')
	{
		$TRANSFER_TO_WEB_SERVER_FLAG 			= $false
	}
	if ($Flags.Length -gt 4 -and $Flags[4] -eq '0')
	{
		$CHECK_WEB_SERVER_FILE_FLAG 			= $false
	}
	if ($Flags.Length -gt 5 -and $Flags[5] -eq '0')
	{
		$COMPARE_WEB_FILE_FLAG 					= $false
	}
	if ($Flags.Length -gt 6 -and $Flags[6] -eq '0')
	{
		$IMAGE_CONVERSION_FLAG 					= $false
	}
	if ($Flags.Length -gt 7 -and $Flags[7] -eq '0')
	{
		$REMOVE_IMAGE_FROM_TRANSFER_DIR_FLAG	= $false
	}
	if ($Flags.Length -gt 8 -and $Flags[8] -eq '0')
	{
		$REMOVE_LOCAL_WEB_FILES					= $false
	}
	if ($Flags.Length -gt 9 -and $Flags[9] -eq '0')
	{
		$CREATE_SYMBOLIC_LINKS					= $false
	}
	if ($Flags.Length -gt 10 -and $Flags[10] -eq '0')
	{
		$READ_EXIF_INFO							= $false
	}
}

#
# Do no longer copy original image to $FullImageProcessingPath!
# It would be overwritten and deleted in case of $COMPARE_WEB_FILE_FLAG,
# if the converted image name remains unchanged!
# Use $FullImageImportPath as working directory for conversion!
# $REMOVE_IMAGE_FROM_PROCESSING_DIR_FLAG 	= $false
#
# ========= neu ==========
$global:WebServerRootPath 	= '//$global:ServerIP/SnsbPictures'
$global:WebServerFileName   = ""
# ========================
#
# Check file extension *** should not be made here, but on each individual file which is processed !!!!
#
$ind1  = $InputFileName.LastIndexOf( '.' )
$global:extString = $InputFileName.SubString( $ind1 )
$global:extString = $global:extString.ToLower()
$global:webExtString = ".jpg"
$global:IsMediaFile = $false
$global:DestinationSubdir = ""
$global:ArchiveDir = "Archive"

#
# For MediaService usage only:
# Parameter as third argument "name":	Just return target file path
$JustReturnTargetPath = $false
if ( $args.Length -gt 2)
{
 	if ($args[2] -eq "name")
	{
		$TRANSFER_TO_WEB_SERVER_FLAG 		= $false
		$CHECK_WEB_SERVER_FILE_FLAG 		= $false
		$COMPARE_WEB_FILE_FLAG 				= $false
		$IMAGE_CONVERSION_FLAG 				= $false
		$BACKUP_ORIGINAL_FILES				= $false
		$REMOVE_IMAGE_FROM_TRANSFER_DIR_FLAG 		= $false
		$UPDATE_DATABASE_FLAG 				= $false
		$RENAME_ORIGINAL_FILES				= $false			
		$REMOVE_LOCAL_WEB_FILES				= $false	
		$CREATE_SYMBOLIC_LINKS				= $false
		$READ_EXIF_INFO						= $false
		$JustReturnTargetPath				= $true
 	}
}
#
# Decide whether current file is an image or not (in case of wildcard file input)
#
$global:DoImageConversion = $IMAGE_CONVERSION_FLAG
#
# Special PROJECT SETTINGS:
# -------------------------
# Set how many digits behind the characters the subdirectory should have:
# 
$SubdirNumDigits = 4
#
# Different settings according project name:
#
# e. g. TESTnewcoll...
if ( $ProjectName -eq 'TESTnewcoll' )
{
	$CreateNewDataSet   = $true
	$SQL_SERVER 		= "new.diversityworkbench.de,1234"
	$SQL_DATABASE_NAME 	= "DiversityCollection_new"
	$SQL_PROJECTS_DATABASE_NAME = "DiversityProjects_new"
	$InsertMinus	= $false
	$SubdirNumDigits = 0
	$maxDigits = 20
}
#
# Extend max digits if $UseExtendedName
#
if ($UseExtendedName)
{
	$maxDigits = 80
}
#
# ===============================
#
# Communication files:
#
$OutputImageWeb = "output.imgweb" + $FileExt + ".txt"
$OutputImagePre6 = "output.imgpre6" + $FileExt + ".txt"
$ErrorImageWeb = "error.imgweb" + $FileExt + ".txt"
$ErrorImagePre6 = "error.imgpre6" + $FileExt + ".txt"
$OutputExifInfo = "output.exif" + $FileExt + ".txt"
$ErrorExifInfo = "error.exif" + $FileExt + ".txt"
#
# web conversion is depending on the project!
# image conversion parameter settings list (conversion dir, ImageMagic args, stdout, stderr, database update flag)
#
switch ($ProjectName)
{
	"TESTcoll"          {$listWeb 	= "web", 	"",											$OutputImageWeb, 	$ErrorImageWeb, 	$true}
	default 			{$listWeb 	= "web", 	"-resize 800 -trim", 					 	$OutputImageWeb, 	$ErrorImageWeb, 	$true}
}
#
# preview conversion is depending on the project!
#
switch ($ProjectName)
{
	"TESTcoll" 			{$listPre6 	= "pre6", 	"-resize 200 -trim", 						$OutputImagePre6, 	$ErrorImagePre6, 	$false}
	default 			{$listPre6 	= "pre6", 	"-resize 200 -trim", 						$OutputImagePre6, 	$ErrorImagePre6, 	$false}
}
# Examples for conversion parameters:
# no conversion at all:							""
# resize to width 800 pixel:					"-resize 800 -trim"
# resize to width 200 pixel:					"-resize 200 -trim"
# resize to height 800 pixel:					"-resize x800 -trim"
# resize to height 1200 pixel:					"-resize x1200 -trim"
# resize to maximum width or height 800 pixel:	"-resize 800x800 -trim"
# resize and normalize, adapt gamma:			"-resize 800 -trim -normalize -gamma 1.6"
# change quality and resize to 50%:				"-quality 35 -resize 50%"
#
# Settings for GFBio projects:
if ($ProjectName.StartsWith("GFBio"))
{
    $listWeb 	= "web", 	"-resize 800 -trim", 					$OutputImageWeb, 	$ErrorImageWeb, 	$true
    $listPre6 	= "pre6", 	"-resize 200 -trim", 					$OutputImagePre6, 	$ErrorImagePre6, 	$false
}
#
$listArrayConversionParams = $listWeb, $listPre6
#
# debug and verbose flags
#
$debug = $false
$verbose = $true
#
# return string (URI)
#
$global:returnString = ""
#
# define global variables
#
$global:RetVal = 0
$global:EmailMessage = ""
$global:Image_URI = ""
$global:BsmFileName    = ""
$global:BsmWebFileName = ""
$global:ExtendedName = ""
$global:SpecimenPartAccNum = ""
$global:exportfile = ""
$global:date = ((([System.DateTime]::Now).ToString()).SubString( 0, 10 )).Replace(".","_")
#
#
#========================================================================================
#
# Function definitions
#
#========================================================================================
#
# #######################################################################################
#
# Trace processing in Debug1.out file
#
# #######################################################################################

function Trace( [string] $Text )
{
	if( $trace -eq $true )
	{
		$t = ([System.DateTime]::Now).ToString()
		echo $t":  "$Text >> $global:traceFile
	}
}
	
#
# #######################################################################################
#
# List imported pictures in ListAddr.out file
#
# #######################################################################################

function ListAddr( [string] $Text )
{
	if( $listAddr -eq $true )
	{
		$t = ([System.DateTime]::Now).ToString()
		echo $t":  "$Text >> $listAddrFile
	}
}

# #######################################################################################
#
#	Processing image
#
# #######################################################################################

function ProcessImage( [string] $ImageFileName )
{
	Trace "------------------------------------------"
	Trace "...Start Process Image..."
	$script:ifn = $ImageFileName

	if( $verbose -eq $true )
	{
		Write-Output "`r`n"
		Write-Output "ProcessImage( $script:ifn )"
		Write-Output "`r`n"				
	}
	Write-Output "BsmFileName:    $global:BsmFileName"
	Write-Output "BsmWebFileName: $global:BsmWebFileName"
	
	$t = [System.DateTime]::Now
	$global:EmailMessage += "Time: $t`r`n"
	$global:EmailMessage += "Projekt: $ProjectName`r`n"
	$global:EmailMessage += "File: $ImageFileName`r`n"
	
	#
	# read exif info
	#
	if ( $READ_EXIF_INFO )
	{
		ReadExifInfo
	}
	#
	# check if image filename is accepted
	#
	CheckValidFileName $ImageFileName

	$global:EmailMessage += "BsmFileName: $global:BsmFileName`r`n"
	$global:EmailMessage += "BsmWebFileName: $global:BsmWebFileName`r`n" 

	#
	# create SQL accession number
	#
	$pos = $global:BsmFileName.IndexOf( '_' )
	# if ( $UPDATE_DATABASE_FLAG -and $pos -gt 0 )
	if ( $UPDATE_DATABASE_FLAG -and $pos -gt 0 )
	{
        if ($TrimAccNrToDigits -gt 0 -and $TrimAccNrToDigits -lt $pos)
        {
            $SQL_AccessionNumber = $global:BsmFileName.SubString( $pos - $TrimAccNrToDigits, $TrimAccNrToDigits )	
        }
        else
        {
		    $SQL_AccessionNumber = $global:BsmFileName.SubString( 0, $pos )	
        }
		$SQL_SpecimenPartAccessionNumber = $global:SpecimenPartAccNum
		#
		# Special treatment e.g. for JMEpiscescoll: cut tailing non digits from Accession number, if any
		#
		if ( $UseExtendedName )
		{
			$posext = $global:BsmFileName.LastIndexOf( $global:ExtendedName )
			if ( $posext -lt $pos )
			{
				if ( -not $UseExtendedAccNr)
				{
					$SQL_AccessionNumber = $global:BsmFileName.SubString( 0, $posext )
				}
			}
		}
	}

    $global:BsmFileName = $global:BsmFileName.Replace($BLANK,$MINUS)
    $global:BsmWebFileName = $global:BsmWebFileName.Replace($BLANK,$MINUS)
	
	$pos = 0
	for ( $i = 0; $i -lt $global:BsmFileName.Length; $i++ )
	{
		if ( [char]::IsDigit( $global:BsmFileName[$i] ) )
		{
			$pos = $i
			break;
		}
	}

    # If true, set fixed number of chars after last '-' for subdir name
   	if ($SubdirFixedLength)
    {
	    $subdir = $global:BsmFileName.Substring( 0, $global:BsmFileName.LastIndexOf( '-' ) + 1 + $SubdirNumDigits )
        # Set chars to lower case in num part
        $Len = $subdir.Length
        for ($ii = $SubdirNumDigits; $ii > 0; $ii--)
        {
            $subdir[$Len - $ii] = $subdir[$Len - $ii].ToLower()
        }
    }
    else
    {
	    $subdir = $global:BsmFileName.Substring( 0, $pos + $SubdirNumDigits )
    }

	if ($UseName)
	{
		$subdir = $MediaUserName
	}
	$outDir = "$global:FullImageBackupRootPath$global:DestinationSubdir/$subdir"
	$inFile  = "$FullImageImportPath/$ImageFileName"

	$outFile = "$outDir/$ImageFileName"

	$linkFile = "$outDir/$BSMFileName"
	
	if( $ArchiveOnImageStorage )
	{
		$outDir1 = "$global:FullImageBackupRootPath1$global:DestinationSubdir/$subdir"
		$outFile1 = "$outDir1/$ImageFileName"
		$linkFile1 = "$outDir1/$BSMFileName"
	}
	#
	# backup image file
	#
	if ( $BACKUP_ORIGINAL_FILES )
	{
		Trace "...Backup image file"
		
		#
		# create backup directory
		#
		CheckAndCreateDirectory $outDir 
	
		#
		# copy file to backup directory
		#
		
		# $scriptFileDir = "'$global:FullImageBackupRootPath/$subdir/$ImageFileName'"

		if ( $RENAME_ORIGINAL_FILES )
		{
			$global:EmailMessage += "copy file $inFile to backup directory $linkFile `r`n"
			# Check if file already exists
			if( $( Test-Path $linkFile ) )
			{
				# Error: File aready exists, do not overwrite it!
				Trace "-----> ERROR: $inFile already exists in backup directory $linkFile"
				$global:EmailMessage += "ERROR: $inFile already exists in backup directory $linkFile `r`n"
				$global:RetVal = 1
				SendErrorMessage $global:EmailMessage
			}
			else
			{		
				Copy-Item -Path "$inFile" -Destination "$linkFile"
				$scriptFileDir = "'$global:FullImageBackupRootPath$global:DestinationSubdir/$subdir/$BsmFileName'"
			}
			 
		}
		else
		{
			$global:EmailMessage += "copy file $inFile to backup directory $outFile `r`n"
			# Check if file already exists
			if( $( Test-Path $outFile ) )
			{
				# Error: File aready exists, do not overwrite it!
				$global:EmailMessage += "ERROR: $inFile already exists in backup directory $outFile `r`n"
			    $global:RetVal = 1
			    SendErrorMessage $global:EmailMessage
			}
			else
			{		
				Copy-Item -Path "$inFile" -Destination "$outFile"
			}
			$scriptFileDir = "'$global:FullImageBackupRootPath$global:DestinationSubdir/$subdir/$OriginalFileName'"
		}
		
		if( ! $? )
		{
            $global:returnString = "ERROR 02"
			$global:RetVal = 1
			SendErrorMessage $global:EmailMessage
		}	
		
		# Archive on ImageStorage:
		if( $ArchiveOnImageStorage )
		{
			# create backup directory
			CheckAndCreateDirectory $outDir1 
			# copy file to backup directory
			
			if ( $RENAME_ORIGINAL_FILES )
			{
				$global:EmailMessage += "copy file $inFile to backup directory $linkFile1 `r`n"
				# Check if file already exists
				if( $( Test-Path $linkFile1 ) )
				{
					# Error: File aready exists, do not overwrite it!
					$global:EmailMessage += "ERROR: $inFile already exists in backup directory $linkFile1 `r`n"
			        $global:RetVal = 1
			        SendErrorMessage $global:EmailMessage
				}
				else
				{		
					Copy-Item -Path "$inFile" -Destination "$linkFile1"
					# $scriptFileDir = "'$global:FullImageBackupRootPath/$subdir/$BsmFileName'"
				}
			}
			else
			{
				$global:EmailMessage += "copy file $inFile to backup directory $outFile1 `r`n"
				# Check if file already exists
				if( $( Test-Path $outFile1 ) )
				{
					# Error: File aready exists, do not overwrite it!
					$global:EmailMessage += "ERROR: $inFile already exists in backup directory $outFile1 `r`n"
			        $global:RetVal = 1
			        SendErrorMessage $global:EmailMessage
				}
				else
				{		
					Copy-Item -Path "$inFile" -Destination "$outFile1"
					# $scriptFileDir = "'$global:FullImageBackupRootPath/$subdir/$OriginalFileName'"
				}
			}

			if( ! $? )
			{
                $global:returnString = "ERROR 06"
                $global:RetVal = 1
				SendErrorMessage $global:EmailMessage
			}	
		}
		#
		# write entry into backup script file
		#
		if ($BACKUP_ORIGINAL_FILES)
        {
	        # write "cd"-line only once at the beginning of the script
	        if( -not $( Test-Path "$global:BackupScriptFileName" -PathType Leaf ) )
	        {
		        Write-Output "cd $BACKUP_PROG_DIR" >> $global:BackupScriptFileName
	        }
        }
        #
		$outline = "Start-Process $BACKUP_PROG_EXE $BACKUP_ARGS_EXE" + $scriptFileDir.Replace( '/' , '\'  ) + "`""
		try
		{
			Write-Output  $outline >> $global:BackupScriptFileName
		}
		catch
		{
			$t2 = $UNDERSCORE + ([System.DateTime]::Now).ToString().Replace(".", "").Replace(":", "").Replace(" ","_");
			$global:BackupScriptFileNameTimestamp = $global:BackupScriptFileName + $t2 + ".txt"
			Write-Output  $outline >> $global:BackupScriptFileNameTimestamp
		}
	}
	
	
	#
	# symbolic links script
	#
	if ( $CREATE_SYMBOLIC_LINKS )
	{
		Trace "...Create symbolic links"
		#
		# write entry into symbolic links script file
		#
		# Windows symbolic links:
		# $outline = "mklink $linkFile $outFile"
		# $outline = "Start-Process cmd -NoNewWindow -Wait -Verbose -ArgumentList `"/c " + $outline.Replace( '/' , '\'  ) + "`""
		# Create table for symbolic links:
		if ( $RENAME_ORIGINAL_FILES )
		{
			# Original file has been renamed: Link is original file name, points to converted file name
			$outline = "$BackupRootDir	$subdir	$BsmFileName	$OriginalFileName"
		}
		else
		{
			# Link is converted file name, points to original file name
			$outline = "$BackupRootDir	$subdir $OriginalFileName	$BsmFileName"
		}
		# $outline = "Start-Process C:\cygwin\bin\ln.exe -NoNewWindow -Wait -Verbose -ArgumentList `"-s " + $outline.Replace( '/' , '\'  ) + "`""
		$global:EmailMessage += "Build LinkScriptEntry: $outline`r`n"
		Write-Output "$outline" >> $global:LinkScriptFileName	
		
		if( $ArchiveOnImageStorage )
		{
			# Linux symbolic links:
			# $outline = "$outFile1 $linkFile1"
			# $outline = "Start-Process C:\cygwin\bin\ln.exe -NoNewWindow -Wait -Verbose -ArgumentList `"-s " + $outline.Replace( '/' , '\'  ) + "`""
			
			$global:EmailMessage += "Build LinkScriptEntry: $outline`r`n"
			Write-Output "$outline" >> $global:LinkScriptFileName1	
		}

	}
	
	#
	# convert images to web/preview files
	#
	ForEach ( $paramsList in $listArrayConversionParams )
	{
		Trace "...Image conversion"
		# image conversion
		ConvertImage $paramsList

		# transfer webfiles to remote host
		if( $TRANSFER_TO_WEB_SERVER_FLAG )
		{
			Trace "...Transfer webfiles"
			TransferFilesToWebServer $global:exportfile
		}
		
		# create URI
		MakeUri $global:exportfile
		if ( $paramsList[4] )
		{
			$global:returnString = $global:Image_URI
			ListAddr $global:returnString
		}

		# compare source and target files
		if ( $CHECK_WEB_SERVER_FILE_FLAG )
		{
			Trace "...Check webserver file"
			CheckAndCompareWebServerImage $global:exportfile
		}
		
		# audio file, just process once
		if ( -not $global:DoImageConversion )
		{
			break
		}
	}
	
	# database update
	if( $UPDATE_DATABASE_FLAG )
	{
		Trace "...Update database"
		Write-Output "Update database ...."
		SqlCommands $SQL_AccessionNumber $global:returnString $SQL_SpecimenPartAccessionNumber
	}
 

	# remove image from processing directory
	# if ( $REMOVE_IMAGE_FROM_PROCESSING_DIR_FLAG )
	# {
	# 	Remove-Item -Path "$FullImageProcessingPath/$ImageFileName"	
	# }	
}

# #######################################################################################
#
# Check for Directory and create it if not available
#
# #######################################################################################

function CheckAndCreateDirectory( [string] $path )
{
	$script:mypath = $path
	
	if( $verbose -eq $true )
	{
		Write-Output "`r`nFunction: CheckAndCreateDirectory( $path )"
		Write-Output "`r`n"
	}
	
	if( $( Test-Path $path ) )
	{
		Write-Output "Is ok: $path"
	}
	else
	{
		Write-Output "Create path: $path"
	
		$dirs = @()
		While( !(Test-Path $mypath) -and ($mypath.Length -gt 0) )
		{
			$dirs += $mypath
			$mypath = Split-Path $mypath
		}
		[array]::Reverse( $dirs )
		ForEach( $i in $dirs )
		{
			Write-Output "Create new dir: $i"
			New-Item  $i -type directory
		}
		if( $( Test-Path $path ) )
		{
			Write-Output "successfull creating directory: $path"
			$global:RetVal = 0
		}
		else
		{
			Write-Output "Error while creating directory: $path"
			$global:RetVal = 1
			$global:returnString = "ERROR 07"
			SendErrorMessage $global:EmailMessage
		}	
	}	
}

# #######################################################################################
#
#	Check for exec file
#
# #######################################################################################

function CheckExecFile( [string] $path )
{
	$script:mypath = $path
	
	if( $verbose -eq $true )
	{
		Write-Output "`r`nFunction: CheckExecFile( $path )"
		Write-Output "`r`n"
	}
	if( $( Test-Path $path -PathType Leaf ) )
	{
		Write-Output "Is ok: $path"
		$global:RetVal = 0
	}
	else
	{
		Write-Output "Not found: $path"
		$global:RetVal = 1
		$global:returnString = "ERROR 08"
		$global:EmailMessage += "Function: CheckExecFile( $path )`r`n" + "Not found: $path`r`n"
	    SendErrorMessage $global:EmailMessage
	}	
}


# #######################################################################################
#
#	Check for valid input filename
#
# #######################################################################################

function CheckValidFileName( [string] $MyOriginalFileName )
{

	# e.g.:
	# $MyOriginalFileName = "TST000100.tif"
	# $MyOriginalFileName = "TST-000100_20061011_130243.tif"
	# $MyOriginalFileName = "4FB46D30-2F6D-DE11-871C-001EC9D7AE4B.jpg"	
	# $MyOriginalFileName = "M-030327_001.tif"
	# $MyOriginalFileName = "JE_030327_1400.tif"
	#
	# Type 1:
	# 1. Scan characters 	--> ID
	# 2. Scan numbers		--> Number
	# 3. Scan rest			--> Ignore
	# --> TST-000100_<date>_<time>.jpg
	#
	# Type 2:
	# 1. Split into <name>-<number>_<date>_<time>
	# 2. Check consistency (<time> 6 digits, <date> 8 digits, <name> letters, <number> digits)
	# --> M-12345_<date>_<time>.jpg
	# 
	# Type 3:
	# 1. Check GUID format
	# --> 4FB46D30-2F6D-DE11-871C-001EC9D7AE4B.jpg
	#
	# NOTE: The directory 'ImageStorage' is redirected to an IP address with in the hosts file, e. g. 
	# C:\Windows\System32\drivers\etc\hosts
	#     111.222.33.44 	ImageStorage
	# This is useful to avoid an IP address in the archive script and to use the same archive directory for different servers
	#
	#
	$fileString = $MyOriginalFileName
	#
	# check for correct extension
	# set file extension specific parameters
	#	
	$ind1  = $fileString.LastIndexOf( '.' )
	$global:extString = $fileString.SubString( $ind1 )
	$global:extString = $global:extString.ToLower()
	
	if ( $global:extString -eq ".tif" -or $global:extString -eq ".tiff" -or  $global:extString -eq ".jpg" -or  $global:extString -eq ".png" )
	{
		$global:DoImageConversion = $IMAGE_CONVERSION_FLAG
		$global:webExtString = ".jpg"
		$global:WebServerRootPath 	= '//ImageStorage/SnsbPictures'
		$global:IsMediaFile = $false
	}
	elseif ( $global:extString -eq ".wav" -or $global:extString -eq ".mp3" -or $global:extString -eq ".mp4" )
	{
		$global:DoImageConversion = $false
		$global:webExtString = $global:extString
		$global:WebServerRootPath 	= '//ImageStorage/SnsbMedia'
		$global:IsMediaFile = $true
	}
	elseif ( $global:extString -eq ".tifw" -or $global:extString -eq ".txt" -or $global:extString -eq ".eip" -or $global:extString -eq ".dng" -or $global:extString -eq ".nef" -or $global:extString -eq ".shp2" -or $global:extString -eq ".xml" )
	{
		$global:DoImageConversion = $false
		$global:webExtString = $global:extString
		$global:WebServerRootPath 	= '//ImageStorage/SnsbPictures'
		$global:IsMediaFile = $false
	}
	else
	{
		$global:RetVal = 1
		$global:returnString = "ERROR 09"
		$global:EmailMessage += "Function: CheckValidFileName( $MyOriginalFileName )`r`nError: Invalid file extension`r`n"
		Write-Output "Function: CheckValidFileName( $MyOriginalFileName )`r`nError: Invalid file extension`r`n"
		SendErrorMessage $global:EmailMessage
	}
	
	$global:DestinationSubdir = ""
    $global:ArchiveDir = "Archive"
	if ( $global:extString -eq ".eip" )
	{
		# $global:DestinationSubdir = "/EIP"
        $global:ArchiveDir = "ArchiveEIP"
	}
		
	if ( $global:extString -eq ".dng" -or $global:extString -eq ".nef" )
	{
		# $global:DestinationSubdir = "/DNG"
		$global:ArchiveDir = "ArchiveDNG"
	}

    # Set path for backup file according to ArchiveDir
    $global:FullImageBackupRootPath 	= $ArchiveDrive + "$global:ArchiveDir/Pictures/Original/$BackupRootDir"
	if( $ArchiveOnImageStorage )
	{
		$global:FullImageBackupRootPath1 	= "//$global:ServerIP/$global:ArchiveDir/Pictures/Original/$BackupRootDir"
		$global:LinkScriptFileName1		= $global:FullImageBackupRootPath1 + "/" + $BackupRootDir + $UNDERSCORE + "CreateSymLinks_" + $global:date + ".txt"
	}
	# Set path within backup script file (long term archive at LRZ)
	$global:LinkScriptFileName			= $global:FullImageBackupRootPath + "/" + $BackupRootDir + $UNDERSCORE + "CreateSymLinks_" + $global:date + ".txt"
	$global:BackupScriptFileName		= $global:FullImageBackupRootPath + "/" + $BackupRootDir + $UNDERSCORE + "Archive.ps1"
		
	$fileString = $fileString.SubString( 0, $ind1 )
	#
	$type = 0

	#	
	# check for type 3 (GUID z.B. 4FB46D30-2F6D-DE11-871C-001EC9D7AE4B.jpg)
	#
	if ( $fileString.Length -eq 36 )
	{
		$type = 3
		for ( $i1 = 0; $i1 -lt 36; $i1++ )
		{
			if ( $i1 -eq 8 -or $i1 -eq 13 -or $i1 -eq 18 -or $i1 -eq 23 )
			{
				if ( $fileString[$i1] -ne '-' )
				{
					$type = 0
					break
				}
			}
			else 
			{
				if (( -not [char]::IsLetter( $fileString[$i1] )) -and ( -not [char]::IsDigit( $fileString[$i1] )))
				{
					$type = 0
					break
				}
			}
		}
	}
	#
	# check for type 2 (ABC-123456_<date>_<time>.tif*
	#
	# $MyOriginalFileName = "M-0155684_20091211_112741.tif"
	#                        01234567890123456789012345678
	if ( $type -eq 0 )
	{
		#
		# get substrings name, number, date, time
		#
		$ind1 = $fileString.LastIndexOf( '_' )
		if ($ind1 -ge 12)
		{
			$strTime = $fileString.SubString($ind1+1)
			$ind2 = $fileString.IndexOf( '_' )
			if ($ind2 -ge 3 -and ($ind1-$ind2) -ge 9)
			{
				$strDate = $fileString.SubString($ind2+1, $ind1-$ind2-1)
				$ind3 = $fileString.IndexOf( '-' )
				if ($ind3 -ge 1 -and ($ind2-$ind3) -ge 2)
				{
					$strNum = $fileString.SubString($ind3+1, $ind2-$ind3-1)
					$strName = $fileString.SubString(0, $ind3)
					#
					# check length of substrings
					#
					if (($strTime.Length -eq 6) -and ($strDate.Length -eq 8) -and ($strNum.Length -ge 1) -and ($strName.Length -ge 1))
					{
						#
						# check consistency of substrings
						#
						if ((CheckLetters $strName) -and (CheckDigits $strNum) -and (CheckDigits $strDate) -and (CheckDigits $strTime))
						{
							$type = 2
						}
					}
				}
			}
		}
	}
	#
	# check for type 1 (TUB123456*.*)
	#
	if ( $type -eq 0 )
	{
		$type = 1
		$global:ExtendedName = ""
		$k = 0
		for ( $i1 = 0; $i1 -lt $fileString.Length; $i1++ )
		{
			# check for leading letters or Minus chars
			if ( -not [char]::IsLetter( $fileString[$i1] ) -and $fileString[$i1] -ne $MINUS -and $fileString[$i1] -ne $UNDERSCORE -and $fileString[$i1] -ne $BLANK)
			{
				# check for no letter at all --> error
				if ( $i1 -eq 0 )
				{
					$type = 0
				}
				else
				{
					# check for following digits, underscore, minus
					$strName = $fileString.SubString(0, $i1)
					#
					# ignore one Underscore
					#
					if ($fileString[$i1] -eq $UNDERSCORE -and $i1 -lt ($fileString.Length - 1))
					{
						$i1++
					}
					
					# Check for SpecimenPart-AccessionNumber
					$SPIndex1 = $fileString.IndexOf( '(' )
					$SPIndex2 = $fileString.IndexOf( ')' )
					if ( $SPIndex2 - $SPIndex1 -gt 1 )
					{
						$global:SpecimenPartAccNum = $fileString.SubString($SPIndex1 + 1, $SPIndex2 - $SPIndex1 - 1)
					}
					else
					{
						$global:SpecimenPartAccNum = ""
					}
					
					# for ( $i2 = $i1; $i2 -lt $fileString.Length; $i2++ )
					# skip after $maxDigits digits!
					for ( $i2 = $i1; $i2 -lt $i1 + $maxDigits -and $i2 -lt $fileString.Length; $i2++ )
					{
						# check for following non digit --> finished
						if ( -not [char]::IsDigit( $fileString[$i2] ) -and ($fileString[$i2] -ne '-'))
						{
							# check for no digits after leading letters --> error
							if ( $i2 -eq $i1 )
							{
								$type = 0
							}
							#
							# Special treatment e.g. for JMEpiscescoll: allow all following characters until underscore
							#
							if ( $UseExtendedName )
							{
								for ( ; $i2 -lt $fileString.Length; $i2++ )
								{
									if ( $fileString[$i2] -eq $UNDERSCORE)
									{
										break
									}
									try
									{
										$global:ExtendedName += $fileString[$i2]
										$k++
									}
									catch
									{
										$message = $_.Exception.GetType().FullName + ": " + $_.Exception.Message
										$type = 0
										break
									}
								}
							}
							break
						}
					}
					if ($type -eq 1)
					{
						$strNum = $fileString.SubString($i1, $i2-$i1)
					}
					break
				}
			}
		}	
		
		if ( $type -eq 1 )
		{
			$tt1 = $FullImageImportPath
			$tt2 = $OriginalFileName
			$i = get-childitem "$FullImageImportPath/$OriginalFileName"
			#
			# get file timestamp
			#
			$day    = $i.LastWriteTime.day
			$month  = $i.LastWriteTime.month
			$year   = $i.LastWriteTime.year
			$hour   = $i.LastWriteTime.hour
			$minute = $i.LastWriteTime.minute
			$second = $i.LastWriteTime.second
			#
			# format timestamp
			#
			if( "$day".Length -eq 1 ) 		{ $day = "0$day" }
			if( "$month".Length -eq 1 ) 	{ $month = "0$month" }
			if( "$hour".Length -eq 1 ) 		{ $hour = "0$hour" }
			if( "$minute".Length -eq 1 ) 	{ $minute = "0$minute" }
			if( "$second".Length -eq 1 ) 	{ $second = "0$second" }
			
			if ($global:ExifCreateDate -ne "")
			{
				$TimeStamp = $global:ExifCreateDate
			}
			else
			{		
				$TimeStamp = "$year$month$day$UNDERSCORE$hour$minute$second"
			}
			
            if ($ConvertToUpperCase)
            {
			    $strName = $strName.ToUpper()
            }
		}
	}
	if ( $type -eq 0 )
	{
		$type = 4
		for ( $i1 = 0; $i1 -lt $fileString.Length; $i1++ )
		{
			if ( -not ( [char]::IsLetter( $fileString[$i1] ) -or $fileString[$i1] -eq $MINUS ))
			{
				if ( $i1 -eq 0 )
				{
					$type = 0
				}
				else
				{
					$strName = $fileString.SubString(0, $i1)
					# for ( $i2 = $i1; $i2 -lt $fileString.Length; $i2++ )
					# skip after 7 digits!
					for ( $i2 = $i1; $i2 -lt $i1 + $maxDigits; $i2++ )
					{
						if ( -not [char]::IsDigit( $fileString[$i2] ))
						{
							if ( $i2 -eq $i1 )
							{
								$type = 0
							}
							break
						}
					}
					if ($type -eq 4)
					{
						$strNum = $fileString.SubString($i1, $i2-$i1)
					}
					break
				}
			}
		}	
		
		if ( $type -eq 4 )
		{
			$i = get-childitem "$FullImageImportPath/$OriginalFileName"
			#
			# get file timestamp
			#
			$day    = $i.LastWriteTime.day
			$month  = $i.LastWriteTime.month
			$year   = $i.LastWriteTime.year
			$hour   = $i.LastWriteTime.hour
			$minute = $i.LastWriteTime.minute
			$second = $i.LastWriteTime.second
			
			#
			# format timestamp
			#
			if( "$day".Length -eq 1 ) 		{ $day = "0$day" }
			if( "$month".Length -eq 1 ) 	{ $month = "0$month" }
			if( "$hour".Length -eq 1 ) 		{ $hour = "0$hour" }
			if( "$minute".Length -eq 1 ) 	{ $minute = "0$minute" }
			if( "$second".Length -eq 1 ) 	{ $second = "0$second" }
		
			if ($global:ExifCreateDate -ne "")
			{
				$TimeStamp = $global:ExifCreateDate
			}
			else
			{		
				$TimeStamp = "$year$month$day$UNDERSCORE$hour$minute$second"
			}

            if ($ConvertToUpperCase)
            {
			    $strName = $strName.ToUpper()
            }
		}
	}
	
    if ($ConvertToUpperCase)
    {
	    $fileString = $fileString.ToUpper()
	}

	#
	# create target filenames (backup, web)
	#
	if ( $type -eq 1 )
	{
		# add Minus if necessary
		if ( $InsertMinus -and -not $UseExtendedName -and $strName[$strName.Length - 1] -ne '-' )
		{
			$strName += '-'
		}
		# set name to correct format
		$global:BsmFileName    = "$strName$strNum$UNDERSCORE$TimeStamp$global:extString"
		$global:BsmWebFileName = "$strName$strNum$UNDERSCORE$TimeStamp$global:webExtString"
	}
	elseif ( $type -eq 4 )
	{
		# set name to correct format
		$global:BsmFileName    = "$strName$strNum$UNDERSCORE$TimeStamp$global:extString"
		$global:BsmWebFileName = "$strName$strNum$UNDERSCORE$TimeStamp$global:webExtString"
	}
	elseif ( $type -eq 2 )
	{
		# name is already in the right format
		$global:BsmFileName    = "$fileString$global:extString"
		$global:BsmWebFileName = "$fileString$global:webExtString"
	}
	elseif ( $type -eq 3 )
	{
		# create name from GUID, already a unique name
		$global:BsmFileName    = "$fileString$global:extString"
		$global:BsmWebFileName = "$fileString$global:webExtString"
		# do we need an image conversion in this case?
	}
	else
	{
		$global:RetVal = 1
		$global:returnString = "ERROR 11"
		$global:EmailMessage += "Function: CheckValidFileName( $MyOriginalFileName )`r`nError: Filename has invalid format`r`n"
		Write-Output "Function: CheckValidFileName( $MyOriginalFileName )`r`nError: Filename has invalid format`r`n"
	    SendErrorMessage $global:EmailMessage
	}
		
	if( $verbose -eq $true )
	{
		Write-Output "BsmFileName: $global:BsmFileName"
		Write-Output "BsmWebFileName: $global:BsmWebFileName"
	}	
}

# #######################################################################################
#
#	Check letter string
#
# #######################################################################################
function CheckLetters( [string] $inputString )
{
	for ( $i1 = 0; $i1 -lt $inputString.Length; $i1++ )
	{
		if ( -not [char]::IsLetter( $inputString[$i1] ))
		{
			return $false
		}
	}
	return $true
}
# #######################################################################################
#
#	Check number string
#
# #######################################################################################
function CheckDigits( [string] $inputString )
{
	for ( $i1 = 0; $i1 -lt $inputString.Length; $i1++ )
	{
		if ( -not [char]::IsDigit( $inputString[$i1] ))
		{
			return $false
		}
	}
	return $true
}


# #######################################################################################
#
#	Convert original image according conversion parameters to target directory
#
# #######################################################################################
function ConvertImage( [array] $ConversionParameters )
{
	#
	# set parameters
	#	
	$conversionDir 		= "$FullImageProcessingPath/" + $ConversionParameters[0] + "/$subdir"
	$global:exportfile	= "$conversionDir/$global:BsmWebFileName"	
	$webfile    		= $ConversionParameters[0] + "/$subdir/$global:BsmWebFileName"
	$imageMagicParams 	= "`"$ImageFileName`" " + $ConversionParameters[1] + " $global:exportfile"
	$stdout 			= "$FullImageProcessingPath/" + $ConversionParameters[2]
	$stderr 			= "$FullImageProcessingPath/" + $ConversionParameters[3]	
	#
	# create target directory
	#
    if ( $JustReturnTargetPath )
    {
        return
    }

    CheckAndCreateDirectory $conversionDir 

	if ( $global:DoImageConversion )
	{
		$global:EmailMessage += "ImageMagic: $imageMagicParams`r`n"			
		#
		# remove old output/error files
		#
		RemoveOutputFiles
		#
		# start conversion program
		#
		Start-Process -FilePath $CONVERT_PROG_EXE -Wait -NoNewWindow -WorkingDirectory $FullImageImportPath -RedirectStandardError $stderr -RedirectStandardOutput $stdout -ArgumentList $imageMagicParams
		$global:EmailMessage += "...done`r`n"
		#
		# check result
		#
		CheckFunctionError "Convert image to Web file" $stderr $stdout ""
		#
		# check if converted file has been created
		#	
	}
	else
	{
	  	#
		# just copy file to conversion dir
		#
	    Copy-Item -Path "$FullImageImportPath/$ImageFileName" -Destination "$global:exportfile"
	}
	if( ! $( Test-Path $global:exportfile -PathType Leaf ) )
	{
		Write-Output "Not found: $global:exportfile"
		$global:EmailMessage += "$CONVERT_PROG_EXE`r`n"
		$global:EmailMessage += "exportfile:       $global:exportfile`r`n"
		$global:EmailMessage += "webfile:    	   $webfile`r`n"
		$global:EmailMessage += "ImageMagicParams: $imageMagicParams`r`n"
		$global:RetVal = 1
		$global:returnString = "ERROR 15"
		SendErrorMessage $global:EmailMessage
	}	
}


# #######################################################################################
#
# Read Exif-Info from image file
#
# #######################################################################################
function ReadExifInfo
{
	$ExifToolParams 	= " -X `"$ImageFileName`""
	$stdout 			= "$FullImageProcessingPath/" + $OutputExifInfo
	$stderr 			= "$FullImageProcessingPath/" + $ErrorExifInfo 	
	$global:ExifInfoStr = " "
	$global:SQL_Description = " "
	$global:ExifCreateDate = ""
	
	#
	#$global:EmailMessage += "ExifTool: $ExifToolParams`r`n"	
	#
	if ( $READ_EXIF_INFO )
	{
		#
		# remove old output/error files
		#
		RemoveOutputFiles
		#
		# start exiftool program
		#
		Start-Process -FilePath $EXIF_PROG_EXE -Wait -NoNewWindow -WorkingDirectory $FullImageImportPath -RedirectStandardError $stderr -RedirectStandardOutput $stdout -ArgumentList $ExifToolParams
		#
		# check result?	
		# CheckFunctionError "Read exif info" $stderr $stdout ""
		#
		if( $( Test-Path "$stdout" -PathType Leaf ) )
		{
			$testout = Get-Content $stdout
			if ( $testout.Length -gt 0 )
			{
				#
				# Read Exif Info successful
				#
				$testout[0] = ""
				$global:ExifInfoStr = [string] $testout
				#
				# Trace $global:ExifInfoStr
				#
				$global:SQL_Description = $global:ExifInfoStr.Replace("'", "''")

                #
                # Truncate EXIF string if it is too long for sqlcmd arguments!! 
                #
                if ($TruncateExifData)
                {
                    $index = $global:SQL_Description.IndexOf("<ICC_Profile:Technology>")
                    if ($index -gt 0)
                    {
                        $tempStr = $global:SQL_Description.Substring(0,$index)
                        $global:SQL_Description = $tempStr + "</rdf:Description></rdf:RDF>"
                    }
                }
				
				#
				# Extract date time  "<ExifIFD:CreateDate>2013:08:14 00:16:23"
				#
				$searchstring = ":CreateDate>"
				$dateindex = $global:ExifInfoStr.IndexOf($searchstring)
				$datestring1 = $global:ExifInfoStr.SubString($dateindex + $searchstring.Length, 19)
				# $datestring2 = $datestring.SubString($datestring, 19)
				$datestring2 = $datestring1.Replace(" ", "_")
				$datestring3 = $datestring2.Replace(":", "")
				#
				# check consistency of timestamp
				#
				if ($datestring3.Length -ne 15)
				{
					#
					# Check for "<IFD0:ModifyDate>2004:03:08 11:40:15"
					#
					$searchstring = ":ModifyDate>"
					$dateindex = $global:ExifInfoStr.IndexOf($searchstring)
					$datestring1 = $global:ExifInfoStr.SubString($dateindex + $searchstring.Length, 19)
					# $datestring2 = $datestring.SubString($datestring, 19)
					$datestring2 = $datestring1.Replace(" ", "_")
					#
					# check for reduced month and day:  "<IFD0:ModifyDate>2004:3:8 11:40:15"
					#
					if ($datestring2[6] -eq ':')
					{
						$datestring2a = $datestring2.SubString(0, 5) + "0" + $datestring2.SubString(5, 13)
						$datestring2 = $datestring2a
					}
					if ($datestring2[9] -eq '_')
					{
						$datestring2a = $datestring2.SubString(0, 8) + "0" + $datestring2.SubString(8, 10)
						$datestring2 = $datestring2a
					}
					if ($datestring2[12] -eq ':')
					{
						$datestring2a = $datestring2.SubString(0, 11) + "0" + $datestring2.SubString(11, 7)
						$datestring2 = $datestring2a
					}
					if ($datestring2[15] -eq ':')
					{
						$datestring2a = $datestring2.SubString(0, 14) + "0" + $datestring2.SubString(14, 4)
						$datestring2 = $datestring2a
					}
					if ($datestring2[18] -eq '<')
					{
						$datestring2a = $datestring2.SubString(0, 17) + "0" + $datestring2.SubString(17, 1)
						$datestring2 = $datestring2a
					}
										
					$datestring3 = $datestring2.Replace(":", "")
					if ($datestring3.Length -ne 15)
					{
						return
					}
				}				
				for ( $ii = 0; $ii -lt $datestring3.Length; $ii++ )
				{
					$ch = $datestring3[$ii]
					if ( -not [char]::IsDigit( $ch ) )
					{
						if ($ch -ne '_')
						{
							return
						}
						if ($ii -ne 8)
						{
							return
						}
					}
				}
				# use EXIF info time stamp for file rename
				if ($UseExifCreateDate)
				{
					$global:ExifCreateDate = $datestring3
				}
				
				$outdtstr = "... EXIF INFO DATE_TIME: " + $global:ExifCreateDate
				Trace $outdtstr
			}
		}
	}

}

# #######################################################################################
#
# Remove stdout and stderr files before starting a process
#
# #######################################################################################
function RemoveOutputFiles
{
	if( $( Test-Path "$stdout" -PathType Leaf ) )
	{
		Remove-Item -Path $stdout
	}
	if( $( Test-Path "$stderr" -PathType Leaf ) )
	{
		Remove-Item -Path $stderr
	}
}


# #######################################################################################
#
# Remove communication files if process has been successful
#
# #######################################################################################
function RemoveCommunicationFiles
{
	if( $( Test-Path "$OutputSsh" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputSsh
	} 		
	if( $( Test-Path "$ErrorSsh" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorSsh
	}		
	if( $( Test-Path "$OutputScp" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputScp
	}		
	if( $( Test-Path "$ErrorScp" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorScp
	} 	
	if( $( Test-Path "$OutputWget" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputWget
	} 		
	if( $( Test-Path "$ErrorWget" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorWget
	} 	
	if( $( Test-Path "$OutputDiff" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputDiff
	} 		
	if( $( Test-Path "$ErrorDiff" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorDiff
	} 	
	if( $( Test-Path "$OutputSqlDir" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputSqlDir
	} 	
	if( $( Test-Path "$ErrorSqlDir" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorSqlDir
	}
	if( $( Test-Path "$ErrorSql" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorSql
	}
	if( $( Test-Path "$OutputSql" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputSql
	}
	if( $( Test-Path "$OutputImageWebPath" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputImageWebPath
	}
	if( $( Test-Path "$OutputImagePre6Path" -PathType Leaf ) )
	{
		Remove-Item -Path $OutputImagePre6Path
	} 	
	if( $( Test-Path "$ErrorImageWebPath" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorImageWebPath
	} 	
	if( $( Test-Path "$ErrorImagePre6Path" -PathType Leaf ) )
	{
		Remove-Item -Path $ErrorImagePre6Path
	}
}
	
# #######################################################################################
#
# Check content of function error file
#
# #######################################################################################
function CheckFunctionError( [string] $caller, [string] $stderr, [string] $stdout, [string] $content )
{
 	$global:EmailMessage += $caller + ":`r`n"
		
	#
	# check stderr file
	#
	if( $( Test-Path "$stderr" -PathType Leaf ) )
	{
		$testerr = Get-Content $stderr
		[string] $s = $testerr
		
		if( $s.Length -gt 0 )
		{
			if ( $stderr.Contains( "error.img" ))
			{
				if ($Projectname -eq "TUBafrplantscoll" -or $Projectname -eq "TUBvplantscoll" -or $Projectname -eq "HOHafrplantscoll"  -or $Projectname -eq "BSMvplantscoll" -or $Projectname -eq "REGafrplantscoll")
				{
					for ( $ii = 0; $ii -lt $testerr.Length; $ii++ )
					{
						if ( $testerr[$ii].Contains( "tif: wrong data type 9 for" ) -and $ii -lt 6 )
						{
							continue
						}
						if ( $testerr[$ii].Contains( "tif: invalid TIFF directory; tags are not sorted in ascending order." ) -and $ii -lt 6 )
						{
							continue
						}
						if ( $testerr[$ii].StartsWith( "convert.exe: incorrect count for field" ) -and $ii -lt 2 )
						{
							continue
						}
						if ( $testerr[$ii].StartsWith( "convert.exe: Unknown field" ) -and $ii -lt 2 )
						{
							continue
						}
						if ( $testerr[$ii].StartsWith( "convert.exe: Unknown field" ) -and $ii -lt 4 )
						{
							continue
						}
						if ( $testerr[$ii].StartsWith( "convert.exe: Wrong data type" ) -and $ii -lt 6 )
						{
							continue
						}
						if ( $testerr[$ii].StartsWith( "convert.exe: Incompatible type" ) -and $ii -lt 8 )
						{
							continue
						}
						$global:EmailMessage += $s + "`r`n"
						$global:RetVal = 1		
						$global:returnString = "ERROR 16"
						SendErrorMessage $global:EmailMessage 
					}
				}
			}			
			else
			{	
				$global:EmailMessage += $s + "`r`n"
				$global:RetVal = 1		
				$global:returnString = "ERROR 17"
				SendErrorMessage $global:EmailMessage 
			}
		}
		
		# moved to this place: Could happen without error content!!
		if ($global:exportfile -ne "")
		{
			$delfile = $global:exportfile.SubString( 0 , $global:exportfile.Length - 4 ) + "-1.jpg" 
			if ( $( Test-Path $delfile -PathType Leaf ))					
			{
				Remove-Item $delfile		
			}
			
			$renfile = $global:exportfile.SubString( 0 , $global:exportfile.Length - 4 ) + "-0.jpg" 				
			if ( $( Test-Path $renfile -PathType Leaf ))					
			{
				if ( $( Test-Path $global:exportfile -PathType Leaf ))
				{
					Remove-Item $global:exportfile
				}
				Rename-Item $renfile $global:BsmWebFileName
			}
		}
	}
	#
	# check stdout file
	#
	if( $( Test-Path "$stdout" -PathType Leaf ) )
	{
		$testout = Get-Content $stdout
		[string] $s = $testout
		
		if( $content.Length -eq 0 -and $s.Length -gt 0)
		{
			Write-Output "ERROR: $caller" 
			SendErrorMessage $global:EmailMessage 
		}
		
		#
		# Preset index by 0. Calling the IndexOf() function throws an exception, if $content is empty string.
		# Curious: The exception is thrown only, if script is called from text-based Service.
		# Same code, same parameters from Mtom-Service: IndexOf() function returns valid value 0. ???????
		#
		$index = 0
		if ( $content.Length -gt 0 )
		{
			$index = $s.IndexOf( $content )	
		}
		# $index = $s.IndexOf( $content )	
		
		if ( $index -lt 0 )
		{
			$global:EmailMessage += $s + "`r`n"
			$global:RetVal = 1
			$global:returnString = "ERROR 18"
			Write-Output "ERROR: $caller" 
			SendErrorMessage $global:EmailMessage 
		}
		
		#
		# read project directory
		#
		if ( $stdout.Contains( "output.sqldir" ))
		{
			$index = $s.LastIndexOf( $content )
			$dirStr = $s.SubString( $Index + 2 )
			$index2 = $dirStr.IndexOf( ' ' )
			if ( $index -lt 0 )
			{
				$global:EmailMessage += "Could not evaluate project name from string: " + $dirStr + "`r`n"
				$global:RetVal = 1
			    $global:returnString = "ERROR 19"
				Write-Output "ERROR: $caller" 
				SendErrorMessage $global:EmailMessage 
			}
			$global:SQL_ProjectID = $dirStr.SubString( 0, $index2 )
			Write-Output "Project name: $dirStr"
	 	}
	}
	else
	{
		if ( $content -ne "" )
		{
			SendErrorMessage $global:EmailMessage 
		}
	}
}

# #######################################################################################
#
# Transfer image data to WEB-Server
#
# #######################################################################################
function TransferFilesToWebServer( [string] $ScpFile )
{
	if( $verbose -eq $true )
	{
		Write-Output "`r`n"
		Write-Output "TransferFilesToWebServer( )"
		Write-Output "`r`n"
	}
	
	$WebProjectRoot = "$global:WebServerRootPath/$ProjectName"
	
	#######################################
	if ($ProjectTargetDir -ne '')
	{
		$WebProjectRoot = "$global:WebServerRootPath/$ProjectTargetDir"
	}
	#######################################
	
	$tempstr = $ScpFile
	$index3  = $tempstr.LastIndexOf( '/' )
	$file    = $tempstr.SubString( $index3 + 1)
	$tempstr = $tempstr.SubString( 0 , $index3 )	
	$index2  = $tempstr.LastIndexOf( '/' )
	$subdir  = $tempstr.SubString( $index2 + 1 )
	if ($UseName)
	{
		$subdir = $MediaUserName
	}
	$tempstr = $tempstr.SubString( 0 , $index2 )	
	$index1  = $tempstr.LastIndexOf( '/' )
	$webdir  = $tempstr.SubString( $index1 + 1 )	
	
	# $uripart = $ProjectName + "/" + $webdir  + "/" + $subdir + "/" + $file
	
	$subdir  = $WebProjectRoot + "/" + $webdir + "/" + $subdir 
	# $webdir  = $WebProjectRoot + "/" + $webdir	

	$checkPath = $subdir + "/" + $file

# ====== Copy processed files to picture server ============:
	try
	{

	    #
	    # create backup directory
	    #
	    CheckAndCreateDirectory $subdir 
	    #
	    # copy file to backup directory

        $stdout = $OutputScp
	    $stderr = $ErrorScp

        $global:WebServerFileName = $checkPath

	    $global:EmailMessage += "copy file $file to picture directory $subdir `r`n"
	    # Check if file already exists
	    if( $( Test-Path $checkPath ) )
	    {
            # No Error: File aready exists, do not copy again
            return
	    }
	    else
	    {
		    Copy-Item -Path "$ScpFile" -Destination "$checkPath"
	    }

    }
	# Check exception error
	catch
	{
        $global:returnString = "ERROR 20"
		$global:RetVal = 1
		SendErrorMessage $global:EmailMessage
	}	


    CheckFunctionError "Transfer files to Webserver" $stderr $stdout ""  
	$global:EmailMessage += "...done`r`n"


# ========= ? not needed ==========
# chmod 444 $subdir/$file
#         RemoveOutputFiles
#         $CHMOD_EXE 		= 'C:/cygwin/bin/chmod.exe'
#         $PARAMS         = $checkPath
#         Start-Process -FilePath $CHMOD_EXE -Wait -NoNewWindow  -ArgumentList $PARAMS

}
	       
  
# #######################################################################################
#
# Create URI for accessing image on webserver
#
# #######################################################################################
function MakeUri ( [string] $targetFile )
{
	$WebProjectRoot = "$global:WebServerRootPath/$ProjectName"
	$WebProjectDir = $ProjectName
	
	#######################################
	if ($ProjectTargetDir -ne '')
	{
		$WebProjectRoot = "$global:WebServerRootPath/$ProjectTargetDir"
		$WebProjectDir = $ProjectTargetDir
	}
	#######################################

	
	$tempstr = $targetFile
	$index3  = $tempstr.LastIndexOf( '/' )
	$file    = $tempstr.SubString( $index3 + 1)
	$tempstr = $tempstr.SubString( 0 , $index3 )	
	$index2  = $tempstr.LastIndexOf( '/' )
	$subdir  = $tempstr.SubString( $index2 + 1 )
	if ($UseName)
	{
		$subdir = $MediaUserName
	}
	$tempstr = $tempstr.SubString( 0 , $index2 )	
	$index1  = $tempstr.LastIndexOf( '/' )
	$webdir  = $tempstr.SubString( $index1 + 1 )	
	
	if ($global:IsMediaFile)
	{
		$uripart = $WebProjectDir + "/" + $webdir  + "/" + $subdir + "/" + $file
		$global:Image_URI = "http://$WebServerMedia/" + $uripart
	}
	else
	{
		$uripart = $WebProjectDir + "/" + $webdir  + "/" + $subdir + "/" + $file
		$global:Image_URI = "http://$WebServer/" + $uripart
	}
	
	$subdir  = $WebProjectRoot + "/" + $webdir + "/" + $subdir 
	$webdir  = $WebProjectRoot + "/" + $webdir	

	
	echo $global:Image_URI
}

# #######################################################################################
#
# Transfer image back from WEB-Server and compare with original image
#
# #######################################################################################
function CheckAndCompareWebServerImage( [string] $Filename )
{
    # check if target file is present on picture server
	if( ! $( Test-Path "$global:WebServerFileName" -PathType Leaf ) )
	{
		Trace "-----> ERROR: $global:WebServerFileName not found on picture server"
		$global:EmailMessage += "ERROR: $global:WebServerFileName not found on picture server `r`n"
	    $global:RetVal = 1
	    SendErrorMessage $global:EmailMessage
	}

	# compare source and target files
	if ( $COMPARE_WEB_FILE_FLAG )
	{
		Trace "...Check webserver file"
	    $stdout = $OutputDiff
	    $stderr = $ErrorDiff

	    $args = " `"$global:WebServerFileName`" `"$Filename`""
	    $global:EmailMessage += "$DIFF_PROC_EXE $args`r`n"
	    RemoveOutputFiles

	    Start-Process -FilePath $DIFF_PROC_EXE -Wait -NoNewWindow -WorkingDirectory $FullImageProcessingPath -RedirectStandardError "$stderr" -RedirectStandardOutput "$stdout" -ArgumentList $args
	    $global:EmailMessage += "...done`r`n"

	    CheckFunctionError "Compare local and Webserver image" $stderr $stdout ""  			
		
    	}
	if ( $REMOVE_LOCAL_WEB_FILES )
	{
		if( $( Test-Path "$Filename" -PathType Leaf ) )
		{
			Remove-Item -Path "$Filename"
		}
	}

}


# #######################################################################################
#
# Update SQL database 
#
# #######################################################################################
function SqlProjectDir( )
{

	# Directory:
	# $sql = "select Value from $SQL_PROJECTS_DATABASE_NAME.dbo.ProjectSettings_Media ( $global:SQL_ProjectID ) "
	# $sql += "	where ProjectSetting = '/settings/media/images/archive/directory' "

	# Server:
	# $sql += "select Value from $SQL_PROJECTS_DATABASE_NAME.dbo.ProjectSettings_Media ( $global:SQL_ProjectID ) "
	# $sql += "where ProjectSetting = '/settings/media/images/preview/server' "
	
	#
	# get project name from project ID
	#
	$sql = "select Project from $SQL_PROJECTS_DATABASE_NAME.dbo.Project where ProjectID = $global:SQL_ProjectID "
	
	# $args = "-S " + '"' + "$SQL_SERVER" + '"' + " -d $SQL_DATABASE_NAME -Q " + '"' + $sql + '"' 	
	$args = "-S " + '"' + "$SQL_SERVER" + '"' + " -U $SQL_USER -P $SQL_PASSWORD -d $SQL_PROJECTS_DATABASE_NAME -Q " + '"' + $sql + '"' 	

	$stdout = $OutputSqlDir
	$stderr = $ErrorSqlDir
		Write-Output "ARGS: $args"

	if( $debug )
	{
		Write-Output "SQL: $sql"
		Write-Output "ARGS: $args"
	}
	try
	{
		RemoveOutputFiles
		# Open/Insert/Close DB
		Start-Process -FilePath $SQL_COMMAND_PROG -NoNewWindow -Wait -WorkingDirectory $FullImageProcessingPath -ArgumentList $args -RedirectStandardOutput "$stdout" -RedirectStandardError "$stderr"
		CheckFunctionError "Read Database Project Directory" $stderr $stdout "-"  

	}
	catch
	{
		Write-Output "SQL ERROR"
		$global:RetVal = 1
		$global:returnString = "ERROR 22"
		SendErrorMessage $global:EmailMessage
	}
}	

# #######################################################################################
#
# Update SQL database 
#
# #######################################################################################
function SqlCommands( [string] $SQL_AccessionNumber, [string] $SQL_URI, [string] $SQL_SpecimenPartAccessionNumber )
{
	if( $verbose -eq $true )
	{
		# Write-Output "`r`n"
		# Write-Output "SqlCommands()"
		# Write-Output "`r`n"
	}	
    #
    $AssignToID = $false
    #
    # Check if the picture should be assigned to the Specimen ID
    #
    if ( $SQL_AccessionNumber.StartsWith("ID-") )
    {
	    $AssignToID = $true
        $SQL_AccessionNumber = $SQL_AccessionNumber.Substring(3)
    }
    #
	$sql = ""
	$sql += "DECLARE @Transaction varchar(20) = 'Import'; "
	$sql += "DECLARE @Message nvarchar(50) = ''; "
	$sql += "BEGIN TRY "
	$sql += "	BEGIN TRANSACTION @Transaction "
	$sql += "		DECLARE @AccessionNumber nvarchar(50); "
	$sql += "		DECLARE @URI varchar(255); "
	$sql += "		DECLARE @ProjectName varchar(255); "
	$sql += "		DECLARE @SpecimenPartAccessionNumber nvarchar(50); "
	$sql += "		DECLARE @Description xml; "
	$sql += "		SET @URI = '" + $SQL_URI + "' "
	$sql += "		SET @AccessionNumber = '" + $SQL_AccessionNumber + "' "
	$sql += "		SET @ProjectName = '" + $ProjectName + "' "
	$sql += "		SET @SpecimenPartAccessionNumber = '" + $SQL_SpecimenPartAccessionNumber + "' "
	$sql += "		SET @Description = '" + $global:SQL_Description + "' "
	$sql += "		DECLARE @ii int "
	$sql += "		SET @ii = (SELECT COUNT(*) FROM CollectionSpecimen S WHERE S.AccessionNumber = @AccessionNumber) "
	$sql += "		IF (@ii > 1) "
	$sql += "			BEGIN "
	$sql += "				SET @Message = @AccessionNumber + ' exists ' + cast(@ii as varchar) + ' times.' "
	$sql += "			END "
	$sql += "		ELSE "
	$sql += "			BEGIN "
if ( $SetLicenseInfo -eq $true  )
{
	$sql += "				DECLARE @IPR nvarchar(500); "
	$sql += "				SET @IPR = '$SQL_IPR' "
	$sql += "				DECLARE @LicenseType nvarchar(500); "
	$sql += "				SET @LicenseType = '$SQL_LicenseType' "
	$sql += "				DECLARE @LicenseHolder nvarchar(500); "
	$sql += "				SET @LicenseHolder = '$SQL_LicenseHolder' "
	$sql += "				DECLARE @LicenseURI nvarchar(500); "
	$sql += "				SET @LicenseURI = '$SQL_LicenseURI' "
}
	$sql += "				DECLARE @ProjectID int; "
	$sql += "				SET @ProjectID = (SELECT ProjectID FROM $SQL_PROJECTS_DATABASE_NAME.dbo.Project WHERE Project = @ProjectName); "

	$sql += "				DECLARE @ImageType nvarchar(50); "
	$sql += "				SET @ImageType = (SELECT MIN(Value) FROM $SQL_PROJECTS_DATABASE_NAME.dbo.SettingHierarchyProjectAll (@ProjectID) S WHERE S.DisplayText = 'ImageType') "

	$sql += "				DECLARE @ImageNotes nvarchar(500); "
	$sql += "				SET @ImageNotes = (SELECT MIN(Value) FROM $SQL_PROJECTS_DATABASE_NAME.dbo.SettingHierarchyProjectAll (@ProjectID) S WHERE S.DisplayText = 'Notes') "

	$sql += "				DECLARE @TaxonomicGroup nvarchar(50); "
	$sql += "				SET @TaxonomicGroup = (SELECT MIN(Value) FROM $SQL_PROJECTS_DATABASE_NAME.dbo.SettingHierarchyProjectAll (@ProjectID) S WHERE S.DisplayText = 'TaxonomicGroup') "

	$sql += "				DECLARE @CollectionID nvarchar(50); "
	$sql += "				SET @CollectionID = (SELECT MIN(Value) FROM $SQL_PROJECTS_DATABASE_NAME.dbo.SettingHierarchyProjectAll (@ProjectID) S WHERE S.DisplayText = 'CollectionID') "

	$sql += "				DECLARE @MaterialCategory nvarchar(50); "
	$sql += "				SET @MaterialCategory = (SELECT MIN(Value) FROM $SQL_PROJECTS_DATABASE_NAME.dbo.SettingHierarchyProjectAll (@ProjectID) S WHERE S.DisplayText = 'MaterialCategory') "

	$sql += "				DECLARE @CollectionSpecimenID int; "
if ( $AssignToID -eq $true )
{
	$sql += "				SET @CollectionSpecimenID = (SELECT S.CollectionSpecimenID FROM CollectionSpecimen S WHERE S.CollectionSpecimenID = @AccessionNumber);  "
	$sql += "				IF (@CollectionSpecimenID is null) "
	$sql += "					SET @Message = 'DataSET ID does not exist. ' "
}
elseif ( $AssignToExternalIdentifier -eq $true )
{
	$sql += "				SET @CollectionSpecimenID = (SELECT S.CollectionSpecimenID FROM CollectionSpecimen S WHERE S.ExternalIdentifier = @AccessionNumber);  "
	$sql += "				IF (@CollectionSpecimenID is null) "
	$sql += "					SET @Message = 'DataSET ID does not exist. ' "
}
else
{
	$sql += "				SET @CollectionSpecimenID = (SELECT S.CollectionSpecimenID FROM CollectionSpecimen S WHERE S.AccessionNumber = @AccessionNumber); "
}
	$sql += "				IF ( NOT @ProjectID IS NULL AND @AccessionNumber <> '' AND @URI <> '') "
	$sql += "					BEGIN "
	$sql += "						IF (@CollectionSpecimenID is null) "
if ( $CreateNewDataSet -eq $true  )
{
	$sql += "							BEGIN "
	$sql += "								INSERT INTO CollectionSpecimen (AccessionNumber, DataWithholdingReason) VALUES (@AccessionNumber, 'data entry not completed'); "
	$sql += "								SET @CollectionSpecimenID = (SELECT SCOPE_IDENTITY() AS [SCOPE_IDENTITY]); "
	$sql += "								INSERT INTO IdentificationUnit (CollectionSpecimenID, LastIdentificationCache, TaxonomicGroup, DisplayOrder) VALUES (@CollectionSpecimenID, @TaxonomicGroup, @TaxonomicGroup, 1); "
	$sql += "								INSERT INTO CollectionSpecimenPart (CollectionSpecimenID, CollectionID, MaterialCategory) VALUES(@CollectionSpecimenID, @CollectionID, @MaterialCategory); "
	$sql += "								INSERT INTO CollectionProject (CollectionSpecimenID, ProjectID) VALUES(@CollectionSpecimenID, @ProjectID); "
	$sql += "								SET @Message = 'New DataSET created. ' "
	$sql += "							END "
}
else
{
	$sql += "								SET @Message = 'No DataSET present. ' "
}
	$sql += "						ELSE "

	$sql += "							BEGIN "
	$sql += "							    SET @Message = 'DataSET present. '; "
	$sql += "				                DECLARE @Count int; "
	$sql += "				                SET @Count = (SELECT count(*) FROM CollectionProject WHERE CollectionSpecimenID = @CollectionSpecimenID and ProjectID = @ProjectID ); "

	$sql += "				                IF (@Count = 0) "
	$sql += "								    INSERT INTO CollectionProject (CollectionSpecimenID, ProjectID) VALUES(@CollectionSpecimenID, @ProjectID); "
	$sql += "							END "

	$sql += "						IF (@SpecimenPartAccessionNumber <> '') "
	$sql += "							BEGIN "
	$sql += "								DECLARE @j int; "
	$sql += "								SET @j = (SELECT COUNT(*) FROM CollectionSpecimenPart WHERE CollectionSpecimenID = @CollectionSpecimenID AND AccessionNumber = @SpecimenPartAccessionNumber); "
	$sql += "								IF (@j = 1) "
	$sql += "									BEGIN "
	$sql += "										DECLARE @SpecimenPartID int; "
	$sql += "										SET @SpecimenPartID = (SELECT MIN(SpecimenPartID) FROM CollectionSpecimenPart WHERE CollectionSpecimenID = @CollectionSpecimenID AND AccessionNumber = @SpecimenPartAccessionNumber); "
	$sql += "										BEGIN "
	$sql += "											DECLARE @k int; "
	$sql += "											SET @k = (SELECT COUNT(*) FROM CollectionSpecimenImage I WHERE I.CollectionSpecimenID = @CollectionSpecimenID AND I.URI = @URI AND I.SpecimenPartID = @SpecimenPartID); "
	$sql += "											IF (@k = 0) "
	$sql += "												BEGIN "
if ( $SetLicenseInfo -eq $true  )
{
	$sql += "													INSERT INTO CollectionSpecimenImage (CollectionSpecimenID, URI, [Description], ImageType, Notes, SpecimenPartID, IPR, LicenseType, LicenseHolder, LicenseURI) 
                                                                    VALUES(@CollectionSpecimenID, @URI, @Description, @ImageType, @ImageNotes, @SpecimenPartID, @IPR, @LicenseType, @LicenseHolder, @LicenseURI); "
}
else
{
	$sql += "													INSERT INTO CollectionSpecimenImage (CollectionSpecimenID, URI, [Description], ImageType, Notes, SpecimenPartID) 
                                                                    VALUES(@CollectionSpecimenID, @URI, @Description, @ImageType, @ImageNotes, @SpecimenPartID); "
}
	$sql += "													SET @Message = @Message +  'New SpecimenPart Image inserted.' "
	$sql += "												END "
	$sql += "											ELSE "
	$sql += "												SET @Message = @Message +  'SpecimenPart Image already present.' "
	$sql += "										END "
	$sql += "									END "
	$sql += "								ELSE "
	$sql += "									SET @Message = @Message +  'SpecimenPart AccessionNumber not found or inconsistent.' "
	$sql += "							END "
	$sql += "						ELSE "
	$sql += "							BEGIN "
	$sql += "								DECLARE @i int; "
	$sql += "								SET @i = (SELECT COUNT(*) FROM CollectionSpecimenImage I WHERE I.CollectionSpecimenID = @CollectionSpecimenID AND I.URI = @URI); "
	$sql += "								IF (@i = 0) "
	$sql += "									BEGIN "
if ( $SetLicenseInfo -eq $true  )
{
	$sql += "										INSERT INTO CollectionSpecimenImage (CollectionSpecimenID, URI, [Description], ImageType, Notes, IPR, LicenseType, LicenseHolder, LicenseURI) 
                                                        VALUES(@CollectionSpecimenID, @URI, @Description, @ImageType, @ImageNotes, @IPR, @LicenseType, @LicenseHolder, @LicenseURI); "
}
else
{
	$sql += "										INSERT INTO CollectionSpecimenImage (CollectionSpecimenID, URI, [Description], ImageType, Notes) 
                                                        VALUES(@CollectionSpecimenID, @URI, @Description, @ImageType, @ImageNotes); "
}
	$sql += "										SET @Message = @Message +  'New Image inserted.' "
	$sql += "									END "
	$sql += "								ELSE "
	$sql += "									SET @Message = @Message +  'Image already present.' "
	$sql += "							END "
	$sql += "					END "
	$sql += "				ELSE "
	$sql += "					BEGIN "
	$sql += "						SET @Message = 'settings incomplete' "
	$sql += "					END "
	$sql += "			END "
	$sql += "		IF @Message <> '' "
	$sql += "			SELECT @Message; "
	$sql += "	COMMIT TRANSACTION @Transaction; "
	$sql += "END TRY "
	$sql += "BEGIN CATCH "
	$sql += "	SELECT @Message + '. ' + ERROR_MESSAGE(); "
	$sql += "	ROLLBACK TRANSACTION @Transaction; "
	$sql += "END CATCH "
#
	Trace $sql
#
	$args = ""
	$args = "-S " + '"' + "$SQL_SERVER" + '"' + " -d $SQL_DATABASE_NAME -Q " + '"' + $sql + '"' 	

	$stdout = $OutputSql
	$stderr = $ErrorSql

	if( $debug )
	{
		Write-Output "SQL: $sql"
		Write-Output "ARGS: $args"
	}
	try
	{
		RemoveOutputFiles
		# Open/Insert/Close DB
		Start-Process -FilePath $SQL_COMMAND_PROG -NoNewWindow -Wait -WorkingDirectory $FullImageProcessingPath -ArgumentList $args -RedirectStandardOutput "$stdout" -RedirectStandardError "$stderr"
		
		# CheckFunctionError "Write Database Entry" $stderr $stdout "New Image inserted."  
		CheckFunctionError "Write Database Entry" $stderr $stdout "Image in"  

	}
	catch
	{
		Write-Output "SQL ERROR"
		$global:RetVal = 1
		$global:returnString = "ERROR 23"
		SendErrorMessage $global:EmailMessage
	}
}

# #######################################################################################
#
#	SendErrorMessage
#
# #######################################################################################
function SendErrorMessage( [string] $message )
{
	if( $verbose -eq $true )
	{
		Write-Output "`r`n"
		Write-Output "SendErrorMessage( $message )"
		Write-Output "`r`n"
	}
	#
	# exit processing
	#
	throw (New-Object Exception)
	# exit 1
}



# #######################################################################################
# #######################################################################################
#
# Main program
#
# #######################################################################################
#

$global:EmailMessage = "ImageTransfer initializing`r`n"
Trace ""
Trace "---- ImageTransfer ----"
ForEach ( $aa in $args )
{
	Trace $aa;
}
try
{
	#
	# check if $ProjectName is a ProjectID (a number)
	#
	$global:isProjectID = $true 
	ForEach ( $ch in $ProjectName.ToCharArray() )
	{
		if ( -not [char]::IsDigit( $ch ) )
		{
			$global:isProjectID = $false
		}
	}
	
	#
	#preset path for function call when evaluating project from Project ID
	#
	$FullImageProcessingPath 	= $InputDrive + "ImageProcessing"		
	$OutputSqlDir 	= "$FullImageProcessingPath/output.sqldir" + $FileExt + ".txt"
	$ErrorSqlDir 	= "$FullImageProcessingPath/error.sqldir" + $FileExt + ".txt"

	if ( $global:isProjectID )
	{
		$global:EmailMessage += "Project ID: $ProjectName`r`n"
		$global:EmailMessage += "Evaluate project name by database request`r`n"
		$global:EmailMessage += "SQL server: $SQL_SERVER`r`n"
		$global:EmailMessage += "Database name: $SQL_DATABASE_NAME`r`n"

		$global:SQL_ProjectID = $ProjectName
		if (! $( Test-Path $SQL_PWFILE -PathType Leaf ))
		{
			$global:EmailMessage += "Error: Could not find password file $SQL_PWFILE for database access`r`n"
			SendErrorMessage $global:EmailMessage
		}
		#
		# get password for database access
		#			
		$SQL_PASSWORD = Get-Content $SQL_PWFILE
		#
		# read ProjectName from Database according ProjectID
		#	
		SqlProjectDir 
		$ProjectName = $global:SQL_ProjectID
				
		$UPDATE_DATABASE_FLAG = $false
    }
    #
    # Set Image import path
    #
	$FullImageImportPath = $InputDrive + "ImageTransfer/" + $ProjectName + $UNDERSCORE + "Transfer"
    #
    # Set backup root path (server directory on BSM7 / local)
    #
	$BackupRootDir = $ProjectName

	#######################################
	if ($ProjectTargetDir -ne '')
	{
		$BackupRootDir = $ProjectTargetDir
	}
	#######################################
	
	$global:FullImageBackupRootPath 	= $ArchiveDrive + "$global:ArchiveDir/Pictures/Original/$BackupRootDir"
	
	if( $ArchiveOnImageStorage )
	{
		$global:FullImageBackupRootPath1 	= "//$global:ServerIP/$global:ArchiveDir/Pictures/Original/$BackupRootDir"
		$global:LinkScriptFileName1		= $global:FullImageBackupRootPath1 + "/" + $BackupRootDir + $UNDERSCORE + "CreateSymLinks_" + $global:date + ".txt"
	}

	# Set path within backup script file (long term archive at LRZ)
	$global:FullImageBackupRootPath 	= $ArchiveDrive + "$global:ArchiveDir/Pictures/Original/$BackupRootDir"
    # Set logfile name and path
	$listAddrFile = "$FullImageImportPath/ListAddr" + $FileExt + ".out"
	
	#
	# Conversion paths and settings
	#
	$FullImageProcessingPath 	= $InputDrive + "ImageProcessing/$ProjectName"
	# $FullImageProcessingPathCygwin 	= "/cygdrive/e/ImageProcessing/$ProjectName"
	#
	# script files to be created (Admin account needed for backup and symbolic links)
	#
	$global:LinkScriptFileName			= $global:FullImageBackupRootPath + "/" + $BackupRootDir + $UNDERSCORE + "CreateSymLinks_" + $global:date + ".txt"
	$global:BackupScriptFileName		= $global:FullImageBackupRootPath + "/" + $BackupRootDir + $UNDERSCORE + "Archive.ps1"
	$RemoveScriptFileName		= $FullImageProcessingPath + "/" + $BackupRootDir + $UNDERSCORE + "Remove.sh"
	#
	# communication output and error files to be created
	#
	$OutputSsh 		= "$FullImageProcessingPath/output.ssh" + $FileExt + ".txt"
	$ErrorSsh 		= "$FullImageProcessingPath/error.ssh" + $FileExt + ".txt"
	$OutputScp		= "$FullImageProcessingPath/output.scp" + $FileExt + ".txt"
	$ErrorScp		= "$FullImageProcessingPath/error.scp" + $FileExt + ".txt"
	$OutputWget 	= "$FullImageProcessingPath/output.wget" + $FileExt + ".txt"
	$ErrorWget 		= "$FullImageProcessingPath/error.wget" + $FileExt + ".txt"
	$OutputDiff 	= "$FullImageProcessingPath/output.diff" + $FileExt + ".txt"
	$ErrorDiff 		= "$FullImageProcessingPath/error.diff" + $FileExt + ".txt"
	$OutputSql 		= "$FullImageProcessingPath/output.sql" + $FileExt + ".txt"
	$ErrorSql 		= "$FullImageProcessingPath/error.sql" + $FileExt + ".txt"
	$Exception 		= "$FullImageProcessingPath/Exception" + $FileExt + ".txt"
	# Image conversion files including path
	$OutputImageWebPath	 	= "$FullImageProcessingPath/" + $OutputImageWeb	
	$OutputImagePre6Path 	= "$FullImageProcessingPath/" + $OutputImagePre6
	$ErrorImageWebPath 		= "$FullImageProcessingPath/" + $ErrorImageWeb 	
	$ErrorImagePre6Path 	= "$FullImageProcessingPath/" + $ErrorImagePre6 
	#
	#
	if( $debug -eq $true )
	{
		Write-Output "--------"
		Write-Output "Windows:"
		Write-Output "--------"
		Write-Output "FullImageImportPath:		$FullImageImportPath"
		Write-Output "FullImageBackupRootPath:	$global:FullImageBackupRootPath"
		Write-Output "FullImageProcessingPath:  $FullImageProcessingPath"
		Write-Output "------"
		Write-Output "Linux:"
		Write-Output "------"
		Write-Output "WebServerRootPath:		$global:WebServerRootPath"
	}	
	
	$global:EmailMessage += "--------`r`n"
	$global:EmailMessage += "Windows:`r`n"
	$global:EmailMessage += "--------`r`n"
	$global:EmailMessage += "FullImageImportPath:		$FullImageImportPath`r`n"
	$global:EmailMessage += "FullImageBackupRootPath:	$global:FullImageBackupRootPath`r`n"
	$global:EmailMessage += "FullImageProcessingPath:  $FullImageProcessingPath`r`n"
	$global:EmailMessage += "------`r`n"
	$global:EmailMessage += "Linux:`r`n"
	$global:EmailMessage += "------`r`n"
	$global:EmailMessage += "WebServerRootPath:		$global:WebServerRootPath`r`n"
	
	Write-Output "Check for all used directories" 
	#
	CheckAndCreateDirectory $FullImageProcessingPath 
	# CheckAndCreateDirectory $global:FullImageBackupRootPath 
	CheckAndCreateDirectory $FullImageImportPath 
	# CheckAndCreateDirectory $FullWebImageSubPath 
	# CheckAndCreateDirectory $FullWebPreImageSubPath 
	
	if( $global:RetVal -ne 0 )
	{
		Write-Output "ERROR: $FullImageImportPath"
		SendErrorMessage $global:EmailMessage
	}
	#
	Write-Output "Check for all used programms" 
	#
	CheckExecFile $CONVERT_PROG_EXE 
	# CheckExecFile( $SQL_PROG_EXE )??? PATH
	# CheckExecFile( $BACKUP_PROG_EXE )
	CheckExecFile $DIFF_PROC_EXE

	if( $global:RetVal -ne 0 )
	{
		Write-Output "ERROR: CheckExecFile" 
		SendErrorMessage $global:EmailMessage
	}
}
catch 
{
	$Subject = "ImageProcessingError " + $Projectname + ": " + $global:BsmFileName
	$message = $_.Exception.GetType().FullName + ": " + $_.Exception.Message + "`r`n" + $global:EmailMessage
	
	Write-Output $message
	Trace $message;
	Send-MailMessage -From $emailFrom -To $emailTo -SmtpServer $emailSmtpServer -Subject $Subject -Body $message
	exit 1
}


# set exception max count before exit
$Counter = 0

if ($BACKUP_ORIGINAL_FILES)
{
	# write "cd"-line only once at the beginning of the script
	if( -not $( Test-Path "$global:BackupScriptFileName" -PathType Leaf ) )
	{
		Write-Output "cd $BACKUP_PROG_DIR" >> $global:BackupScriptFileName
	}
}
#
Write-Output( "Process images" )
#
ForEach ( $i in get-childitem "$FullImageImportPath/$InputFileName" | sort ) 
{
	$global:EmailMessage = "Image: $i `r`n"
	
	$global:EmailMessage += "--------`r`n"
	$global:EmailMessage += "Windows:`r`n"
	$global:EmailMessage += "--------`r`n"
	$global:EmailMessage += "FullImageImportPath:		$FullImageImportPath`r`n"
	$global:EmailMessage += "FullImageBackupRootPath:	$global:FullImageBackupRootPath`r`n"
	$global:EmailMessage += "FullImageProcessingPath:  $FullImageProcessingPath`r`n"
	$global:EmailMessage += "------`r`n"
	$global:EmailMessage += "Linux:`r`n"
	$global:EmailMessage += "------`r`n"
	$global:EmailMessage += "WebServerRootPath:		$global:WebServerRootPath`r`n"

	$OriginalFileName = $i.name
	$OriginalFilePath = $i.FullName
	try
	{
		#
		# Image Processing
		#
		Write-Output "Processing file : " $OriginalFileName	
		ProcessImage $OriginalFileName
		#
		#
		if( $global:RetVal -ne 0 )
		{
			Write-Output "ERROR: " 
			SendErrorMessage $global:EmailMessage
		}
		if ( $REMOVE_IMAGE_FROM_TRANSFER_DIR_FLAG)
		{	   
			$ImportedName = $OriginalFileName + ".imported"		
			# Rename only to ".imported"
			Rename-Item  -Path $OriginalFilePath -NewName $ImportedName
		}	
	}
	catch
	{
		$indrem = $global:BsmFileName.IndexOf( '-' )
		if ( $indrem -gt 0 )
		{
			$remDir = $global:BsmFileName.Substring( 0, $global:BsmFileName.IndexOf( '-' ) + 5 )
			Write-Output "rm -f ./web/$remDir/$global:BsmWebFileName ./pre6/$remDir/$global:BsmWebFileName " >> $RemoveScriptFileName
		}
		
		$Subject = "ImageProcessingError " + $Projectname + ": " + $global:BsmFileName
		$message = $_.Exception.GetType().FullName + ": " + $_.Exception.Message + "`r`n" + $global:EmailMessage
		
		Write-Output $message
		Send-MailMessage -From $emailFrom -To $emailTo -SmtpServer $emailSmtpServer -Subject $Subject -Body $message
		
		echo $_.Exception.Message >> $Exception
		echo $_.Exception.GetType().FullName >> $Exception

		Write-Output "ERROR on image $i - MessageCount: $Counter"
		$global:RetVal = 0
		if ($global:returnString -eq "")
		{
			$global:returnString = "ERROR"
		}
		$global:returnString += " when processing file $i"
		#
		#===========================================================================
		# Set Counter for maximum number of errors to stop the batch execution here!
		#===========================================================================
		#
		if ( ++$Counter -gt 5 )
		{
			# too many error Emails, error exit
			exit 1
		}		
	}
}
#
# Notify Admin for call
if ( $args.Length -gt 1)
{
	$Subject = $Projectname + ": " + $global:BsmFileName
	$message = "File has been transmitted - " + $global:returnString
	if ( -not $JustReturnTargetPath -and $TRANSFER_TO_WEB_SERVER_FLAG)
	{
		Send-MailMessage -From $emailFrom -To $emailTo -SmtpServer $emailSmtpServer -Subject $Subject -Body $message
	}
}
#
# return URL of last processed image for MediaService
Write-Output $global:returnString
#
# remove communication files
#
#
Trace "---- finished ----"
# regular exit
exit 0
