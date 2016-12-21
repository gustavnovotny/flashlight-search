<#assign liferay_portlet = taglibLiferayHash["/META-INF/liferay-portlet.tld"] />
<#assign liferay_security = taglibLiferayHash["/META-INF/liferay-security.tld"] />
<#assign liferay_theme = taglibLiferayHash["/META-INF/liferay-theme.tld"] />
<#assign aui = taglibLiferayHash["/META-INF/liferay-aui.tld"] />
<#assign liferay_ddm = taglibLiferayHash["/META-INF/resources/liferay-ddm.tld"] />
<#assign liferay_ui = taglibLiferayHash["/META-INF/liferay-ui.tld"] />

<#assign Field = staticUtil["com.liferay.portal.kernel.search.Field"] />
<#assign content=Field.CONTENT />
<#assign title = Field.TITLE />
<#assign snippet = Field.SNIPPET>
<#assign tags = Field.ASSET_TAG_NAMES />




<@liferay_portlet["renderURL"] var="viewURL">
	<@liferay_portlet["param"] name="mvcPath" value="/view.ftl" />				
</@>
<@liferay_portlet["renderURL"] var="editURL">
	<@liferay_portlet["param"] name="mvcPath" value="/search_result.ftl" />			
</@>


<@aui["form"] action="${editURL}" name="search_form">
	<@aui["fieldset"]>
		<@aui["input"] label="facet field" placeholder="ddmStructureKey" name="ddmStructureKey" />
		
			<@aui["input"] class="search-input" label="" name="keywords" placeholder="search"  type="text" size="30" inlineField=true  >
				<@aui["validator"] name="required" errorMessage="You must enter a search term"/>
			</@>
			<@aui["field-wrapper"]  inlineField=true >
				<@aui["button"] type="submit"   value="Search" class="icon-monospaced " icon="icon-search"></@>
			</@>
	</@>


<@aui["input"] type="hidden" name="selected_facet" value="" id="selected_facet"/>
<nav class="navbar navbar-inverse">
	<div class="container-fluid">
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav">
				<li><a id="" onclick="myfunction(this);" href="" >All </a></li>
					<#list Request.facets?keys as facet>
						<#if Request.groupedDocuments[facet]?? >
						<li><a href="" onclick="myfunction(this);" id="${facet}">${Request.facets[facet]} <span class="badge">${Request.groupedDocuments[facet]?size}</span></a></li>
						</#if>
					</#list>
      		</ul>
    	</div>
  	</div>
</nav>	
</@>	

<@aui["script"] >
function myfunction(element){
	var selected_facet = element.id;
	//alert(selected_facet);
	document.getElementById("<@liferay_portlet["namespace"] />selected_facet").value=selected_facet;
	document.getElementById("<@liferay_portlet["namespace"] />search_form").submit();

}

</@>


<#include  "facet/structure.ftl" />

<div class="container">

<div class="container">
	<#if false>
		<@liferay_ddm["template-renderer"] 
			className="${Request.documentClassName}"
	    	displayStyle="${Request.displayStyle[0]}"
	    	displayStyleGroupId=Request.displayStyleGroupId[0]
	    	entries=Request.documents
		>
			<h2 class="h2">All results</h2>
			<#list Request.documents as doc>
				<div class="col-md-4">
	          		<h2>${doc.get(title)}</h2>
	          		<p>${doc.get(content)} </p>
	          		<p>asset type:  ${doc.get("entryClassName")}</p>
	          		<p>${doc.get(snippet)}</p>
	          		<p>tags: </p>
	          		<p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
	        	</div>
			</#list>
	
		</@>
	</#if>
	</div>
<#-- 
<div class="container">
<h2>Test article display</h2>
<div class="abderrahmane">
${Request.articleDisplay.getContent()}
</div>
</div>
 -->
<h2 class="h2">Grouped results</h2>
	<#if Request.groupedDocuments?has_content >
		
		 <#--  
		<#list Request.facets?keys as key>
		<p>key</p>
		</#list>
		--> 
		<#list Request.facets?keys as key>
		<#if Request.groupedDocuments[key]??  && true>
		<#assign docs=Request.groupedDocuments[key][0..*3] />
		<#-- original 
		<@liferay_ddm["template-renderer"] 
			className="${key}"
	    	displayStyle=Request.displayStyle[key?counter]
	    	displayStyleGroupId=Request.displayStyleGroupId[key?counter]
	    	entries=Request.groupedDocuments[key]
		>
		-->
		
		<@liferay_ddm["template-renderer"] 
			className="com.liferay.journal.model.JournalArticle"
	    	displayStyle=Request.displayStyle[key?counter]
	    	displayStyleGroupId=20147
	    	entries=docs
		>
			<div class="panel panel-default">
			<div class="panel-heading">
			${Request.facets[key]}
			</div>
			<div class="panel-body">
				<#list docs as doc >
					<div class="col-md-4">
					<h2>${doc.title} (default)</h2>
					<p>${doc.content}</p>
					</div>
				</#list>
			</div>
			</div>
		</@>
		
		</#if>
			
			<#if Request.groupedDocuments[key]??  && false>
			<div class="panel panel-primary">
				<#--  		
  				<div class="panel-heading"><@liferay_ui["message"] key="flashlight-${key}" /> <span class="badge">${Request.groupedDocuments[key]?size}</span></div>
  				-->	
  				
  				<div class="panel-heading">${key} <span class="badge">${Request.groupedDocuments[key]?size}</span></div>
  				<div class="panel-body">
  				<#if true>
  				<#list Request.groupedDocuments[key] as document>
  					<div class="col-md-4">
	          		<h2><u>${document.get(title)}</u></h2>
	          		<p>${document.get(content)} <a href="">read more</a></p>
	          		
	          		<#--
	          		<p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
	          		-->
	        	</div>
	        	</#list>
	        	</#if>
  				</div>
			</div>
			</#if>
		</#list>
	</#if>
<hr/>
	<div>
		<button onclick="location.href='${viewURL}'">Return to search</button>
	</div>
</div>

