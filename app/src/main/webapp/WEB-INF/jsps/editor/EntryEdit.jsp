<%--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  The ASF licenses this file to You
  under the Apache License, Version 2.0 (the "License"); you may not
  use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.  For additional information regarding
  copyright in this work, please see the NOTICE file in the top level
  directory of this distribution.
--%>
<%@ include file="/WEB-INF/jsps/taglibs-struts2.jsp" %>

<link rel="stylesheet" media="all" href='<s:url value="/roller-ui/jquery-ui-1.11.0/jquery-ui.min.css"/>'/>

<script src="<s:url value="/roller-ui/scripts/jquery-2.1.1.min.js" />"></script>
<script src='<s:url value="/roller-ui/jquery-ui-1.11.0/jquery-ui.min.js"/>'></script>

<style>
    #tagAutoCompleteWrapper {
        width: 40em; /* set width here or else widget will expand to fit its container */
        padding-bottom: 2em;
    }
</style>

<%-- Titling, processing actions different between entry add and edit --%>
<s:if test="actionName == 'entryEdit'">
    <s:set var="subtitleKey">weblogEdit.subtitle.editEntry</s:set>
    <s:set var="mainAction">entryEdit</s:set>
</s:if>
<s:else>
    <s:set var="subtitleKey">weblogEdit.subtitle.newEntry</s:set>
    <s:set var="mainAction">entryAdd</s:set>
</s:else>

<p class="subtitle">
    <s:text name="%{#subtitleKey}">
        <s:param value="actionWeblog.handle"/>
    </s:text>
</p>

<s:form id="entry" theme="bootstrap" cssClass="form-horizontal">
    <s:hidden name="salt"/>
    <s:hidden name="weblog"/>
    <s:hidden name="bean.status"/>
    <s:if test="actionName == 'entryEdit'">
        <s:hidden name="bean.id"/>
    </s:if>

    <%-- ================================================================== --%>
    <%-- Title, category, dates and other metadata --%>

    <%-- title --%>
    <s:textfield label="%{getText('weblogEdit.title')}" name="bean.title" maxlength="255" tabindex="1"/>

    <%-- status --%>
    <div class="form-group">
        <label class="col-sm-3 control-label" for="weblogEdit.status"><s:text name="weblogEdit.status"/></label>

        <div class="col-sm-9 controls">
            <s:if test="bean.published">
                <span class="label label-success">
                    <s:text name="weblogEdit.published"/>
                    (<s:text name="weblogEdit.updateTime"/>
                    <s:date name="entry.updateTime"/>)
                </span>
            </s:if>
            <s:elseif test="bean.draft">
                <span class="label label-info">
                    <s:text name="weblogEdit.draft"/>
                    (<s:text name="weblogEdit.updateTime"/>
                    <s:date name="entry.updateTime"/>)
                </span>
            </s:elseif>
            <s:elseif test="bean.pending">
                <span class="label label-warning">
                    <s:text name="weblogEdit.pending"/>
                    (<s:text name="weblogEdit.updateTime"/>
                    <s:date name="entry.updateTime"/>)
                </span>
            </s:elseif>
            <s:elseif test="bean.scheduled">
                <span class="label label-info">
                    <s:text name="weblogEdit.scheduled"/>
                    (<s:text name="weblogEdit.updateTime"/>
                    <s:date name="entry.updateTime"/>)
                </span>
            </s:elseif>
            <s:else>
                <span class="label label-danger"><s:text name="weblogEdit.unsaved"/></span>
            </s:else>
        </div>

    </div>

    <%-- permalink --%>
    <s:if test="actionName == 'entryEdit'">
        <div class="form-group">
            <label for="entry_bean_permalink"><s:text name="weblogEdit.permaLink"/></label>
            <s:if test="bean.published">
                <a id="entry_bean_permalink" href='<s:property value="entry.permalink" />'>
                    <s:property value="entry.permalink"/>
                </a>
                <img src='<s:url value="/images/launch-link.png"/>'/>
            </s:if>
            <s:else>
                <s:property value="entry.permalink"/>
            </s:else>
        </div>
    </s:if>

    <%-- tags --%>
    <s:textfield label="%{getText('weblogEdit.tags')}" id="tagAutoComplete" name="bean.tagsAsString"
                 maxlength="255" tabindex="3"/>

    <%-- category --%>
    <s:select label="%{getText('weblogEdit.category')}" name="bean.categoryId"
              list="categories" listKey="id" listValue="name"/>

    <s:if test="actionWeblog.enableMultiLang">
        <s:select label="%{getText('weblogEdit.locale')}" name="bean.locale" size="1"
                  list="localesList" listValue="displayName"/>
    </s:if>

    <s:else>
        <s:hidden name="bean.locale"/>
    </s:else>


    <div class="panel-group" id="accordion">

        <%-- Weblog editor --%>

        <s:include value="%{editor.jspPage}"/>

        <%-- Plugins --%>

        <s:if test="!entryPlugins.isEmpty">

            <div class="panel panel-default" id="panel-plugins">
                <div class="panel-heading">

                    <h4 class="panel-title">
                        <a aria-expanded="false"
                           data-toggle="collapse" data-target="#collapsePlugins" href="#collapsePlugins">
                            <s:text name="weblogEdit.pluginsToApply"/> </a>
                    </h4>

                </div>
                <div id="collapsePlugins" class="panel-collapse collapse in">
                    <div class="panel-body">

                        <s:checkboxlist name="bean.plugins" list="entryPlugins" listKey="name" listValue="name"/>

                    </div>
                </div>
            </div>

        </s:if>

        <%-- Advanced settings --%>

        <div class="panel panel-default" id="panel-settings">
            <div class="panel-heading">

                <h4 class="panel-title">
                    <a class="accordion-toggle" aria-expanded="false"
                       data-toggle="collapse" data-parent="#collapseAdvanced" href="#collapseAdvanced">
                        <s:text name="weblogEdit.miscSettings"/> </a>
                </h4>

            </div>
            <div id="collapseAdvanced" class="panel-collapse collapse in">
                <div class="panel-body">

                    <div class="form-group">

                        <label class="col-sm-3 control-label"><s:text name="weblogEdit.pubTime"/></label>
                        
                        <div class="col-sm-9 controls">
                            
                            <s:select theme="simple" name="bean.hours" list="hoursList"/> :
                            <s:select theme="simple" name="bean.minutes" list="minutesList"/> : 
                            <s:select theme="simple" name="bean.seconds" list="secondsList"/>
                            &nbsp;&nbsp;
                            <script>
                                $(function () {
                                    $("#entry_bean_dateString").datepicker({
                                        showOn: "button",
                                        buttonImage: "../../images/calendar.png",
                                        buttonImageOnly: true,
                                        changeMonth: true,
                                        changeYear: true
                                    });
                                });
                            </script>
                            &nbsp;&nbsp;
                            <s:textfield theme="simple" name="bean.dateString" readonly="true"/>
                            &nbsp;&nbsp;
                            <s:property value="actionWeblog.timeZone"/>
                            
                        </div>

                    </div>

                    
                    <%--
                    <s:checkbox label="%{getText('weblogEdit.allowComments')}" name="bean.allowComments"/>
                    <s:select label="%{getText('weblogEdit.commentDays')}" name="bean.commentDays" 
                              list="commentDaysList" listKey="key" listValue="value"/>
                    --%>

                    <%-- use raw HTML tags here, Struts-Bootstrap does not provide this --%>                    
                    <div class="form-group">
                        
                        <label class="col-sm-3 control-label" for="entry_bean_allowComments">
                            <s:text name="weblogEdit.allowComments" />
                        </label>
                        
                        <div class="col-sm-9 controls">

                            <div class="input-group">
                                
                                <span class="input-group-addon">
                                    <input type="checkbox" name="bean.allowComments"
                                           value="true" checked="checked" id="entry_bean_allowComments"/>
                                    <input type="hidden" id="__checkbox_entry_bean_allowComments"
                                           name="__checkbox_bean.allowComments" value="true"/> 
                                </span>

                                <select name="bean.commentDays" id="entry_bean_commentDays" class="form-control">
                                    <option value="0" selected="selected">unlimited days</option>
                                    <option value="3">3 days</option>
                                    <option value="7">7 days</option>
                                    <option value="14">14 days</option>
                                    <option value="30">30 days</option>
                                    <option value="60">60 days</option>
                                    <option value="90">90 days</option>
                                </select>
                                    
                            </div> <!-- /input-group -->
                            
                        </div>
                        
                    </div> <!-- /form-group -->

                    <s:checkbox label="%{getText('weblogEdit.rightToLeft')}" name="bean.rightToLeft"/>
                   
                    <%-- global admin can pin items to front page weblog --%>
                    <s:if test="authenticatedUser.hasGlobalPermission('admin')">
                        <s:checkbox label="%{getText('weblogEdit.pinnedToMain')}" name="bean.pinnedToMain"
                        tooltop="%{getText('weblogEdit.pinnedToMain.tooltip')}" />
                    </s:if>

                    <s:textfield label="%{getText('weblogEdit.searchDescription')}" name="bean.searchDescription" 
                                 maxlength="255" tooltip="%{getText('weblogEdit.searchDescription.tooltip')}" />
                
                    <s:textfield label="%{getText('weblogEdit.enclosureURL')}" name="bean.enclosureURL" 
                                 maxlength="255" tooltip="%{getText('weblogEdit.enclosureURL.tooltip')}" />
                
                    <s:if test="actionName == 'entryEdit'">
                        <s:if test="bean.enclosureURL != null">
                            <s:text name="weblogEdit.enclosureType"/>:
                            <s:property value='entry.findEntryAttribute("att_mediacast_type")'/>
                            <s:text name="weblogEdit.enclosureLength"/>:
                            <s:property value='entry.findEntryAttribute("att_mediacast_length")'/>
                        </s:if>
                    </s:if>
                    
                </div>
                
            </div>
            
        </div> 
    
    </div>
    

    <%-- ================================================================== --%>
    <%-- The button box --%>

        <%-- save draft --%>
        <s:submit cssClass="btn btn-default" 
                  value="%{getText('weblogEdit.save')}" 
                  action="%{#mainAction}!saveDraft"/>

        <s:if test="actionName == 'entryEdit'">
            
            <%-- preview mode --%>
            <input class="btn btn-default" type="button" name="fullPreview"
                   value="<s:text name='weblogEdit.fullPreviewMode' />"
                   onclick="fullPreviewMode()"/>
        </s:if>
        <s:if test="userAnAuthor">
            
            <%-- publish --%>
            <s:submit cssClass="btn btn-default" 
                      value="%{getText('weblogEdit.post')}" 
                      action="%{#mainAction}!publish"/>
        </s:if>
        <s:else>
            
            <%-- submit for review --%>
            <s:submit cssClass="btn btn-default" 
                      value="%{getText('weblogEdit.submitForReview')}" 
                      action="%{#mainAction}!publish" />
        </s:else>
    
        <%-- delete --%>
        <s:if test="actionName == 'entryEdit'">
            <span style="float:right">
                <s:url var="removeUrl" action="entryRemove">
                    <s:param name="weblog" value="actionWeblog.handle"/>
                    <s:param name="removeId" value="%{entry.id}"/>
                </s:url>
                <input class="btn btn-default" type="button" 
                       value="<s:text name='weblogEdit.deleteEntry'/>"
                       onclick="window.location='<s:property value="removeUrl" escape="false"/>'"/>
            </span>
        </s:if>


    <%-- ================================================================== --%>
    <%-- Trackback control --%>

    <s:if test="actionName == 'entryEdit' && userAnAuthor">
        <br/>
        <h2><s:text name="weblogEdit.trackback"/></h2>
        <s:text name="weblogEdit.trackbackUrl"/>
        <br/>
        <s:textfield name="trackbackUrl" size="80" maxlength="255" style="width:35%"/>

        <s:submit value="%{getText('weblogEdit.sendTrackback')}" action="entryEdit!trackback"/>
    </s:if>

</s:form>

<script>
    function fullPreviewMode() {
        window.open('<s:property value="previewURL" />');
    }

    $(function () {
        function split(val) {
            return val.split(/ \s*/);
        }

        function extractLast(term) {
            return split(term).pop();
        }

        $("#tagAutoComplete")
        // don't navigate away from the field on tab when selecting an item
                .bind("keydown", function (event) {
                    if (event.keyCode === $.ui.keyCode.TAB && $(this).autocomplete("instance").menu.active) {
                        event.preventDefault();
                    }
                })
                .autocomplete({
                    delay: 500,
                    source: function (request, response) {
                        $.getJSON("<s:property value='jsonAutocompleteUrl' />", {
                                    format: 'json',
                                    prefix: extractLast(request.term)
                                },
                                function (data) {
                                    response($.map(data.tagcounts, function (dataValue) {
                                        return {
                                            value: dataValue.tag
                                        };
                                    }))
                                })
                    },
                    focus: function () {
                        // prevent value inserted on focus
                        return false;
                    },
                    select: function (event, ui) {
                        var terms = split(this.value);
                        // remove the current input
                        terms.pop();
                        // add the selected item
                        terms.push(ui.item.value);
                        // add placeholder to get the space at the end
                        terms.push("");
                        this.value = terms.join(" ");
                        return false;
                    }
                });
    });
</script>
