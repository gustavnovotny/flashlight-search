
<#assign liferay_portlet = taglibLiferayHash["/META-INF/liferay-portlet.tld"] />
<#assign liferay_portlet_ext = taglibLiferayHash["/META-INF/liferay-portlet-ext.tld"] />
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

<#assign journalArticleLocalService = serviceLocator.findService("com.liferay.journal.service.JournalArticleLocalService")>
<#assign assetEntryLocalService = serviceLocator.findService("com.liferay.asset.kernel.service.AssetEntryLocalService")>

<@liferay_theme["defineObjects"] />
<@portlet["defineObjects"] />

<@liferay_portlet["renderURL"] var="viewURL">
	<@liferay_portlet["param"] name="mvcPath" value="/view.ftl" />
</@>
<@liferay_portlet["renderURL"] varImpl="searchURL"/>


			<#assign results=Request.searchResults />
			<@liferay_ddm["template-renderer"] 
				className="${Request.documentClassName}"
				displayStyle="${Request.displayStyle[0]}"
				displayStyleGroupId=Request.displayStyleGroupId[0]
				entries=results
			>
			
<@aui["form"] action="${searchURL}" name="search_form" method="get">
	<@liferay_portlet_ext["renderURLParams"] varImpl="searchURL"/>
	<@aui["input"] name="mvcPath" type="hidden" value="/search_result.ftl" />
	<@aui["fieldset"]>
		<@aui["input"] class="search-input" label="" name="keywords" placeholder="search"  type="text" size="30" inlineField=true  >
			<@aui["validator"] name="required" errorMessage="You must enter a search term"/>
		</@>
		<@aui["field-wrapper"]  inlineField=true >
			<@aui["button"] type="submit"   value="Search" class="icon-monospaced " icon="icon-search"></@>
		</@>
	</@>

	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="collapse navbar-collapse">
				<ul class="nav navbar-nav">
					<@liferay_portlet["renderURL"] var="facetURL">
						<@liferay_portlet["param"] name="mvcPath" value="/search_result.ftl" />
						<@liferay_portlet["param"] name="keywords" value=Request.keywords />
					</@>
					<li><a href="${facetURL}" >All</a></li>
					<#list Request.searchFacets as facet>
						<#list facet.facet.facetCollector.termCollectors as term>
							<#if (Request.groupedDocuments[term.term])?? && Request.enabled_facets?seq_contains(facet.className) >
								<@liferay_portlet["renderURL"] var="facetURL">
								<#--  original 
									<@liferay_portlet["param"] name="mvcPath" value="/search_result.ftl" />
									-->
									<@liferay_portlet["param"] name="mvcPath" value="/search_details.ftl" />
									<@liferay_portlet["param"] name="keywords" value=Request.keywords />
									<@liferay_portlet["param"] name=facet.fieldName value=term.term />
								</@>
								<li><a href="${facetURL}">${Request.facets[term.term]} <span class="badge">${term.frequency}</span></a></li>
							</#if>
						</#list>
					</#list>
				</ul>
			</div>
		</div>
	</nav>	
</@>	

<div class="container">
	<#if true>
		
			
				<h2 class="h2">Default template</h2>
			
			 <div class="container">
				<#if results?has_content >
					<#list results as group>
						<#assign key = group.key />
						<div class="panel panel-default">
							<div class="panel-heading">
								${Request.facets[key]}
							</div>
							 
							<div class="panel-body">
								<#list group.documents[0..*3] as document>
									<div class="col-md-4"> 
										<#assign assetEntry = assetEntryLocalService.getEntry(document.entryClassName, document.entryClassPK?number)>
										<#assign entryUrl = Request.assetPublisherHelper.getAssetViewURL(Request.renderRequest, Request.renderResponse, assetEntry, true)>
										<#if document.entryClassName == "com.liferay.journal.model.JournalArticle">
											<#assign article = journalArticleLocalService.fetchArticle(document.groupId?number, document.articleId)>  
											<#assign content = journalArticleLocalService.getArticleContent(article, Request.renderRequest.getPreferences().getValue("ddm-"+document.get("ddmStructureKey"), document.get(ddmTemplateKey)), "VIEW", locale, Request.portletRequest, themeDisplay)>
											${content?replace("{entryUrl}", entryUrl)}
										<#else>
										<h2><a href="${entryUrl}">${document.get("title")}</a></h2>
											<p>can't display ${document.entryClassName}</p>
										</#if>
									</div>
								</#list>
							</div>
							
						</div>
					</#list>
		
				</#if>
			</div>
			
		
	</#if>
</@>

<#-- old way of templating 
	<h2 class="h2">Grouped results</h2>
	<#if Request.groupedDocuments?has_content >
		
		<#list Request.facets?keys as key>
			<#if Request.groupedDocuments[key]??  && true>
				<#assign docs=Request.groupedDocuments[key][0..*3] />
			
				
				<@liferay_ddm["template-renderer"] 
					className="com.liferay.journal.model.JournalArticle"
					displayStyle=Request.displayStyle[key?counter]
					displayStyleGroupId=Request.displayStyleGroupId[key?counter]
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
								<#assign doc_length = doc.content?length />
								
									<p>${htmlUtil.escape(doc.content[0..*250])}</p>
								
								</div>
							</#list>
						</div>
					</div>
				</@>
			</#if>
			
			
		</#list>
	</#if>
-->
	<hr/>
	<div>
		<a href="${viewURL}" class="btn">Return to search</a>
	</div>
</div>

