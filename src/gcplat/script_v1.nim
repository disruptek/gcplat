
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ScriptProcessesList_593677 = ref object of OpenApiRestCall_593408
proc url_ScriptProcessesList_593679(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ScriptProcessesList_593678(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("userProcessFilter.scriptId")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "userProcessFilter.scriptId", valid_593792
  var valid_593793 = query.getOrDefault("userProcessFilter.deploymentId")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "userProcessFilter.deploymentId", valid_593793
  var valid_593794 = query.getOrDefault("fields")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "fields", valid_593794
  var valid_593795 = query.getOrDefault("pageToken")
  valid_593795 = validateParameter(valid_593795, JString, required = false,
                                 default = nil)
  if valid_593795 != nil:
    section.add "pageToken", valid_593795
  var valid_593796 = query.getOrDefault("quotaUser")
  valid_593796 = validateParameter(valid_593796, JString, required = false,
                                 default = nil)
  if valid_593796 != nil:
    section.add "quotaUser", valid_593796
  var valid_593810 = query.getOrDefault("alt")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = newJString("json"))
  if valid_593810 != nil:
    section.add "alt", valid_593810
  var valid_593811 = query.getOrDefault("oauth_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "oauth_token", valid_593811
  var valid_593812 = query.getOrDefault("callback")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "callback", valid_593812
  var valid_593813 = query.getOrDefault("access_token")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "access_token", valid_593813
  var valid_593814 = query.getOrDefault("uploadType")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "uploadType", valid_593814
  var valid_593815 = query.getOrDefault("userProcessFilter.projectName")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "userProcessFilter.projectName", valid_593815
  var valid_593816 = query.getOrDefault("userProcessFilter.userAccessLevels")
  valid_593816 = validateParameter(valid_593816, JArray, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "userProcessFilter.userAccessLevels", valid_593816
  var valid_593817 = query.getOrDefault("userProcessFilter.types")
  valid_593817 = validateParameter(valid_593817, JArray, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "userProcessFilter.types", valid_593817
  var valid_593818 = query.getOrDefault("key")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = nil)
  if valid_593818 != nil:
    section.add "key", valid_593818
  var valid_593819 = query.getOrDefault("$.xgafv")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = newJString("1"))
  if valid_593819 != nil:
    section.add "$.xgafv", valid_593819
  var valid_593820 = query.getOrDefault("pageSize")
  valid_593820 = validateParameter(valid_593820, JInt, required = false, default = nil)
  if valid_593820 != nil:
    section.add "pageSize", valid_593820
  var valid_593821 = query.getOrDefault("userProcessFilter.functionName")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "userProcessFilter.functionName", valid_593821
  var valid_593822 = query.getOrDefault("userProcessFilter.endTime")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "userProcessFilter.endTime", valid_593822
  var valid_593823 = query.getOrDefault("prettyPrint")
  valid_593823 = validateParameter(valid_593823, JBool, required = false,
                                 default = newJBool(true))
  if valid_593823 != nil:
    section.add "prettyPrint", valid_593823
  var valid_593824 = query.getOrDefault("userProcessFilter.startTime")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "userProcessFilter.startTime", valid_593824
  var valid_593825 = query.getOrDefault("userProcessFilter.statuses")
  valid_593825 = validateParameter(valid_593825, JArray, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "userProcessFilter.statuses", valid_593825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593848: Call_ScriptProcessesList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List information about processes made by or on behalf of a user,
  ## such as process type and current status.
  ## 
  let valid = call_593848.validator(path, query, header, formData, body)
  let scheme = call_593848.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593848.url(scheme.get, call_593848.host, call_593848.base,
                         call_593848.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593848, url, valid)

proc call*(call_593919: Call_ScriptProcessesList_593677;
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
  var query_593920 = newJObject()
  add(query_593920, "upload_protocol", newJString(uploadProtocol))
  add(query_593920, "userProcessFilter.scriptId",
      newJString(userProcessFilterScriptId))
  add(query_593920, "userProcessFilter.deploymentId",
      newJString(userProcessFilterDeploymentId))
  add(query_593920, "fields", newJString(fields))
  add(query_593920, "pageToken", newJString(pageToken))
  add(query_593920, "quotaUser", newJString(quotaUser))
  add(query_593920, "alt", newJString(alt))
  add(query_593920, "oauth_token", newJString(oauthToken))
  add(query_593920, "callback", newJString(callback))
  add(query_593920, "access_token", newJString(accessToken))
  add(query_593920, "uploadType", newJString(uploadType))
  add(query_593920, "userProcessFilter.projectName",
      newJString(userProcessFilterProjectName))
  if userProcessFilterUserAccessLevels != nil:
    query_593920.add "userProcessFilter.userAccessLevels",
                    userProcessFilterUserAccessLevels
  if userProcessFilterTypes != nil:
    query_593920.add "userProcessFilter.types", userProcessFilterTypes
  add(query_593920, "key", newJString(key))
  add(query_593920, "$.xgafv", newJString(Xgafv))
  add(query_593920, "pageSize", newJInt(pageSize))
  add(query_593920, "userProcessFilter.functionName",
      newJString(userProcessFilterFunctionName))
  add(query_593920, "userProcessFilter.endTime",
      newJString(userProcessFilterEndTime))
  add(query_593920, "prettyPrint", newJBool(prettyPrint))
  add(query_593920, "userProcessFilter.startTime",
      newJString(userProcessFilterStartTime))
  if userProcessFilterStatuses != nil:
    query_593920.add "userProcessFilter.statuses", userProcessFilterStatuses
  result = call_593919.call(nil, query_593920, nil, nil, nil)

var scriptProcessesList* = Call_ScriptProcessesList_593677(
    name: "scriptProcessesList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes",
    validator: validate_ScriptProcessesList_593678, base: "/",
    url: url_ScriptProcessesList_593679, schemes: {Scheme.Https})
type
  Call_ScriptProcessesListScriptProcesses_593960 = ref object of OpenApiRestCall_593408
proc url_ScriptProcessesListScriptProcesses_593962(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ScriptProcessesListScriptProcesses_593961(path: JsonNode;
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
  var valid_593963 = query.getOrDefault("scriptProcessFilter.userAccessLevels")
  valid_593963 = validateParameter(valid_593963, JArray, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "scriptProcessFilter.userAccessLevels", valid_593963
  var valid_593964 = query.getOrDefault("upload_protocol")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "upload_protocol", valid_593964
  var valid_593965 = query.getOrDefault("fields")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = nil)
  if valid_593965 != nil:
    section.add "fields", valid_593965
  var valid_593966 = query.getOrDefault("pageToken")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "pageToken", valid_593966
  var valid_593967 = query.getOrDefault("quotaUser")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "quotaUser", valid_593967
  var valid_593968 = query.getOrDefault("scriptProcessFilter.startTime")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "scriptProcessFilter.startTime", valid_593968
  var valid_593969 = query.getOrDefault("alt")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = newJString("json"))
  if valid_593969 != nil:
    section.add "alt", valid_593969
  var valid_593970 = query.getOrDefault("scriptProcessFilter.types")
  valid_593970 = validateParameter(valid_593970, JArray, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "scriptProcessFilter.types", valid_593970
  var valid_593971 = query.getOrDefault("oauth_token")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "oauth_token", valid_593971
  var valid_593972 = query.getOrDefault("callback")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "callback", valid_593972
  var valid_593973 = query.getOrDefault("access_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "access_token", valid_593973
  var valid_593974 = query.getOrDefault("uploadType")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "uploadType", valid_593974
  var valid_593975 = query.getOrDefault("scriptProcessFilter.endTime")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "scriptProcessFilter.endTime", valid_593975
  var valid_593976 = query.getOrDefault("scriptProcessFilter.deploymentId")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "scriptProcessFilter.deploymentId", valid_593976
  var valid_593977 = query.getOrDefault("scriptProcessFilter.statuses")
  valid_593977 = validateParameter(valid_593977, JArray, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "scriptProcessFilter.statuses", valid_593977
  var valid_593978 = query.getOrDefault("key")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "key", valid_593978
  var valid_593979 = query.getOrDefault("$.xgafv")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("1"))
  if valid_593979 != nil:
    section.add "$.xgafv", valid_593979
  var valid_593980 = query.getOrDefault("pageSize")
  valid_593980 = validateParameter(valid_593980, JInt, required = false, default = nil)
  if valid_593980 != nil:
    section.add "pageSize", valid_593980
  var valid_593981 = query.getOrDefault("scriptId")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "scriptId", valid_593981
  var valid_593982 = query.getOrDefault("prettyPrint")
  valid_593982 = validateParameter(valid_593982, JBool, required = false,
                                 default = newJBool(true))
  if valid_593982 != nil:
    section.add "prettyPrint", valid_593982
  var valid_593983 = query.getOrDefault("scriptProcessFilter.functionName")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "scriptProcessFilter.functionName", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_ScriptProcessesListScriptProcesses_593960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List information about a script's executed processes, such as process type
  ## and current status.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ScriptProcessesListScriptProcesses_593960;
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
  var query_593986 = newJObject()
  if scriptProcessFilterUserAccessLevels != nil:
    query_593986.add "scriptProcessFilter.userAccessLevels",
                    scriptProcessFilterUserAccessLevels
  add(query_593986, "upload_protocol", newJString(uploadProtocol))
  add(query_593986, "fields", newJString(fields))
  add(query_593986, "pageToken", newJString(pageToken))
  add(query_593986, "quotaUser", newJString(quotaUser))
  add(query_593986, "scriptProcessFilter.startTime",
      newJString(scriptProcessFilterStartTime))
  add(query_593986, "alt", newJString(alt))
  if scriptProcessFilterTypes != nil:
    query_593986.add "scriptProcessFilter.types", scriptProcessFilterTypes
  add(query_593986, "oauth_token", newJString(oauthToken))
  add(query_593986, "callback", newJString(callback))
  add(query_593986, "access_token", newJString(accessToken))
  add(query_593986, "uploadType", newJString(uploadType))
  add(query_593986, "scriptProcessFilter.endTime",
      newJString(scriptProcessFilterEndTime))
  add(query_593986, "scriptProcessFilter.deploymentId",
      newJString(scriptProcessFilterDeploymentId))
  if scriptProcessFilterStatuses != nil:
    query_593986.add "scriptProcessFilter.statuses", scriptProcessFilterStatuses
  add(query_593986, "key", newJString(key))
  add(query_593986, "$.xgafv", newJString(Xgafv))
  add(query_593986, "pageSize", newJInt(pageSize))
  add(query_593986, "scriptId", newJString(scriptId))
  add(query_593986, "prettyPrint", newJBool(prettyPrint))
  add(query_593986, "scriptProcessFilter.functionName",
      newJString(scriptProcessFilterFunctionName))
  result = call_593985.call(nil, query_593986, nil, nil, nil)

var scriptProcessesListScriptProcesses* = Call_ScriptProcessesListScriptProcesses_593960(
    name: "scriptProcessesListScriptProcesses", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/processes:listScriptProcesses",
    validator: validate_ScriptProcessesListScriptProcesses_593961, base: "/",
    url: url_ScriptProcessesListScriptProcesses_593962, schemes: {Scheme.Https})
type
  Call_ScriptProjectsCreate_593987 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsCreate_593989(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ScriptProjectsCreate_593988(path: JsonNode; query: JsonNode;
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
  var valid_593990 = query.getOrDefault("upload_protocol")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "upload_protocol", valid_593990
  var valid_593991 = query.getOrDefault("fields")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "fields", valid_593991
  var valid_593992 = query.getOrDefault("quotaUser")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "quotaUser", valid_593992
  var valid_593993 = query.getOrDefault("alt")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("json"))
  if valid_593993 != nil:
    section.add "alt", valid_593993
  var valid_593994 = query.getOrDefault("oauth_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "oauth_token", valid_593994
  var valid_593995 = query.getOrDefault("callback")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "callback", valid_593995
  var valid_593996 = query.getOrDefault("access_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "access_token", valid_593996
  var valid_593997 = query.getOrDefault("uploadType")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "uploadType", valid_593997
  var valid_593998 = query.getOrDefault("key")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "key", valid_593998
  var valid_593999 = query.getOrDefault("$.xgafv")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("1"))
  if valid_593999 != nil:
    section.add "$.xgafv", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
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

proc call*(call_594002: Call_ScriptProjectsCreate_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new, empty script project with no script files and a base
  ## manifest file.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_ScriptProjectsCreate_593987;
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
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(query_594004, "key", newJString(key))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594005 = body
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  result = call_594003.call(nil, query_594004, nil, nil, body_594005)

var scriptProjectsCreate* = Call_ScriptProjectsCreate_593987(
    name: "scriptProjectsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects",
    validator: validate_ScriptProjectsCreate_593988, base: "/",
    url: url_ScriptProjectsCreate_593989, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGet_594006 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsGet_594008(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scriptId" in path, "`scriptId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "scriptId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScriptProjectsGet_594007(path: JsonNode; query: JsonNode;
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
  var valid_594023 = path.getOrDefault("scriptId")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "scriptId", valid_594023
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
  var valid_594024 = query.getOrDefault("upload_protocol")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "upload_protocol", valid_594024
  var valid_594025 = query.getOrDefault("fields")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "fields", valid_594025
  var valid_594026 = query.getOrDefault("quotaUser")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "quotaUser", valid_594026
  var valid_594027 = query.getOrDefault("alt")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = newJString("json"))
  if valid_594027 != nil:
    section.add "alt", valid_594027
  var valid_594028 = query.getOrDefault("oauth_token")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "oauth_token", valid_594028
  var valid_594029 = query.getOrDefault("callback")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "callback", valid_594029
  var valid_594030 = query.getOrDefault("access_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "access_token", valid_594030
  var valid_594031 = query.getOrDefault("uploadType")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "uploadType", valid_594031
  var valid_594032 = query.getOrDefault("key")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "key", valid_594032
  var valid_594033 = query.getOrDefault("$.xgafv")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = newJString("1"))
  if valid_594033 != nil:
    section.add "$.xgafv", valid_594033
  var valid_594034 = query.getOrDefault("prettyPrint")
  valid_594034 = validateParameter(valid_594034, JBool, required = false,
                                 default = newJBool(true))
  if valid_594034 != nil:
    section.add "prettyPrint", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_ScriptProjectsGet_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a script project's metadata.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_ScriptProjectsGet_594006; scriptId: string;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(query_594038, "upload_protocol", newJString(uploadProtocol))
  add(query_594038, "fields", newJString(fields))
  add(query_594038, "quotaUser", newJString(quotaUser))
  add(query_594038, "alt", newJString(alt))
  add(query_594038, "oauth_token", newJString(oauthToken))
  add(query_594038, "callback", newJString(callback))
  add(query_594038, "access_token", newJString(accessToken))
  add(query_594038, "uploadType", newJString(uploadType))
  add(query_594038, "key", newJString(key))
  add(query_594038, "$.xgafv", newJString(Xgafv))
  add(path_594037, "scriptId", newJString(scriptId))
  add(query_594038, "prettyPrint", newJBool(prettyPrint))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var scriptProjectsGet* = Call_ScriptProjectsGet_594006(name: "scriptProjectsGet",
    meth: HttpMethod.HttpGet, host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}", validator: validate_ScriptProjectsGet_594007,
    base: "/", url: url_ScriptProjectsGet_594008, schemes: {Scheme.Https})
type
  Call_ScriptProjectsUpdateContent_594059 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsUpdateContent_594061(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsUpdateContent_594060(path: JsonNode; query: JsonNode;
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
  var valid_594062 = path.getOrDefault("scriptId")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "scriptId", valid_594062
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
  var valid_594063 = query.getOrDefault("upload_protocol")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "upload_protocol", valid_594063
  var valid_594064 = query.getOrDefault("fields")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "fields", valid_594064
  var valid_594065 = query.getOrDefault("quotaUser")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "quotaUser", valid_594065
  var valid_594066 = query.getOrDefault("alt")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = newJString("json"))
  if valid_594066 != nil:
    section.add "alt", valid_594066
  var valid_594067 = query.getOrDefault("oauth_token")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "oauth_token", valid_594067
  var valid_594068 = query.getOrDefault("callback")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "callback", valid_594068
  var valid_594069 = query.getOrDefault("access_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "access_token", valid_594069
  var valid_594070 = query.getOrDefault("uploadType")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "uploadType", valid_594070
  var valid_594071 = query.getOrDefault("key")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "key", valid_594071
  var valid_594072 = query.getOrDefault("$.xgafv")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("1"))
  if valid_594072 != nil:
    section.add "$.xgafv", valid_594072
  var valid_594073 = query.getOrDefault("prettyPrint")
  valid_594073 = validateParameter(valid_594073, JBool, required = false,
                                 default = newJBool(true))
  if valid_594073 != nil:
    section.add "prettyPrint", valid_594073
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

proc call*(call_594075: Call_ScriptProjectsUpdateContent_594059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the content of the specified script project.
  ## This content is stored as the HEAD version, and is used when the script is
  ## executed as a trigger, in the script editor, in add-on preview mode, or as
  ## a web app or Apps Script API in development mode. This clears all the
  ## existing files in the project.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_ScriptProjectsUpdateContent_594059; scriptId: string;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  var body_594079 = newJObject()
  add(query_594078, "upload_protocol", newJString(uploadProtocol))
  add(query_594078, "fields", newJString(fields))
  add(query_594078, "quotaUser", newJString(quotaUser))
  add(query_594078, "alt", newJString(alt))
  add(query_594078, "oauth_token", newJString(oauthToken))
  add(query_594078, "callback", newJString(callback))
  add(query_594078, "access_token", newJString(accessToken))
  add(query_594078, "uploadType", newJString(uploadType))
  add(query_594078, "key", newJString(key))
  add(query_594078, "$.xgafv", newJString(Xgafv))
  add(path_594077, "scriptId", newJString(scriptId))
  if body != nil:
    body_594079 = body
  add(query_594078, "prettyPrint", newJBool(prettyPrint))
  result = call_594076.call(path_594077, query_594078, nil, nil, body_594079)

var scriptProjectsUpdateContent* = Call_ScriptProjectsUpdateContent_594059(
    name: "scriptProjectsUpdateContent", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsUpdateContent_594060, base: "/",
    url: url_ScriptProjectsUpdateContent_594061, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetContent_594039 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsGetContent_594041(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsGetContent_594040(path: JsonNode; query: JsonNode;
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
  var valid_594042 = path.getOrDefault("scriptId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "scriptId", valid_594042
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
  var valid_594043 = query.getOrDefault("upload_protocol")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "upload_protocol", valid_594043
  var valid_594044 = query.getOrDefault("versionNumber")
  valid_594044 = validateParameter(valid_594044, JInt, required = false, default = nil)
  if valid_594044 != nil:
    section.add "versionNumber", valid_594044
  var valid_594045 = query.getOrDefault("fields")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "fields", valid_594045
  var valid_594046 = query.getOrDefault("quotaUser")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "quotaUser", valid_594046
  var valid_594047 = query.getOrDefault("alt")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = newJString("json"))
  if valid_594047 != nil:
    section.add "alt", valid_594047
  var valid_594048 = query.getOrDefault("oauth_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "oauth_token", valid_594048
  var valid_594049 = query.getOrDefault("callback")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "callback", valid_594049
  var valid_594050 = query.getOrDefault("access_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "access_token", valid_594050
  var valid_594051 = query.getOrDefault("uploadType")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "uploadType", valid_594051
  var valid_594052 = query.getOrDefault("key")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "key", valid_594052
  var valid_594053 = query.getOrDefault("$.xgafv")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("1"))
  if valid_594053 != nil:
    section.add "$.xgafv", valid_594053
  var valid_594054 = query.getOrDefault("prettyPrint")
  valid_594054 = validateParameter(valid_594054, JBool, required = false,
                                 default = newJBool(true))
  if valid_594054 != nil:
    section.add "prettyPrint", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594055: Call_ScriptProjectsGetContent_594039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the content of the script project, including the code source and
  ## metadata for each script file.
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ScriptProjectsGetContent_594039; scriptId: string;
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
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  add(query_594058, "upload_protocol", newJString(uploadProtocol))
  add(query_594058, "versionNumber", newJInt(versionNumber))
  add(query_594058, "fields", newJString(fields))
  add(query_594058, "quotaUser", newJString(quotaUser))
  add(query_594058, "alt", newJString(alt))
  add(query_594058, "oauth_token", newJString(oauthToken))
  add(query_594058, "callback", newJString(callback))
  add(query_594058, "access_token", newJString(accessToken))
  add(query_594058, "uploadType", newJString(uploadType))
  add(query_594058, "key", newJString(key))
  add(query_594058, "$.xgafv", newJString(Xgafv))
  add(path_594057, "scriptId", newJString(scriptId))
  add(query_594058, "prettyPrint", newJBool(prettyPrint))
  result = call_594056.call(path_594057, query_594058, nil, nil, nil)

var scriptProjectsGetContent* = Call_ScriptProjectsGetContent_594039(
    name: "scriptProjectsGetContent", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/content",
    validator: validate_ScriptProjectsGetContent_594040, base: "/",
    url: url_ScriptProjectsGetContent_594041, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsCreate_594101 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsDeploymentsCreate_594103(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsDeploymentsCreate_594102(path: JsonNode;
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
  var valid_594104 = path.getOrDefault("scriptId")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "scriptId", valid_594104
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
  var valid_594105 = query.getOrDefault("upload_protocol")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "upload_protocol", valid_594105
  var valid_594106 = query.getOrDefault("fields")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "fields", valid_594106
  var valid_594107 = query.getOrDefault("quotaUser")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "quotaUser", valid_594107
  var valid_594108 = query.getOrDefault("alt")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = newJString("json"))
  if valid_594108 != nil:
    section.add "alt", valid_594108
  var valid_594109 = query.getOrDefault("oauth_token")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "oauth_token", valid_594109
  var valid_594110 = query.getOrDefault("callback")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "callback", valid_594110
  var valid_594111 = query.getOrDefault("access_token")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "access_token", valid_594111
  var valid_594112 = query.getOrDefault("uploadType")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "uploadType", valid_594112
  var valid_594113 = query.getOrDefault("key")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "key", valid_594113
  var valid_594114 = query.getOrDefault("$.xgafv")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("1"))
  if valid_594114 != nil:
    section.add "$.xgafv", valid_594114
  var valid_594115 = query.getOrDefault("prettyPrint")
  valid_594115 = validateParameter(valid_594115, JBool, required = false,
                                 default = newJBool(true))
  if valid_594115 != nil:
    section.add "prettyPrint", valid_594115
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

proc call*(call_594117: Call_ScriptProjectsDeploymentsCreate_594101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a deployment of an Apps Script project.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_ScriptProjectsDeploymentsCreate_594101;
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
  var path_594119 = newJObject()
  var query_594120 = newJObject()
  var body_594121 = newJObject()
  add(query_594120, "upload_protocol", newJString(uploadProtocol))
  add(query_594120, "fields", newJString(fields))
  add(query_594120, "quotaUser", newJString(quotaUser))
  add(query_594120, "alt", newJString(alt))
  add(query_594120, "oauth_token", newJString(oauthToken))
  add(query_594120, "callback", newJString(callback))
  add(query_594120, "access_token", newJString(accessToken))
  add(query_594120, "uploadType", newJString(uploadType))
  add(query_594120, "key", newJString(key))
  add(query_594120, "$.xgafv", newJString(Xgafv))
  add(path_594119, "scriptId", newJString(scriptId))
  if body != nil:
    body_594121 = body
  add(query_594120, "prettyPrint", newJBool(prettyPrint))
  result = call_594118.call(path_594119, query_594120, nil, nil, body_594121)

var scriptProjectsDeploymentsCreate* = Call_ScriptProjectsDeploymentsCreate_594101(
    name: "scriptProjectsDeploymentsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsCreate_594102, base: "/",
    url: url_ScriptProjectsDeploymentsCreate_594103, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsList_594080 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsDeploymentsList_594082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsDeploymentsList_594081(path: JsonNode; query: JsonNode;
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
  var valid_594083 = path.getOrDefault("scriptId")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "scriptId", valid_594083
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
  var valid_594084 = query.getOrDefault("upload_protocol")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "upload_protocol", valid_594084
  var valid_594085 = query.getOrDefault("fields")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "fields", valid_594085
  var valid_594086 = query.getOrDefault("pageToken")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "pageToken", valid_594086
  var valid_594087 = query.getOrDefault("quotaUser")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "quotaUser", valid_594087
  var valid_594088 = query.getOrDefault("alt")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("json"))
  if valid_594088 != nil:
    section.add "alt", valid_594088
  var valid_594089 = query.getOrDefault("oauth_token")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "oauth_token", valid_594089
  var valid_594090 = query.getOrDefault("callback")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "callback", valid_594090
  var valid_594091 = query.getOrDefault("access_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "access_token", valid_594091
  var valid_594092 = query.getOrDefault("uploadType")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "uploadType", valid_594092
  var valid_594093 = query.getOrDefault("key")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "key", valid_594093
  var valid_594094 = query.getOrDefault("$.xgafv")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("1"))
  if valid_594094 != nil:
    section.add "$.xgafv", valid_594094
  var valid_594095 = query.getOrDefault("pageSize")
  valid_594095 = validateParameter(valid_594095, JInt, required = false, default = nil)
  if valid_594095 != nil:
    section.add "pageSize", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_ScriptProjectsDeploymentsList_594080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the deployments of an Apps Script project.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_ScriptProjectsDeploymentsList_594080;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(query_594100, "upload_protocol", newJString(uploadProtocol))
  add(query_594100, "fields", newJString(fields))
  add(query_594100, "pageToken", newJString(pageToken))
  add(query_594100, "quotaUser", newJString(quotaUser))
  add(query_594100, "alt", newJString(alt))
  add(query_594100, "oauth_token", newJString(oauthToken))
  add(query_594100, "callback", newJString(callback))
  add(query_594100, "access_token", newJString(accessToken))
  add(query_594100, "uploadType", newJString(uploadType))
  add(query_594100, "key", newJString(key))
  add(query_594100, "$.xgafv", newJString(Xgafv))
  add(path_594099, "scriptId", newJString(scriptId))
  add(query_594100, "pageSize", newJInt(pageSize))
  add(query_594100, "prettyPrint", newJBool(prettyPrint))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var scriptProjectsDeploymentsList* = Call_ScriptProjectsDeploymentsList_594080(
    name: "scriptProjectsDeploymentsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/deployments",
    validator: validate_ScriptProjectsDeploymentsList_594081, base: "/",
    url: url_ScriptProjectsDeploymentsList_594082, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsUpdate_594142 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsDeploymentsUpdate_594144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsDeploymentsUpdate_594143(path: JsonNode;
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
  var valid_594145 = path.getOrDefault("deploymentId")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = nil)
  if valid_594145 != nil:
    section.add "deploymentId", valid_594145
  var valid_594146 = path.getOrDefault("scriptId")
  valid_594146 = validateParameter(valid_594146, JString, required = true,
                                 default = nil)
  if valid_594146 != nil:
    section.add "scriptId", valid_594146
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
  var valid_594147 = query.getOrDefault("upload_protocol")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "upload_protocol", valid_594147
  var valid_594148 = query.getOrDefault("fields")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "fields", valid_594148
  var valid_594149 = query.getOrDefault("quotaUser")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "quotaUser", valid_594149
  var valid_594150 = query.getOrDefault("alt")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("json"))
  if valid_594150 != nil:
    section.add "alt", valid_594150
  var valid_594151 = query.getOrDefault("oauth_token")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "oauth_token", valid_594151
  var valid_594152 = query.getOrDefault("callback")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "callback", valid_594152
  var valid_594153 = query.getOrDefault("access_token")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "access_token", valid_594153
  var valid_594154 = query.getOrDefault("uploadType")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "uploadType", valid_594154
  var valid_594155 = query.getOrDefault("key")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "key", valid_594155
  var valid_594156 = query.getOrDefault("$.xgafv")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = newJString("1"))
  if valid_594156 != nil:
    section.add "$.xgafv", valid_594156
  var valid_594157 = query.getOrDefault("prettyPrint")
  valid_594157 = validateParameter(valid_594157, JBool, required = false,
                                 default = newJBool(true))
  if valid_594157 != nil:
    section.add "prettyPrint", valid_594157
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

proc call*(call_594159: Call_ScriptProjectsDeploymentsUpdate_594142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a deployment of an Apps Script project.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_ScriptProjectsDeploymentsUpdate_594142;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(query_594162, "upload_protocol", newJString(uploadProtocol))
  add(query_594162, "fields", newJString(fields))
  add(query_594162, "quotaUser", newJString(quotaUser))
  add(query_594162, "alt", newJString(alt))
  add(query_594162, "oauth_token", newJString(oauthToken))
  add(query_594162, "callback", newJString(callback))
  add(query_594162, "access_token", newJString(accessToken))
  add(query_594162, "uploadType", newJString(uploadType))
  add(path_594161, "deploymentId", newJString(deploymentId))
  add(query_594162, "key", newJString(key))
  add(query_594162, "$.xgafv", newJString(Xgafv))
  add(path_594161, "scriptId", newJString(scriptId))
  if body != nil:
    body_594163 = body
  add(query_594162, "prettyPrint", newJBool(prettyPrint))
  result = call_594160.call(path_594161, query_594162, nil, nil, body_594163)

var scriptProjectsDeploymentsUpdate* = Call_ScriptProjectsDeploymentsUpdate_594142(
    name: "scriptProjectsDeploymentsUpdate", meth: HttpMethod.HttpPut,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsUpdate_594143, base: "/",
    url: url_ScriptProjectsDeploymentsUpdate_594144, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsGet_594122 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsDeploymentsGet_594124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsDeploymentsGet_594123(path: JsonNode; query: JsonNode;
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
  var valid_594125 = path.getOrDefault("deploymentId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "deploymentId", valid_594125
  var valid_594126 = path.getOrDefault("scriptId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "scriptId", valid_594126
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
  var valid_594127 = query.getOrDefault("upload_protocol")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "upload_protocol", valid_594127
  var valid_594128 = query.getOrDefault("fields")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "fields", valid_594128
  var valid_594129 = query.getOrDefault("quotaUser")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "quotaUser", valid_594129
  var valid_594130 = query.getOrDefault("alt")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = newJString("json"))
  if valid_594130 != nil:
    section.add "alt", valid_594130
  var valid_594131 = query.getOrDefault("oauth_token")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "oauth_token", valid_594131
  var valid_594132 = query.getOrDefault("callback")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "callback", valid_594132
  var valid_594133 = query.getOrDefault("access_token")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "access_token", valid_594133
  var valid_594134 = query.getOrDefault("uploadType")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "uploadType", valid_594134
  var valid_594135 = query.getOrDefault("key")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "key", valid_594135
  var valid_594136 = query.getOrDefault("$.xgafv")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = newJString("1"))
  if valid_594136 != nil:
    section.add "$.xgafv", valid_594136
  var valid_594137 = query.getOrDefault("prettyPrint")
  valid_594137 = validateParameter(valid_594137, JBool, required = false,
                                 default = newJBool(true))
  if valid_594137 != nil:
    section.add "prettyPrint", valid_594137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594138: Call_ScriptProjectsDeploymentsGet_594122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment of an Apps Script project.
  ## 
  let valid = call_594138.validator(path, query, header, formData, body)
  let scheme = call_594138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594138.url(scheme.get, call_594138.host, call_594138.base,
                         call_594138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594138, url, valid)

proc call*(call_594139: Call_ScriptProjectsDeploymentsGet_594122;
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
  var path_594140 = newJObject()
  var query_594141 = newJObject()
  add(query_594141, "upload_protocol", newJString(uploadProtocol))
  add(query_594141, "fields", newJString(fields))
  add(query_594141, "quotaUser", newJString(quotaUser))
  add(query_594141, "alt", newJString(alt))
  add(query_594141, "oauth_token", newJString(oauthToken))
  add(query_594141, "callback", newJString(callback))
  add(query_594141, "access_token", newJString(accessToken))
  add(query_594141, "uploadType", newJString(uploadType))
  add(path_594140, "deploymentId", newJString(deploymentId))
  add(query_594141, "key", newJString(key))
  add(query_594141, "$.xgafv", newJString(Xgafv))
  add(path_594140, "scriptId", newJString(scriptId))
  add(query_594141, "prettyPrint", newJBool(prettyPrint))
  result = call_594139.call(path_594140, query_594141, nil, nil, nil)

var scriptProjectsDeploymentsGet* = Call_ScriptProjectsDeploymentsGet_594122(
    name: "scriptProjectsDeploymentsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsGet_594123, base: "/",
    url: url_ScriptProjectsDeploymentsGet_594124, schemes: {Scheme.Https})
type
  Call_ScriptProjectsDeploymentsDelete_594164 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsDeploymentsDelete_594166(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsDeploymentsDelete_594165(path: JsonNode;
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
  var valid_594167 = path.getOrDefault("deploymentId")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "deploymentId", valid_594167
  var valid_594168 = path.getOrDefault("scriptId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "scriptId", valid_594168
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
  var valid_594169 = query.getOrDefault("upload_protocol")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "upload_protocol", valid_594169
  var valid_594170 = query.getOrDefault("fields")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "fields", valid_594170
  var valid_594171 = query.getOrDefault("quotaUser")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "quotaUser", valid_594171
  var valid_594172 = query.getOrDefault("alt")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = newJString("json"))
  if valid_594172 != nil:
    section.add "alt", valid_594172
  var valid_594173 = query.getOrDefault("oauth_token")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "oauth_token", valid_594173
  var valid_594174 = query.getOrDefault("callback")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "callback", valid_594174
  var valid_594175 = query.getOrDefault("access_token")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "access_token", valid_594175
  var valid_594176 = query.getOrDefault("uploadType")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "uploadType", valid_594176
  var valid_594177 = query.getOrDefault("key")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "key", valid_594177
  var valid_594178 = query.getOrDefault("$.xgafv")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = newJString("1"))
  if valid_594178 != nil:
    section.add "$.xgafv", valid_594178
  var valid_594179 = query.getOrDefault("prettyPrint")
  valid_594179 = validateParameter(valid_594179, JBool, required = false,
                                 default = newJBool(true))
  if valid_594179 != nil:
    section.add "prettyPrint", valid_594179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594180: Call_ScriptProjectsDeploymentsDelete_594164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a deployment of an Apps Script project.
  ## 
  let valid = call_594180.validator(path, query, header, formData, body)
  let scheme = call_594180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594180.url(scheme.get, call_594180.host, call_594180.base,
                         call_594180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594180, url, valid)

proc call*(call_594181: Call_ScriptProjectsDeploymentsDelete_594164;
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
  var path_594182 = newJObject()
  var query_594183 = newJObject()
  add(query_594183, "upload_protocol", newJString(uploadProtocol))
  add(query_594183, "fields", newJString(fields))
  add(query_594183, "quotaUser", newJString(quotaUser))
  add(query_594183, "alt", newJString(alt))
  add(query_594183, "oauth_token", newJString(oauthToken))
  add(query_594183, "callback", newJString(callback))
  add(query_594183, "access_token", newJString(accessToken))
  add(query_594183, "uploadType", newJString(uploadType))
  add(path_594182, "deploymentId", newJString(deploymentId))
  add(query_594183, "key", newJString(key))
  add(query_594183, "$.xgafv", newJString(Xgafv))
  add(path_594182, "scriptId", newJString(scriptId))
  add(query_594183, "prettyPrint", newJBool(prettyPrint))
  result = call_594181.call(path_594182, query_594183, nil, nil, nil)

var scriptProjectsDeploymentsDelete* = Call_ScriptProjectsDeploymentsDelete_594164(
    name: "scriptProjectsDeploymentsDelete", meth: HttpMethod.HttpDelete,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/deployments/{deploymentId}",
    validator: validate_ScriptProjectsDeploymentsDelete_594165, base: "/",
    url: url_ScriptProjectsDeploymentsDelete_594166, schemes: {Scheme.Https})
type
  Call_ScriptProjectsGetMetrics_594184 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsGetMetrics_594186(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsGetMetrics_594185(path: JsonNode; query: JsonNode;
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
  var valid_594187 = path.getOrDefault("scriptId")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "scriptId", valid_594187
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
  var valid_594188 = query.getOrDefault("upload_protocol")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "upload_protocol", valid_594188
  var valid_594189 = query.getOrDefault("fields")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "fields", valid_594189
  var valid_594190 = query.getOrDefault("quotaUser")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "quotaUser", valid_594190
  var valid_594191 = query.getOrDefault("alt")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = newJString("json"))
  if valid_594191 != nil:
    section.add "alt", valid_594191
  var valid_594192 = query.getOrDefault("oauth_token")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "oauth_token", valid_594192
  var valid_594193 = query.getOrDefault("callback")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "callback", valid_594193
  var valid_594194 = query.getOrDefault("access_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "access_token", valid_594194
  var valid_594195 = query.getOrDefault("uploadType")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "uploadType", valid_594195
  var valid_594196 = query.getOrDefault("key")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "key", valid_594196
  var valid_594197 = query.getOrDefault("metricsGranularity")
  valid_594197 = validateParameter(valid_594197, JString, required = false, default = newJString(
      "UNSPECIFIED_GRANULARITY"))
  if valid_594197 != nil:
    section.add "metricsGranularity", valid_594197
  var valid_594198 = query.getOrDefault("$.xgafv")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = newJString("1"))
  if valid_594198 != nil:
    section.add "$.xgafv", valid_594198
  var valid_594199 = query.getOrDefault("metricsFilter.deploymentId")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "metricsFilter.deploymentId", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594201: Call_ScriptProjectsGetMetrics_594184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get metrics data for scripts, such as number of executions and
  ## active users.
  ## 
  let valid = call_594201.validator(path, query, header, formData, body)
  let scheme = call_594201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594201.url(scheme.get, call_594201.host, call_594201.base,
                         call_594201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594201, url, valid)

proc call*(call_594202: Call_ScriptProjectsGetMetrics_594184; scriptId: string;
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
  var path_594203 = newJObject()
  var query_594204 = newJObject()
  add(query_594204, "upload_protocol", newJString(uploadProtocol))
  add(query_594204, "fields", newJString(fields))
  add(query_594204, "quotaUser", newJString(quotaUser))
  add(query_594204, "alt", newJString(alt))
  add(query_594204, "oauth_token", newJString(oauthToken))
  add(query_594204, "callback", newJString(callback))
  add(query_594204, "access_token", newJString(accessToken))
  add(query_594204, "uploadType", newJString(uploadType))
  add(query_594204, "key", newJString(key))
  add(query_594204, "metricsGranularity", newJString(metricsGranularity))
  add(query_594204, "$.xgafv", newJString(Xgafv))
  add(path_594203, "scriptId", newJString(scriptId))
  add(query_594204, "metricsFilter.deploymentId",
      newJString(metricsFilterDeploymentId))
  add(query_594204, "prettyPrint", newJBool(prettyPrint))
  result = call_594202.call(path_594203, query_594204, nil, nil, nil)

var scriptProjectsGetMetrics* = Call_ScriptProjectsGetMetrics_594184(
    name: "scriptProjectsGetMetrics", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/metrics",
    validator: validate_ScriptProjectsGetMetrics_594185, base: "/",
    url: url_ScriptProjectsGetMetrics_594186, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsCreate_594226 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsVersionsCreate_594228(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsVersionsCreate_594227(path: JsonNode; query: JsonNode;
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
  var valid_594229 = path.getOrDefault("scriptId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "scriptId", valid_594229
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
  var valid_594230 = query.getOrDefault("upload_protocol")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "upload_protocol", valid_594230
  var valid_594231 = query.getOrDefault("fields")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "fields", valid_594231
  var valid_594232 = query.getOrDefault("quotaUser")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "quotaUser", valid_594232
  var valid_594233 = query.getOrDefault("alt")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = newJString("json"))
  if valid_594233 != nil:
    section.add "alt", valid_594233
  var valid_594234 = query.getOrDefault("oauth_token")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "oauth_token", valid_594234
  var valid_594235 = query.getOrDefault("callback")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "callback", valid_594235
  var valid_594236 = query.getOrDefault("access_token")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "access_token", valid_594236
  var valid_594237 = query.getOrDefault("uploadType")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "uploadType", valid_594237
  var valid_594238 = query.getOrDefault("key")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "key", valid_594238
  var valid_594239 = query.getOrDefault("$.xgafv")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = newJString("1"))
  if valid_594239 != nil:
    section.add "$.xgafv", valid_594239
  var valid_594240 = query.getOrDefault("prettyPrint")
  valid_594240 = validateParameter(valid_594240, JBool, required = false,
                                 default = newJBool(true))
  if valid_594240 != nil:
    section.add "prettyPrint", valid_594240
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

proc call*(call_594242: Call_ScriptProjectsVersionsCreate_594226; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new immutable version using the current code, with a unique
  ## version number.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_ScriptProjectsVersionsCreate_594226; scriptId: string;
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
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  var body_594246 = newJObject()
  add(query_594245, "upload_protocol", newJString(uploadProtocol))
  add(query_594245, "fields", newJString(fields))
  add(query_594245, "quotaUser", newJString(quotaUser))
  add(query_594245, "alt", newJString(alt))
  add(query_594245, "oauth_token", newJString(oauthToken))
  add(query_594245, "callback", newJString(callback))
  add(query_594245, "access_token", newJString(accessToken))
  add(query_594245, "uploadType", newJString(uploadType))
  add(query_594245, "key", newJString(key))
  add(query_594245, "$.xgafv", newJString(Xgafv))
  add(path_594244, "scriptId", newJString(scriptId))
  if body != nil:
    body_594246 = body
  add(query_594245, "prettyPrint", newJBool(prettyPrint))
  result = call_594243.call(path_594244, query_594245, nil, nil, body_594246)

var scriptProjectsVersionsCreate* = Call_ScriptProjectsVersionsCreate_594226(
    name: "scriptProjectsVersionsCreate", meth: HttpMethod.HttpPost,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsCreate_594227, base: "/",
    url: url_ScriptProjectsVersionsCreate_594228, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsList_594205 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsVersionsList_594207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsVersionsList_594206(path: JsonNode; query: JsonNode;
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
  var valid_594208 = path.getOrDefault("scriptId")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "scriptId", valid_594208
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
  var valid_594209 = query.getOrDefault("upload_protocol")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "upload_protocol", valid_594209
  var valid_594210 = query.getOrDefault("fields")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "fields", valid_594210
  var valid_594211 = query.getOrDefault("pageToken")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "pageToken", valid_594211
  var valid_594212 = query.getOrDefault("quotaUser")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "quotaUser", valid_594212
  var valid_594213 = query.getOrDefault("alt")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("json"))
  if valid_594213 != nil:
    section.add "alt", valid_594213
  var valid_594214 = query.getOrDefault("oauth_token")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "oauth_token", valid_594214
  var valid_594215 = query.getOrDefault("callback")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "callback", valid_594215
  var valid_594216 = query.getOrDefault("access_token")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "access_token", valid_594216
  var valid_594217 = query.getOrDefault("uploadType")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "uploadType", valid_594217
  var valid_594218 = query.getOrDefault("key")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "key", valid_594218
  var valid_594219 = query.getOrDefault("$.xgafv")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = newJString("1"))
  if valid_594219 != nil:
    section.add "$.xgafv", valid_594219
  var valid_594220 = query.getOrDefault("pageSize")
  valid_594220 = validateParameter(valid_594220, JInt, required = false, default = nil)
  if valid_594220 != nil:
    section.add "pageSize", valid_594220
  var valid_594221 = query.getOrDefault("prettyPrint")
  valid_594221 = validateParameter(valid_594221, JBool, required = false,
                                 default = newJBool(true))
  if valid_594221 != nil:
    section.add "prettyPrint", valid_594221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594222: Call_ScriptProjectsVersionsList_594205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the versions of a script project.
  ## 
  let valid = call_594222.validator(path, query, header, formData, body)
  let scheme = call_594222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594222.url(scheme.get, call_594222.host, call_594222.base,
                         call_594222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594222, url, valid)

proc call*(call_594223: Call_ScriptProjectsVersionsList_594205; scriptId: string;
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
  var path_594224 = newJObject()
  var query_594225 = newJObject()
  add(query_594225, "upload_protocol", newJString(uploadProtocol))
  add(query_594225, "fields", newJString(fields))
  add(query_594225, "pageToken", newJString(pageToken))
  add(query_594225, "quotaUser", newJString(quotaUser))
  add(query_594225, "alt", newJString(alt))
  add(query_594225, "oauth_token", newJString(oauthToken))
  add(query_594225, "callback", newJString(callback))
  add(query_594225, "access_token", newJString(accessToken))
  add(query_594225, "uploadType", newJString(uploadType))
  add(query_594225, "key", newJString(key))
  add(query_594225, "$.xgafv", newJString(Xgafv))
  add(path_594224, "scriptId", newJString(scriptId))
  add(query_594225, "pageSize", newJInt(pageSize))
  add(query_594225, "prettyPrint", newJBool(prettyPrint))
  result = call_594223.call(path_594224, query_594225, nil, nil, nil)

var scriptProjectsVersionsList* = Call_ScriptProjectsVersionsList_594205(
    name: "scriptProjectsVersionsList", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com", route: "/v1/projects/{scriptId}/versions",
    validator: validate_ScriptProjectsVersionsList_594206, base: "/",
    url: url_ScriptProjectsVersionsList_594207, schemes: {Scheme.Https})
type
  Call_ScriptProjectsVersionsGet_594247 = ref object of OpenApiRestCall_593408
proc url_ScriptProjectsVersionsGet_594249(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptProjectsVersionsGet_594248(path: JsonNode; query: JsonNode;
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
  var valid_594250 = path.getOrDefault("scriptId")
  valid_594250 = validateParameter(valid_594250, JString, required = true,
                                 default = nil)
  if valid_594250 != nil:
    section.add "scriptId", valid_594250
  var valid_594251 = path.getOrDefault("versionNumber")
  valid_594251 = validateParameter(valid_594251, JInt, required = true, default = nil)
  if valid_594251 != nil:
    section.add "versionNumber", valid_594251
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
  var valid_594252 = query.getOrDefault("upload_protocol")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "upload_protocol", valid_594252
  var valid_594253 = query.getOrDefault("fields")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "fields", valid_594253
  var valid_594254 = query.getOrDefault("quotaUser")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "quotaUser", valid_594254
  var valid_594255 = query.getOrDefault("alt")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = newJString("json"))
  if valid_594255 != nil:
    section.add "alt", valid_594255
  var valid_594256 = query.getOrDefault("oauth_token")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "oauth_token", valid_594256
  var valid_594257 = query.getOrDefault("callback")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "callback", valid_594257
  var valid_594258 = query.getOrDefault("access_token")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = nil)
  if valid_594258 != nil:
    section.add "access_token", valid_594258
  var valid_594259 = query.getOrDefault("uploadType")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "uploadType", valid_594259
  var valid_594260 = query.getOrDefault("key")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "key", valid_594260
  var valid_594261 = query.getOrDefault("$.xgafv")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = newJString("1"))
  if valid_594261 != nil:
    section.add "$.xgafv", valid_594261
  var valid_594262 = query.getOrDefault("prettyPrint")
  valid_594262 = validateParameter(valid_594262, JBool, required = false,
                                 default = newJBool(true))
  if valid_594262 != nil:
    section.add "prettyPrint", valid_594262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594263: Call_ScriptProjectsVersionsGet_594247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a version of a script project.
  ## 
  let valid = call_594263.validator(path, query, header, formData, body)
  let scheme = call_594263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594263.url(scheme.get, call_594263.host, call_594263.base,
                         call_594263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594263, url, valid)

proc call*(call_594264: Call_ScriptProjectsVersionsGet_594247; scriptId: string;
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
  var path_594265 = newJObject()
  var query_594266 = newJObject()
  add(query_594266, "upload_protocol", newJString(uploadProtocol))
  add(query_594266, "fields", newJString(fields))
  add(query_594266, "quotaUser", newJString(quotaUser))
  add(query_594266, "alt", newJString(alt))
  add(query_594266, "oauth_token", newJString(oauthToken))
  add(query_594266, "callback", newJString(callback))
  add(query_594266, "access_token", newJString(accessToken))
  add(query_594266, "uploadType", newJString(uploadType))
  add(query_594266, "key", newJString(key))
  add(query_594266, "$.xgafv", newJString(Xgafv))
  add(path_594265, "scriptId", newJString(scriptId))
  add(query_594266, "prettyPrint", newJBool(prettyPrint))
  add(path_594265, "versionNumber", newJInt(versionNumber))
  result = call_594264.call(path_594265, query_594266, nil, nil, nil)

var scriptProjectsVersionsGet* = Call_ScriptProjectsVersionsGet_594247(
    name: "scriptProjectsVersionsGet", meth: HttpMethod.HttpGet,
    host: "script.googleapis.com",
    route: "/v1/projects/{scriptId}/versions/{versionNumber}",
    validator: validate_ScriptProjectsVersionsGet_594248, base: "/",
    url: url_ScriptProjectsVersionsGet_594249, schemes: {Scheme.Https})
type
  Call_ScriptScriptsRun_594267 = ref object of OpenApiRestCall_593408
proc url_ScriptScriptsRun_594269(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_ScriptScriptsRun_594268(path: JsonNode; query: JsonNode;
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
  var valid_594270 = path.getOrDefault("scriptId")
  valid_594270 = validateParameter(valid_594270, JString, required = true,
                                 default = nil)
  if valid_594270 != nil:
    section.add "scriptId", valid_594270
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
  var valid_594271 = query.getOrDefault("upload_protocol")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "upload_protocol", valid_594271
  var valid_594272 = query.getOrDefault("fields")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "fields", valid_594272
  var valid_594273 = query.getOrDefault("quotaUser")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "quotaUser", valid_594273
  var valid_594274 = query.getOrDefault("alt")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = newJString("json"))
  if valid_594274 != nil:
    section.add "alt", valid_594274
  var valid_594275 = query.getOrDefault("oauth_token")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "oauth_token", valid_594275
  var valid_594276 = query.getOrDefault("callback")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "callback", valid_594276
  var valid_594277 = query.getOrDefault("access_token")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "access_token", valid_594277
  var valid_594278 = query.getOrDefault("uploadType")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "uploadType", valid_594278
  var valid_594279 = query.getOrDefault("key")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "key", valid_594279
  var valid_594280 = query.getOrDefault("$.xgafv")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = newJString("1"))
  if valid_594280 != nil:
    section.add "$.xgafv", valid_594280
  var valid_594281 = query.getOrDefault("prettyPrint")
  valid_594281 = validateParameter(valid_594281, JBool, required = false,
                                 default = newJBool(true))
  if valid_594281 != nil:
    section.add "prettyPrint", valid_594281
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

proc call*(call_594283: Call_ScriptScriptsRun_594267; path: JsonNode;
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
  let valid = call_594283.validator(path, query, header, formData, body)
  let scheme = call_594283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594283.url(scheme.get, call_594283.host, call_594283.base,
                         call_594283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594283, url, valid)

proc call*(call_594284: Call_ScriptScriptsRun_594267; scriptId: string;
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
  var path_594285 = newJObject()
  var query_594286 = newJObject()
  var body_594287 = newJObject()
  add(query_594286, "upload_protocol", newJString(uploadProtocol))
  add(query_594286, "fields", newJString(fields))
  add(query_594286, "quotaUser", newJString(quotaUser))
  add(query_594286, "alt", newJString(alt))
  add(query_594286, "oauth_token", newJString(oauthToken))
  add(query_594286, "callback", newJString(callback))
  add(query_594286, "access_token", newJString(accessToken))
  add(query_594286, "uploadType", newJString(uploadType))
  add(query_594286, "key", newJString(key))
  add(query_594286, "$.xgafv", newJString(Xgafv))
  add(path_594285, "scriptId", newJString(scriptId))
  if body != nil:
    body_594287 = body
  add(query_594286, "prettyPrint", newJBool(prettyPrint))
  result = call_594284.call(path_594285, query_594286, nil, nil, body_594287)

var scriptScriptsRun* = Call_ScriptScriptsRun_594267(name: "scriptScriptsRun",
    meth: HttpMethod.HttpPost, host: "script.googleapis.com",
    route: "/v1/scripts/{scriptId}:run", validator: validate_ScriptScriptsRun_594268,
    base: "/", url: url_ScriptScriptsRun_594269, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
