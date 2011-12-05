<cfoutput>
	<h3>Blogger</h3>	
	<p>Upload your Blogger XML File.</p>
	<form name="fileUpload" method="post" action="?mcAction=blogger.import" enctype="multipart/form-data">
		<input type="file" name="bloggerXML" />
		<button type="submit">Upload</button>
	</form>
</cfoutput>