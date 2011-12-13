<cfcomponent extends="controller" output="false">

	<cffunction name="import" output="false" returntype="any">
		<cfargument name="rc" />

		<cfset var newFilename = createUUID() & ".xml" />
		<cfset var importDirectory = expandPath(rc.$.siteConfig('assetPath')) & '/assets/file/muraConverter/wordpressImport/' />
		<cfset var rawXML = "" />
		<cfset var wpXML = "" />
		<cfset var item = "" />
		<cfset var parentContent = "" />
		<cfset var content = "" />
		<cfset var allParentsFound = false />
		<cfset var categoryList = "" />
        <!--- Added this variable so that content can be imported into a blog portal instead of directely under the "home" section of the site. Eventually it would be nice to add a select input to the view file default.cfm so that the end user can select what contentID they would like the imported pages to appear under. --->
        <!--- <cfset var contentID = "0B7D5375-0E3D-9F3F-DD84497227F81A98" /> ACA Site--->
        <cfset var contentID = "23E58CCE-D236-481C-8F6B8CA975124C82" /> <!--- Test Site --->
        <!--- Use this if imported posts should be inserted into the root of the site. --->
		<!--- <cfset var contentID = "00000000000000000000000000000000001" /> root of test site ---> 
		
		<cfif not directoryExists(importDirectory)>
			<cfset directoryCreate(importDirectory) />
		</cfif>
		
		<cffile action="upload" filefield="wordpressXML" destination="#importDirectory#" nameConflict="makeunique" result="uploadedFile">
		<cffile action="rename" destination="#importDirectory##newFilename#" source="#importDirectory##uploadedFile.serverFile#" >
		
		<cffile action="read" file="#importDirectory##newFilename#" variable="rawXML" >
		
		<cfset wpXML = xmlParse(rawXML) />
        
		<cfdump var="#wpXML#" abort="true">
		
        <cfloop condition="allParentsFound eq false">
			<cfset allParentsFound = true />
			<cfloop array="#wpXML.rss.channel.item#" index="item">
				<cfscript>
					if(item["wp:post_type"].xmlText == "post" && len(item["title"].xmlText)) {
						if(item["wp:post_parent"].xmlText eq 0) {
							parentContent = rc.$.getBean("content").loadBy(contentID="#contentID#");
						} else {
							parentContent = rc.$.getBean("content").loadBy(remoteID=item["wp:post_parent"].xmlText);
						}
						
						if(parentContent.getIsNew()) {
							allParentsFound = false;
						} else {
							content = rc.$.getBean("content").loadBy(remoteID=item["wp:post_id"].xmlText);
							content.setParentID(parentContent.getContentID());
							content.setTitle(item["title"].xmlText);
							content.setBody(item["content:encoded"].xmlText);
							content.setRemoteID(item["wp:post_id"].xmlText);
							content.setApproved(1);
							content.setReleaseDate(item["pubDate"].xmlText);
							content.setSiteID(rc.$.event('siteID'));
							
							categoryList = "";
							
							for(var i=1; i<=arrayLen(item.category); i++) {
								var category = rc.$.getBean("category").loadBy(name="#item.category[i].xmlText#");
								if(category.getIsNew()) {
									category.setName(item.category[i].xmlText);
									
									category.save();	
								}
								categoryList = listAppend(categoryList, category.getCategoryID());
							}
							
							content.setCategories(categoryList);
							
							content.save();	
									
							}
						}
					}
				</cfscript>
			</cfloop>
		</cfloop>
		
	</cffunction>

</cfcomponent>