Const PADDING = 4
Const ROOT_PATH = "C:\Users\<%user_name%>\Documents\MakeVid\"

Dim objFSO, objRootFolder, objFiles, objTextStream
Dim intCounter
Dim strFileName, strRootPath

Set objWSH = CreateObject("WScript.Shell")
Set objFSO = WScript.CreateObject("Scripting.FileSystemObject")

If objFSO.FileExists(CONFIG_FILE) then
	Set objRootFolder = objFSO.GetFolder(ROOT_PATH)
	
	For Each Folder in objRootFolder.SubFolders
		Set objScreensFolder = objFSO.GetFolder(Folder.Path & "\screens\")
	
		For Each Folder2 in objScreensFolder.SubFolders
			Set objFiles = Folder2.Files

			intCounter = 0	
			
			'Rename files
			For Each File in objFiles
				strFileName = "img" & FormatNumber(intCounter) & ".png"
				
				If Not objFSO.FileExists(Folder2.Path & "\" & strFileName) Then
					File.Name = strFileName
				End If
				intCounter = intCounter + 1	
			Next
			
			'Make video
			objWSH.Run "MakeVid.cmd " & Folder2.Path, 1, True
			
			'Delete Files
			Set objFiles = Folder2.Files
			For Each File in objFiles
				If Right(File.Path, 3) = "png" Then
					File.Delete	
				End If
			Next
		Next
	Next

	Set objFSO = Nothing
	Set objRootFolder = Nothing
	Set objWSH = Nothing
	Set objScreensFolder = Nothing
End If

Function FormatNumber(intNumber)
	Dim strNumber
	Dim strNewNumber
	
	strNumber = intNumber & ""
	strNewNumber = ""
	
	For i = 0 To PADDING - Len(strNumber) 
		strNewNumber = strNewNumber & "0"
	Next
	
	FormatNumber = strNewNumber & strNumber
End Function