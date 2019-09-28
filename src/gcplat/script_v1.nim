
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_ScriptProcessesList_579677 = ref object of OpenApiRestCall_579408
proc url_ScriptProcessesList_579679(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProcessesList_579678(path: JsonNode; query: JsonNode;
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
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("userProcessFilter.scriptId")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "userProcessFilter.scriptId", valid_579792
  var valid_579793 = query.getOrDefault("userProcessFilter.deploymentId")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "userProcessFilter.deploymentId", valid_579793
  var valid_579794 = query.getOrDefault("fields")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "fields", valid_579794
  var valid_579795 = query.getOrDefault("pageToken")
  valid_579795 = validateParameter(valid_579795, JString, required = false,
                                 default = nil)
  if valid_579795 != nil:
    section.add "pageToken", valid_579795
  var valid_579796 = query.getOrDefault("quotaUser")
  valid_579796 = validateParameter(valid_579796, JString, required = false,
                                 default = nil)
  if valid_579796 != nil:
    section.add "quotaUser", valid_579796
  var valid_579810 = query.getOrDefault("alt")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = newJString("json"))
  if valid_579810 != nil:
    section.add "alt", valid_579810
  var valid_579811 = query.getOrDefault("oauth_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "oauth_token", valid_579811
  var valid_579812 = query.getOrDefault("callback")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "callback", valid_579812
  var valid_579813 = query.getOrDefault("access_token")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "access_token", valid_579813
  var valid_579814 = query.getOrDefault("uploadType")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "uploadType", valid_579814
  var valid_579815 = query.getOrDefault("userProcessFilter.projectName")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = nil)
  if valid_579815 != nil:
    section.add "userProcessFilter.projectName", valid_579815
  var valid_579816 = query.getOrDefault("userProcessFilter.userAccessLevels")
  valid_579816 = validateParameter(valid_579816, JArray, required = false,
                                 default = nil)
  if valid_579816 != nil:
    section.add "userProcessFilter.userAccessLevels", valid_579816
  var valid_579817 = query.getOrDefault("userProcessFilter.types")
  valid_579817 = validateParameter(valid_579817, JArray, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "userProcessFilter.types", valid_579817
  var valid_579818 = query.getOrDefault("key")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = nil)
  if valid_579818 != nil:
    section.add "key", valid_579818
  var valid_579819 = query.getOrDefault("$.xgafv")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = newJString("1"))
  if valid_579819 != nil:
    section.add "$.xgafv", valid_579819
  var valid_579820 = query.getOrDefault("pageSize")
  valid_579820 = validateParameter(valid_579820, JInt, required = false, default = nil)
  if valid_579820 != nil:
    section.add "pageSize", valid_579820
  var valid_579821 = query.getOrDefault("userProcessFilter.functionName")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "userProcessFilter.functionName", valid_579821
  var valid_579822 = query.getOrDefault("userProcessFilter.endTime")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "userProcessFilter.endTime", valid_579822
  var valid_579823 = query.getOrDefault("prettyPrint")
  valid_579823 = validateParameter(valid_579823, JBool, required = false,
                                 default = newJBool(true))
  if valid_579823 != nil:
    section.add "prettyPrint", valid_579823
  var valid_579824 = query.getOrDefault("userProcessFilter.startTime")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userProcessFilter.startTime", valid_579824
  var valid_579825 = query.getOrDefault("userProcessFilter.statuses")
  valid_579825 = validateParameter(valid_579825, JArray, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "userProcessFilter.statuses", valid_579825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579848: Call_ScriptProcessesList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List information about processes made by or on behalf of a user,
  ## such as process type and current status.
  ## 
  let valid = call_579848.validator(path, query, header, formData, body)
  let scheme = call_579848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579848.url(scheme.get, call_579848.host, call_579848.base,
                         call_579848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579848, url, valid)

proc call*(call_579919: Call_ScriptProcessesList_579677;
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
  var query_579920 = newJObject()
  add(query_579920, "upload_protocol", newJString(uploadProtocol))
  add(query_579920, "userProcessFilter.scriptId",
      newJString(userProcessFilterScriptId))
  add(query_579920, "userProcessFilter.deploymentId",
      newJString(userProcessFilterDeploymentId))
  add(query_579920, "fields", newJString(fields))
  add(query_579920, "pageToken", newJString(pageToken))
  add(query_579920, "quotaUser", newJString(quotaUser))
  add(query_579920, "alt", newJString(alt))
  add(query_579920, "oauth_token", newJString(oauthToken))
  add(query_579920, "callback", newJString(callback))
  add(query_579920, "access_token", newJString(accessToken))
  add(query_579920, "uploadType", newJString(uploadType))
  add(query_579920, "userProcessFilter.projectName",
      newJString(userProcessFilterProjectName))
  if userProcessFilterUserAccessLevels != nil:
    query_579920.add "userProcessFilter.userAccessLevels",
                    userProcessFilterUserAccessLevels
  if userProcessFilterTypes != nil:
    query_579920.add "userProcessFilter.types", userProcessFilterTypes
  add(query_579920, "key", newJString(key))
  add(query_579920, "$.xgafv", newJString(Xgafv))
  add(query_579920, "pageSize", newJInt(pageSize))
  add(query_579920, "userProcessFilter.functionName",
      newJString(userProcessFilterFunctionName))
  add(query_579920, "userProcessFilter.endTime",
      newJString(userProcessFilterEndTime))
  add(query_579920, "prettyPrint", newJBool(prettyPrint))
  add(query_579920, "userProcessFilter.startTime",
      newJString(userProcessFilterStartTime))
  if userProcessFilterStatuses != nil:
    query_579920.add "userProcessFilter.statuses", userProcessFilterStatuses
  result = call_579919.call(nil, query_579920, nil, nil, nil)

var scriptProcessesList* = Call_ScriptProcessesList_579677(
    name: "scriptProcessesList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes",
    validator: validate_ScriptProcessesList_579678, base: "/",
    url: url_ScriptProcessesList_579679, schemes: {Scheme.Https})
type
  Call_ScriptProcessesListScriptProcesses_579960 = ref object of OpenApiRestCall_579408
proc url_ScriptProcessesListScriptProcesses_579962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProcessesListScriptProcesses_579961(path: JsonNode;
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
  var valid_579963 = query.getOrDefault("scriptProcessFilter.userAccessLevels")
  valid_579963 = validateParameter(valid_579963, JArray, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "scriptProcessFilter.userAccessLevels", valid_579963
  var valid_579964 = query.getOrDefault("upload_protocol")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "upload_protocol", valid_579964
  var valid_579965 = query.getOrDefault("fields")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "fields", valid_579965
  var valid_579966 = query.getOrDefault("pageToken")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "pageToken", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("scriptProcessFilter.startTime")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "scriptProcessFilter.startTime", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("scriptProcessFilter.types")
  valid_579970 = validateParameter(valid_579970, JArray, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "scriptProcessFilter.types", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("callback")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "callback", valid_579972
  var valid_579973 = query.getOrDefault("access_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "access_token", valid_579973
  var valid_579974 = query.getOrDefault("uploadType")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "uploadType", valid_579974
  var valid_579975 = query.getOrDefault("scriptProcessFilter.endTime")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "scriptProcessFilter.endTime", valid_579975
  var valid_579976 = query.getOrDefault("scriptProcessFilter.deploymentId")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "scriptProcessFilter.deploymentId", valid_579976
  var valid_579977 = query.getOrDefault("scriptProcessFilter.statuses")
  valid_579977 = validateParameter(valid_579977, JArray, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "scriptProcessFilter.statuses", valid_579977
  var valid_579978 = query.getOrDefault("key")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "key", valid_579978
  var valid_579979 = query.getOrDefault("$.xgafv")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("1"))
  if valid_579979 != nil:
    section.add "$.xgafv", valid_579979
  var valid_579980 = query.getOrDefault("pageSize")
  valid_579980 = validateParameter(valid_579980, JInt, required = false, default = nil)
  if valid_579980 != nil:
    section.add "pageSize", valid_579980
  var valid_579981 = query.getOrDefault("scriptId")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "scriptId", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(true))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  var valid_579983 = query.getOrDefault("scriptProcessFilter.functionName")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "scriptProcessFilter.functionName", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_ScriptProcessesListScriptProcesses_579960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_ScriptProcessesListScriptProcesses_579960;
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
  var query_579986 = newJObject()
  if scriptProcessFilterUserAccessLevels != nil:
    query_579986.add "scriptProcessFilter.userAccessLevels",
                    scriptProcessFilterUserAccessLevels
  add(query_579986, "upload_protocol", newJString(uploadProtocol))
  add(query_579986, "fields", newJString(fields))
  add(query_579986, "pageToken", newJString(pageToken))
  add(query_579986, "quotaUser", newJString(quotaUser))
  add(query_579986, "scriptProcessFilter.startTime",
      newJString(scriptProcessFilterStartTime))
  add(query_579986, "alt", newJString(alt))
  if scriptProcessFilterTypes != nil:
    query_579986.add "scriptProcessFilter.types", scriptProcessFilterTypes
  add(query_579986, "oauth_token", newJString(oauthToken))
  add(query_579986, "callback", newJString(callback))
  add(query_579986, "access_token", newJString(accessToken))
  add(query_579986, "uploadType", newJString(uploadType))
  add(query_579986, "scriptProcessFilter.endTime",
      newJString(scriptProcessFilterEndTime))
  add(query_579986, "scriptProcessFilter.deploymentId",
      newJString(scriptProcessFilterDeploymentId))
  if scriptProcessFilterStatuses != nil:
    query_579986.add "scriptProcessFilter.statuses", scriptProcessFilterStatuses
  add(query_579986, "key", newJString(key))
  add(query_579986, "$.xgafv", newJString(Xgafv))
  add(query_579986, "pageSize", newJInt(pageSize))
  add(query_579986, "scriptId", newJString(scriptId))
  add(query_579986, "prettyPrint", newJBool(prettyPrint))
  add(query_579986, "scriptProcessFilter.functionName",
      newJString(scriptProcessFilterFunctionName))
  result = call_579985.call(nil, query_579986, nil, nil, nil)

var scriptProcessesListScriptProcesses* = Call_ScriptProcessesListScriptProcesses_579960(
    name: "scriptProcessesListScriptProcesses", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes:listScriptProcesses",
    validator: validate_ScriptProcessesListScriptProcesses_579961, base: "/",
    url: url_ScriptProcessesListScriptProcesses_579962, schemes: {Scheme.Https})
type
  Call_ScriptProjectsCreate_579987 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsCreate_579989(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProjectsCreate_579988(path: JsonNode; query: JsonNode;
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
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("callback")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "callback", valid_579995
  var valid_579996 = query.getOrDefault("access_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "access_token", valid_579996
  var valid_579997 = query.getOrDefault("uploadType")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "uploadType", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("$.xgafv")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("1"))
  if valid_579999 != nil:
    section.add "$.xgafv", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_ScriptProjectsCreate_579987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_ScriptProjectsCreate_579987;
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
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(nil, query_580004, nil, nil, body_580005)

var scriptProjectsCreate* = Call_ScriptProjectsCreate_579987(
    name: "scriptProjectsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects",
    validator: validate_ScriptProjectsCreate_579988, base: "/",
    url: url_ScriptProjectsCreate_579989, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGet_580006 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsGet_580008(protocol: Scheme; host: string; base: string;
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

proc validate_ScriptProjectsGet_580007(path: JsonNode; query: JsonNode;
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
  var valid_580023 = path.getOrDefault("scriptId")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "scriptId", valid_580023
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
  var valid_580024 = query.getOrDefault("upload_protocol")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "upload_protocol", valid_580024
  var valid_580025 = query.getOrDefault("fields")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "fields", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("alt")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = newJString("json"))
  if valid_580027 != nil:
    section.add "alt", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("callback")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "callback", valid_580029
  var valid_580030 = query.getOrDefault("access_token")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "access_token", valid_580030
  var valid_580031 = query.getOrDefault("uploadType")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "uploadType", valid_580031
  var valid_580032 = query.getOrDefault("key")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "key", valid_580032
  var valid_580033 = query.getOrDefault("$.xgafv")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("1"))
  if valid_580033 != nil:
    section.add "$.xgafv", valid_580033
  var valid_580034 = query.getOrDefault("prettyPrint")
  valid_580034 = validateParameter(valid_580034, JBool, required = false,
                                 default = newJBool(true))
  if valid_580034 != nil:
    section.add "prettyPrint", valid_580034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580035: Call_ScriptProjectsGet_580006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a script project's metadata.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_ScriptProjectsGet_580006; scriptId: string;
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
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "upload_protocol", newJString(uploadProtocol))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "callback", newJString(callback))
  add(query_580038, "access_token", newJString(accessToken))
  add(query_580038, "uploadType", newJString(uploadType))
  add(query_580038, "key", newJString(key))
  add(query_580038, "$.xgafv", newJString(Xgafv))
  add(path_580037, "scriptId", newJString(scriptId))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var scriptProjectsGet* = Call_ScriptProjectsGet_580006(name: "scriptProjectsGet",
    meth: HttpMethod.HttpGet, host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}", validator: validate_ScriptProjectsGet_580007,
    base: "/", url: url_ScriptProjectsGet_580008, schemes: {Scheme.Https})
type
  Call_ScriptProjectsUpdateContent_580059 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsUpdateContent_580061(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsUpdateContent_580060(path: JsonNode; query: JsonNode;
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
  var valid_580062 = path.getOrDefault("scriptId")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "scriptId", valid_580062
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
  var valid_580063 = query.getOrDefault("upload_protocol")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "upload_protocol", valid_580063
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("callback")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "callback", valid_580068
  var valid_580069 = query.getOrDefault("access_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "access_token", valid_580069
  var valid_580070 = query.getOrDefault("uploadType")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "uploadType", valid_580070
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("$.xgafv")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = newJString("1"))
  if valid_580072 != nil:
    section.add "$.xgafv", valid_580072
  var valid_580073 = query.getOrDefault("prettyPrint")
  valid_580073 = validateParameter(valid_580073, JBool, required = false,
                                 default = newJBool(true))
  if valid_580073 != nil:
    section.add "prettyPrint", valid_580073
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

proc call*(call_580075: Call_ScriptProjectsUpdateContent_580059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the content of the specified script project.
  ## This content is stored as the HEAD version, and is used when the script is
  ## executed as a trigger, in the script editor, in add-on preview mode, or as
  ## a web app or Apps Script API in development mode. This clears all the
  ## existing files in the project.
  ## 
  let valid = call_580075.validator(path, query, header, formData, body)
  let scheme = call_580075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580075.url(scheme.get, call_580075.host, call_580075.base,
                         call_580075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580075, url, valid)

proc call*(call_580076: Call_ScriptProjectsUpdateContent_580059; scriptId: string;
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
  var path_580077 = newJObject()
  var query_580078 = newJObject()
  var body_580079 = newJObject()
  add(query_580078, "upload_protocol", newJString(uploadProtocol))
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "callback", newJString(callback))
  add(query_580078, "access_token", newJString(accessToken))
  add(query_580078, "uploadType", newJString(uploadType))
  add(query_580078, "key", newJString(key))
  add(query_580078, "$.xgafv", newJString(Xgafv))
  add(path_580077, "scriptId", newJString(scriptId))
  if body != nil:
    body_580079 = body
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  result = call_580076.call(path_580077, query_580078, nil, nil, body_580079)

var scriptProjectsUpdateContent* = Call_ScriptProjectsUpdateContent_580059(
    name: "scriptProjectsUpdateContent", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsUpdateContent_580060, base: "/",
    url: url_ScriptProjectsUpdateContent_580061, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetContent_580039 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsGetContent_580041(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsGetContent_580040(path: JsonNode; query: JsonNode;
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
  var valid_580042 = path.getOrDefault("scriptId")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "scriptId", valid_580042
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
  var valid_580043 = query.getOrDefault("upload_protocol")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "upload_protocol", valid_580043
  var valid_580044 = query.getOrDefault("versionNumber")
  valid_580044 = validateParameter(valid_580044, JInt, required = false, default = nil)
  if valid_580044 != nil:
    section.add "versionNumber", valid_580044
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  var valid_580046 = query.getOrDefault("quotaUser")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "quotaUser", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("oauth_token")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "oauth_token", valid_580048
  var valid_580049 = query.getOrDefault("callback")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "callback", valid_580049
  var valid_580050 = query.getOrDefault("access_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "access_token", valid_580050
  var valid_580051 = query.getOrDefault("uploadType")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "uploadType", valid_580051
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("$.xgafv")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("1"))
  if valid_580053 != nil:
    section.add "$.xgafv", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580055: Call_ScriptProjectsGetContent_580039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the content of the script project, including the code source and
  ## metadata for each script file.
  ## 
  let valid = call_580055.validator(path, query, header, formData, body)
  let scheme = call_580055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580055.url(scheme.get, call_580055.host, call_580055.base,
                         call_580055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580055, url, valid)

proc call*(call_580056: Call_ScriptProjectsGetContent_580039; scriptId: string;
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
  var path_580057 = newJObject()
  var query_580058 = newJObject()
  add(query_580058, "upload_protocol", newJString(uploadProtocol))
  add(query_580058, "versionNumber", newJInt(versionNumber))
  add(query_580058, "fields", newJString(fields))
  add(query_580058, "quotaUser", newJString(quotaUser))
  add(query_580058, "alt", newJString(alt))
  add(query_580058, "oauth_token", newJString(oauthToken))
  add(query_580058, "callback", newJString(callback))
  add(query_580058, "access_token", newJString(accessToken))
  add(query_580058, "uploadType", newJString(uploadType))
  add(query_580058, "key", newJString(key))
  add(query_580058, "$.xgafv", newJString(Xgafv))
  add(path_580057, "scriptId", newJString(scriptId))
  add(query_580058, "prettyPrint", newJBool(prettyPrint))
  result = call_580056.call(path_580057, query_580058, nil, nil, nil)

var scriptProjectsGetContent* = Call_ScriptProjectsGetContent_580039(
    name: "scriptProjectsGetContent", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsGetContent_580040, base: "/",
    url: url_ScriptProjectsGetContent_580041, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsCreate_580101 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsDeploymentsCreate_580103(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsCreate_580102(path: JsonNode;
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
  var valid_580104 = path.getOrDefault("scriptId")
  valid_580104 = validateParameter(valid_580104, JString, required = true,
                                 default = nil)
  if valid_580104 != nil:
    section.add "scriptId", valid_580104
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
  var valid_580105 = query.getOrDefault("upload_protocol")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "upload_protocol", valid_580105
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  var valid_580107 = query.getOrDefault("quotaUser")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "quotaUser", valid_580107
  var valid_580108 = query.getOrDefault("alt")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = newJString("json"))
  if valid_580108 != nil:
    section.add "alt", valid_580108
  var valid_580109 = query.getOrDefault("oauth_token")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "oauth_token", valid_580109
  var valid_580110 = query.getOrDefault("callback")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "callback", valid_580110
  var valid_580111 = query.getOrDefault("access_token")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "access_token", valid_580111
  var valid_580112 = query.getOrDefault("uploadType")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "uploadType", valid_580112
  var valid_580113 = query.getOrDefault("key")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "key", valid_580113
  var valid_580114 = query.getOrDefault("$.xgafv")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = newJString("1"))
  if valid_580114 != nil:
    section.add "$.xgafv", valid_580114
  var valid_580115 = query.getOrDefault("prettyPrint")
  valid_580115 = validateParameter(valid_580115, JBool, required = false,
                                 default = newJBool(true))
  if valid_580115 != nil:
    section.add "prettyPrint", valid_580115
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

proc call*(call_580117: Call_ScriptProjectsDeploymentsCreate_580101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment of an Apps Script project.
  ## 
  let valid = call_580117.validator(path, query, header, formData, body)
  let scheme = call_580117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580117.url(scheme.get, call_580117.host, call_580117.base,
                         call_580117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580117, url, valid)

proc call*(call_580118: Call_ScriptProjectsDeploymentsCreate_580101;
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
  var path_580119 = newJObject()
  var query_580120 = newJObject()
  var body_580121 = newJObject()
  add(query_580120, "upload_protocol", newJString(uploadProtocol))
  add(query_580120, "fields", newJString(fields))
  add(query_580120, "quotaUser", newJString(quotaUser))
  add(query_580120, "alt", newJString(alt))
  add(query_580120, "oauth_token", newJString(oauthToken))
  add(query_580120, "callback", newJString(callback))
  add(query_580120, "access_token", newJString(accessToken))
  add(query_580120, "uploadType", newJString(uploadType))
  add(query_580120, "key", newJString(key))
  add(query_580120, "$.xgafv", newJString(Xgafv))
  add(path_580119, "scriptId", newJString(scriptId))
  if body != nil:
    body_580121 = body
  add(query_580120, "prettyPrint", newJBool(prettyPrint))
  result = call_580118.call(path_580119, query_580120, nil, nil, body_580121)

var scriptProjectsDeploymentsCreate* = Call_ScriptProjectsDeploymentsCreate_580101(
    name: "scriptProjectsDeploymentsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsCreate_580102, base: "/",
    url: url_ScriptProjectsDeploymentsCreate_580103, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsList_580080 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsDeploymentsList_580082(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsList_580081(path: JsonNode; query: JsonNode;
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
  var valid_580083 = path.getOrDefault("scriptId")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "scriptId", valid_580083
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
  var valid_580084 = query.getOrDefault("upload_protocol")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "upload_protocol", valid_580084
  var valid_580085 = query.getOrDefault("fields")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "fields", valid_580085
  var valid_580086 = query.getOrDefault("pageToken")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "pageToken", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("access_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "access_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("pageSize")
  valid_580095 = validateParameter(valid_580095, JInt, required = false, default = nil)
  if valid_580095 != nil:
    section.add "pageSize", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580097: Call_ScriptProjectsDeploymentsList_580080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the deployments of an Apps Script project.
  ## 
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_ScriptProjectsDeploymentsList_580080;
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
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  add(query_580100, "upload_protocol", newJString(uploadProtocol))
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "pageToken", newJString(pageToken))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "callback", newJString(callback))
  add(query_580100, "access_token", newJString(accessToken))
  add(query_580100, "uploadType", newJString(uploadType))
  add(query_580100, "key", newJString(key))
  add(query_580100, "$.xgafv", newJString(Xgafv))
  add(path_580099, "scriptId", newJString(scriptId))
  add(query_580100, "pageSize", newJInt(pageSize))
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  result = call_580098.call(path_580099, query_580100, nil, nil, nil)

var scriptProjectsDeploymentsList* = Call_ScriptProjectsDeploymentsList_580080(
    name: "scriptProjectsDeploymentsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsList_580081, base: "/",
    url: url_ScriptProjectsDeploymentsList_580082, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsUpdate_580142 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsDeploymentsUpdate_580144(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsUpdate_580143(path: JsonNode;
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
  var valid_580145 = path.getOrDefault("deploymentId")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "deploymentId", valid_580145
  var valid_580146 = path.getOrDefault("scriptId")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "scriptId", valid_580146
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
  var valid_580147 = query.getOrDefault("upload_protocol")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "upload_protocol", valid_580147
  var valid_580148 = query.getOrDefault("fields")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "fields", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("callback")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "callback", valid_580152
  var valid_580153 = query.getOrDefault("access_token")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "access_token", valid_580153
  var valid_580154 = query.getOrDefault("uploadType")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "uploadType", valid_580154
  var valid_580155 = query.getOrDefault("key")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "key", valid_580155
  var valid_580156 = query.getOrDefault("$.xgafv")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = newJString("1"))
  if valid_580156 != nil:
    section.add "$.xgafv", valid_580156
  var valid_580157 = query.getOrDefault("prettyPrint")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "prettyPrint", valid_580157
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

proc call*(call_580159: Call_ScriptProjectsDeploymentsUpdate_580142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment of an Apps Script project.
  ## 
  let valid = call_580159.validator(path, query, header, formData, body)
  let scheme = call_580159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580159.url(scheme.get, call_580159.host, call_580159.base,
                         call_580159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580159, url, valid)

proc call*(call_580160: Call_ScriptProjectsDeploymentsUpdate_580142;
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
  var path_580161 = newJObject()
  var query_580162 = newJObject()
  var body_580163 = newJObject()
  add(query_580162, "upload_protocol", newJString(uploadProtocol))
  add(query_580162, "fields", newJString(fields))
  add(query_580162, "quotaUser", newJString(quotaUser))
  add(query_580162, "alt", newJString(alt))
  add(query_580162, "oauth_token", newJString(oauthToken))
  add(query_580162, "callback", newJString(callback))
  add(query_580162, "access_token", newJString(accessToken))
  add(query_580162, "uploadType", newJString(uploadType))
  add(path_580161, "deploymentId", newJString(deploymentId))
  add(query_580162, "key", newJString(key))
  add(query_580162, "$.xgafv", newJString(Xgafv))
  add(path_580161, "scriptId", newJString(scriptId))
  if body != nil:
    body_580163 = body
  add(query_580162, "prettyPrint", newJBool(prettyPrint))
  result = call_580160.call(path_580161, query_580162, nil, nil, body_580163)

var scriptProjectsDeploymentsUpdate* = Call_ScriptProjectsDeploymentsUpdate_580142(
    name: "scriptProjectsDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsUpdate_580143, base: "/",
    url: url_ScriptProjectsDeploymentsUpdate_580144, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsGet_580122 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsDeploymentsGet_580124(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsGet_580123(path: JsonNode; query: JsonNode;
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
  var valid_580125 = path.getOrDefault("deploymentId")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "deploymentId", valid_580125
  var valid_580126 = path.getOrDefault("scriptId")
  valid_580126 = validateParameter(valid_580126, JString, required = true,
                                 default = nil)
  if valid_580126 != nil:
    section.add "scriptId", valid_580126
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
  var valid_580127 = query.getOrDefault("upload_protocol")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "upload_protocol", valid_580127
  var valid_580128 = query.getOrDefault("fields")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "fields", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("alt")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = newJString("json"))
  if valid_580130 != nil:
    section.add "alt", valid_580130
  var valid_580131 = query.getOrDefault("oauth_token")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "oauth_token", valid_580131
  var valid_580132 = query.getOrDefault("callback")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "callback", valid_580132
  var valid_580133 = query.getOrDefault("access_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "access_token", valid_580133
  var valid_580134 = query.getOrDefault("uploadType")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "uploadType", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("$.xgafv")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("1"))
  if valid_580136 != nil:
    section.add "$.xgafv", valid_580136
  var valid_580137 = query.getOrDefault("prettyPrint")
  valid_580137 = validateParameter(valid_580137, JBool, required = false,
                                 default = newJBool(true))
  if valid_580137 != nil:
    section.add "prettyPrint", valid_580137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580138: Call_ScriptProjectsDeploymentsGet_580122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment of an Apps Script project.
  ## 
  let valid = call_580138.validator(path, query, header, formData, body)
  let scheme = call_580138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580138.url(scheme.get, call_580138.host, call_580138.base,
                         call_580138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580138, url, valid)

proc call*(call_580139: Call_ScriptProjectsDeploymentsGet_580122;
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
  var path_580140 = newJObject()
  var query_580141 = newJObject()
  add(query_580141, "upload_protocol", newJString(uploadProtocol))
  add(query_580141, "fields", newJString(fields))
  add(query_580141, "quotaUser", newJString(quotaUser))
  add(query_580141, "alt", newJString(alt))
  add(query_580141, "oauth_token", newJString(oauthToken))
  add(query_580141, "callback", newJString(callback))
  add(query_580141, "access_token", newJString(accessToken))
  add(query_580141, "uploadType", newJString(uploadType))
  add(path_580140, "deploymentId", newJString(deploymentId))
  add(query_580141, "key", newJString(key))
  add(query_580141, "$.xgafv", newJString(Xgafv))
  add(path_580140, "scriptId", newJString(scriptId))
  add(query_580141, "prettyPrint", newJBool(prettyPrint))
  result = call_580139.call(path_580140, query_580141, nil, nil, nil)

var scriptProjectsDeploymentsGet* = Call_ScriptProjectsDeploymentsGet_580122(
    name: "scriptProjectsDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsGet_580123, base: "/",
    url: url_ScriptProjectsDeploymentsGet_580124, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsDelete_580164 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsDeploymentsDelete_580166(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsDelete_580165(path: JsonNode;
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
  var valid_580167 = path.getOrDefault("deploymentId")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "deploymentId", valid_580167
  var valid_580168 = path.getOrDefault("scriptId")
  valid_580168 = validateParameter(valid_580168, JString, required = true,
                                 default = nil)
  if valid_580168 != nil:
    section.add "scriptId", valid_580168
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
  var valid_580169 = query.getOrDefault("upload_protocol")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "upload_protocol", valid_580169
  var valid_580170 = query.getOrDefault("fields")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "fields", valid_580170
  var valid_580171 = query.getOrDefault("quotaUser")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "quotaUser", valid_580171
  var valid_580172 = query.getOrDefault("alt")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = newJString("json"))
  if valid_580172 != nil:
    section.add "alt", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("callback")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "callback", valid_580174
  var valid_580175 = query.getOrDefault("access_token")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "access_token", valid_580175
  var valid_580176 = query.getOrDefault("uploadType")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "uploadType", valid_580176
  var valid_580177 = query.getOrDefault("key")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "key", valid_580177
  var valid_580178 = query.getOrDefault("$.xgafv")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = newJString("1"))
  if valid_580178 != nil:
    section.add "$.xgafv", valid_580178
  var valid_580179 = query.getOrDefault("prettyPrint")
  valid_580179 = validateParameter(valid_580179, JBool, required = false,
                                 default = newJBool(true))
  if valid_580179 != nil:
    section.add "prettyPrint", valid_580179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580180: Call_ScriptProjectsDeploymentsDelete_580164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment of an Apps Script project.
  ## 
  let valid = call_580180.validator(path, query, header, formData, body)
  let scheme = call_580180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580180.url(scheme.get, call_580180.host, call_580180.base,
                         call_580180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580180, url, valid)

proc call*(call_580181: Call_ScriptProjectsDeploymentsDelete_580164;
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
  var path_580182 = newJObject()
  var query_580183 = newJObject()
  add(query_580183, "upload_protocol", newJString(uploadProtocol))
  add(query_580183, "fields", newJString(fields))
  add(query_580183, "quotaUser", newJString(quotaUser))
  add(query_580183, "alt", newJString(alt))
  add(query_580183, "oauth_token", newJString(oauthToken))
  add(query_580183, "callback", newJString(callback))
  add(query_580183, "access_token", newJString(accessToken))
  add(query_580183, "uploadType", newJString(uploadType))
  add(path_580182, "deploymentId", newJString(deploymentId))
  add(query_580183, "key", newJString(key))
  add(query_580183, "$.xgafv", newJString(Xgafv))
  add(path_580182, "scriptId", newJString(scriptId))
  add(query_580183, "prettyPrint", newJBool(prettyPrint))
  result = call_580181.call(path_580182, query_580183, nil, nil, nil)

var scriptProjectsDeploymentsDelete* = Call_ScriptProjectsDeploymentsDelete_580164(
    name: "scriptProjectsDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsDelete_580165, base: "/",
    url: url_ScriptProjectsDeploymentsDelete_580166, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetMetrics_580184 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsGetMetrics_580186(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsGetMetrics_580185(path: JsonNode; query: JsonNode;
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
  var valid_580187 = path.getOrDefault("scriptId")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "scriptId", valid_580187
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
  var valid_580188 = query.getOrDefault("upload_protocol")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "upload_protocol", valid_580188
  var valid_580189 = query.getOrDefault("fields")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "fields", valid_580189
  var valid_580190 = query.getOrDefault("quotaUser")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "quotaUser", valid_580190
  var valid_580191 = query.getOrDefault("alt")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("json"))
  if valid_580191 != nil:
    section.add "alt", valid_580191
  var valid_580192 = query.getOrDefault("oauth_token")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "oauth_token", valid_580192
  var valid_580193 = query.getOrDefault("callback")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "callback", valid_580193
  var valid_580194 = query.getOrDefault("access_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "access_token", valid_580194
  var valid_580195 = query.getOrDefault("uploadType")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "uploadType", valid_580195
  var valid_580196 = query.getOrDefault("key")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "key", valid_580196
  var valid_580197 = query.getOrDefault("metricsGranularity")
  valid_580197 = validateParameter(valid_580197, JString, required = false, default = newJString(
      "UNSPECIFIED_GRANULARITY"))
  if valid_580197 != nil:
    section.add "metricsGranularity", valid_580197
  var valid_580198 = query.getOrDefault("$.xgafv")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("1"))
  if valid_580198 != nil:
    section.add "$.xgafv", valid_580198
  var valid_580199 = query.getOrDefault("metricsFilter.deploymentId")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "metricsFilter.deploymentId", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580201: Call_ScriptProjectsGetMetrics_580184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get metrics data for scripts, such as number of executions and
  ## active users.
  ## 
  let valid = call_580201.validator(path, query, header, formData, body)
  let scheme = call_580201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580201.url(scheme.get, call_580201.host, call_580201.base,
                         call_580201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580201, url, valid)

proc call*(call_580202: Call_ScriptProjectsGetMetrics_580184; scriptId: string;
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
  var path_580203 = newJObject()
  var query_580204 = newJObject()
  add(query_580204, "upload_protocol", newJString(uploadProtocol))
  add(query_580204, "fields", newJString(fields))
  add(query_580204, "quotaUser", newJString(quotaUser))
  add(query_580204, "alt", newJString(alt))
  add(query_580204, "oauth_token", newJString(oauthToken))
  add(query_580204, "callback", newJString(callback))
  add(query_580204, "access_token", newJString(accessToken))
  add(query_580204, "uploadType", newJString(uploadType))
  add(query_580204, "key", newJString(key))
  add(query_580204, "metricsGranularity", newJString(metricsGranularity))
  add(query_580204, "$.xgafv", newJString(Xgafv))
  add(path_580203, "scriptId", newJString(scriptId))
  add(query_580204, "metricsFilter.deploymentId",
      newJString(metricsFilterDeploymentId))
  add(query_580204, "prettyPrint", newJBool(prettyPrint))
  result = call_580202.call(path_580203, query_580204, nil, nil, nil)

var scriptProjectsGetMetrics* = Call_ScriptProjectsGetMetrics_580184(
    name: "scriptProjectsGetMetrics", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/metrics",
    validator: validate_ScriptProjectsGetMetrics_580185, base: "/",
    url: url_ScriptProjectsGetMetrics_580186, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsCreate_580226 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsVersionsCreate_580228(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsVersionsCreate_580227(path: JsonNode; query: JsonNode;
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
  var valid_580229 = path.getOrDefault("scriptId")
  valid_580229 = validateParameter(valid_580229, JString, required = true,
                                 default = nil)
  if valid_580229 != nil:
    section.add "scriptId", valid_580229
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
  var valid_580230 = query.getOrDefault("upload_protocol")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "upload_protocol", valid_580230
  var valid_580231 = query.getOrDefault("fields")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "fields", valid_580231
  var valid_580232 = query.getOrDefault("quotaUser")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "quotaUser", valid_580232
  var valid_580233 = query.getOrDefault("alt")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = newJString("json"))
  if valid_580233 != nil:
    section.add "alt", valid_580233
  var valid_580234 = query.getOrDefault("oauth_token")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "oauth_token", valid_580234
  var valid_580235 = query.getOrDefault("callback")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "callback", valid_580235
  var valid_580236 = query.getOrDefault("access_token")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "access_token", valid_580236
  var valid_580237 = query.getOrDefault("uploadType")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "uploadType", valid_580237
  var valid_580238 = query.getOrDefault("key")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "key", valid_580238
  var valid_580239 = query.getOrDefault("$.xgafv")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = newJString("1"))
  if valid_580239 != nil:
    section.add "$.xgafv", valid_580239
  var valid_580240 = query.getOrDefault("prettyPrint")
  valid_580240 = validateParameter(valid_580240, JBool, required = false,
                                 default = newJBool(true))
  if valid_580240 != nil:
    section.add "prettyPrint", valid_580240
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

proc call*(call_580242: Call_ScriptProjectsVersionsCreate_580226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new immutable version using the current code, with a unique
  ## version number.
  ## 
  let valid = call_580242.validator(path, query, header, formData, body)
  let scheme = call_580242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580242.url(scheme.get, call_580242.host, call_580242.base,
                         call_580242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580242, url, valid)

proc call*(call_580243: Call_ScriptProjectsVersionsCreate_580226; scriptId: string;
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
  var path_580244 = newJObject()
  var query_580245 = newJObject()
  var body_580246 = newJObject()
  add(query_580245, "upload_protocol", newJString(uploadProtocol))
  add(query_580245, "fields", newJString(fields))
  add(query_580245, "quotaUser", newJString(quotaUser))
  add(query_580245, "alt", newJString(alt))
  add(query_580245, "oauth_token", newJString(oauthToken))
  add(query_580245, "callback", newJString(callback))
  add(query_580245, "access_token", newJString(accessToken))
  add(query_580245, "uploadType", newJString(uploadType))
  add(query_580245, "key", newJString(key))
  add(query_580245, "$.xgafv", newJString(Xgafv))
  add(path_580244, "scriptId", newJString(scriptId))
  if body != nil:
    body_580246 = body
  add(query_580245, "prettyPrint", newJBool(prettyPrint))
  result = call_580243.call(path_580244, query_580245, nil, nil, body_580246)

var scriptProjectsVersionsCreate* = Call_ScriptProjectsVersionsCreate_580226(
    name: "scriptProjectsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsCreate_580227, base: "/",
    url: url_ScriptProjectsVersionsCreate_580228, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsList_580205 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsVersionsList_580207(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsVersionsList_580206(path: JsonNode; query: JsonNode;
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
  var valid_580208 = path.getOrDefault("scriptId")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "scriptId", valid_580208
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
  var valid_580209 = query.getOrDefault("upload_protocol")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "upload_protocol", valid_580209
  var valid_580210 = query.getOrDefault("fields")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "fields", valid_580210
  var valid_580211 = query.getOrDefault("pageToken")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "pageToken", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("oauth_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "oauth_token", valid_580214
  var valid_580215 = query.getOrDefault("callback")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "callback", valid_580215
  var valid_580216 = query.getOrDefault("access_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "access_token", valid_580216
  var valid_580217 = query.getOrDefault("uploadType")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "uploadType", valid_580217
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("$.xgafv")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = newJString("1"))
  if valid_580219 != nil:
    section.add "$.xgafv", valid_580219
  var valid_580220 = query.getOrDefault("pageSize")
  valid_580220 = validateParameter(valid_580220, JInt, required = false, default = nil)
  if valid_580220 != nil:
    section.add "pageSize", valid_580220
  var valid_580221 = query.getOrDefault("prettyPrint")
  valid_580221 = validateParameter(valid_580221, JBool, required = false,
                                 default = newJBool(true))
  if valid_580221 != nil:
    section.add "prettyPrint", valid_580221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580222: Call_ScriptProjectsVersionsList_580205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of a script project.
  ## 
  let valid = call_580222.validator(path, query, header, formData, body)
  let scheme = call_580222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580222.url(scheme.get, call_580222.host, call_580222.base,
                         call_580222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580222, url, valid)

proc call*(call_580223: Call_ScriptProjectsVersionsList_580205; scriptId: string;
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
  var path_580224 = newJObject()
  var query_580225 = newJObject()
  add(query_580225, "upload_protocol", newJString(uploadProtocol))
  add(query_580225, "fields", newJString(fields))
  add(query_580225, "pageToken", newJString(pageToken))
  add(query_580225, "quotaUser", newJString(quotaUser))
  add(query_580225, "alt", newJString(alt))
  add(query_580225, "oauth_token", newJString(oauthToken))
  add(query_580225, "callback", newJString(callback))
  add(query_580225, "access_token", newJString(accessToken))
  add(query_580225, "uploadType", newJString(uploadType))
  add(query_580225, "key", newJString(key))
  add(query_580225, "$.xgafv", newJString(Xgafv))
  add(path_580224, "scriptId", newJString(scriptId))
  add(query_580225, "pageSize", newJInt(pageSize))
  add(query_580225, "prettyPrint", newJBool(prettyPrint))
  result = call_580223.call(path_580224, query_580225, nil, nil, nil)

var scriptProjectsVersionsList* = Call_ScriptProjectsVersionsList_580205(
    name: "scriptProjectsVersionsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsList_580206, base: "/",
    url: url_ScriptProjectsVersionsList_580207, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsGet_580247 = ref object of OpenApiRestCall_579408
proc url_ScriptProjectsVersionsGet_580249(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsVersionsGet_580248(path: JsonNode; query: JsonNode;
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
  var valid_580250 = path.getOrDefault("scriptId")
  valid_580250 = validateParameter(valid_580250, JString, required = true,
                                 default = nil)
  if valid_580250 != nil:
    section.add "scriptId", valid_580250
  var valid_580251 = path.getOrDefault("versionNumber")
  valid_580251 = validateParameter(valid_580251, JInt, required = true, default = nil)
  if valid_580251 != nil:
    section.add "versionNumber", valid_580251
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
  var valid_580252 = query.getOrDefault("upload_protocol")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "upload_protocol", valid_580252
  var valid_580253 = query.getOrDefault("fields")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "fields", valid_580253
  var valid_580254 = query.getOrDefault("quotaUser")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "quotaUser", valid_580254
  var valid_580255 = query.getOrDefault("alt")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = newJString("json"))
  if valid_580255 != nil:
    section.add "alt", valid_580255
  var valid_580256 = query.getOrDefault("oauth_token")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "oauth_token", valid_580256
  var valid_580257 = query.getOrDefault("callback")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "callback", valid_580257
  var valid_580258 = query.getOrDefault("access_token")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "access_token", valid_580258
  var valid_580259 = query.getOrDefault("uploadType")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "uploadType", valid_580259
  var valid_580260 = query.getOrDefault("key")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "key", valid_580260
  var valid_580261 = query.getOrDefault("$.xgafv")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("1"))
  if valid_580261 != nil:
    section.add "$.xgafv", valid_580261
  var valid_580262 = query.getOrDefault("prettyPrint")
  valid_580262 = validateParameter(valid_580262, JBool, required = false,
                                 default = newJBool(true))
  if valid_580262 != nil:
    section.add "prettyPrint", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_ScriptProjectsVersionsGet_580247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a version of a script project.
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_ScriptProjectsVersionsGet_580247; scriptId: string;
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
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "upload_protocol", newJString(uploadProtocol))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "callback", newJString(callback))
  add(query_580266, "access_token", newJString(accessToken))
  add(query_580266, "uploadType", newJString(uploadType))
  add(query_580266, "key", newJString(key))
  add(query_580266, "$.xgafv", newJString(Xgafv))
  add(path_580265, "scriptId", newJString(scriptId))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(path_580265, "versionNumber", newJInt(versionNumber))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var scriptProjectsVersionsGet* = Call_ScriptProjectsVersionsGet_580247(
    name: "scriptProjectsVersionsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/versions/{versionNumber}",
    validator: validate_ScriptProjectsVersionsGet_580248, base: "/",
    url: url_ScriptProjectsVersionsGet_580249, schemes: {Scheme.Https})
type
  Call_ScriptScriptsRun_580267 = ref object of OpenApiRestCall_579408
proc url_ScriptScriptsRun_580269(protocol: Scheme; host: string; base: string;
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

proc validate_ScriptScriptsRun_580268(path: JsonNode; query: JsonNode;
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
  var valid_580270 = path.getOrDefault("scriptId")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "scriptId", valid_580270
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
  var valid_580271 = query.getOrDefault("upload_protocol")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "upload_protocol", valid_580271
  var valid_580272 = query.getOrDefault("fields")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "fields", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("alt")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("json"))
  if valid_580274 != nil:
    section.add "alt", valid_580274
  var valid_580275 = query.getOrDefault("oauth_token")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "oauth_token", valid_580275
  var valid_580276 = query.getOrDefault("callback")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "callback", valid_580276
  var valid_580277 = query.getOrDefault("access_token")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "access_token", valid_580277
  var valid_580278 = query.getOrDefault("uploadType")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "uploadType", valid_580278
  var valid_580279 = query.getOrDefault("key")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "key", valid_580279
  var valid_580280 = query.getOrDefault("$.xgafv")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = newJString("1"))
  if valid_580280 != nil:
    section.add "$.xgafv", valid_580280
  var valid_580281 = query.getOrDefault("prettyPrint")
  valid_580281 = validateParameter(valid_580281, JBool, required = false,
                                 default = newJBool(true))
  if valid_580281 != nil:
    section.add "prettyPrint", valid_580281
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

proc call*(call_580283: Call_ScriptScriptsRun_580267; path: JsonNode;
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
  let valid = call_580283.validator(path, query, header, formData, body)
  let scheme = call_580283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580283.url(scheme.get, call_580283.host, call_580283.base,
                         call_580283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580283, url, valid)

proc call*(call_580284: Call_ScriptScriptsRun_580267; scriptId: string;
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
  var path_580285 = newJObject()
  var query_580286 = newJObject()
  var body_580287 = newJObject()
  add(query_580286, "upload_protocol", newJString(uploadProtocol))
  add(query_580286, "fields", newJString(fields))
  add(query_580286, "quotaUser", newJString(quotaUser))
  add(query_580286, "alt", newJString(alt))
  add(query_580286, "oauth_token", newJString(oauthToken))
  add(query_580286, "callback", newJString(callback))
  add(query_580286, "access_token", newJString(accessToken))
  add(query_580286, "uploadType", newJString(uploadType))
  add(query_580286, "key", newJString(key))
  add(query_580286, "$.xgafv", newJString(Xgafv))
  add(path_580285, "scriptId", newJString(scriptId))
  if body != nil:
    body_580287 = body
  add(query_580286, "prettyPrint", newJBool(prettyPrint))
  result = call_580284.call(path_580285, query_580286, nil, nil, body_580287)

var scriptScriptsRun* = Call_ScriptScriptsRun_580267(name: "scriptScriptsRun",
    meth: HttpMethod.HttpPost, host: "script.googleapis.com",
    route: "/v1/scripts/{scriptId}:run", validator: validate_ScriptScriptsRun_580268,
    base: "/", url: url_ScriptScriptsRun_580269, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
