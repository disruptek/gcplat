
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "script"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ScriptProcessesList_578610 = ref object of OpenApiRestCall_578339
proc url_ScriptProcessesList_578612(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProcessesList_578611(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   userProcessFilter.projectName: JString
  ##                                : Optional field used to limit returned processes to those originating from
  ## projects with project names containing a specific string.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userProcessFilter.deploymentId: JString
  ##                                 : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   userProcessFilter.endTime: JString
  ##                            : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   userProcessFilter.startTime: JString
  ##                              : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   pageSize: JInt
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   userProcessFilter.types: JArray
  ##                          : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   callback: JString
  ##           : JSONP
  ##   userProcessFilter.userAccessLevels: JArray
  ##                                     : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   userProcessFilter.statuses: JArray
  ##                             : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  ##   userProcessFilter.functionName: JString
  ##                                 : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   userProcessFilter.scriptId: JString
  ##                             : Optional field used to limit returned processes to those originating from
  ## projects with a specific script ID.
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578725 = query.getOrDefault("userProcessFilter.projectName")
  valid_578725 = validateParameter(valid_578725, JString, required = false,
                                 default = nil)
  if valid_578725 != nil:
    section.add "userProcessFilter.projectName", valid_578725
  var valid_578739 = query.getOrDefault("prettyPrint")
  valid_578739 = validateParameter(valid_578739, JBool, required = false,
                                 default = newJBool(true))
  if valid_578739 != nil:
    section.add "prettyPrint", valid_578739
  var valid_578740 = query.getOrDefault("oauth_token")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "oauth_token", valid_578740
  var valid_578741 = query.getOrDefault("userProcessFilter.deploymentId")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "userProcessFilter.deploymentId", valid_578741
  var valid_578742 = query.getOrDefault("$.xgafv")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("1"))
  if valid_578742 != nil:
    section.add "$.xgafv", valid_578742
  var valid_578743 = query.getOrDefault("userProcessFilter.endTime")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "userProcessFilter.endTime", valid_578743
  var valid_578744 = query.getOrDefault("userProcessFilter.startTime")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "userProcessFilter.startTime", valid_578744
  var valid_578745 = query.getOrDefault("pageSize")
  valid_578745 = validateParameter(valid_578745, JInt, required = false, default = nil)
  if valid_578745 != nil:
    section.add "pageSize", valid_578745
  var valid_578746 = query.getOrDefault("alt")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = newJString("json"))
  if valid_578746 != nil:
    section.add "alt", valid_578746
  var valid_578747 = query.getOrDefault("uploadType")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "uploadType", valid_578747
  var valid_578748 = query.getOrDefault("quotaUser")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "quotaUser", valid_578748
  var valid_578749 = query.getOrDefault("pageToken")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "pageToken", valid_578749
  var valid_578750 = query.getOrDefault("userProcessFilter.types")
  valid_578750 = validateParameter(valid_578750, JArray, required = false,
                                 default = nil)
  if valid_578750 != nil:
    section.add "userProcessFilter.types", valid_578750
  var valid_578751 = query.getOrDefault("callback")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = nil)
  if valid_578751 != nil:
    section.add "callback", valid_578751
  var valid_578752 = query.getOrDefault("userProcessFilter.userAccessLevels")
  valid_578752 = validateParameter(valid_578752, JArray, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "userProcessFilter.userAccessLevels", valid_578752
  var valid_578753 = query.getOrDefault("userProcessFilter.statuses")
  valid_578753 = validateParameter(valid_578753, JArray, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "userProcessFilter.statuses", valid_578753
  var valid_578754 = query.getOrDefault("userProcessFilter.functionName")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "userProcessFilter.functionName", valid_578754
  var valid_578755 = query.getOrDefault("fields")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "fields", valid_578755
  var valid_578756 = query.getOrDefault("access_token")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "access_token", valid_578756
  var valid_578757 = query.getOrDefault("upload_protocol")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "upload_protocol", valid_578757
  var valid_578758 = query.getOrDefault("userProcessFilter.scriptId")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "userProcessFilter.scriptId", valid_578758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578781: Call_ScriptProcessesList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List information about processes made by or on behalf of a user,
  ## such as process type and current status.
  ## 
  let valid = call_578781.validator(path, query, header, formData, body)
  let scheme = call_578781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578781.url(scheme.get, call_578781.host, call_578781.base,
                         call_578781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578781, url, valid)

proc call*(call_578852: Call_ScriptProcessesList_578610; key: string = "";
          userProcessFilterProjectName: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; userProcessFilterDeploymentId: string = "";
          Xgafv: string = "1"; userProcessFilterEndTime: string = "";
          userProcessFilterStartTime: string = ""; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; userProcessFilterTypes: JsonNode = nil;
          callback: string = ""; userProcessFilterUserAccessLevels: JsonNode = nil;
          userProcessFilterStatuses: JsonNode = nil;
          userProcessFilterFunctionName: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          userProcessFilterScriptId: string = ""): Recallable =
  ## scriptProcessesList
  ## List information about processes made by or on behalf of a user,
  ## such as process type and current status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   userProcessFilterProjectName: string
  ##                               : Optional field used to limit returned processes to those originating from
  ## projects with project names containing a specific string.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userProcessFilterDeploymentId: string
  ##                                : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   userProcessFilterEndTime: string
  ##                           : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   userProcessFilterStartTime: string
  ##                             : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   pageSize: int
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   userProcessFilterTypes: JArray
  ##                         : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   callback: string
  ##           : JSONP
  ##   userProcessFilterUserAccessLevels: JArray
  ##                                    : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   userProcessFilterStatuses: JArray
  ##                            : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  ##   userProcessFilterFunctionName: string
  ##                                : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   userProcessFilterScriptId: string
  ##                            : Optional field used to limit returned processes to those originating from
  ## projects with a specific script ID.
  var query_578853 = newJObject()
  add(query_578853, "key", newJString(key))
  add(query_578853, "userProcessFilter.projectName",
      newJString(userProcessFilterProjectName))
  add(query_578853, "prettyPrint", newJBool(prettyPrint))
  add(query_578853, "oauth_token", newJString(oauthToken))
  add(query_578853, "userProcessFilter.deploymentId",
      newJString(userProcessFilterDeploymentId))
  add(query_578853, "$.xgafv", newJString(Xgafv))
  add(query_578853, "userProcessFilter.endTime",
      newJString(userProcessFilterEndTime))
  add(query_578853, "userProcessFilter.startTime",
      newJString(userProcessFilterStartTime))
  add(query_578853, "pageSize", newJInt(pageSize))
  add(query_578853, "alt", newJString(alt))
  add(query_578853, "uploadType", newJString(uploadType))
  add(query_578853, "quotaUser", newJString(quotaUser))
  add(query_578853, "pageToken", newJString(pageToken))
  if userProcessFilterTypes != nil:
    query_578853.add "userProcessFilter.types", userProcessFilterTypes
  add(query_578853, "callback", newJString(callback))
  if userProcessFilterUserAccessLevels != nil:
    query_578853.add "userProcessFilter.userAccessLevels",
                    userProcessFilterUserAccessLevels
  if userProcessFilterStatuses != nil:
    query_578853.add "userProcessFilter.statuses", userProcessFilterStatuses
  add(query_578853, "userProcessFilter.functionName",
      newJString(userProcessFilterFunctionName))
  add(query_578853, "fields", newJString(fields))
  add(query_578853, "access_token", newJString(accessToken))
  add(query_578853, "upload_protocol", newJString(uploadProtocol))
  add(query_578853, "userProcessFilter.scriptId",
      newJString(userProcessFilterScriptId))
  result = call_578852.call(nil, query_578853, nil, nil, nil)

var scriptProcessesList* = Call_ScriptProcessesList_578610(
    name: "scriptProcessesList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes",
    validator: validate_ScriptProcessesList_578611, base: "/",
    url: url_ScriptProcessesList_578612, schemes: {Scheme.Https})
type
  Call_ScriptProcessesListScriptProcesses_578893 = ref object of OpenApiRestCall_578339
proc url_ScriptProcessesListScriptProcesses_578895(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProcessesListScriptProcesses_578894(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   scriptProcessFilter.deploymentId: JString
  ##                                   : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   scriptProcessFilter.types: JArray
  ##                            : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   scriptProcessFilter.userAccessLevels: JArray
  ##                                       : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   pageSize: JInt
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   scriptProcessFilter.statuses: JArray
  ##                               : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   scriptProcessFilter.functionName: JString
  ##                                   : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   scriptProcessFilter.endTime: JString
  ##                              : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   scriptProcessFilter.startTime: JString
  ##                                : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   callback: JString
  ##           : JSONP
  ##   scriptId: JString
  ##           : The script ID of the project whose processes are listed.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578896 = query.getOrDefault("key")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "key", valid_578896
  var valid_578897 = query.getOrDefault("prettyPrint")
  valid_578897 = validateParameter(valid_578897, JBool, required = false,
                                 default = newJBool(true))
  if valid_578897 != nil:
    section.add "prettyPrint", valid_578897
  var valid_578898 = query.getOrDefault("oauth_token")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "oauth_token", valid_578898
  var valid_578899 = query.getOrDefault("scriptProcessFilter.deploymentId")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "scriptProcessFilter.deploymentId", valid_578899
  var valid_578900 = query.getOrDefault("scriptProcessFilter.types")
  valid_578900 = validateParameter(valid_578900, JArray, required = false,
                                 default = nil)
  if valid_578900 != nil:
    section.add "scriptProcessFilter.types", valid_578900
  var valid_578901 = query.getOrDefault("$.xgafv")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = newJString("1"))
  if valid_578901 != nil:
    section.add "$.xgafv", valid_578901
  var valid_578902 = query.getOrDefault("scriptProcessFilter.userAccessLevels")
  valid_578902 = validateParameter(valid_578902, JArray, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "scriptProcessFilter.userAccessLevels", valid_578902
  var valid_578903 = query.getOrDefault("pageSize")
  valid_578903 = validateParameter(valid_578903, JInt, required = false, default = nil)
  if valid_578903 != nil:
    section.add "pageSize", valid_578903
  var valid_578904 = query.getOrDefault("scriptProcessFilter.statuses")
  valid_578904 = validateParameter(valid_578904, JArray, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "scriptProcessFilter.statuses", valid_578904
  var valid_578905 = query.getOrDefault("alt")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = newJString("json"))
  if valid_578905 != nil:
    section.add "alt", valid_578905
  var valid_578906 = query.getOrDefault("uploadType")
  valid_578906 = validateParameter(valid_578906, JString, required = false,
                                 default = nil)
  if valid_578906 != nil:
    section.add "uploadType", valid_578906
  var valid_578907 = query.getOrDefault("scriptProcessFilter.functionName")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "scriptProcessFilter.functionName", valid_578907
  var valid_578908 = query.getOrDefault("quotaUser")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "quotaUser", valid_578908
  var valid_578909 = query.getOrDefault("pageToken")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "pageToken", valid_578909
  var valid_578910 = query.getOrDefault("scriptProcessFilter.endTime")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = nil)
  if valid_578910 != nil:
    section.add "scriptProcessFilter.endTime", valid_578910
  var valid_578911 = query.getOrDefault("scriptProcessFilter.startTime")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "scriptProcessFilter.startTime", valid_578911
  var valid_578912 = query.getOrDefault("callback")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "callback", valid_578912
  var valid_578913 = query.getOrDefault("scriptId")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "scriptId", valid_578913
  var valid_578914 = query.getOrDefault("fields")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "fields", valid_578914
  var valid_578915 = query.getOrDefault("access_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "access_token", valid_578915
  var valid_578916 = query.getOrDefault("upload_protocol")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "upload_protocol", valid_578916
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578917: Call_ScriptProcessesListScriptProcesses_578893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ## 
  let valid = call_578917.validator(path, query, header, formData, body)
  let scheme = call_578917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578917.url(scheme.get, call_578917.host, call_578917.base,
                         call_578917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578917, url, valid)

proc call*(call_578918: Call_ScriptProcessesListScriptProcesses_578893;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          scriptProcessFilterDeploymentId: string = "";
          scriptProcessFilterTypes: JsonNode = nil; Xgafv: string = "1";
          scriptProcessFilterUserAccessLevels: JsonNode = nil; pageSize: int = 0;
          scriptProcessFilterStatuses: JsonNode = nil; alt: string = "json";
          uploadType: string = ""; scriptProcessFilterFunctionName: string = "";
          quotaUser: string = ""; pageToken: string = "";
          scriptProcessFilterEndTime: string = "";
          scriptProcessFilterStartTime: string = ""; callback: string = "";
          scriptId: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## scriptProcessesListScriptProcesses
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   scriptProcessFilterDeploymentId: string
  ##                                  : Optional field used to limit returned processes to those originating from
  ## projects with a specific deployment ID.
  ##   scriptProcessFilterTypes: JArray
  ##                           : Optional field used to limit returned processes to those having one of
  ## the specified process types.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   scriptProcessFilterUserAccessLevels: JArray
  ##                                      : Optional field used to limit returned processes to those having one of
  ## the specified user access levels.
  ##   pageSize: int
  ##           : The maximum number of returned processes per page of results. Defaults to
  ## 50.
  ##   scriptProcessFilterStatuses: JArray
  ##                              : Optional field used to limit returned processes to those having one of
  ## the specified process statuses.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   scriptProcessFilterFunctionName: string
  ##                                  : Optional field used to limit returned processes to those originating from
  ## a script function with the given function name.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   scriptProcessFilterEndTime: string
  ##                             : Optional field used to limit returned processes to those that completed
  ## on or before the given timestamp.
  ##   scriptProcessFilterStartTime: string
  ##                               : Optional field used to limit returned processes to those that were
  ## started on or after the given timestamp.
  ##   callback: string
  ##           : JSONP
  ##   scriptId: string
  ##           : The script ID of the project whose processes are listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578919 = newJObject()
  add(query_578919, "key", newJString(key))
  add(query_578919, "prettyPrint", newJBool(prettyPrint))
  add(query_578919, "oauth_token", newJString(oauthToken))
  add(query_578919, "scriptProcessFilter.deploymentId",
      newJString(scriptProcessFilterDeploymentId))
  if scriptProcessFilterTypes != nil:
    query_578919.add "scriptProcessFilter.types", scriptProcessFilterTypes
  add(query_578919, "$.xgafv", newJString(Xgafv))
  if scriptProcessFilterUserAccessLevels != nil:
    query_578919.add "scriptProcessFilter.userAccessLevels",
                    scriptProcessFilterUserAccessLevels
  add(query_578919, "pageSize", newJInt(pageSize))
  if scriptProcessFilterStatuses != nil:
    query_578919.add "scriptProcessFilter.statuses", scriptProcessFilterStatuses
  add(query_578919, "alt", newJString(alt))
  add(query_578919, "uploadType", newJString(uploadType))
  add(query_578919, "scriptProcessFilter.functionName",
      newJString(scriptProcessFilterFunctionName))
  add(query_578919, "quotaUser", newJString(quotaUser))
  add(query_578919, "pageToken", newJString(pageToken))
  add(query_578919, "scriptProcessFilter.endTime",
      newJString(scriptProcessFilterEndTime))
  add(query_578919, "scriptProcessFilter.startTime",
      newJString(scriptProcessFilterStartTime))
  add(query_578919, "callback", newJString(callback))
  add(query_578919, "scriptId", newJString(scriptId))
  add(query_578919, "fields", newJString(fields))
  add(query_578919, "access_token", newJString(accessToken))
  add(query_578919, "upload_protocol", newJString(uploadProtocol))
  result = call_578918.call(nil, query_578919, nil, nil, nil)

var scriptProcessesListScriptProcesses* = Call_ScriptProcessesListScriptProcesses_578893(
    name: "scriptProcessesListScriptProcesses", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes:listScriptProcesses",
    validator: validate_ScriptProcessesListScriptProcesses_578894, base: "/",
    url: url_ScriptProcessesListScriptProcesses_578895, schemes: {Scheme.Https})
type
  Call_ScriptProjectsCreate_578920 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsCreate_578922(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_ScriptProjectsCreate_578921(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578923 = query.getOrDefault("key")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "key", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("$.xgafv")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("1"))
  if valid_578926 != nil:
    section.add "$.xgafv", valid_578926
  var valid_578927 = query.getOrDefault("alt")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = newJString("json"))
  if valid_578927 != nil:
    section.add "alt", valid_578927
  var valid_578928 = query.getOrDefault("uploadType")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "uploadType", valid_578928
  var valid_578929 = query.getOrDefault("quotaUser")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "quotaUser", valid_578929
  var valid_578930 = query.getOrDefault("callback")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "callback", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  var valid_578932 = query.getOrDefault("access_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "access_token", valid_578932
  var valid_578933 = query.getOrDefault("upload_protocol")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "upload_protocol", valid_578933
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

proc call*(call_578935: Call_ScriptProjectsCreate_578920; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ## 
  let valid = call_578935.validator(path, query, header, formData, body)
  let scheme = call_578935.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578935.url(scheme.get, call_578935.host, call_578935.base,
                         call_578935.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578935, url, valid)

proc call*(call_578936: Call_ScriptProjectsCreate_578920; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsCreate
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578937 = newJObject()
  var body_578938 = newJObject()
  add(query_578937, "key", newJString(key))
  add(query_578937, "prettyPrint", newJBool(prettyPrint))
  add(query_578937, "oauth_token", newJString(oauthToken))
  add(query_578937, "$.xgafv", newJString(Xgafv))
  add(query_578937, "alt", newJString(alt))
  add(query_578937, "uploadType", newJString(uploadType))
  add(query_578937, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578938 = body
  add(query_578937, "callback", newJString(callback))
  add(query_578937, "fields", newJString(fields))
  add(query_578937, "access_token", newJString(accessToken))
  add(query_578937, "upload_protocol", newJString(uploadProtocol))
  result = call_578936.call(nil, query_578937, nil, nil, body_578938)

var scriptProjectsCreate* = Call_ScriptProjectsCreate_578920(
    name: "scriptProjectsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects",
    validator: validate_ScriptProjectsCreate_578921, base: "/",
    url: url_ScriptProjectsCreate_578922, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGet_578939 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsGet_578941(protocol: Scheme; host: string; base: string;
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

proc validate_ScriptProjectsGet_578940(path: JsonNode; query: JsonNode;
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
  var valid_578956 = path.getOrDefault("scriptId")
  valid_578956 = validateParameter(valid_578956, JString, required = true,
                                 default = nil)
  if valid_578956 != nil:
    section.add "scriptId", valid_578956
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578957 = query.getOrDefault("key")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "key", valid_578957
  var valid_578958 = query.getOrDefault("prettyPrint")
  valid_578958 = validateParameter(valid_578958, JBool, required = false,
                                 default = newJBool(true))
  if valid_578958 != nil:
    section.add "prettyPrint", valid_578958
  var valid_578959 = query.getOrDefault("oauth_token")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "oauth_token", valid_578959
  var valid_578960 = query.getOrDefault("$.xgafv")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = newJString("1"))
  if valid_578960 != nil:
    section.add "$.xgafv", valid_578960
  var valid_578961 = query.getOrDefault("alt")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("json"))
  if valid_578961 != nil:
    section.add "alt", valid_578961
  var valid_578962 = query.getOrDefault("uploadType")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "uploadType", valid_578962
  var valid_578963 = query.getOrDefault("quotaUser")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "quotaUser", valid_578963
  var valid_578964 = query.getOrDefault("callback")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "callback", valid_578964
  var valid_578965 = query.getOrDefault("fields")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "fields", valid_578965
  var valid_578966 = query.getOrDefault("access_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "access_token", valid_578966
  var valid_578967 = query.getOrDefault("upload_protocol")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "upload_protocol", valid_578967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578968: Call_ScriptProjectsGet_578939; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a script project's metadata.
  ## 
  let valid = call_578968.validator(path, query, header, formData, body)
  let scheme = call_578968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578968.url(scheme.get, call_578968.host, call_578968.base,
                         call_578968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578968, url, valid)

proc call*(call_578969: Call_ScriptProjectsGet_578939; scriptId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsGet
  ## Gets a script project's metadata.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578970 = newJObject()
  var query_578971 = newJObject()
  add(query_578971, "key", newJString(key))
  add(query_578971, "prettyPrint", newJBool(prettyPrint))
  add(query_578971, "oauth_token", newJString(oauthToken))
  add(query_578971, "$.xgafv", newJString(Xgafv))
  add(query_578971, "alt", newJString(alt))
  add(query_578971, "uploadType", newJString(uploadType))
  add(query_578971, "quotaUser", newJString(quotaUser))
  add(path_578970, "scriptId", newJString(scriptId))
  add(query_578971, "callback", newJString(callback))
  add(query_578971, "fields", newJString(fields))
  add(query_578971, "access_token", newJString(accessToken))
  add(query_578971, "upload_protocol", newJString(uploadProtocol))
  result = call_578969.call(path_578970, query_578971, nil, nil, nil)

var scriptProjectsGet* = Call_ScriptProjectsGet_578939(name: "scriptProjectsGet",
    meth: HttpMethod.HttpGet, host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}", validator: validate_ScriptProjectsGet_578940,
    base: "/", url: url_ScriptProjectsGet_578941, schemes: {Scheme.Https})
type
  Call_ScriptProjectsUpdateContent_578992 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsUpdateContent_578994(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsUpdateContent_578993(path: JsonNode; query: JsonNode;
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
  var valid_578995 = path.getOrDefault("scriptId")
  valid_578995 = validateParameter(valid_578995, JString, required = true,
                                 default = nil)
  if valid_578995 != nil:
    section.add "scriptId", valid_578995
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578996 = query.getOrDefault("key")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "key", valid_578996
  var valid_578997 = query.getOrDefault("prettyPrint")
  valid_578997 = validateParameter(valid_578997, JBool, required = false,
                                 default = newJBool(true))
  if valid_578997 != nil:
    section.add "prettyPrint", valid_578997
  var valid_578998 = query.getOrDefault("oauth_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "oauth_token", valid_578998
  var valid_578999 = query.getOrDefault("$.xgafv")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("1"))
  if valid_578999 != nil:
    section.add "$.xgafv", valid_578999
  var valid_579000 = query.getOrDefault("alt")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("json"))
  if valid_579000 != nil:
    section.add "alt", valid_579000
  var valid_579001 = query.getOrDefault("uploadType")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "uploadType", valid_579001
  var valid_579002 = query.getOrDefault("quotaUser")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "quotaUser", valid_579002
  var valid_579003 = query.getOrDefault("callback")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "callback", valid_579003
  var valid_579004 = query.getOrDefault("fields")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "fields", valid_579004
  var valid_579005 = query.getOrDefault("access_token")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "access_token", valid_579005
  var valid_579006 = query.getOrDefault("upload_protocol")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "upload_protocol", valid_579006
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

proc call*(call_579008: Call_ScriptProjectsUpdateContent_578992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the content of the specified script project.
  ## This content is stored as the HEAD version, and is used when the script is
  ## executed as a trigger, in the script editor, in add-on preview mode, or as
  ## a web app or Apps Script API in development mode. This clears all the
  ## existing files in the project.
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_ScriptProjectsUpdateContent_578992; scriptId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsUpdateContent
  ## Updates the content of the specified script project.
  ## This content is stored as the HEAD version, and is used when the script is
  ## executed as a trigger, in the script editor, in add-on preview mode, or as
  ## a web app or Apps Script API in development mode. This clears all the
  ## existing files in the project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  var body_579012 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "$.xgafv", newJString(Xgafv))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "uploadType", newJString(uploadType))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(path_579010, "scriptId", newJString(scriptId))
  if body != nil:
    body_579012 = body
  add(query_579011, "callback", newJString(callback))
  add(query_579011, "fields", newJString(fields))
  add(query_579011, "access_token", newJString(accessToken))
  add(query_579011, "upload_protocol", newJString(uploadProtocol))
  result = call_579009.call(path_579010, query_579011, nil, nil, body_579012)

var scriptProjectsUpdateContent* = Call_ScriptProjectsUpdateContent_578992(
    name: "scriptProjectsUpdateContent", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsUpdateContent_578993, base: "/",
    url: url_ScriptProjectsUpdateContent_578994, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetContent_578972 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsGetContent_578974(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsGetContent_578973(path: JsonNode; query: JsonNode;
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
  var valid_578975 = path.getOrDefault("scriptId")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "scriptId", valid_578975
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   versionNumber: JInt
  ##                : The version number of the project to retrieve. If not provided, the
  ## project's HEAD version is returned.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578976 = query.getOrDefault("key")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "key", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("$.xgafv")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("1"))
  if valid_578979 != nil:
    section.add "$.xgafv", valid_578979
  var valid_578980 = query.getOrDefault("alt")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = newJString("json"))
  if valid_578980 != nil:
    section.add "alt", valid_578980
  var valid_578981 = query.getOrDefault("uploadType")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "uploadType", valid_578981
  var valid_578982 = query.getOrDefault("quotaUser")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "quotaUser", valid_578982
  var valid_578983 = query.getOrDefault("versionNumber")
  valid_578983 = validateParameter(valid_578983, JInt, required = false, default = nil)
  if valid_578983 != nil:
    section.add "versionNumber", valid_578983
  var valid_578984 = query.getOrDefault("callback")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "callback", valid_578984
  var valid_578985 = query.getOrDefault("fields")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "fields", valid_578985
  var valid_578986 = query.getOrDefault("access_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "access_token", valid_578986
  var valid_578987 = query.getOrDefault("upload_protocol")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "upload_protocol", valid_578987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578988: Call_ScriptProjectsGetContent_578972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the content of the script project, including the code source and
  ## metadata for each script file.
  ## 
  let valid = call_578988.validator(path, query, header, formData, body)
  let scheme = call_578988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578988.url(scheme.get, call_578988.host, call_578988.base,
                         call_578988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578988, url, valid)

proc call*(call_578989: Call_ScriptProjectsGetContent_578972; scriptId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; versionNumber: int = 0; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsGetContent
  ## Gets the content of the script project, including the code source and
  ## metadata for each script file.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   versionNumber: int
  ##                : The version number of the project to retrieve. If not provided, the
  ## project's HEAD version is returned.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578990 = newJObject()
  var query_578991 = newJObject()
  add(query_578991, "key", newJString(key))
  add(query_578991, "prettyPrint", newJBool(prettyPrint))
  add(query_578991, "oauth_token", newJString(oauthToken))
  add(query_578991, "$.xgafv", newJString(Xgafv))
  add(query_578991, "alt", newJString(alt))
  add(query_578991, "uploadType", newJString(uploadType))
  add(query_578991, "quotaUser", newJString(quotaUser))
  add(path_578990, "scriptId", newJString(scriptId))
  add(query_578991, "versionNumber", newJInt(versionNumber))
  add(query_578991, "callback", newJString(callback))
  add(query_578991, "fields", newJString(fields))
  add(query_578991, "access_token", newJString(accessToken))
  add(query_578991, "upload_protocol", newJString(uploadProtocol))
  result = call_578989.call(path_578990, query_578991, nil, nil, nil)

var scriptProjectsGetContent* = Call_ScriptProjectsGetContent_578972(
    name: "scriptProjectsGetContent", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsGetContent_578973, base: "/",
    url: url_ScriptProjectsGetContent_578974, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsCreate_579034 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsDeploymentsCreate_579036(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsCreate_579035(path: JsonNode;
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
  var valid_579037 = path.getOrDefault("scriptId")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "scriptId", valid_579037
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579038 = query.getOrDefault("key")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "key", valid_579038
  var valid_579039 = query.getOrDefault("prettyPrint")
  valid_579039 = validateParameter(valid_579039, JBool, required = false,
                                 default = newJBool(true))
  if valid_579039 != nil:
    section.add "prettyPrint", valid_579039
  var valid_579040 = query.getOrDefault("oauth_token")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "oauth_token", valid_579040
  var valid_579041 = query.getOrDefault("$.xgafv")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = newJString("1"))
  if valid_579041 != nil:
    section.add "$.xgafv", valid_579041
  var valid_579042 = query.getOrDefault("alt")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("json"))
  if valid_579042 != nil:
    section.add "alt", valid_579042
  var valid_579043 = query.getOrDefault("uploadType")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "uploadType", valid_579043
  var valid_579044 = query.getOrDefault("quotaUser")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "quotaUser", valid_579044
  var valid_579045 = query.getOrDefault("callback")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "callback", valid_579045
  var valid_579046 = query.getOrDefault("fields")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "fields", valid_579046
  var valid_579047 = query.getOrDefault("access_token")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "access_token", valid_579047
  var valid_579048 = query.getOrDefault("upload_protocol")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "upload_protocol", valid_579048
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

proc call*(call_579050: Call_ScriptProjectsDeploymentsCreate_579034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment of an Apps Script project.
  ## 
  let valid = call_579050.validator(path, query, header, formData, body)
  let scheme = call_579050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579050.url(scheme.get, call_579050.host, call_579050.base,
                         call_579050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579050, url, valid)

proc call*(call_579051: Call_ScriptProjectsDeploymentsCreate_579034;
          scriptId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## scriptProjectsDeploymentsCreate
  ## Creates a deployment of an Apps Script project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579052 = newJObject()
  var query_579053 = newJObject()
  var body_579054 = newJObject()
  add(query_579053, "key", newJString(key))
  add(query_579053, "prettyPrint", newJBool(prettyPrint))
  add(query_579053, "oauth_token", newJString(oauthToken))
  add(query_579053, "$.xgafv", newJString(Xgafv))
  add(query_579053, "alt", newJString(alt))
  add(query_579053, "uploadType", newJString(uploadType))
  add(query_579053, "quotaUser", newJString(quotaUser))
  add(path_579052, "scriptId", newJString(scriptId))
  if body != nil:
    body_579054 = body
  add(query_579053, "callback", newJString(callback))
  add(query_579053, "fields", newJString(fields))
  add(query_579053, "access_token", newJString(accessToken))
  add(query_579053, "upload_protocol", newJString(uploadProtocol))
  result = call_579051.call(path_579052, query_579053, nil, nil, body_579054)

var scriptProjectsDeploymentsCreate* = Call_ScriptProjectsDeploymentsCreate_579034(
    name: "scriptProjectsDeploymentsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsCreate_579035, base: "/",
    url: url_ScriptProjectsDeploymentsCreate_579036, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsList_579013 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsDeploymentsList_579015(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsList_579014(path: JsonNode; query: JsonNode;
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
  var valid_579016 = path.getOrDefault("scriptId")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "scriptId", valid_579016
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of deployments on each returned page. Defaults to 50.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("$.xgafv")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("1"))
  if valid_579020 != nil:
    section.add "$.xgafv", valid_579020
  var valid_579021 = query.getOrDefault("pageSize")
  valid_579021 = validateParameter(valid_579021, JInt, required = false, default = nil)
  if valid_579021 != nil:
    section.add "pageSize", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("uploadType")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "uploadType", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("pageToken")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "pageToken", valid_579025
  var valid_579026 = query.getOrDefault("callback")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "callback", valid_579026
  var valid_579027 = query.getOrDefault("fields")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "fields", valid_579027
  var valid_579028 = query.getOrDefault("access_token")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "access_token", valid_579028
  var valid_579029 = query.getOrDefault("upload_protocol")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "upload_protocol", valid_579029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579030: Call_ScriptProjectsDeploymentsList_579013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the deployments of an Apps Script project.
  ## 
  let valid = call_579030.validator(path, query, header, formData, body)
  let scheme = call_579030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579030.url(scheme.get, call_579030.host, call_579030.base,
                         call_579030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579030, url, valid)

proc call*(call_579031: Call_ScriptProjectsDeploymentsList_579013;
          scriptId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsDeploymentsList
  ## Lists the deployments of an Apps Script project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of deployments on each returned page. Defaults to 50.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579032 = newJObject()
  var query_579033 = newJObject()
  add(query_579033, "key", newJString(key))
  add(query_579033, "prettyPrint", newJBool(prettyPrint))
  add(query_579033, "oauth_token", newJString(oauthToken))
  add(query_579033, "$.xgafv", newJString(Xgafv))
  add(query_579033, "pageSize", newJInt(pageSize))
  add(query_579033, "alt", newJString(alt))
  add(query_579033, "uploadType", newJString(uploadType))
  add(query_579033, "quotaUser", newJString(quotaUser))
  add(path_579032, "scriptId", newJString(scriptId))
  add(query_579033, "pageToken", newJString(pageToken))
  add(query_579033, "callback", newJString(callback))
  add(query_579033, "fields", newJString(fields))
  add(query_579033, "access_token", newJString(accessToken))
  add(query_579033, "upload_protocol", newJString(uploadProtocol))
  result = call_579031.call(path_579032, query_579033, nil, nil, nil)

var scriptProjectsDeploymentsList* = Call_ScriptProjectsDeploymentsList_579013(
    name: "scriptProjectsDeploymentsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsList_579014, base: "/",
    url: url_ScriptProjectsDeploymentsList_579015, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsUpdate_579075 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsDeploymentsUpdate_579077(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsUpdate_579076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a deployment of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  ##   deploymentId: JString (required)
  ##               : The deployment ID for this deployment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_579078 = path.getOrDefault("scriptId")
  valid_579078 = validateParameter(valid_579078, JString, required = true,
                                 default = nil)
  if valid_579078 != nil:
    section.add "scriptId", valid_579078
  var valid_579079 = path.getOrDefault("deploymentId")
  valid_579079 = validateParameter(valid_579079, JString, required = true,
                                 default = nil)
  if valid_579079 != nil:
    section.add "deploymentId", valid_579079
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579080 = query.getOrDefault("key")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "key", valid_579080
  var valid_579081 = query.getOrDefault("prettyPrint")
  valid_579081 = validateParameter(valid_579081, JBool, required = false,
                                 default = newJBool(true))
  if valid_579081 != nil:
    section.add "prettyPrint", valid_579081
  var valid_579082 = query.getOrDefault("oauth_token")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "oauth_token", valid_579082
  var valid_579083 = query.getOrDefault("$.xgafv")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = newJString("1"))
  if valid_579083 != nil:
    section.add "$.xgafv", valid_579083
  var valid_579084 = query.getOrDefault("alt")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("json"))
  if valid_579084 != nil:
    section.add "alt", valid_579084
  var valid_579085 = query.getOrDefault("uploadType")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "uploadType", valid_579085
  var valid_579086 = query.getOrDefault("quotaUser")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "quotaUser", valid_579086
  var valid_579087 = query.getOrDefault("callback")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "callback", valid_579087
  var valid_579088 = query.getOrDefault("fields")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "fields", valid_579088
  var valid_579089 = query.getOrDefault("access_token")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "access_token", valid_579089
  var valid_579090 = query.getOrDefault("upload_protocol")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "upload_protocol", valid_579090
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

proc call*(call_579092: Call_ScriptProjectsDeploymentsUpdate_579075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment of an Apps Script project.
  ## 
  let valid = call_579092.validator(path, query, header, formData, body)
  let scheme = call_579092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579092.url(scheme.get, call_579092.host, call_579092.base,
                         call_579092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579092, url, valid)

proc call*(call_579093: Call_ScriptProjectsDeploymentsUpdate_579075;
          scriptId: string; deploymentId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsDeploymentsUpdate
  ## Updates a deployment of an Apps Script project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   deploymentId: string (required)
  ##               : The deployment ID for this deployment.
  var path_579094 = newJObject()
  var query_579095 = newJObject()
  var body_579096 = newJObject()
  add(query_579095, "key", newJString(key))
  add(query_579095, "prettyPrint", newJBool(prettyPrint))
  add(query_579095, "oauth_token", newJString(oauthToken))
  add(query_579095, "$.xgafv", newJString(Xgafv))
  add(query_579095, "alt", newJString(alt))
  add(query_579095, "uploadType", newJString(uploadType))
  add(query_579095, "quotaUser", newJString(quotaUser))
  add(path_579094, "scriptId", newJString(scriptId))
  if body != nil:
    body_579096 = body
  add(query_579095, "callback", newJString(callback))
  add(query_579095, "fields", newJString(fields))
  add(query_579095, "access_token", newJString(accessToken))
  add(query_579095, "upload_protocol", newJString(uploadProtocol))
  add(path_579094, "deploymentId", newJString(deploymentId))
  result = call_579093.call(path_579094, query_579095, nil, nil, body_579096)

var scriptProjectsDeploymentsUpdate* = Call_ScriptProjectsDeploymentsUpdate_579075(
    name: "scriptProjectsDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsUpdate_579076, base: "/",
    url: url_ScriptProjectsDeploymentsUpdate_579077, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsGet_579055 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsDeploymentsGet_579057(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsGet_579056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  ##   deploymentId: JString (required)
  ##               : The deployment ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_579058 = path.getOrDefault("scriptId")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "scriptId", valid_579058
  var valid_579059 = path.getOrDefault("deploymentId")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "deploymentId", valid_579059
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("prettyPrint")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "prettyPrint", valid_579061
  var valid_579062 = query.getOrDefault("oauth_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "oauth_token", valid_579062
  var valid_579063 = query.getOrDefault("$.xgafv")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("1"))
  if valid_579063 != nil:
    section.add "$.xgafv", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("uploadType")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "uploadType", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("callback")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "callback", valid_579067
  var valid_579068 = query.getOrDefault("fields")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "fields", valid_579068
  var valid_579069 = query.getOrDefault("access_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "access_token", valid_579069
  var valid_579070 = query.getOrDefault("upload_protocol")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "upload_protocol", valid_579070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579071: Call_ScriptProjectsDeploymentsGet_579055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment of an Apps Script project.
  ## 
  let valid = call_579071.validator(path, query, header, formData, body)
  let scheme = call_579071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579071.url(scheme.get, call_579071.host, call_579071.base,
                         call_579071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579071, url, valid)

proc call*(call_579072: Call_ScriptProjectsDeploymentsGet_579055; scriptId: string;
          deploymentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsDeploymentsGet
  ## Gets a deployment of an Apps Script project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   deploymentId: string (required)
  ##               : The deployment ID.
  var path_579073 = newJObject()
  var query_579074 = newJObject()
  add(query_579074, "key", newJString(key))
  add(query_579074, "prettyPrint", newJBool(prettyPrint))
  add(query_579074, "oauth_token", newJString(oauthToken))
  add(query_579074, "$.xgafv", newJString(Xgafv))
  add(query_579074, "alt", newJString(alt))
  add(query_579074, "uploadType", newJString(uploadType))
  add(query_579074, "quotaUser", newJString(quotaUser))
  add(path_579073, "scriptId", newJString(scriptId))
  add(query_579074, "callback", newJString(callback))
  add(query_579074, "fields", newJString(fields))
  add(query_579074, "access_token", newJString(accessToken))
  add(query_579074, "upload_protocol", newJString(uploadProtocol))
  add(path_579073, "deploymentId", newJString(deploymentId))
  result = call_579072.call(path_579073, query_579074, nil, nil, nil)

var scriptProjectsDeploymentsGet* = Call_ScriptProjectsDeploymentsGet_579055(
    name: "scriptProjectsDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsGet_579056, base: "/",
    url: url_ScriptProjectsDeploymentsGet_579057, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsDelete_579097 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsDeploymentsDelete_579099(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsDeploymentsDelete_579098(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a deployment of an Apps Script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  ##   deploymentId: JString (required)
  ##               : The deployment ID to be undeployed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scriptId` field"
  var valid_579100 = path.getOrDefault("scriptId")
  valid_579100 = validateParameter(valid_579100, JString, required = true,
                                 default = nil)
  if valid_579100 != nil:
    section.add "scriptId", valid_579100
  var valid_579101 = path.getOrDefault("deploymentId")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "deploymentId", valid_579101
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579102 = query.getOrDefault("key")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "key", valid_579102
  var valid_579103 = query.getOrDefault("prettyPrint")
  valid_579103 = validateParameter(valid_579103, JBool, required = false,
                                 default = newJBool(true))
  if valid_579103 != nil:
    section.add "prettyPrint", valid_579103
  var valid_579104 = query.getOrDefault("oauth_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "oauth_token", valid_579104
  var valid_579105 = query.getOrDefault("$.xgafv")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = newJString("1"))
  if valid_579105 != nil:
    section.add "$.xgafv", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("uploadType")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "uploadType", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
  var valid_579109 = query.getOrDefault("callback")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "callback", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  var valid_579111 = query.getOrDefault("access_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "access_token", valid_579111
  var valid_579112 = query.getOrDefault("upload_protocol")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "upload_protocol", valid_579112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579113: Call_ScriptProjectsDeploymentsDelete_579097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment of an Apps Script project.
  ## 
  let valid = call_579113.validator(path, query, header, formData, body)
  let scheme = call_579113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579113.url(scheme.get, call_579113.host, call_579113.base,
                         call_579113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579113, url, valid)

proc call*(call_579114: Call_ScriptProjectsDeploymentsDelete_579097;
          scriptId: string; deploymentId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## scriptProjectsDeploymentsDelete
  ## Deletes a deployment of an Apps Script project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   deploymentId: string (required)
  ##               : The deployment ID to be undeployed.
  var path_579115 = newJObject()
  var query_579116 = newJObject()
  add(query_579116, "key", newJString(key))
  add(query_579116, "prettyPrint", newJBool(prettyPrint))
  add(query_579116, "oauth_token", newJString(oauthToken))
  add(query_579116, "$.xgafv", newJString(Xgafv))
  add(query_579116, "alt", newJString(alt))
  add(query_579116, "uploadType", newJString(uploadType))
  add(query_579116, "quotaUser", newJString(quotaUser))
  add(path_579115, "scriptId", newJString(scriptId))
  add(query_579116, "callback", newJString(callback))
  add(query_579116, "fields", newJString(fields))
  add(query_579116, "access_token", newJString(accessToken))
  add(query_579116, "upload_protocol", newJString(uploadProtocol))
  add(path_579115, "deploymentId", newJString(deploymentId))
  result = call_579114.call(path_579115, query_579116, nil, nil, nil)

var scriptProjectsDeploymentsDelete* = Call_ScriptProjectsDeploymentsDelete_579097(
    name: "scriptProjectsDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsDelete_579098, base: "/",
    url: url_ScriptProjectsDeploymentsDelete_579099, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetMetrics_579117 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsGetMetrics_579119(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsGetMetrics_579118(path: JsonNode; query: JsonNode;
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
  var valid_579120 = path.getOrDefault("scriptId")
  valid_579120 = validateParameter(valid_579120, JString, required = true,
                                 default = nil)
  if valid_579120 != nil:
    section.add "scriptId", valid_579120
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   metricsGranularity: JString
  ##                     : Required field indicating what granularity of metrics are returned.
  ##   metricsFilter.deploymentId: JString
  ##                             : Optional field indicating a specific deployment to retrieve metrics from.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579121 = query.getOrDefault("key")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "key", valid_579121
  var valid_579122 = query.getOrDefault("prettyPrint")
  valid_579122 = validateParameter(valid_579122, JBool, required = false,
                                 default = newJBool(true))
  if valid_579122 != nil:
    section.add "prettyPrint", valid_579122
  var valid_579123 = query.getOrDefault("oauth_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "oauth_token", valid_579123
  var valid_579124 = query.getOrDefault("$.xgafv")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = newJString("1"))
  if valid_579124 != nil:
    section.add "$.xgafv", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("uploadType")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "uploadType", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("metricsGranularity")
  valid_579128 = validateParameter(valid_579128, JString, required = false, default = newJString(
      "UNSPECIFIED_GRANULARITY"))
  if valid_579128 != nil:
    section.add "metricsGranularity", valid_579128
  var valid_579129 = query.getOrDefault("metricsFilter.deploymentId")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "metricsFilter.deploymentId", valid_579129
  var valid_579130 = query.getOrDefault("callback")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "callback", valid_579130
  var valid_579131 = query.getOrDefault("fields")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "fields", valid_579131
  var valid_579132 = query.getOrDefault("access_token")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "access_token", valid_579132
  var valid_579133 = query.getOrDefault("upload_protocol")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "upload_protocol", valid_579133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579134: Call_ScriptProjectsGetMetrics_579117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get metrics data for scripts, such as number of executions and
  ## active users.
  ## 
  let valid = call_579134.validator(path, query, header, formData, body)
  let scheme = call_579134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579134.url(scheme.get, call_579134.host, call_579134.base,
                         call_579134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579134, url, valid)

proc call*(call_579135: Call_ScriptProjectsGetMetrics_579117; scriptId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = "";
          metricsGranularity: string = "UNSPECIFIED_GRANULARITY";
          metricsFilterDeploymentId: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsGetMetrics
  ## Get metrics data for scripts, such as number of executions and
  ## active users.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   metricsGranularity: string
  ##                     : Required field indicating what granularity of metrics are returned.
  ##   scriptId: string (required)
  ##           : Required field indicating the script to get metrics for.
  ##   metricsFilterDeploymentId: string
  ##                            : Optional field indicating a specific deployment to retrieve metrics from.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579136 = newJObject()
  var query_579137 = newJObject()
  add(query_579137, "key", newJString(key))
  add(query_579137, "prettyPrint", newJBool(prettyPrint))
  add(query_579137, "oauth_token", newJString(oauthToken))
  add(query_579137, "$.xgafv", newJString(Xgafv))
  add(query_579137, "alt", newJString(alt))
  add(query_579137, "uploadType", newJString(uploadType))
  add(query_579137, "quotaUser", newJString(quotaUser))
  add(query_579137, "metricsGranularity", newJString(metricsGranularity))
  add(path_579136, "scriptId", newJString(scriptId))
  add(query_579137, "metricsFilter.deploymentId",
      newJString(metricsFilterDeploymentId))
  add(query_579137, "callback", newJString(callback))
  add(query_579137, "fields", newJString(fields))
  add(query_579137, "access_token", newJString(accessToken))
  add(query_579137, "upload_protocol", newJString(uploadProtocol))
  result = call_579135.call(path_579136, query_579137, nil, nil, nil)

var scriptProjectsGetMetrics* = Call_ScriptProjectsGetMetrics_579117(
    name: "scriptProjectsGetMetrics", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/metrics",
    validator: validate_ScriptProjectsGetMetrics_579118, base: "/",
    url: url_ScriptProjectsGetMetrics_579119, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsCreate_579159 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsVersionsCreate_579161(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsVersionsCreate_579160(path: JsonNode; query: JsonNode;
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
  var valid_579162 = path.getOrDefault("scriptId")
  valid_579162 = validateParameter(valid_579162, JString, required = true,
                                 default = nil)
  if valid_579162 != nil:
    section.add "scriptId", valid_579162
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579163 = query.getOrDefault("key")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "key", valid_579163
  var valid_579164 = query.getOrDefault("prettyPrint")
  valid_579164 = validateParameter(valid_579164, JBool, required = false,
                                 default = newJBool(true))
  if valid_579164 != nil:
    section.add "prettyPrint", valid_579164
  var valid_579165 = query.getOrDefault("oauth_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "oauth_token", valid_579165
  var valid_579166 = query.getOrDefault("$.xgafv")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = newJString("1"))
  if valid_579166 != nil:
    section.add "$.xgafv", valid_579166
  var valid_579167 = query.getOrDefault("alt")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("json"))
  if valid_579167 != nil:
    section.add "alt", valid_579167
  var valid_579168 = query.getOrDefault("uploadType")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "uploadType", valid_579168
  var valid_579169 = query.getOrDefault("quotaUser")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "quotaUser", valid_579169
  var valid_579170 = query.getOrDefault("callback")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "callback", valid_579170
  var valid_579171 = query.getOrDefault("fields")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "fields", valid_579171
  var valid_579172 = query.getOrDefault("access_token")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "access_token", valid_579172
  var valid_579173 = query.getOrDefault("upload_protocol")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "upload_protocol", valid_579173
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

proc call*(call_579175: Call_ScriptProjectsVersionsCreate_579159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new immutable version using the current code, with a unique
  ## version number.
  ## 
  let valid = call_579175.validator(path, query, header, formData, body)
  let scheme = call_579175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579175.url(scheme.get, call_579175.host, call_579175.base,
                         call_579175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579175, url, valid)

proc call*(call_579176: Call_ScriptProjectsVersionsCreate_579159; scriptId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsVersionsCreate
  ## Creates a new immutable version using the current code, with a unique
  ## version number.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579177 = newJObject()
  var query_579178 = newJObject()
  var body_579179 = newJObject()
  add(query_579178, "key", newJString(key))
  add(query_579178, "prettyPrint", newJBool(prettyPrint))
  add(query_579178, "oauth_token", newJString(oauthToken))
  add(query_579178, "$.xgafv", newJString(Xgafv))
  add(query_579178, "alt", newJString(alt))
  add(query_579178, "uploadType", newJString(uploadType))
  add(query_579178, "quotaUser", newJString(quotaUser))
  add(path_579177, "scriptId", newJString(scriptId))
  if body != nil:
    body_579179 = body
  add(query_579178, "callback", newJString(callback))
  add(query_579178, "fields", newJString(fields))
  add(query_579178, "access_token", newJString(accessToken))
  add(query_579178, "upload_protocol", newJString(uploadProtocol))
  result = call_579176.call(path_579177, query_579178, nil, nil, body_579179)

var scriptProjectsVersionsCreate* = Call_ScriptProjectsVersionsCreate_579159(
    name: "scriptProjectsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsCreate_579160, base: "/",
    url: url_ScriptProjectsVersionsCreate_579161, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsList_579138 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsVersionsList_579140(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsVersionsList_579139(path: JsonNode; query: JsonNode;
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
  var valid_579141 = path.getOrDefault("scriptId")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "scriptId", valid_579141
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of versions on each returned page. Defaults to 50.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579142 = query.getOrDefault("key")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "key", valid_579142
  var valid_579143 = query.getOrDefault("prettyPrint")
  valid_579143 = validateParameter(valid_579143, JBool, required = false,
                                 default = newJBool(true))
  if valid_579143 != nil:
    section.add "prettyPrint", valid_579143
  var valid_579144 = query.getOrDefault("oauth_token")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "oauth_token", valid_579144
  var valid_579145 = query.getOrDefault("$.xgafv")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("1"))
  if valid_579145 != nil:
    section.add "$.xgafv", valid_579145
  var valid_579146 = query.getOrDefault("pageSize")
  valid_579146 = validateParameter(valid_579146, JInt, required = false, default = nil)
  if valid_579146 != nil:
    section.add "pageSize", valid_579146
  var valid_579147 = query.getOrDefault("alt")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("json"))
  if valid_579147 != nil:
    section.add "alt", valid_579147
  var valid_579148 = query.getOrDefault("uploadType")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "uploadType", valid_579148
  var valid_579149 = query.getOrDefault("quotaUser")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "quotaUser", valid_579149
  var valid_579150 = query.getOrDefault("pageToken")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "pageToken", valid_579150
  var valid_579151 = query.getOrDefault("callback")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "callback", valid_579151
  var valid_579152 = query.getOrDefault("fields")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "fields", valid_579152
  var valid_579153 = query.getOrDefault("access_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "access_token", valid_579153
  var valid_579154 = query.getOrDefault("upload_protocol")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "upload_protocol", valid_579154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579155: Call_ScriptProjectsVersionsList_579138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of a script project.
  ## 
  let valid = call_579155.validator(path, query, header, formData, body)
  let scheme = call_579155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579155.url(scheme.get, call_579155.host, call_579155.base,
                         call_579155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579155, url, valid)

proc call*(call_579156: Call_ScriptProjectsVersionsList_579138; scriptId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## scriptProjectsVersionsList
  ## List the versions of a script project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of versions on each returned page. Defaults to 50.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   pageToken: string
  ##            : The token for continuing a previous list request on the next page. This
  ## should be set to the value of `nextPageToken` from a previous response.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579157 = newJObject()
  var query_579158 = newJObject()
  add(query_579158, "key", newJString(key))
  add(query_579158, "prettyPrint", newJBool(prettyPrint))
  add(query_579158, "oauth_token", newJString(oauthToken))
  add(query_579158, "$.xgafv", newJString(Xgafv))
  add(query_579158, "pageSize", newJInt(pageSize))
  add(query_579158, "alt", newJString(alt))
  add(query_579158, "uploadType", newJString(uploadType))
  add(query_579158, "quotaUser", newJString(quotaUser))
  add(path_579157, "scriptId", newJString(scriptId))
  add(query_579158, "pageToken", newJString(pageToken))
  add(query_579158, "callback", newJString(callback))
  add(query_579158, "fields", newJString(fields))
  add(query_579158, "access_token", newJString(accessToken))
  add(query_579158, "upload_protocol", newJString(uploadProtocol))
  result = call_579156.call(path_579157, query_579158, nil, nil, nil)

var scriptProjectsVersionsList* = Call_ScriptProjectsVersionsList_579138(
    name: "scriptProjectsVersionsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsList_579139, base: "/",
    url: url_ScriptProjectsVersionsList_579140, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsGet_579180 = ref object of OpenApiRestCall_578339
proc url_ScriptProjectsVersionsGet_579182(protocol: Scheme; host: string;
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

proc validate_ScriptProjectsVersionsGet_579181(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a version of a script project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   versionNumber: JInt (required)
  ##                : The version number.
  ##   scriptId: JString (required)
  ##           : The script project's Drive ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `versionNumber` field"
  var valid_579183 = path.getOrDefault("versionNumber")
  valid_579183 = validateParameter(valid_579183, JInt, required = true, default = nil)
  if valid_579183 != nil:
    section.add "versionNumber", valid_579183
  var valid_579184 = path.getOrDefault("scriptId")
  valid_579184 = validateParameter(valid_579184, JString, required = true,
                                 default = nil)
  if valid_579184 != nil:
    section.add "scriptId", valid_579184
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579185 = query.getOrDefault("key")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "key", valid_579185
  var valid_579186 = query.getOrDefault("prettyPrint")
  valid_579186 = validateParameter(valid_579186, JBool, required = false,
                                 default = newJBool(true))
  if valid_579186 != nil:
    section.add "prettyPrint", valid_579186
  var valid_579187 = query.getOrDefault("oauth_token")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "oauth_token", valid_579187
  var valid_579188 = query.getOrDefault("$.xgafv")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = newJString("1"))
  if valid_579188 != nil:
    section.add "$.xgafv", valid_579188
  var valid_579189 = query.getOrDefault("alt")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = newJString("json"))
  if valid_579189 != nil:
    section.add "alt", valid_579189
  var valid_579190 = query.getOrDefault("uploadType")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "uploadType", valid_579190
  var valid_579191 = query.getOrDefault("quotaUser")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "quotaUser", valid_579191
  var valid_579192 = query.getOrDefault("callback")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "callback", valid_579192
  var valid_579193 = query.getOrDefault("fields")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "fields", valid_579193
  var valid_579194 = query.getOrDefault("access_token")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "access_token", valid_579194
  var valid_579195 = query.getOrDefault("upload_protocol")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "upload_protocol", valid_579195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579196: Call_ScriptProjectsVersionsGet_579180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a version of a script project.
  ## 
  let valid = call_579196.validator(path, query, header, formData, body)
  let scheme = call_579196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579196.url(scheme.get, call_579196.host, call_579196.base,
                         call_579196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579196, url, valid)

proc call*(call_579197: Call_ScriptProjectsVersionsGet_579180; versionNumber: int;
          scriptId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## scriptProjectsVersionsGet
  ## Gets a version of a script project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   versionNumber: int (required)
  ##                : The version number.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script project's Drive ID.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579198 = newJObject()
  var query_579199 = newJObject()
  add(query_579199, "key", newJString(key))
  add(query_579199, "prettyPrint", newJBool(prettyPrint))
  add(query_579199, "oauth_token", newJString(oauthToken))
  add(query_579199, "$.xgafv", newJString(Xgafv))
  add(path_579198, "versionNumber", newJInt(versionNumber))
  add(query_579199, "alt", newJString(alt))
  add(query_579199, "uploadType", newJString(uploadType))
  add(query_579199, "quotaUser", newJString(quotaUser))
  add(path_579198, "scriptId", newJString(scriptId))
  add(query_579199, "callback", newJString(callback))
  add(query_579199, "fields", newJString(fields))
  add(query_579199, "access_token", newJString(accessToken))
  add(query_579199, "upload_protocol", newJString(uploadProtocol))
  result = call_579197.call(path_579198, query_579199, nil, nil, nil)

var scriptProjectsVersionsGet* = Call_ScriptProjectsVersionsGet_579180(
    name: "scriptProjectsVersionsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/versions/{versionNumber}",
    validator: validate_ScriptProjectsVersionsGet_579181, base: "/",
    url: url_ScriptProjectsVersionsGet_579182, schemes: {Scheme.Https})
type
  Call_ScriptScriptsRun_579200 = ref object of OpenApiRestCall_578339
proc url_ScriptScriptsRun_579202(protocol: Scheme; host: string; base: string;
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

proc validate_ScriptScriptsRun_579201(path: JsonNode; query: JsonNode;
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
  var valid_579203 = path.getOrDefault("scriptId")
  valid_579203 = validateParameter(valid_579203, JString, required = true,
                                 default = nil)
  if valid_579203 != nil:
    section.add "scriptId", valid_579203
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579204 = query.getOrDefault("key")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "key", valid_579204
  var valid_579205 = query.getOrDefault("prettyPrint")
  valid_579205 = validateParameter(valid_579205, JBool, required = false,
                                 default = newJBool(true))
  if valid_579205 != nil:
    section.add "prettyPrint", valid_579205
  var valid_579206 = query.getOrDefault("oauth_token")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "oauth_token", valid_579206
  var valid_579207 = query.getOrDefault("$.xgafv")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = newJString("1"))
  if valid_579207 != nil:
    section.add "$.xgafv", valid_579207
  var valid_579208 = query.getOrDefault("alt")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = newJString("json"))
  if valid_579208 != nil:
    section.add "alt", valid_579208
  var valid_579209 = query.getOrDefault("uploadType")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "uploadType", valid_579209
  var valid_579210 = query.getOrDefault("quotaUser")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "quotaUser", valid_579210
  var valid_579211 = query.getOrDefault("callback")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "callback", valid_579211
  var valid_579212 = query.getOrDefault("fields")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "fields", valid_579212
  var valid_579213 = query.getOrDefault("access_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "access_token", valid_579213
  var valid_579214 = query.getOrDefault("upload_protocol")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "upload_protocol", valid_579214
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

proc call*(call_579216: Call_ScriptScriptsRun_579200; path: JsonNode;
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
  let valid = call_579216.validator(path, query, header, formData, body)
  let scheme = call_579216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579216.url(scheme.get, call_579216.host, call_579216.base,
                         call_579216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579216, url, valid)

proc call*(call_579217: Call_ScriptScriptsRun_579200; scriptId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   scriptId: string (required)
  ##           : The script ID of the script to be executed. To find the script ID, open
  ## the project in the script editor and select **File > Project properties**.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579218 = newJObject()
  var query_579219 = newJObject()
  var body_579220 = newJObject()
  add(query_579219, "key", newJString(key))
  add(query_579219, "prettyPrint", newJBool(prettyPrint))
  add(query_579219, "oauth_token", newJString(oauthToken))
  add(query_579219, "$.xgafv", newJString(Xgafv))
  add(query_579219, "alt", newJString(alt))
  add(query_579219, "uploadType", newJString(uploadType))
  add(query_579219, "quotaUser", newJString(quotaUser))
  add(path_579218, "scriptId", newJString(scriptId))
  if body != nil:
    body_579220 = body
  add(query_579219, "callback", newJString(callback))
  add(query_579219, "fields", newJString(fields))
  add(query_579219, "access_token", newJString(accessToken))
  add(query_579219, "upload_protocol", newJString(uploadProtocol))
  result = call_579217.call(path_579218, query_579219, nil, nil, body_579220)

var scriptScriptsRun* = Call_ScriptScriptsRun_579200(name: "scriptScriptsRun",
    meth: HttpMethod.HttpPost, host: "script.googleapis.com",
    route: "/v1/scripts/{scriptId}:run", validator: validate_ScriptScriptsRun_579201,
    base: "/", url: url_ScriptScriptsRun_579202, schemes: {Scheme.Https})
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
