
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Apps Script
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages and executes Google Apps Script projects.
## 
## 
## https://developers.google.com/apps-script/api/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "script"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ScriptProcessesList_588710 = ref object of OpenApiRestCall_588441
proc url_ScriptProcessesList_588712(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProcessesList_588711(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## List information about processes made by or on behalf of a user,
  ## such as process type and current status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   userProcessFilter.scriptId: JString
  ##                             : Optional field used to limit returned processes to those originating from
  ## projects with a specific script ID.
  ##   userProcessFilter.deploymentId: JString
  ##                                 : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   userProcessFilter.projectName: JString
  ##                                : Optional field used to limit returned processes to those originating from
  ## projects with project names containing a specific string.
  ##   userProcessFilter.userAccessLevels: JArray
  ##                                     : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   userProcessFilter.types: JArray
  ##                          : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   userProcessFilter.functionName: JString
  ##                                 : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  ##   userProcessFilter.endTime: JString
  ##                            : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   userProcessFilter.startTime: JString
  ##                              : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   userProcessFilter.statuses: JArray
  ##                             : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  section = newJObject()
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("userProcessFilter.scriptId")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "userProcessFilter.scriptId", valid_588825
  var valid_588826 = query.getOrDefault("userProcessFilter.deploymentId")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "userProcessFilter.deploymentId", valid_588826
  var valid_588827 = query.getOrDefault("fields")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "fields", valid_588827
  var valid_588828 = query.getOrDefault("pageToken")
  valid_588828 = validateParameter(valid_588828, JString, required = false,
                                 default = nil)
  if valid_588828 != nil:
    section.add "pageToken", valid_588828
  var valid_588829 = query.getOrDefault("quotaUser")
  valid_588829 = validateParameter(valid_588829, JString, required = false,
                                 default = nil)
  if valid_588829 != nil:
    section.add "quotaUser", valid_588829
  var valid_588843 = query.getOrDefault("alt")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = newJString("json"))
  if valid_588843 != nil:
    section.add "alt", valid_588843
  var valid_588844 = query.getOrDefault("oauth_token")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "oauth_token", valid_588844
  var valid_588845 = query.getOrDefault("callback")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "callback", valid_588845
  var valid_588846 = query.getOrDefault("access_token")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "access_token", valid_588846
  var valid_588847 = query.getOrDefault("uploadType")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "uploadType", valid_588847
  var valid_588848 = query.getOrDefault("userProcessFilter.projectName")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "userProcessFilter.projectName", valid_588848
  var valid_588849 = query.getOrDefault("userProcessFilter.userAccessLevels")
  valid_588849 = validateParameter(valid_588849, JArray, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "userProcessFilter.userAccessLevels", valid_588849
  var valid_588850 = query.getOrDefault("userProcessFilter.types")
  valid_588850 = validateParameter(valid_588850, JArray, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "userProcessFilter.types", valid_588850
  var valid_588851 = query.getOrDefault("key")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "key", valid_588851
  var valid_588852 = query.getOrDefault("$.xgafv")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = newJString("1"))
  if valid_588852 != nil:
    section.add "$.xgafv", valid_588852
  var valid_588853 = query.getOrDefault("pageSize")
  valid_588853 = validateParameter(valid_588853, JInt, required = false, default = nil)
  if valid_588853 != nil:
    section.add "pageSize", valid_588853
  var valid_588854 = query.getOrDefault("userProcessFilter.functionName")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "userProcessFilter.functionName", valid_588854
  var valid_588855 = query.getOrDefault("userProcessFilter.endTime")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "userProcessFilter.endTime", valid_588855
  var valid_588856 = query.getOrDefault("prettyPrint")
  valid_588856 = validateParameter(valid_588856, JBool, required = false,
                                 default = newJBool(true))
  if valid_588856 != nil:
    section.add "prettyPrint", valid_588856
  var valid_588857 = query.getOrDefault("userProcessFilter.startTime")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "userProcessFilter.startTime", valid_588857
  var valid_588858 = query.getOrDefault("userProcessFilter.statuses")
  valid_588858 = validateParameter(valid_588858, JArray, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "userProcessFilter.statuses", valid_588858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588881: Call_ScriptProcessesList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List information about processes made by or on behalf of a user,
  ## such as process type and current status.
  ## 
  let valid = call_588881.validator(path, query, header, formData, body)
  let scheme = call_588881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588881.url(scheme.get, call_588881.host, call_588881.base,
                         call_588881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588881, url, valid)

proc call*(call_588952: Call_ScriptProcessesList_588710;
          uploadProtocol: string = ""; userProcessFilterScriptId: string = "";
          userProcessFilterDeploymentId: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; userProcessFilterProjectName: string = "";
          userProcessFilterUserAccessLevels: JsonNode = nil;
          userProcessFilterTypes: JsonNode = nil; key: string = ""; Xgafv: string = "1";
          pageSize: int = 0; userProcessFilterFunctionName: string = "";
          userProcessFilterEndTime: string = ""; prettyPrint: bool = true;
          userProcessFilterStartTime: string = "";
          userProcessFilterStatuses: JsonNode = nil): Recallable =
  ## scriptProcessesList
  ## List information about processes made by or on behalf of a user,
  ## such as process type and current status.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   userProcessFilterScriptId: string
  ##                            : Optional field used to limit returned processes to those originating from
  ## projects with a specific script ID.
  ##   userProcessFilterDeploymentId: string
  ##                                : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   userProcessFilterProjectName: string
  ##                               : Optional field used to limit returned processes to those originating from
  ## projects with project names containing a specific string.
  ##   userProcessFilterUserAccessLevels: JArray
  ##                                    : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   userProcessFilterTypes: JArray
  ##                         : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   userProcessFilterFunctionName: string
  ##                                : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  ##   userProcessFilterEndTime: string
  ##                           : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userProcessFilterStartTime: string
  ##                             : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   userProcessFilterStatuses: JArray
  ##                            : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  var query_588953 = newJObject()
  add(query_588953, "upload_protocol", newJString(uploadProtocol))
  add(query_588953, "userProcessFilter.scriptId",
      newJString(userProcessFilterScriptId))
  add(query_588953, "userProcessFilter.deploymentId",
      newJString(userProcessFilterDeploymentId))
  add(query_588953, "fields", newJString(fields))
  add(query_588953, "pageToken", newJString(pageToken))
  add(query_588953, "quotaUser", newJString(quotaUser))
  add(query_588953, "alt", newJString(alt))
  add(query_588953, "oauth_token", newJString(oauthToken))
  add(query_588953, "callback", newJString(callback))
  add(query_588953, "access_token", newJString(accessToken))
  add(query_588953, "uploadType", newJString(uploadType))
  add(query_588953, "userProcessFilter.projectName",
      newJString(userProcessFilterProjectName))
  if userProcessFilterUserAccessLevels != nil:
    query_588953.add "userProcessFilter.userAccessLevels",
                    userProcessFilterUserAccessLevels
  if userProcessFilterTypes != nil:
    query_588953.add "userProcessFilter.types", userProcessFilterTypes
  add(query_588953, "key", newJString(key))
  add(query_588953, "$.xgafv", newJString(Xgafv))
  add(query_588953, "pageSize", newJInt(pageSize))
  add(query_588953, "userProcessFilter.functionName",
      newJString(userProcessFilterFunctionName))
  add(query_588953, "userProcessFilter.endTime",
      newJString(userProcessFilterEndTime))
  add(query_588953, "prettyPrint", newJBool(prettyPrint))
  add(query_588953, "userProcessFilter.startTime",
      newJString(userProcessFilterStartTime))
  if userProcessFilterStatuses != nil:
    query_588953.add "userProcessFilter.statuses", userProcessFilterStatuses
  result = call_588952.call(nil, query_588953, nil, nil, nil)

var scriptProcessesList* = Call_ScriptProcessesList_588710(
    name: "scriptProcessesList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes",
    validator: validate_ScriptProcessesList_588711, base: "/",
    url: url_ScriptProcessesList_588712, schemes: {Scheme.Https})
type
  Call_ScriptProcessesListScriptProcesses_588993 = ref object of OpenApiRestCall_588441
proc url_ScriptProcessesListScriptProcesses_588995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProcessesListScriptProcesses_588994(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   scriptProcessFilter.userAccessLevels: JArray
  ##                                       : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptProcessFilter.startTime: JString
  ##                                : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   alt: JString
  ##      : Data format for response.
  ##   scriptProcessFilter.types: JArray
  ##                            : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   scriptProcessFilter.endTime: JString
  ##                              : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   scriptProcessFilter.deploymentId: JString
  ##                                   : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   scriptProcessFilter.statuses: JArray
  ##                               : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   scriptId: JString
  ##           : The script ID of the project whose processes are listed.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   scriptProcessFilter.functionName: JString
  ##                                   : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  section = newJObject()
  var valid_588996 = query.getOrDefault("scriptProcessFilter.userAccessLevels")
  valid_588996 = validateParameter(valid_588996, JArray, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "scriptProcessFilter.userAccessLevels", valid_588996
  var valid_588997 = query.getOrDefault("upload_protocol")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "upload_protocol", valid_588997
  var valid_588998 = query.getOrDefault("fields")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "fields", valid_588998
  var valid_588999 = query.getOrDefault("pageToken")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "pageToken", valid_588999
  var valid_589000 = query.getOrDefault("quotaUser")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "quotaUser", valid_589000
  var valid_589001 = query.getOrDefault("scriptProcessFilter.startTime")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "scriptProcessFilter.startTime", valid_589001
  var valid_589002 = query.getOrDefault("alt")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = newJString("json"))
  if valid_589002 != nil:
    section.add "alt", valid_589002
  var valid_589003 = query.getOrDefault("scriptProcessFilter.types")
  valid_589003 = validateParameter(valid_589003, JArray, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "scriptProcessFilter.types", valid_589003
  var valid_589004 = query.getOrDefault("oauth_token")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "oauth_token", valid_589004
  var valid_589005 = query.getOrDefault("callback")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "callback", valid_589005
  var valid_589006 = query.getOrDefault("access_token")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "access_token", valid_589006
  var valid_589007 = query.getOrDefault("uploadType")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "uploadType", valid_589007
  var valid_589008 = query.getOrDefault("scriptProcessFilter.endTime")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "scriptProcessFilter.endTime", valid_589008
  var valid_589009 = query.getOrDefault("scriptProcessFilter.deploymentId")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "scriptProcessFilter.deploymentId", valid_589009
  var valid_589010 = query.getOrDefault("scriptProcessFilter.statuses")
  valid_589010 = validateParameter(valid_589010, JArray, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "scriptProcessFilter.statuses", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("$.xgafv")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("1"))
  if valid_589012 != nil:
    section.add "$.xgafv", valid_589012
  var valid_589013 = query.getOrDefault("pageSize")
  valid_589013 = validateParameter(valid_589013, JInt, required = false, default = nil)
  if valid_589013 != nil:
    section.add "pageSize", valid_589013
  var valid_589014 = query.getOrDefault("scriptId")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "scriptId", valid_589014
  var valid_589015 = query.getOrDefault("prettyPrint")
  valid_589015 = validateParameter(valid_589015, JBool, required = false,
                                 default = newJBool(true))
  if valid_589015 != nil:
    section.add "prettyPrint", valid_589015
  var valid_589016 = query.getOrDefault("scriptProcessFilter.functionName")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "scriptProcessFilter.functionName", valid_589016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589017: Call_ScriptProcessesListScriptProcesses_588993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ## 
  let valid = call_589017.validator(path, query, header, formData, body)
  let scheme = call_589017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589017.url(scheme.get, call_589017.host, call_589017.base,
                         call_589017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589017, url, valid)

proc call*(call_589018: Call_ScriptProcessesListScriptProcesses_588993;
          scriptProcessFilterUserAccessLevels: JsonNode = nil;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; scriptProcessFilterStartTime: string = "";
          alt: string = "json"; scriptProcessFilterTypes: JsonNode = nil;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; scriptProcessFilterEndTime: string = "";
          scriptProcessFilterDeploymentId: string = "";
          scriptProcessFilterStatuses: JsonNode = nil; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; scriptId: string = "";
          prettyPrint: bool = true; scriptProcessFilterFunctionName: string = ""): Recallable =
  ## scriptProcessesListScriptProcesses
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ##   scriptProcessFilterUserAccessLevels: JArray
  ##                                      : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptProcessFilterStartTime: string
  ##                               : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   alt: string
  ##      : Data format for response.
  ##   scriptProcessFilterTypes: JArray
  ##                           : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   scriptProcessFilterEndTime: string
  ##                             : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   scriptProcessFilterDeploymentId: string
  ##                                  : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   scriptProcessFilterStatuses: JArray
  ##                              : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   scriptId: string
  ##           : The script ID of the project whose processes are listed.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   scriptProcessFilterFunctionName: string
  ##                                  : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  var query_589019 = newJObject()
  if scriptProcessFilterUserAccessLevels != nil:
    query_589019.add "scriptProcessFilter.userAccessLevels",
                    scriptProcessFilterUserAccessLevels
  add(query_589019, "upload_protocol", newJString(uploadProtocol))
  add(query_589019, "fields", newJString(fields))
  add(query_589019, "pageToken", newJString(pageToken))
  add(query_589019, "quotaUser", newJString(quotaUser))
  add(query_589019, "scriptProcessFilter.startTime",
      newJString(scriptProcessFilterStartTime))
  add(query_589019, "alt", newJString(alt))
  if scriptProcessFilterTypes != nil:
    query_589019.add "scriptProcessFilter.types", scriptProcessFilterTypes
  add(query_589019, "oauth_token", newJString(oauthToken))
  add(query_589019, "callback", newJString(callback))
  add(query_589019, "access_token", newJString(accessToken))
  add(query_589019, "uploadType", newJString(uploadType))
  add(query_589019, "scriptProcessFilter.endTime",
      newJString(scriptProcessFilterEndTime))
  add(query_589019, "scriptProcessFilter.deploymentId",
      newJString(scriptProcessFilterDeploymentId))
  if scriptProcessFilterStatuses != nil:
    query_589019.add "scriptProcessFilter.statuses", scriptProcessFilterStatuses
  add(query_589019, "key", newJString(key))
  add(query_589019, "$.xgafv", newJString(Xgafv))
  add(query_589019, "pageSize", newJInt(pageSize))
  add(query_589019, "scriptId", newJString(scriptId))
  add(query_589019, "prettyPrint", newJBool(prettyPrint))
  add(query_589019, "scriptProcessFilter.functionName",
      newJString(scriptProcessFilterFunctionName))
  result = call_589018.call(nil, query_589019, nil, nil, nil)

var scriptProcessesListScriptProcesses* = Call_ScriptProcessesListScriptProcesses_588993(
    name: "scriptProcessesListScriptProcesses", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes:listScriptProcesses",
    validator: validate_ScriptProcessesListScriptProcesses_588994, base: "/",
    url: url_ScriptProcessesListScriptProcesses_588995, schemes: {Scheme.Https})
type
  Call_ScriptProjectsCreate_589020 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsCreate_589022(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProjectsCreate_589021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589023 = query.getOrDefault("upload_protocol")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "upload_protocol", valid_589023
  var valid_589024 = query.getOrDefault("fields")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "fields", valid_589024
  var valid_589025 = query.getOrDefault("quotaUser")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "quotaUser", valid_589025
  var valid_589026 = query.getOrDefault("alt")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("json"))
  if valid_589026 != nil:
    section.add "alt", valid_589026
  var valid_589027 = query.getOrDefault("oauth_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "oauth_token", valid_589027
  var valid_589028 = query.getOrDefault("callback")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "callback", valid_589028
  var valid_589029 = query.getOrDefault("access_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "access_token", valid_589029
  var valid_589030 = query.getOrDefault("uploadType")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "uploadType", valid_589030
  var valid_589031 = query.getOrDefault("key")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "key", valid_589031
  var valid_589032 = query.getOrDefault("$.xgafv")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("1"))
  if valid_589032 != nil:
    section.add "$.xgafv", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589035: Call_ScriptProjectsCreate_589020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_ScriptProjectsCreate_589020;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## scriptProjectsCreate
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589037 = newJObject()
  var body_589038 = newJObject()
  add(query_589037, "upload_protocol", newJString(uploadProtocol))
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "callback", newJString(callback))
  add(query_589037, "access_token", newJString(accessToken))
  add(query_589037, "uploadType", newJString(uploadType))
  add(query_589037, "key", newJString(key))
  add(query_589037, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589038 = body
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(nil, query_589037, nil, nil, body_589038)

var scriptProjectsCreate* = Call_ScriptProjectsCreate_589020(
    name: "scriptProjectsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects",
    validator: validate_ScriptProjectsCreate_589021, base: "/",
    url: url_ScriptProjectsCreate_589022, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGet_589039 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsGet_589041(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsGet_589040(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a script project's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589056 = path.getOrDefault("scriptId")
  valid_589056 = validateParameter(valid_589056, JString, required = true,
                                 default = nil)
  if valid_589056 != nil:
    section.add "scriptId", valid_589056
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589057 = query.getOrDefault("upload_protocol")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "upload_protocol", valid_589057
  var valid_589058 = query.getOrDefault("fields")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "fields", valid_589058
  var valid_589059 = query.getOrDefault("quotaUser")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "quotaUser", valid_589059
  var valid_589060 = query.getOrDefault("alt")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("json"))
  if valid_589060 != nil:
    section.add "alt", valid_589060
  var valid_589061 = query.getOrDefault("oauth_token")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "oauth_token", valid_589061
  var valid_589062 = query.getOrDefault("callback")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "callback", valid_589062
  var valid_589063 = query.getOrDefault("access_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "access_token", valid_589063
  var valid_589064 = query.getOrDefault("uploadType")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "uploadType", valid_589064
  var valid_589065 = query.getOrDefault("key")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "key", valid_589065
  var valid_589066 = query.getOrDefault("$.xgafv")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("1"))
  if valid_589066 != nil:
    section.add "$.xgafv", valid_589066
  var valid_589067 = query.getOrDefault("prettyPrint")
  valid_589067 = validateParameter(valid_589067, JBool, required = false,
                                 default = newJBool(true))
  if valid_589067 != nil:
    section.add "prettyPrint", valid_589067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589068: Call_ScriptProjectsGet_589039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a script project's metadata.
  ## 
  let valid = call_589068.validator(path, query, header, formData, body)
  let scheme = call_589068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589068.url(scheme.get, call_589068.host, call_589068.base,
                         call_589068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589068, url, valid)

proc call*(call_589069: Call_ScriptProjectsGet_589039; scriptId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## scriptProjectsGet
  ## Gets a script project's metadata.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589070 = newJObject()
  var query_589071 = newJObject()
  add(query_589071, "upload_protocol", newJString(uploadProtocol))
  add(query_589071, "fields", newJString(fields))
  add(query_589071, "quotaUser", newJString(quotaUser))
  add(query_589071, "alt", newJString(alt))
  add(query_589071, "oauth_token", newJString(oauthToken))
  add(query_589071, "callback", newJString(callback))
  add(query_589071, "access_token", newJString(accessToken))
  add(query_589071, "uploadType", newJString(uploadType))
  add(query_589071, "key", newJString(key))
  add(query_589071, "$.xgafv", newJString(Xgafv))
  add(path_589070, "scriptId", newJString(scriptId))
  add(query_589071, "prettyPrint", newJBool(prettyPrint))
  result = call_589069.call(path_589070, query_589071, nil, nil, nil)

var scriptProjectsGet* = Call_ScriptProjectsGet_589039(name: "scriptProjectsGet",
    meth: HttpMethod.HttpGet, host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}", validator: validate_ScriptProjectsGet_589040,
    base: "/", url: url_ScriptProjectsGet_589041, schemes: {Scheme.Https})
type
  Call_ScriptProjectsUpdateContent_589092 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsUpdateContent_589094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsUpdateContent_589093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the content of the specified script project.
  ## This content is stored as the HEAD version, and is used when the script is
  ## executed as a trigger, in the script editor, in add-on preview mode, or as
  ## a web app or Apps Script API in development mode. This clears all the
  ## existing files in the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589095 = path.getOrDefault("scriptId")
  valid_589095 = validateParameter(valid_589095, JString, required = true,
                                 default = nil)
  if valid_589095 != nil:
    section.add "scriptId", valid_589095
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589096 = query.getOrDefault("upload_protocol")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "upload_protocol", valid_589096
  var valid_589097 = query.getOrDefault("fields")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "fields", valid_589097
  var valid_589098 = query.getOrDefault("quotaUser")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "quotaUser", valid_589098
  var valid_589099 = query.getOrDefault("alt")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = newJString("json"))
  if valid_589099 != nil:
    section.add "alt", valid_589099
  var valid_589100 = query.getOrDefault("oauth_token")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "oauth_token", valid_589100
  var valid_589101 = query.getOrDefault("callback")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "callback", valid_589101
  var valid_589102 = query.getOrDefault("access_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "access_token", valid_589102
  var valid_589103 = query.getOrDefault("uploadType")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "uploadType", valid_589103
  var valid_589104 = query.getOrDefault("key")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "key", valid_589104
  var valid_589105 = query.getOrDefault("$.xgafv")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("1"))
  if valid_589105 != nil:
    section.add "$.xgafv", valid_589105
  var valid_589106 = query.getOrDefault("prettyPrint")
  valid_589106 = validateParameter(valid_589106, JBool, required = false,
                                 default = newJBool(true))
  if valid_589106 != nil:
    section.add "prettyPrint", valid_589106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589108: Call_ScriptProjectsUpdateContent_589092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the content of the specified script project.
  ## This content is stored as the HEAD version, and is used when the script is
  ## executed as a trigger, in the script editor, in add-on preview mode, or as
  ## a web app or Apps Script API in development mode. This clears all the
  ## existing files in the project.
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_ScriptProjectsUpdateContent_589092; scriptId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## scriptProjectsUpdateContent
  ## Updates the content of the specified script project.
  ## This content is stored as the HEAD version, and is used when the script is
  ## executed as a trigger, in the script editor, in add-on preview mode, or as
  ## a web app or Apps Script API in development mode. This clears all the
  ## existing files in the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  var body_589112 = newJObject()
  add(query_589111, "upload_protocol", newJString(uploadProtocol))
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "callback", newJString(callback))
  add(query_589111, "access_token", newJString(accessToken))
  add(query_589111, "uploadType", newJString(uploadType))
  add(query_589111, "key", newJString(key))
  add(query_589111, "$.xgafv", newJString(Xgafv))
  add(path_589110, "scriptId", newJString(scriptId))
  if body != nil:
    body_589112 = body
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  result = call_589109.call(path_589110, query_589111, nil, nil, body_589112)

var scriptProjectsUpdateContent* = Call_ScriptProjectsUpdateContent_589092(
    name: "scriptProjectsUpdateContent", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsUpdateContent_589093, base: "/",
    url: url_ScriptProjectsUpdateContent_589094, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetContent_589072 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsGetContent_589074(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/content")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsGetContent_589073(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the content of the script project, including the code source and
  ## metadata for each script file.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589075 = path.getOrDefault("scriptId")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "scriptId", valid_589075
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   versionNumber: JInt
  ##                : The version number of the project to retrieve. If not provided, the
  ## project's HEAD version is returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589076 = query.getOrDefault("upload_protocol")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "upload_protocol", valid_589076
  var valid_589077 = query.getOrDefault("versionNumber")
  valid_589077 = validateParameter(valid_589077, JInt, required = false, default = nil)
  if valid_589077 != nil:
    section.add "versionNumber", valid_589077
  var valid_589078 = query.getOrDefault("fields")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "fields", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("callback")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "callback", valid_589082
  var valid_589083 = query.getOrDefault("access_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "access_token", valid_589083
  var valid_589084 = query.getOrDefault("uploadType")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "uploadType", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("$.xgafv")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("1"))
  if valid_589086 != nil:
    section.add "$.xgafv", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589088: Call_ScriptProjectsGetContent_589072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the content of the script project, including the code source and
  ## metadata for each script file.
  ## 
  let valid = call_589088.validator(path, query, header, formData, body)
  let scheme = call_589088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589088.url(scheme.get, call_589088.host, call_589088.base,
                         call_589088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589088, url, valid)

proc call*(call_589089: Call_ScriptProjectsGetContent_589072; scriptId: string;
          uploadProtocol: string = ""; versionNumber: int = 0; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## scriptProjectsGetContent
  ## Gets the content of the script project, including the code source and
  ## metadata for each script file.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   versionNumber: int
  ##                : The version number of the project to retrieve. If not provided, the
  ## project's HEAD version is returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589090 = newJObject()
  var query_589091 = newJObject()
  add(query_589091, "upload_protocol", newJString(uploadProtocol))
  add(query_589091, "versionNumber", newJInt(versionNumber))
  add(query_589091, "fields", newJString(fields))
  add(query_589091, "quotaUser", newJString(quotaUser))
  add(query_589091, "alt", newJString(alt))
  add(query_589091, "oauth_token", newJString(oauthToken))
  add(query_589091, "callback", newJString(callback))
  add(query_589091, "access_token", newJString(accessToken))
  add(query_589091, "uploadType", newJString(uploadType))
  add(query_589091, "key", newJString(key))
  add(query_589091, "$.xgafv", newJString(Xgafv))
  add(path_589090, "scriptId", newJString(scriptId))
  add(query_589091, "prettyPrint", newJBool(prettyPrint))
  result = call_589089.call(path_589090, query_589091, nil, nil, nil)

var scriptProjectsGetContent* = Call_ScriptProjectsGetContent_589072(
    name: "scriptProjectsGetContent", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsGetContent_589073, base: "/",
    url: url_ScriptProjectsGetContent_589074, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsCreate_589134 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsDeploymentsCreate_589136(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/deployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsDeploymentsCreate_589135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a deployment of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589137 = path.getOrDefault("scriptId")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "scriptId", valid_589137
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589138 = query.getOrDefault("upload_protocol")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "upload_protocol", valid_589138
  var valid_589139 = query.getOrDefault("fields")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "fields", valid_589139
  var valid_589140 = query.getOrDefault("quotaUser")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "quotaUser", valid_589140
  var valid_589141 = query.getOrDefault("alt")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = newJString("json"))
  if valid_589141 != nil:
    section.add "alt", valid_589141
  var valid_589142 = query.getOrDefault("oauth_token")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "oauth_token", valid_589142
  var valid_589143 = query.getOrDefault("callback")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "callback", valid_589143
  var valid_589144 = query.getOrDefault("access_token")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "access_token", valid_589144
  var valid_589145 = query.getOrDefault("uploadType")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "uploadType", valid_589145
  var valid_589146 = query.getOrDefault("key")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "key", valid_589146
  var valid_589147 = query.getOrDefault("$.xgafv")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("1"))
  if valid_589147 != nil:
    section.add "$.xgafv", valid_589147
  var valid_589148 = query.getOrDefault("prettyPrint")
  valid_589148 = validateParameter(valid_589148, JBool, required = false,
                                 default = newJBool(true))
  if valid_589148 != nil:
    section.add "prettyPrint", valid_589148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589150: Call_ScriptProjectsDeploymentsCreate_589134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment of an Apps Script project.
  ## 
  let valid = call_589150.validator(path, query, header, formData, body)
  let scheme = call_589150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589150.url(scheme.get, call_589150.host, call_589150.base,
                         call_589150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589150, url, valid)

proc call*(call_589151: Call_ScriptProjectsDeploymentsCreate_589134;
          scriptId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## scriptProjectsDeploymentsCreate
  ## Creates a deployment of an Apps Script project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589152 = newJObject()
  var query_589153 = newJObject()
  var body_589154 = newJObject()
  add(query_589153, "upload_protocol", newJString(uploadProtocol))
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "callback", newJString(callback))
  add(query_589153, "access_token", newJString(accessToken))
  add(query_589153, "uploadType", newJString(uploadType))
  add(query_589153, "key", newJString(key))
  add(query_589153, "$.xgafv", newJString(Xgafv))
  add(path_589152, "scriptId", newJString(scriptId))
  if body != nil:
    body_589154 = body
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  result = call_589151.call(path_589152, query_589153, nil, nil, body_589154)

var scriptProjectsDeploymentsCreate* = Call_ScriptProjectsDeploymentsCreate_589134(
    name: "scriptProjectsDeploymentsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsCreate_589135, base: "/",
    url: url_ScriptProjectsDeploymentsCreate_589136, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsList_589113 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsDeploymentsList_589115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/deployments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsDeploymentsList_589114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the deployments of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589116 = path.getOrDefault("scriptId")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "scriptId", valid_589116
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of deployments on each returned page. Defaults to 50.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589117 = query.getOrDefault("upload_protocol")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "upload_protocol", valid_589117
  var valid_589118 = query.getOrDefault("fields")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "fields", valid_589118
  var valid_589119 = query.getOrDefault("pageToken")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "pageToken", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("$.xgafv")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("1"))
  if valid_589127 != nil:
    section.add "$.xgafv", valid_589127
  var valid_589128 = query.getOrDefault("pageSize")
  valid_589128 = validateParameter(valid_589128, JInt, required = false, default = nil)
  if valid_589128 != nil:
    section.add "pageSize", valid_589128
  var valid_589129 = query.getOrDefault("prettyPrint")
  valid_589129 = validateParameter(valid_589129, JBool, required = false,
                                 default = newJBool(true))
  if valid_589129 != nil:
    section.add "prettyPrint", valid_589129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589130: Call_ScriptProjectsDeploymentsList_589113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the deployments of an Apps Script project.
  ## 
  let valid = call_589130.validator(path, query, header, formData, body)
  let scheme = call_589130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589130.url(scheme.get, call_589130.host, call_589130.base,
                         call_589130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589130, url, valid)

proc call*(call_589131: Call_ScriptProjectsDeploymentsList_589113;
          scriptId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## scriptProjectsDeploymentsList
  ## Lists the deployments of an Apps Script project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   pageSize: int
  ##           : The maximum number of deployments on each returned page. Defaults to 50.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589132 = newJObject()
  var query_589133 = newJObject()
  add(query_589133, "upload_protocol", newJString(uploadProtocol))
  add(query_589133, "fields", newJString(fields))
  add(query_589133, "pageToken", newJString(pageToken))
  add(query_589133, "quotaUser", newJString(quotaUser))
  add(query_589133, "alt", newJString(alt))
  add(query_589133, "oauth_token", newJString(oauthToken))
  add(query_589133, "callback", newJString(callback))
  add(query_589133, "access_token", newJString(accessToken))
  add(query_589133, "uploadType", newJString(uploadType))
  add(query_589133, "key", newJString(key))
  add(query_589133, "$.xgafv", newJString(Xgafv))
  add(path_589132, "scriptId", newJString(scriptId))
  add(query_589133, "pageSize", newJInt(pageSize))
  add(query_589133, "prettyPrint", newJBool(prettyPrint))
  result = call_589131.call(path_589132, query_589133, nil, nil, nil)

var scriptProjectsDeploymentsList* = Call_ScriptProjectsDeploymentsList_589113(
    name: "scriptProjectsDeploymentsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsList_589114, base: "/",
    url: url_ScriptProjectsDeploymentsList_589115, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsUpdate_589175 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsDeploymentsUpdate_589177(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  assert "deploymentId" in path, "`deploymentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsDeploymentsUpdate_589176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a deployment of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentId: JString (required)
  ##               : The deployment ID for this deployment.
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentId` field"
  var valid_589178 = path.getOrDefault("deploymentId")
  valid_589178 = validateParameter(valid_589178, JString, required = true,
                                 default = nil)
  if valid_589178 != nil:
    section.add "deploymentId", valid_589178
  var valid_589179 = path.getOrDefault("scriptId")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "scriptId", valid_589179
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589180 = query.getOrDefault("upload_protocol")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "upload_protocol", valid_589180
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("quotaUser")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "quotaUser", valid_589182
  var valid_589183 = query.getOrDefault("alt")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("json"))
  if valid_589183 != nil:
    section.add "alt", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("callback")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "callback", valid_589185
  var valid_589186 = query.getOrDefault("access_token")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "access_token", valid_589186
  var valid_589187 = query.getOrDefault("uploadType")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "uploadType", valid_589187
  var valid_589188 = query.getOrDefault("key")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "key", valid_589188
  var valid_589189 = query.getOrDefault("$.xgafv")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = newJString("1"))
  if valid_589189 != nil:
    section.add "$.xgafv", valid_589189
  var valid_589190 = query.getOrDefault("prettyPrint")
  valid_589190 = validateParameter(valid_589190, JBool, required = false,
                                 default = newJBool(true))
  if valid_589190 != nil:
    section.add "prettyPrint", valid_589190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589192: Call_ScriptProjectsDeploymentsUpdate_589175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment of an Apps Script project.
  ## 
  let valid = call_589192.validator(path, query, header, formData, body)
  let scheme = call_589192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589192.url(scheme.get, call_589192.host, call_589192.base,
                         call_589192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589192, url, valid)

proc call*(call_589193: Call_ScriptProjectsDeploymentsUpdate_589175;
          deploymentId: string; scriptId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## scriptProjectsDeploymentsUpdate
  ## Updates a deployment of an Apps Script project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   deploymentId: string (required)
  ##               : The deployment ID for this deployment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589194 = newJObject()
  var query_589195 = newJObject()
  var body_589196 = newJObject()
  add(query_589195, "upload_protocol", newJString(uploadProtocol))
  add(query_589195, "fields", newJString(fields))
  add(query_589195, "quotaUser", newJString(quotaUser))
  add(query_589195, "alt", newJString(alt))
  add(query_589195, "oauth_token", newJString(oauthToken))
  add(query_589195, "callback", newJString(callback))
  add(query_589195, "access_token", newJString(accessToken))
  add(query_589195, "uploadType", newJString(uploadType))
  add(path_589194, "deploymentId", newJString(deploymentId))
  add(query_589195, "key", newJString(key))
  add(query_589195, "$.xgafv", newJString(Xgafv))
  add(path_589194, "scriptId", newJString(scriptId))
  if body != nil:
    body_589196 = body
  add(query_589195, "prettyPrint", newJBool(prettyPrint))
  result = call_589193.call(path_589194, query_589195, nil, nil, body_589196)

var scriptProjectsDeploymentsUpdate* = Call_ScriptProjectsDeploymentsUpdate_589175(
    name: "scriptProjectsDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsUpdate_589176, base: "/",
    url: url_ScriptProjectsDeploymentsUpdate_589177, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsGet_589155 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsDeploymentsGet_589157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  assert "deploymentId" in path, "`deploymentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsDeploymentsGet_589156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentId: JString (required)
  ##               : The deployment ID.
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentId` field"
  var valid_589158 = path.getOrDefault("deploymentId")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "deploymentId", valid_589158
  var valid_589159 = path.getOrDefault("scriptId")
  valid_589159 = validateParameter(valid_589159, JString, required = true,
                                 default = nil)
  if valid_589159 != nil:
    section.add "scriptId", valid_589159
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589160 = query.getOrDefault("upload_protocol")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "upload_protocol", valid_589160
  var valid_589161 = query.getOrDefault("fields")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "fields", valid_589161
  var valid_589162 = query.getOrDefault("quotaUser")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "quotaUser", valid_589162
  var valid_589163 = query.getOrDefault("alt")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = newJString("json"))
  if valid_589163 != nil:
    section.add "alt", valid_589163
  var valid_589164 = query.getOrDefault("oauth_token")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "oauth_token", valid_589164
  var valid_589165 = query.getOrDefault("callback")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "callback", valid_589165
  var valid_589166 = query.getOrDefault("access_token")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "access_token", valid_589166
  var valid_589167 = query.getOrDefault("uploadType")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "uploadType", valid_589167
  var valid_589168 = query.getOrDefault("key")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "key", valid_589168
  var valid_589169 = query.getOrDefault("$.xgafv")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = newJString("1"))
  if valid_589169 != nil:
    section.add "$.xgafv", valid_589169
  var valid_589170 = query.getOrDefault("prettyPrint")
  valid_589170 = validateParameter(valid_589170, JBool, required = false,
                                 default = newJBool(true))
  if valid_589170 != nil:
    section.add "prettyPrint", valid_589170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589171: Call_ScriptProjectsDeploymentsGet_589155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment of an Apps Script project.
  ## 
  let valid = call_589171.validator(path, query, header, formData, body)
  let scheme = call_589171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589171.url(scheme.get, call_589171.host, call_589171.base,
                         call_589171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589171, url, valid)

proc call*(call_589172: Call_ScriptProjectsDeploymentsGet_589155;
          deploymentId: string; scriptId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## scriptProjectsDeploymentsGet
  ## Gets a deployment of an Apps Script project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   deploymentId: string (required)
  ##               : The deployment ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589173 = newJObject()
  var query_589174 = newJObject()
  add(query_589174, "upload_protocol", newJString(uploadProtocol))
  add(query_589174, "fields", newJString(fields))
  add(query_589174, "quotaUser", newJString(quotaUser))
  add(query_589174, "alt", newJString(alt))
  add(query_589174, "oauth_token", newJString(oauthToken))
  add(query_589174, "callback", newJString(callback))
  add(query_589174, "access_token", newJString(accessToken))
  add(query_589174, "uploadType", newJString(uploadType))
  add(path_589173, "deploymentId", newJString(deploymentId))
  add(query_589174, "key", newJString(key))
  add(query_589174, "$.xgafv", newJString(Xgafv))
  add(path_589173, "scriptId", newJString(scriptId))
  add(query_589174, "prettyPrint", newJBool(prettyPrint))
  result = call_589172.call(path_589173, query_589174, nil, nil, nil)

var scriptProjectsDeploymentsGet* = Call_ScriptProjectsDeploymentsGet_589155(
    name: "scriptProjectsDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsGet_589156, base: "/",
    url: url_ScriptProjectsDeploymentsGet_589157, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsDelete_589197 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsDeploymentsDelete_589199(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  assert "deploymentId" in path, "`deploymentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsDeploymentsDelete_589198(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a deployment of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentId: JString (required)
  ##               : The deployment ID to be undeployed.
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentId` field"
  var valid_589200 = path.getOrDefault("deploymentId")
  valid_589200 = validateParameter(valid_589200, JString, required = true,
                                 default = nil)
  if valid_589200 != nil:
    section.add "deploymentId", valid_589200
  var valid_589201 = path.getOrDefault("scriptId")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "scriptId", valid_589201
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589202 = query.getOrDefault("upload_protocol")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "upload_protocol", valid_589202
  var valid_589203 = query.getOrDefault("fields")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "fields", valid_589203
  var valid_589204 = query.getOrDefault("quotaUser")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "quotaUser", valid_589204
  var valid_589205 = query.getOrDefault("alt")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = newJString("json"))
  if valid_589205 != nil:
    section.add "alt", valid_589205
  var valid_589206 = query.getOrDefault("oauth_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "oauth_token", valid_589206
  var valid_589207 = query.getOrDefault("callback")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "callback", valid_589207
  var valid_589208 = query.getOrDefault("access_token")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "access_token", valid_589208
  var valid_589209 = query.getOrDefault("uploadType")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "uploadType", valid_589209
  var valid_589210 = query.getOrDefault("key")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "key", valid_589210
  var valid_589211 = query.getOrDefault("$.xgafv")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = newJString("1"))
  if valid_589211 != nil:
    section.add "$.xgafv", valid_589211
  var valid_589212 = query.getOrDefault("prettyPrint")
  valid_589212 = validateParameter(valid_589212, JBool, required = false,
                                 default = newJBool(true))
  if valid_589212 != nil:
    section.add "prettyPrint", valid_589212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589213: Call_ScriptProjectsDeploymentsDelete_589197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment of an Apps Script project.
  ## 
  let valid = call_589213.validator(path, query, header, formData, body)
  let scheme = call_589213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589213.url(scheme.get, call_589213.host, call_589213.base,
                         call_589213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589213, url, valid)

proc call*(call_589214: Call_ScriptProjectsDeploymentsDelete_589197;
          deploymentId: string; scriptId: string; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## scriptProjectsDeploymentsDelete
  ## Deletes a deployment of an Apps Script project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   deploymentId: string (required)
  ##               : The deployment ID to be undeployed.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589215 = newJObject()
  var query_589216 = newJObject()
  add(query_589216, "upload_protocol", newJString(uploadProtocol))
  add(query_589216, "fields", newJString(fields))
  add(query_589216, "quotaUser", newJString(quotaUser))
  add(query_589216, "alt", newJString(alt))
  add(query_589216, "oauth_token", newJString(oauthToken))
  add(query_589216, "callback", newJString(callback))
  add(query_589216, "access_token", newJString(accessToken))
  add(query_589216, "uploadType", newJString(uploadType))
  add(path_589215, "deploymentId", newJString(deploymentId))
  add(query_589216, "key", newJString(key))
  add(query_589216, "$.xgafv", newJString(Xgafv))
  add(path_589215, "scriptId", newJString(scriptId))
  add(query_589216, "prettyPrint", newJBool(prettyPrint))
  result = call_589214.call(path_589215, query_589216, nil, nil, nil)

var scriptProjectsDeploymentsDelete* = Call_ScriptProjectsDeploymentsDelete_589197(
    name: "scriptProjectsDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsDelete_589198, base: "/",
    url: url_ScriptProjectsDeploymentsDelete_589199, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetMetrics_589217 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsGetMetrics_589219(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/metrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsGetMetrics_589218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get metrics data for scripts, such as number of executions and
  ## active users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : Required field indicating the script to get metrics for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589220 = path.getOrDefault("scriptId")
  valid_589220 = validateParameter(valid_589220, JString, required = true,
                                 default = nil)
  if valid_589220 != nil:
    section.add "scriptId", valid_589220
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metricsGranularity: JString
  ##                     : Required field indicating what granularity of metrics are returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   metricsFilter.deploymentId: JString
  ##                             : Optional field indicating a specific deployment to retrieve metrics from.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589221 = query.getOrDefault("upload_protocol")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "upload_protocol", valid_589221
  var valid_589222 = query.getOrDefault("fields")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "fields", valid_589222
  var valid_589223 = query.getOrDefault("quotaUser")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "quotaUser", valid_589223
  var valid_589224 = query.getOrDefault("alt")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = newJString("json"))
  if valid_589224 != nil:
    section.add "alt", valid_589224
  var valid_589225 = query.getOrDefault("oauth_token")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "oauth_token", valid_589225
  var valid_589226 = query.getOrDefault("callback")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "callback", valid_589226
  var valid_589227 = query.getOrDefault("access_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "access_token", valid_589227
  var valid_589228 = query.getOrDefault("uploadType")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "uploadType", valid_589228
  var valid_589229 = query.getOrDefault("key")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "key", valid_589229
  var valid_589230 = query.getOrDefault("metricsGranularity")
  valid_589230 = validateParameter(valid_589230, JString, required = false, default = newJString(
      "UNSPECIFIED_GRANULARITY"))
  if valid_589230 != nil:
    section.add "metricsGranularity", valid_589230
  var valid_589231 = query.getOrDefault("$.xgafv")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("1"))
  if valid_589231 != nil:
    section.add "$.xgafv", valid_589231
  var valid_589232 = query.getOrDefault("metricsFilter.deploymentId")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "metricsFilter.deploymentId", valid_589232
  var valid_589233 = query.getOrDefault("prettyPrint")
  valid_589233 = validateParameter(valid_589233, JBool, required = false,
                                 default = newJBool(true))
  if valid_589233 != nil:
    section.add "prettyPrint", valid_589233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589234: Call_ScriptProjectsGetMetrics_589217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get metrics data for scripts, such as number of executions and
  ## active users.
  ## 
  let valid = call_589234.validator(path, query, header, formData, body)
  let scheme = call_589234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589234.url(scheme.get, call_589234.host, call_589234.base,
                         call_589234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589234, url, valid)

proc call*(call_589235: Call_ScriptProjectsGetMetrics_589217; scriptId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          metricsGranularity: string = "UNSPECIFIED_GRANULARITY";
          Xgafv: string = "1"; metricsFilterDeploymentId: string = "";
          prettyPrint: bool = true): Recallable =
  ## scriptProjectsGetMetrics
  ## Get metrics data for scripts, such as number of executions and
  ## active users.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   metricsGranularity: string
  ##                     : Required field indicating what granularity of metrics are returned.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : Required field indicating the script to get metrics for.
  ##   metricsFilterDeploymentId: string
  ##                            : Optional field indicating a specific deployment to retrieve metrics from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589236 = newJObject()
  var query_589237 = newJObject()
  add(query_589237, "upload_protocol", newJString(uploadProtocol))
  add(query_589237, "fields", newJString(fields))
  add(query_589237, "quotaUser", newJString(quotaUser))
  add(query_589237, "alt", newJString(alt))
  add(query_589237, "oauth_token", newJString(oauthToken))
  add(query_589237, "callback", newJString(callback))
  add(query_589237, "access_token", newJString(accessToken))
  add(query_589237, "uploadType", newJString(uploadType))
  add(query_589237, "key", newJString(key))
  add(query_589237, "metricsGranularity", newJString(metricsGranularity))
  add(query_589237, "$.xgafv", newJString(Xgafv))
  add(path_589236, "scriptId", newJString(scriptId))
  add(query_589237, "metricsFilter.deploymentId",
      newJString(metricsFilterDeploymentId))
  add(query_589237, "prettyPrint", newJBool(prettyPrint))
  result = call_589235.call(path_589236, query_589237, nil, nil, nil)

var scriptProjectsGetMetrics* = Call_ScriptProjectsGetMetrics_589217(
    name: "scriptProjectsGetMetrics", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/metrics",
    validator: validate_ScriptProjectsGetMetrics_589218, base: "/",
    url: url_ScriptProjectsGetMetrics_589219, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsCreate_589259 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsVersionsCreate_589261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsVersionsCreate_589260(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new immutable version using the current code, with a unique
  ## version number.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589262 = path.getOrDefault("scriptId")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "scriptId", valid_589262
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589263 = query.getOrDefault("upload_protocol")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "upload_protocol", valid_589263
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("quotaUser")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "quotaUser", valid_589265
  var valid_589266 = query.getOrDefault("alt")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("json"))
  if valid_589266 != nil:
    section.add "alt", valid_589266
  var valid_589267 = query.getOrDefault("oauth_token")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "oauth_token", valid_589267
  var valid_589268 = query.getOrDefault("callback")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "callback", valid_589268
  var valid_589269 = query.getOrDefault("access_token")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "access_token", valid_589269
  var valid_589270 = query.getOrDefault("uploadType")
  valid_589270 = validateParameter(valid_589270, JString, required = false,
                                 default = nil)
  if valid_589270 != nil:
    section.add "uploadType", valid_589270
  var valid_589271 = query.getOrDefault("key")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "key", valid_589271
  var valid_589272 = query.getOrDefault("$.xgafv")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = newJString("1"))
  if valid_589272 != nil:
    section.add "$.xgafv", valid_589272
  var valid_589273 = query.getOrDefault("prettyPrint")
  valid_589273 = validateParameter(valid_589273, JBool, required = false,
                                 default = newJBool(true))
  if valid_589273 != nil:
    section.add "prettyPrint", valid_589273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589275: Call_ScriptProjectsVersionsCreate_589259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new immutable version using the current code, with a unique
  ## version number.
  ## 
  let valid = call_589275.validator(path, query, header, formData, body)
  let scheme = call_589275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589275.url(scheme.get, call_589275.host, call_589275.base,
                         call_589275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589275, url, valid)

proc call*(call_589276: Call_ScriptProjectsVersionsCreate_589259; scriptId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## scriptProjectsVersionsCreate
  ## Creates a new immutable version using the current code, with a unique
  ## version number.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589277 = newJObject()
  var query_589278 = newJObject()
  var body_589279 = newJObject()
  add(query_589278, "upload_protocol", newJString(uploadProtocol))
  add(query_589278, "fields", newJString(fields))
  add(query_589278, "quotaUser", newJString(quotaUser))
  add(query_589278, "alt", newJString(alt))
  add(query_589278, "oauth_token", newJString(oauthToken))
  add(query_589278, "callback", newJString(callback))
  add(query_589278, "access_token", newJString(accessToken))
  add(query_589278, "uploadType", newJString(uploadType))
  add(query_589278, "key", newJString(key))
  add(query_589278, "$.xgafv", newJString(Xgafv))
  add(path_589277, "scriptId", newJString(scriptId))
  if body != nil:
    body_589279 = body
  add(query_589278, "prettyPrint", newJBool(prettyPrint))
  result = call_589276.call(path_589277, query_589278, nil, nil, body_589279)

var scriptProjectsVersionsCreate* = Call_ScriptProjectsVersionsCreate_589259(
    name: "scriptProjectsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsCreate_589260, base: "/",
    url: url_ScriptProjectsVersionsCreate_589261, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsList_589238 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsVersionsList_589240(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/versions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsVersionsList_589239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List the versions of a script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589241 = path.getOrDefault("scriptId")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "scriptId", valid_589241
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of versions on each returned page. Defaults to 50.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589242 = query.getOrDefault("upload_protocol")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "upload_protocol", valid_589242
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("pageToken")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "pageToken", valid_589244
  var valid_589245 = query.getOrDefault("quotaUser")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "quotaUser", valid_589245
  var valid_589246 = query.getOrDefault("alt")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("json"))
  if valid_589246 != nil:
    section.add "alt", valid_589246
  var valid_589247 = query.getOrDefault("oauth_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "oauth_token", valid_589247
  var valid_589248 = query.getOrDefault("callback")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "callback", valid_589248
  var valid_589249 = query.getOrDefault("access_token")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "access_token", valid_589249
  var valid_589250 = query.getOrDefault("uploadType")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "uploadType", valid_589250
  var valid_589251 = query.getOrDefault("key")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "key", valid_589251
  var valid_589252 = query.getOrDefault("$.xgafv")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = newJString("1"))
  if valid_589252 != nil:
    section.add "$.xgafv", valid_589252
  var valid_589253 = query.getOrDefault("pageSize")
  valid_589253 = validateParameter(valid_589253, JInt, required = false, default = nil)
  if valid_589253 != nil:
    section.add "pageSize", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589255: Call_ScriptProjectsVersionsList_589238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of a script project.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_ScriptProjectsVersionsList_589238; scriptId: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## scriptProjectsVersionsList
  ## List the versions of a script project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   pageSize: int
  ##           : The maximum number of versions on each returned page. Defaults to 50.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "upload_protocol", newJString(uploadProtocol))
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "pageToken", newJString(pageToken))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "callback", newJString(callback))
  add(query_589258, "access_token", newJString(accessToken))
  add(query_589258, "uploadType", newJString(uploadType))
  add(query_589258, "key", newJString(key))
  add(query_589258, "$.xgafv", newJString(Xgafv))
  add(path_589257, "scriptId", newJString(scriptId))
  add(query_589258, "pageSize", newJInt(pageSize))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var scriptProjectsVersionsList* = Call_ScriptProjectsVersionsList_589238(
    name: "scriptProjectsVersionsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsList_589239, base: "/",
    url: url_ScriptProjectsVersionsList_589240, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsGet_589280 = ref object of OpenApiRestCall_588441
proc url_ScriptProjectsVersionsGet_589282(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  assert "versionNumber" in path, "`versionNumber` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: "/versions/"),
               (kind: VariableSegment, value: "versionNumber")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsVersionsGet_589281(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a version of a script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  ##   versionNumber: JInt (required)
  ##                : The version number.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589283 = path.getOrDefault("scriptId")
  valid_589283 = validateParameter(valid_589283, JString, required = true,
                                 default = nil)
  if valid_589283 != nil:
    section.add "scriptId", valid_589283
  var valid_589284 = path.getOrDefault("versionNumber")
  valid_589284 = validateParameter(valid_589284, JInt, required = true, default = nil)
  if valid_589284 != nil:
    section.add "versionNumber", valid_589284
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589285 = query.getOrDefault("upload_protocol")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "upload_protocol", valid_589285
  var valid_589286 = query.getOrDefault("fields")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "fields", valid_589286
  var valid_589287 = query.getOrDefault("quotaUser")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "quotaUser", valid_589287
  var valid_589288 = query.getOrDefault("alt")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = newJString("json"))
  if valid_589288 != nil:
    section.add "alt", valid_589288
  var valid_589289 = query.getOrDefault("oauth_token")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "oauth_token", valid_589289
  var valid_589290 = query.getOrDefault("callback")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "callback", valid_589290
  var valid_589291 = query.getOrDefault("access_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "access_token", valid_589291
  var valid_589292 = query.getOrDefault("uploadType")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "uploadType", valid_589292
  var valid_589293 = query.getOrDefault("key")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "key", valid_589293
  var valid_589294 = query.getOrDefault("$.xgafv")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = newJString("1"))
  if valid_589294 != nil:
    section.add "$.xgafv", valid_589294
  var valid_589295 = query.getOrDefault("prettyPrint")
  valid_589295 = validateParameter(valid_589295, JBool, required = false,
                                 default = newJBool(true))
  if valid_589295 != nil:
    section.add "prettyPrint", valid_589295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589296: Call_ScriptProjectsVersionsGet_589280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a version of a script project.
  ## 
  let valid = call_589296.validator(path, query, header, formData, body)
  let scheme = call_589296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589296.url(scheme.get, call_589296.host, call_589296.base,
                         call_589296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589296, url, valid)

proc call*(call_589297: Call_ScriptProjectsVersionsGet_589280; scriptId: string;
          versionNumber: int; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## scriptProjectsVersionsGet
  ## Gets a version of a script project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   versionNumber: int (required)
  ##                : The version number.
  var path_589298 = newJObject()
  var query_589299 = newJObject()
  add(query_589299, "upload_protocol", newJString(uploadProtocol))
  add(query_589299, "fields", newJString(fields))
  add(query_589299, "quotaUser", newJString(quotaUser))
  add(query_589299, "alt", newJString(alt))
  add(query_589299, "oauth_token", newJString(oauthToken))
  add(query_589299, "callback", newJString(callback))
  add(query_589299, "access_token", newJString(accessToken))
  add(query_589299, "uploadType", newJString(uploadType))
  add(query_589299, "key", newJString(key))
  add(query_589299, "$.xgafv", newJString(Xgafv))
  add(path_589298, "scriptId", newJString(scriptId))
  add(query_589299, "prettyPrint", newJBool(prettyPrint))
  add(path_589298, "versionNumber", newJInt(versionNumber))
  result = call_589297.call(path_589298, query_589299, nil, nil, nil)

var scriptProjectsVersionsGet* = Call_ScriptProjectsVersionsGet_589280(
    name: "scriptProjectsVersionsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/versions/{versionNumber}",
    validator: validate_ScriptProjectsVersionsGet_589281, base: "/",
    url: url_ScriptProjectsVersionsGet_589282, schemes: {Scheme.Https})
type
  Call_ScriptScriptsRun_589300 = ref object of OpenApiRestCall_588441
proc url_ScriptScriptsRun_589302(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/scripts/"),
               (kind: VariableSegment, value: "scriptId"),
               (kind: ConstantSegment, value: ":run")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptScriptsRun_589301(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Runs a function in an Apps Script project. The script project must be
  ## deployed for use with the Apps Script API and the calling application must
  ## share the same Cloud Platform project.
  ## 
  ## This method requires authorization with an OAuth 2.0 token that includes at
  ## least one of the scopes listed in the
  ## [Authorization](#authorization-scopes) section; script projects that do not
  ## require authorization cannot be executed through this API. To find the
  ## correct scopes to include in the authentication token, open the project in
  ## the script editor, then select **File > Project properties** and click the
  ## **Scopes** tab.
  ## 
  ## The error `403, PERMISSION_DENIED: The caller does not have permission`
  ## indicates that the Cloud Platform project used to authorize the request is
  ## not the same as the one used by the script.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script ID of the script to be executed. To find the script ID, open
  ## the project in the script editor and select **File > Project properties**.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_589303 = path.getOrDefault("scriptId")
  valid_589303 = validateParameter(valid_589303, JString, required = true,
                                 default = nil)
  if valid_589303 != nil:
    section.add "scriptId", valid_589303
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589304 = query.getOrDefault("upload_protocol")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "upload_protocol", valid_589304
  var valid_589305 = query.getOrDefault("fields")
  valid_589305 = validateParameter(valid_589305, JString, required = false,
                                 default = nil)
  if valid_589305 != nil:
    section.add "fields", valid_589305
  var valid_589306 = query.getOrDefault("quotaUser")
  valid_589306 = validateParameter(valid_589306, JString, required = false,
                                 default = nil)
  if valid_589306 != nil:
    section.add "quotaUser", valid_589306
  var valid_589307 = query.getOrDefault("alt")
  valid_589307 = validateParameter(valid_589307, JString, required = false,
                                 default = newJString("json"))
  if valid_589307 != nil:
    section.add "alt", valid_589307
  var valid_589308 = query.getOrDefault("oauth_token")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "oauth_token", valid_589308
  var valid_589309 = query.getOrDefault("callback")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "callback", valid_589309
  var valid_589310 = query.getOrDefault("access_token")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "access_token", valid_589310
  var valid_589311 = query.getOrDefault("uploadType")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "uploadType", valid_589311
  var valid_589312 = query.getOrDefault("key")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "key", valid_589312
  var valid_589313 = query.getOrDefault("$.xgafv")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("1"))
  if valid_589313 != nil:
    section.add "$.xgafv", valid_589313
  var valid_589314 = query.getOrDefault("prettyPrint")
  valid_589314 = validateParameter(valid_589314, JBool, required = false,
                                 default = newJBool(true))
  if valid_589314 != nil:
    section.add "prettyPrint", valid_589314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589316: Call_ScriptScriptsRun_589300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a function in an Apps Script project. The script project must be
  ## deployed for use with the Apps Script API and the calling application must
  ## share the same Cloud Platform project.
  ## 
  ## This method requires authorization with an OAuth 2.0 token that includes at
  ## least one of the scopes listed in the
  ## [Authorization](#authorization-scopes) section; script projects that do not
  ## require authorization cannot be executed through this API. To find the
  ## correct scopes to include in the authentication token, open the project in
  ## the script editor, then select **File > Project properties** and click the
  ## **Scopes** tab.
  ## 
  ## The error `403, PERMISSION_DENIED: The caller does not have permission`
  ## indicates that the Cloud Platform project used to authorize the request is
  ## not the same as the one used by the script.
  ## 
  let valid = call_589316.validator(path, query, header, formData, body)
  let scheme = call_589316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589316.url(scheme.get, call_589316.host, call_589316.base,
                         call_589316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589316, url, valid)

proc call*(call_589317: Call_ScriptScriptsRun_589300; scriptId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## scriptScriptsRun
  ## Runs a function in an Apps Script project. The script project must be
  ## deployed for use with the Apps Script API and the calling application must
  ## share the same Cloud Platform project.
  ## 
  ## This method requires authorization with an OAuth 2.0 token that includes at
  ## least one of the scopes listed in the
  ## [Authorization](#authorization-scopes) section; script projects that do not
  ## require authorization cannot be executed through this API. To find the
  ## correct scopes to include in the authentication token, open the project in
  ## the script editor, then select **File > Project properties** and click the
  ## **Scopes** tab.
  ## 
  ## The error `403, PERMISSION_DENIED: The caller does not have permission`
  ## indicates that the Cloud Platform project used to authorize the request is
  ## not the same as the one used by the script.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptId: string (required)
  ##           : The script ID of the script to be executed. To find the script ID, open
  ## the project in the script editor and select **File > Project properties**.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589318 = newJObject()
  var query_589319 = newJObject()
  var body_589320 = newJObject()
  add(query_589319, "upload_protocol", newJString(uploadProtocol))
  add(query_589319, "fields", newJString(fields))
  add(query_589319, "quotaUser", newJString(quotaUser))
  add(query_589319, "alt", newJString(alt))
  add(query_589319, "oauth_token", newJString(oauthToken))
  add(query_589319, "callback", newJString(callback))
  add(query_589319, "access_token", newJString(accessToken))
  add(query_589319, "uploadType", newJString(uploadType))
  add(query_589319, "key", newJString(key))
  add(query_589319, "$.xgafv", newJString(Xgafv))
  add(path_589318, "scriptId", newJString(scriptId))
  if body != nil:
    body_589320 = body
  add(query_589319, "prettyPrint", newJBool(prettyPrint))
  result = call_589317.call(path_589318, query_589319, nil, nil, body_589320)

var scriptScriptsRun* = Call_ScriptScriptsRun_589300(name: "scriptScriptsRun",
    meth: HttpMethod.HttpPost, host: "script.googleapis.com",
    route: "/v1/scripts/{scriptId}:run", validator: validate_ScriptScriptsRun_589301,
    base: "/", url: url_ScriptScriptsRun_589302, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
