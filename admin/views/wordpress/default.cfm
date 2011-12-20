<cfoutput>
	<h3>Wordpress</h3>	
	<p>Upload your Wordpress XML File.</p>
	<form name="fileUpload" method="post" action="?mcAction=wordpress.import" enctype="multipart/form-data">
		<ul>
        	<li>
            	<label for="wordpressXML">Wordpress XML</label>
		        <input type="file" name="wordpressXML" id="wordpressXML" />
            </li>
            <li>
            	<label for="parentContentID">Parent ContentID</label>
                <input type="text" name="parentContentID" id="parentContentID" />
            </li>
            <li>
            	<button type="submit">Upload</button>
            </li>
	</form>
</cfoutput>