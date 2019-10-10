
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Monitoring
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages your Stackdriver Monitoring data and configurations. Most projects must be associated with a Stackdriver account, with a few exceptions as noted on the individual method pages. The table entries below are presented in alphabetical order, not in order of common use. For explanations of the concepts found in the table entries, read the Stackdriver Monitoring documentation.
## 
## https://cloud.google.com/monitoring/api/
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "monitoring"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MonitoringUptimeCheckIpsList_588719 = ref object of OpenApiRestCall_588450
proc url_MonitoringUptimeCheckIpsList_588721(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MonitoringUptimeCheckIpsList_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of IP addresses that checkers run from
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
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call. NOTE: this field is not yet implemented
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
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned. NOTE: this field is not yet implemented
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588850 = query.getOrDefault("alt")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = newJString("json"))
  if valid_588850 != nil:
    section.add "alt", valid_588850
  var valid_588851 = query.getOrDefault("oauth_token")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = nil)
  if valid_588851 != nil:
    section.add "oauth_token", valid_588851
  var valid_588852 = query.getOrDefault("callback")
  valid_588852 = validateParameter(valid_588852, JString, required = false,
                                 default = nil)
  if valid_588852 != nil:
    section.add "callback", valid_588852
  var valid_588853 = query.getOrDefault("access_token")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "access_token", valid_588853
  var valid_588854 = query.getOrDefault("uploadType")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "uploadType", valid_588854
  var valid_588855 = query.getOrDefault("key")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "key", valid_588855
  var valid_588856 = query.getOrDefault("$.xgafv")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("1"))
  if valid_588856 != nil:
    section.add "$.xgafv", valid_588856
  var valid_588857 = query.getOrDefault("pageSize")
  valid_588857 = validateParameter(valid_588857, JInt, required = false, default = nil)
  if valid_588857 != nil:
    section.add "pageSize", valid_588857
  var valid_588858 = query.getOrDefault("prettyPrint")
  valid_588858 = validateParameter(valid_588858, JBool, required = false,
                                 default = newJBool(true))
  if valid_588858 != nil:
    section.add "prettyPrint", valid_588858
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588881: Call_MonitoringUptimeCheckIpsList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of IP addresses that checkers run from
  ## 
  let valid = call_588881.validator(path, query, header, formData, body)
  let scheme = call_588881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588881.url(scheme.get, call_588881.host, call_588881.base,
                         call_588881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588881, url, valid)

proc call*(call_588952: Call_MonitoringUptimeCheckIpsList_588719;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true): Recallable =
  ## monitoringUptimeCheckIpsList
  ## Returns the list of IP addresses that checkers run from
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call. NOTE: this field is not yet implemented
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
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned. NOTE: this field is not yet implemented
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588953 = newJObject()
  add(query_588953, "upload_protocol", newJString(uploadProtocol))
  add(query_588953, "fields", newJString(fields))
  add(query_588953, "pageToken", newJString(pageToken))
  add(query_588953, "quotaUser", newJString(quotaUser))
  add(query_588953, "alt", newJString(alt))
  add(query_588953, "oauth_token", newJString(oauthToken))
  add(query_588953, "callback", newJString(callback))
  add(query_588953, "access_token", newJString(accessToken))
  add(query_588953, "uploadType", newJString(uploadType))
  add(query_588953, "key", newJString(key))
  add(query_588953, "$.xgafv", newJString(Xgafv))
  add(query_588953, "pageSize", newJInt(pageSize))
  add(query_588953, "prettyPrint", newJBool(prettyPrint))
  result = call_588952.call(nil, query_588953, nil, nil, nil)

var monitoringUptimeCheckIpsList* = Call_MonitoringUptimeCheckIpsList_588719(
    name: "monitoringUptimeCheckIpsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/uptimeCheckIps",
    validator: validate_MonitoringUptimeCheckIpsList_588720, base: "/",
    url: url_MonitoringUptimeCheckIpsList_588721, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsUpdate_589026 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsGroupsUpdate_589028(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsUpdate_589027(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing group. You can change any group attributes except name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Output only. The name of this group. The format is "projects/{project_id_or_number}/groups/{group_id}". When creating a group, this field is ignored and a new name is created consisting of the project specified in the call to CreateGroup and a unique {group_id} that is generated automatically.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589029 = path.getOrDefault("name")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "name", valid_589029
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
  ##   validateOnly: JBool
  ##               : If true, validate this request but do not update the existing group.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589030 = query.getOrDefault("upload_protocol")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "upload_protocol", valid_589030
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("callback")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "callback", valid_589035
  var valid_589036 = query.getOrDefault("access_token")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "access_token", valid_589036
  var valid_589037 = query.getOrDefault("uploadType")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "uploadType", valid_589037
  var valid_589038 = query.getOrDefault("validateOnly")
  valid_589038 = validateParameter(valid_589038, JBool, required = false, default = nil)
  if valid_589038 != nil:
    section.add "validateOnly", valid_589038
  var valid_589039 = query.getOrDefault("key")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "key", valid_589039
  var valid_589040 = query.getOrDefault("$.xgafv")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("1"))
  if valid_589040 != nil:
    section.add "$.xgafv", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
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

proc call*(call_589043: Call_MonitoringProjectsGroupsUpdate_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing group. You can change any group attributes except name.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_MonitoringProjectsGroupsUpdate_589026; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; validateOnly: bool = false;
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsGroupsUpdate
  ## Updates an existing group. You can change any group attributes except name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Output only. The name of this group. The format is "projects/{project_id_or_number}/groups/{group_id}". When creating a group, this field is ignored and a new name is created consisting of the project specified in the call to CreateGroup and a unique {group_id} that is generated automatically.
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
  ##   validateOnly: bool
  ##               : If true, validate this request but do not update the existing group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589045 = newJObject()
  var query_589046 = newJObject()
  var body_589047 = newJObject()
  add(query_589046, "upload_protocol", newJString(uploadProtocol))
  add(query_589046, "fields", newJString(fields))
  add(query_589046, "quotaUser", newJString(quotaUser))
  add(path_589045, "name", newJString(name))
  add(query_589046, "alt", newJString(alt))
  add(query_589046, "oauth_token", newJString(oauthToken))
  add(query_589046, "callback", newJString(callback))
  add(query_589046, "access_token", newJString(accessToken))
  add(query_589046, "uploadType", newJString(uploadType))
  add(query_589046, "validateOnly", newJBool(validateOnly))
  add(query_589046, "key", newJString(key))
  add(query_589046, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589047 = body
  add(query_589046, "prettyPrint", newJBool(prettyPrint))
  result = call_589044.call(path_589045, query_589046, nil, nil, body_589047)

var monitoringProjectsGroupsUpdate* = Call_MonitoringProjectsGroupsUpdate_589026(
    name: "monitoringProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsGroupsUpdate_589027, base: "/",
    url: url_MonitoringProjectsGroupsUpdate_589028, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsGet_588993 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsUptimeCheckConfigsGet_588995(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsGet_588994(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single Uptime check configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The Uptime check configuration to retrieve. The format  is projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589010 = path.getOrDefault("name")
  valid_589010 = validateParameter(valid_589010, JString, required = true,
                                 default = nil)
  if valid_589010 != nil:
    section.add "name", valid_589010
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
  var valid_589011 = query.getOrDefault("upload_protocol")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "upload_protocol", valid_589011
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("callback")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "callback", valid_589016
  var valid_589017 = query.getOrDefault("access_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "access_token", valid_589017
  var valid_589018 = query.getOrDefault("uploadType")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "uploadType", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("$.xgafv")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("1"))
  if valid_589020 != nil:
    section.add "$.xgafv", valid_589020
  var valid_589021 = query.getOrDefault("prettyPrint")
  valid_589021 = validateParameter(valid_589021, JBool, required = false,
                                 default = newJBool(true))
  if valid_589021 != nil:
    section.add "prettyPrint", valid_589021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589022: Call_MonitoringProjectsUptimeCheckConfigsGet_588993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a single Uptime check configuration.
  ## 
  let valid = call_589022.validator(path, query, header, formData, body)
  let scheme = call_589022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589022.url(scheme.get, call_589022.host, call_589022.base,
                         call_589022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589022, url, valid)

proc call*(call_589023: Call_MonitoringProjectsUptimeCheckConfigsGet_588993;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## monitoringProjectsUptimeCheckConfigsGet
  ## Gets a single Uptime check configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The Uptime check configuration to retrieve. The format  is projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589024 = newJObject()
  var query_589025 = newJObject()
  add(query_589025, "upload_protocol", newJString(uploadProtocol))
  add(query_589025, "fields", newJString(fields))
  add(query_589025, "quotaUser", newJString(quotaUser))
  add(path_589024, "name", newJString(name))
  add(query_589025, "alt", newJString(alt))
  add(query_589025, "oauth_token", newJString(oauthToken))
  add(query_589025, "callback", newJString(callback))
  add(query_589025, "access_token", newJString(accessToken))
  add(query_589025, "uploadType", newJString(uploadType))
  add(query_589025, "key", newJString(key))
  add(query_589025, "$.xgafv", newJString(Xgafv))
  add(query_589025, "prettyPrint", newJBool(prettyPrint))
  result = call_589023.call(path_589024, query_589025, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsGet* = Call_MonitoringProjectsUptimeCheckConfigsGet_588993(
    name: "monitoringProjectsUptimeCheckConfigsGet", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsGet_588994, base: "/",
    url: url_MonitoringProjectsUptimeCheckConfigsGet_588995,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsPatch_589068 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsUptimeCheckConfigsPatch_589070(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsPatch_589069(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an Uptime check configuration. You can either replace the entire configuration with a new one or replace only certain fields in the current configuration by specifying the fields to be updated via updateMask. Returns the updated configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : A unique resource name for this Uptime check configuration. The format is:projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].This field should be omitted when creating the Uptime check configuration; on create, the resource name is assigned by the server and included in the response.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589071 = path.getOrDefault("name")
  valid_589071 = validateParameter(valid_589071, JString, required = true,
                                 default = nil)
  if valid_589071 != nil:
    section.add "name", valid_589071
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
  ##   updateMask: JString
  ##             : Optional. If present, only the listed fields in the current Uptime check configuration are updated with values from the new configuration. If this field is empty, then the current configuration is completely replaced with the new configuration.
  section = newJObject()
  var valid_589072 = query.getOrDefault("upload_protocol")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "upload_protocol", valid_589072
  var valid_589073 = query.getOrDefault("fields")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "fields", valid_589073
  var valid_589074 = query.getOrDefault("quotaUser")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "quotaUser", valid_589074
  var valid_589075 = query.getOrDefault("alt")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = newJString("json"))
  if valid_589075 != nil:
    section.add "alt", valid_589075
  var valid_589076 = query.getOrDefault("oauth_token")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "oauth_token", valid_589076
  var valid_589077 = query.getOrDefault("callback")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "callback", valid_589077
  var valid_589078 = query.getOrDefault("access_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "access_token", valid_589078
  var valid_589079 = query.getOrDefault("uploadType")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "uploadType", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("$.xgafv")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = newJString("1"))
  if valid_589081 != nil:
    section.add "$.xgafv", valid_589081
  var valid_589082 = query.getOrDefault("prettyPrint")
  valid_589082 = validateParameter(valid_589082, JBool, required = false,
                                 default = newJBool(true))
  if valid_589082 != nil:
    section.add "prettyPrint", valid_589082
  var valid_589083 = query.getOrDefault("updateMask")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "updateMask", valid_589083
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

proc call*(call_589085: Call_MonitoringProjectsUptimeCheckConfigsPatch_589068;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an Uptime check configuration. You can either replace the entire configuration with a new one or replace only certain fields in the current configuration by specifying the fields to be updated via updateMask. Returns the updated configuration.
  ## 
  let valid = call_589085.validator(path, query, header, formData, body)
  let scheme = call_589085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589085.url(scheme.get, call_589085.host, call_589085.base,
                         call_589085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589085, url, valid)

proc call*(call_589086: Call_MonitoringProjectsUptimeCheckConfigsPatch_589068;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## monitoringProjectsUptimeCheckConfigsPatch
  ## Updates an Uptime check configuration. You can either replace the entire configuration with a new one or replace only certain fields in the current configuration by specifying the fields to be updated via updateMask. Returns the updated configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : A unique resource name for this Uptime check configuration. The format is:projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].This field should be omitted when creating the Uptime check configuration; on create, the resource name is assigned by the server and included in the response.
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
  ##   updateMask: string
  ##             : Optional. If present, only the listed fields in the current Uptime check configuration are updated with values from the new configuration. If this field is empty, then the current configuration is completely replaced with the new configuration.
  var path_589087 = newJObject()
  var query_589088 = newJObject()
  var body_589089 = newJObject()
  add(query_589088, "upload_protocol", newJString(uploadProtocol))
  add(query_589088, "fields", newJString(fields))
  add(query_589088, "quotaUser", newJString(quotaUser))
  add(path_589087, "name", newJString(name))
  add(query_589088, "alt", newJString(alt))
  add(query_589088, "oauth_token", newJString(oauthToken))
  add(query_589088, "callback", newJString(callback))
  add(query_589088, "access_token", newJString(accessToken))
  add(query_589088, "uploadType", newJString(uploadType))
  add(query_589088, "key", newJString(key))
  add(query_589088, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589089 = body
  add(query_589088, "prettyPrint", newJBool(prettyPrint))
  add(query_589088, "updateMask", newJString(updateMask))
  result = call_589086.call(path_589087, query_589088, nil, nil, body_589089)

var monitoringProjectsUptimeCheckConfigsPatch* = Call_MonitoringProjectsUptimeCheckConfigsPatch_589068(
    name: "monitoringProjectsUptimeCheckConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsPatch_589069,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsPatch_589070,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsDelete_589048 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsUptimeCheckConfigsDelete_589050(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsDelete_589049(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an Uptime check configuration. Note that this method will fail if the Uptime check configuration is referenced by an alert policy or other dependent configs that would be rendered invalid by the deletion.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The Uptime check configuration to delete. The format  is projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589051 = path.getOrDefault("name")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "name", valid_589051
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: JBool
  ##        : If true, the notification channel will be deleted regardless of its use in alert policies (the policies will be updated to remove the channel). If false, channels that are still referenced by an existing alerting policy will fail to be deleted in a delete operation.
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
  var valid_589052 = query.getOrDefault("upload_protocol")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "upload_protocol", valid_589052
  var valid_589053 = query.getOrDefault("fields")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "fields", valid_589053
  var valid_589054 = query.getOrDefault("force")
  valid_589054 = validateParameter(valid_589054, JBool, required = false, default = nil)
  if valid_589054 != nil:
    section.add "force", valid_589054
  var valid_589055 = query.getOrDefault("quotaUser")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "quotaUser", valid_589055
  var valid_589056 = query.getOrDefault("alt")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = newJString("json"))
  if valid_589056 != nil:
    section.add "alt", valid_589056
  var valid_589057 = query.getOrDefault("oauth_token")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "oauth_token", valid_589057
  var valid_589058 = query.getOrDefault("callback")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "callback", valid_589058
  var valid_589059 = query.getOrDefault("access_token")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "access_token", valid_589059
  var valid_589060 = query.getOrDefault("uploadType")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "uploadType", valid_589060
  var valid_589061 = query.getOrDefault("key")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "key", valid_589061
  var valid_589062 = query.getOrDefault("$.xgafv")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("1"))
  if valid_589062 != nil:
    section.add "$.xgafv", valid_589062
  var valid_589063 = query.getOrDefault("prettyPrint")
  valid_589063 = validateParameter(valid_589063, JBool, required = false,
                                 default = newJBool(true))
  if valid_589063 != nil:
    section.add "prettyPrint", valid_589063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589064: Call_MonitoringProjectsUptimeCheckConfigsDelete_589048;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an Uptime check configuration. Note that this method will fail if the Uptime check configuration is referenced by an alert policy or other dependent configs that would be rendered invalid by the deletion.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_MonitoringProjectsUptimeCheckConfigsDelete_589048;
          name: string; uploadProtocol: string = ""; fields: string = "";
          force: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsUptimeCheckConfigsDelete
  ## Deletes an Uptime check configuration. Note that this method will fail if the Uptime check configuration is referenced by an alert policy or other dependent configs that would be rendered invalid by the deletion.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: bool
  ##        : If true, the notification channel will be deleted regardless of its use in alert policies (the policies will be updated to remove the channel). If false, channels that are still referenced by an existing alerting policy will fail to be deleted in a delete operation.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The Uptime check configuration to delete. The format  is projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589066 = newJObject()
  var query_589067 = newJObject()
  add(query_589067, "upload_protocol", newJString(uploadProtocol))
  add(query_589067, "fields", newJString(fields))
  add(query_589067, "force", newJBool(force))
  add(query_589067, "quotaUser", newJString(quotaUser))
  add(path_589066, "name", newJString(name))
  add(query_589067, "alt", newJString(alt))
  add(query_589067, "oauth_token", newJString(oauthToken))
  add(query_589067, "callback", newJString(callback))
  add(query_589067, "access_token", newJString(accessToken))
  add(query_589067, "uploadType", newJString(uploadType))
  add(query_589067, "key", newJString(key))
  add(query_589067, "$.xgafv", newJString(Xgafv))
  add(query_589067, "prettyPrint", newJBool(prettyPrint))
  result = call_589065.call(path_589066, query_589067, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsDelete* = Call_MonitoringProjectsUptimeCheckConfigsDelete_589048(
    name: "monitoringProjectsUptimeCheckConfigsDelete",
    meth: HttpMethod.HttpDelete, host: "monitoring.googleapis.com",
    route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsDelete_589049,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsDelete_589050,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesCreate_589113 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsAlertPoliciesCreate_589115(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/alertPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsAlertPoliciesCreate_589114(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new alerting policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project in which to create the alerting policy. The format is projects/[PROJECT_ID].Note that this field names the parent container in which the alerting policy will be written, not the name of the created policy. The alerting policy that is returned will have a name that contains a normalized representation of this name as a prefix but adds a suffix of the form /alertPolicies/[POLICY_ID], identifying the policy in the container.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589116 = path.getOrDefault("name")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "name", valid_589116
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
  var valid_589119 = query.getOrDefault("quotaUser")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "quotaUser", valid_589119
  var valid_589120 = query.getOrDefault("alt")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = newJString("json"))
  if valid_589120 != nil:
    section.add "alt", valid_589120
  var valid_589121 = query.getOrDefault("oauth_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "oauth_token", valid_589121
  var valid_589122 = query.getOrDefault("callback")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "callback", valid_589122
  var valid_589123 = query.getOrDefault("access_token")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "access_token", valid_589123
  var valid_589124 = query.getOrDefault("uploadType")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "uploadType", valid_589124
  var valid_589125 = query.getOrDefault("key")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "key", valid_589125
  var valid_589126 = query.getOrDefault("$.xgafv")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = newJString("1"))
  if valid_589126 != nil:
    section.add "$.xgafv", valid_589126
  var valid_589127 = query.getOrDefault("prettyPrint")
  valid_589127 = validateParameter(valid_589127, JBool, required = false,
                                 default = newJBool(true))
  if valid_589127 != nil:
    section.add "prettyPrint", valid_589127
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

proc call*(call_589129: Call_MonitoringProjectsAlertPoliciesCreate_589113;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new alerting policy.
  ## 
  let valid = call_589129.validator(path, query, header, formData, body)
  let scheme = call_589129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589129.url(scheme.get, call_589129.host, call_589129.base,
                         call_589129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589129, url, valid)

proc call*(call_589130: Call_MonitoringProjectsAlertPoliciesCreate_589113;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsAlertPoliciesCreate
  ## Creates a new alerting policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project in which to create the alerting policy. The format is projects/[PROJECT_ID].Note that this field names the parent container in which the alerting policy will be written, not the name of the created policy. The alerting policy that is returned will have a name that contains a normalized representation of this name as a prefix but adds a suffix of the form /alertPolicies/[POLICY_ID], identifying the policy in the container.
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
  var path_589131 = newJObject()
  var query_589132 = newJObject()
  var body_589133 = newJObject()
  add(query_589132, "upload_protocol", newJString(uploadProtocol))
  add(query_589132, "fields", newJString(fields))
  add(query_589132, "quotaUser", newJString(quotaUser))
  add(path_589131, "name", newJString(name))
  add(query_589132, "alt", newJString(alt))
  add(query_589132, "oauth_token", newJString(oauthToken))
  add(query_589132, "callback", newJString(callback))
  add(query_589132, "access_token", newJString(accessToken))
  add(query_589132, "uploadType", newJString(uploadType))
  add(query_589132, "key", newJString(key))
  add(query_589132, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589133 = body
  add(query_589132, "prettyPrint", newJBool(prettyPrint))
  result = call_589130.call(path_589131, query_589132, nil, nil, body_589133)

var monitoringProjectsAlertPoliciesCreate* = Call_MonitoringProjectsAlertPoliciesCreate_589113(
    name: "monitoringProjectsAlertPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesCreate_589114, base: "/",
    url: url_MonitoringProjectsAlertPoliciesCreate_589115, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesList_589090 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsAlertPoliciesList_589092(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/alertPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsAlertPoliciesList_589091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the existing alerting policies for the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project whose alert policies are to be listed. The format is
  ## projects/[PROJECT_ID]
  ## Note that this field names the parent container in which the alerting policies to be listed are stored. To retrieve a single alerting policy by name, use the GetAlertPolicy operation, instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589093 = path.getOrDefault("name")
  valid_589093 = validateParameter(valid_589093, JString, required = true,
                                 default = nil)
  if valid_589093 != nil:
    section.add "name", valid_589093
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
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
  ##   orderBy: JString
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of field references as the filter field. Entries can be prefixed with a minus sign to sort by the field in descending order.For more details, see sorting and filtering.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to return in a single response.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : If provided, this field specifies the criteria that must be met by alert policies to be included in the response.For more details, see sorting and filtering.
  section = newJObject()
  var valid_589094 = query.getOrDefault("upload_protocol")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "upload_protocol", valid_589094
  var valid_589095 = query.getOrDefault("fields")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "fields", valid_589095
  var valid_589096 = query.getOrDefault("pageToken")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "pageToken", valid_589096
  var valid_589097 = query.getOrDefault("quotaUser")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "quotaUser", valid_589097
  var valid_589098 = query.getOrDefault("alt")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = newJString("json"))
  if valid_589098 != nil:
    section.add "alt", valid_589098
  var valid_589099 = query.getOrDefault("oauth_token")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "oauth_token", valid_589099
  var valid_589100 = query.getOrDefault("callback")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "callback", valid_589100
  var valid_589101 = query.getOrDefault("access_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "access_token", valid_589101
  var valid_589102 = query.getOrDefault("uploadType")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "uploadType", valid_589102
  var valid_589103 = query.getOrDefault("orderBy")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "orderBy", valid_589103
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
  var valid_589106 = query.getOrDefault("pageSize")
  valid_589106 = validateParameter(valid_589106, JInt, required = false, default = nil)
  if valid_589106 != nil:
    section.add "pageSize", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  var valid_589108 = query.getOrDefault("filter")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "filter", valid_589108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589109: Call_MonitoringProjectsAlertPoliciesList_589090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing alerting policies for the project.
  ## 
  let valid = call_589109.validator(path, query, header, formData, body)
  let scheme = call_589109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589109.url(scheme.get, call_589109.host, call_589109.base,
                         call_589109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589109, url, valid)

proc call*(call_589110: Call_MonitoringProjectsAlertPoliciesList_589090;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## monitoringProjectsAlertPoliciesList
  ## Lists the existing alerting policies for the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project whose alert policies are to be listed. The format is
  ## projects/[PROJECT_ID]
  ## Note that this field names the parent container in which the alerting policies to be listed are stored. To retrieve a single alerting policy by name, use the GetAlertPolicy operation, instead.
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
  ##   orderBy: string
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of field references as the filter field. Entries can be prefixed with a minus sign to sort by the field in descending order.For more details, see sorting and filtering.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : If provided, this field specifies the criteria that must be met by alert policies to be included in the response.For more details, see sorting and filtering.
  var path_589111 = newJObject()
  var query_589112 = newJObject()
  add(query_589112, "upload_protocol", newJString(uploadProtocol))
  add(query_589112, "fields", newJString(fields))
  add(query_589112, "pageToken", newJString(pageToken))
  add(query_589112, "quotaUser", newJString(quotaUser))
  add(path_589111, "name", newJString(name))
  add(query_589112, "alt", newJString(alt))
  add(query_589112, "oauth_token", newJString(oauthToken))
  add(query_589112, "callback", newJString(callback))
  add(query_589112, "access_token", newJString(accessToken))
  add(query_589112, "uploadType", newJString(uploadType))
  add(query_589112, "orderBy", newJString(orderBy))
  add(query_589112, "key", newJString(key))
  add(query_589112, "$.xgafv", newJString(Xgafv))
  add(query_589112, "pageSize", newJInt(pageSize))
  add(query_589112, "prettyPrint", newJBool(prettyPrint))
  add(query_589112, "filter", newJString(filter))
  result = call_589110.call(path_589111, query_589112, nil, nil, nil)

var monitoringProjectsAlertPoliciesList* = Call_MonitoringProjectsAlertPoliciesList_589090(
    name: "monitoringProjectsAlertPoliciesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesList_589091, base: "/",
    url: url_MonitoringProjectsAlertPoliciesList_589092, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsCollectdTimeSeriesCreate_589134 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsCollectdTimeSeriesCreate_589136(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/collectdTimeSeries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsCollectdTimeSeriesCreate_589135(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project in which to create the time series. The format is "projects/PROJECT_ID_OR_NUMBER".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589137 = path.getOrDefault("name")
  valid_589137 = validateParameter(valid_589137, JString, required = true,
                                 default = nil)
  if valid_589137 != nil:
    section.add "name", valid_589137
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

proc call*(call_589150: Call_MonitoringProjectsCollectdTimeSeriesCreate_589134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
  ## 
  let valid = call_589150.validator(path, query, header, formData, body)
  let scheme = call_589150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589150.url(scheme.get, call_589150.host, call_589150.base,
                         call_589150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589150, url, valid)

proc call*(call_589151: Call_MonitoringProjectsCollectdTimeSeriesCreate_589134;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsCollectdTimeSeriesCreate
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project in which to create the time series. The format is "projects/PROJECT_ID_OR_NUMBER".
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
  var path_589152 = newJObject()
  var query_589153 = newJObject()
  var body_589154 = newJObject()
  add(query_589153, "upload_protocol", newJString(uploadProtocol))
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(path_589152, "name", newJString(name))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "callback", newJString(callback))
  add(query_589153, "access_token", newJString(accessToken))
  add(query_589153, "uploadType", newJString(uploadType))
  add(query_589153, "key", newJString(key))
  add(query_589153, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589154 = body
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  result = call_589151.call(path_589152, query_589153, nil, nil, body_589154)

var monitoringProjectsCollectdTimeSeriesCreate* = Call_MonitoringProjectsCollectdTimeSeriesCreate_589134(
    name: "monitoringProjectsCollectdTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/collectdTimeSeries",
    validator: validate_MonitoringProjectsCollectdTimeSeriesCreate_589135,
    base: "/", url: url_MonitoringProjectsCollectdTimeSeriesCreate_589136,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsCreate_589179 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsGroupsCreate_589181(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsCreate_589180(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project in which to create the group. The format is "projects/{project_id_or_number}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589182 = path.getOrDefault("name")
  valid_589182 = validateParameter(valid_589182, JString, required = true,
                                 default = nil)
  if valid_589182 != nil:
    section.add "name", valid_589182
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
  ##   validateOnly: JBool
  ##               : If true, validate this request but do not create the group.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589183 = query.getOrDefault("upload_protocol")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "upload_protocol", valid_589183
  var valid_589184 = query.getOrDefault("fields")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "fields", valid_589184
  var valid_589185 = query.getOrDefault("quotaUser")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "quotaUser", valid_589185
  var valid_589186 = query.getOrDefault("alt")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = newJString("json"))
  if valid_589186 != nil:
    section.add "alt", valid_589186
  var valid_589187 = query.getOrDefault("oauth_token")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "oauth_token", valid_589187
  var valid_589188 = query.getOrDefault("callback")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "callback", valid_589188
  var valid_589189 = query.getOrDefault("access_token")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "access_token", valid_589189
  var valid_589190 = query.getOrDefault("uploadType")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "uploadType", valid_589190
  var valid_589191 = query.getOrDefault("validateOnly")
  valid_589191 = validateParameter(valid_589191, JBool, required = false, default = nil)
  if valid_589191 != nil:
    section.add "validateOnly", valid_589191
  var valid_589192 = query.getOrDefault("key")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "key", valid_589192
  var valid_589193 = query.getOrDefault("$.xgafv")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("1"))
  if valid_589193 != nil:
    section.add "$.xgafv", valid_589193
  var valid_589194 = query.getOrDefault("prettyPrint")
  valid_589194 = validateParameter(valid_589194, JBool, required = false,
                                 default = newJBool(true))
  if valid_589194 != nil:
    section.add "prettyPrint", valid_589194
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

proc call*(call_589196: Call_MonitoringProjectsGroupsCreate_589179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new group.
  ## 
  let valid = call_589196.validator(path, query, header, formData, body)
  let scheme = call_589196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589196.url(scheme.get, call_589196.host, call_589196.base,
                         call_589196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589196, url, valid)

proc call*(call_589197: Call_MonitoringProjectsGroupsCreate_589179; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; validateOnly: bool = false;
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsGroupsCreate
  ## Creates a new group.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project in which to create the group. The format is "projects/{project_id_or_number}".
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
  ##   validateOnly: bool
  ##               : If true, validate this request but do not create the group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589198 = newJObject()
  var query_589199 = newJObject()
  var body_589200 = newJObject()
  add(query_589199, "upload_protocol", newJString(uploadProtocol))
  add(query_589199, "fields", newJString(fields))
  add(query_589199, "quotaUser", newJString(quotaUser))
  add(path_589198, "name", newJString(name))
  add(query_589199, "alt", newJString(alt))
  add(query_589199, "oauth_token", newJString(oauthToken))
  add(query_589199, "callback", newJString(callback))
  add(query_589199, "access_token", newJString(accessToken))
  add(query_589199, "uploadType", newJString(uploadType))
  add(query_589199, "validateOnly", newJBool(validateOnly))
  add(query_589199, "key", newJString(key))
  add(query_589199, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589200 = body
  add(query_589199, "prettyPrint", newJBool(prettyPrint))
  result = call_589197.call(path_589198, query_589199, nil, nil, body_589200)

var monitoringProjectsGroupsCreate* = Call_MonitoringProjectsGroupsCreate_589179(
    name: "monitoringProjectsGroupsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsCreate_589180, base: "/",
    url: url_MonitoringProjectsGroupsCreate_589181, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsList_589155 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsGroupsList_589157(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/groups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsList_589156(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the existing groups.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project whose groups are to be listed. The format is "projects/{project_id_or_number}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589158 = path.getOrDefault("name")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "name", valid_589158
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   childrenOfGroup: JString
  ##                  : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups whose parentName field contains the group name. If no groups have this parent, the results are empty.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   descendantsOfGroup: JString
  ##                     : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns the descendants of the specified group. This is a superset of the results returned by the childrenOfGroup filter, and includes children-of-children, and so forth.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ancestorsOfGroup: JString
  ##                   : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups that are ancestors of the specified group. The groups are returned in order, starting with the immediate parent and ending with the most distant ancestor. If the specified group has no immediate parent, the results are empty.
  section = newJObject()
  var valid_589159 = query.getOrDefault("upload_protocol")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "upload_protocol", valid_589159
  var valid_589160 = query.getOrDefault("fields")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "fields", valid_589160
  var valid_589161 = query.getOrDefault("pageToken")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "pageToken", valid_589161
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
  var valid_589164 = query.getOrDefault("childrenOfGroup")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "childrenOfGroup", valid_589164
  var valid_589165 = query.getOrDefault("oauth_token")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "oauth_token", valid_589165
  var valid_589166 = query.getOrDefault("callback")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "callback", valid_589166
  var valid_589167 = query.getOrDefault("access_token")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "access_token", valid_589167
  var valid_589168 = query.getOrDefault("uploadType")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "uploadType", valid_589168
  var valid_589169 = query.getOrDefault("descendantsOfGroup")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "descendantsOfGroup", valid_589169
  var valid_589170 = query.getOrDefault("key")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "key", valid_589170
  var valid_589171 = query.getOrDefault("$.xgafv")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = newJString("1"))
  if valid_589171 != nil:
    section.add "$.xgafv", valid_589171
  var valid_589172 = query.getOrDefault("pageSize")
  valid_589172 = validateParameter(valid_589172, JInt, required = false, default = nil)
  if valid_589172 != nil:
    section.add "pageSize", valid_589172
  var valid_589173 = query.getOrDefault("prettyPrint")
  valid_589173 = validateParameter(valid_589173, JBool, required = false,
                                 default = newJBool(true))
  if valid_589173 != nil:
    section.add "prettyPrint", valid_589173
  var valid_589174 = query.getOrDefault("ancestorsOfGroup")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "ancestorsOfGroup", valid_589174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589175: Call_MonitoringProjectsGroupsList_589155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing groups.
  ## 
  let valid = call_589175.validator(path, query, header, formData, body)
  let scheme = call_589175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589175.url(scheme.get, call_589175.host, call_589175.base,
                         call_589175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589175, url, valid)

proc call*(call_589176: Call_MonitoringProjectsGroupsList_589155; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; childrenOfGroup: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; descendantsOfGroup: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          ancestorsOfGroup: string = ""): Recallable =
  ## monitoringProjectsGroupsList
  ## Lists the existing groups.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project whose groups are to be listed. The format is "projects/{project_id_or_number}".
  ##   alt: string
  ##      : Data format for response.
  ##   childrenOfGroup: string
  ##                  : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups whose parentName field contains the group name. If no groups have this parent, the results are empty.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   descendantsOfGroup: string
  ##                     : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns the descendants of the specified group. This is a superset of the results returned by the childrenOfGroup filter, and includes children-of-children, and so forth.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ancestorsOfGroup: string
  ##                   : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups that are ancestors of the specified group. The groups are returned in order, starting with the immediate parent and ending with the most distant ancestor. If the specified group has no immediate parent, the results are empty.
  var path_589177 = newJObject()
  var query_589178 = newJObject()
  add(query_589178, "upload_protocol", newJString(uploadProtocol))
  add(query_589178, "fields", newJString(fields))
  add(query_589178, "pageToken", newJString(pageToken))
  add(query_589178, "quotaUser", newJString(quotaUser))
  add(path_589177, "name", newJString(name))
  add(query_589178, "alt", newJString(alt))
  add(query_589178, "childrenOfGroup", newJString(childrenOfGroup))
  add(query_589178, "oauth_token", newJString(oauthToken))
  add(query_589178, "callback", newJString(callback))
  add(query_589178, "access_token", newJString(accessToken))
  add(query_589178, "uploadType", newJString(uploadType))
  add(query_589178, "descendantsOfGroup", newJString(descendantsOfGroup))
  add(query_589178, "key", newJString(key))
  add(query_589178, "$.xgafv", newJString(Xgafv))
  add(query_589178, "pageSize", newJInt(pageSize))
  add(query_589178, "prettyPrint", newJBool(prettyPrint))
  add(query_589178, "ancestorsOfGroup", newJString(ancestorsOfGroup))
  result = call_589176.call(path_589177, query_589178, nil, nil, nil)

var monitoringProjectsGroupsList* = Call_MonitoringProjectsGroupsList_589155(
    name: "monitoringProjectsGroupsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsList_589156, base: "/",
    url: url_MonitoringProjectsGroupsList_589157, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsMembersList_589201 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsGroupsMembersList_589203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/members")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsMembersList_589202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the monitored resources that are members of a group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The group whose members are listed. The format is "projects/{project_id_or_number}/groups/{group_id}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589204 = path.getOrDefault("name")
  valid_589204 = validateParameter(valid_589204, JString, required = true,
                                 default = nil)
  if valid_589204 != nil:
    section.add "name", valid_589204
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
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
  ##   interval.endTime: JString
  ##                   : Required. The end of the time interval.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   interval.startTime: JString
  ##                     : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  ##   filter: JString
  ##         : An optional list filter describing the members to be returned. The filter may reference the type, labels, and metadata of monitored resources that comprise the group. For example, to return only resources representing Compute Engine VM instances, use this filter:
  ## resource.type = "gce_instance"
  ## 
  section = newJObject()
  var valid_589205 = query.getOrDefault("upload_protocol")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "upload_protocol", valid_589205
  var valid_589206 = query.getOrDefault("fields")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "fields", valid_589206
  var valid_589207 = query.getOrDefault("pageToken")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "pageToken", valid_589207
  var valid_589208 = query.getOrDefault("quotaUser")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "quotaUser", valid_589208
  var valid_589209 = query.getOrDefault("alt")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = newJString("json"))
  if valid_589209 != nil:
    section.add "alt", valid_589209
  var valid_589210 = query.getOrDefault("oauth_token")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "oauth_token", valid_589210
  var valid_589211 = query.getOrDefault("callback")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "callback", valid_589211
  var valid_589212 = query.getOrDefault("access_token")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "access_token", valid_589212
  var valid_589213 = query.getOrDefault("uploadType")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "uploadType", valid_589213
  var valid_589214 = query.getOrDefault("interval.endTime")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "interval.endTime", valid_589214
  var valid_589215 = query.getOrDefault("key")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "key", valid_589215
  var valid_589216 = query.getOrDefault("$.xgafv")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = newJString("1"))
  if valid_589216 != nil:
    section.add "$.xgafv", valid_589216
  var valid_589217 = query.getOrDefault("pageSize")
  valid_589217 = validateParameter(valid_589217, JInt, required = false, default = nil)
  if valid_589217 != nil:
    section.add "pageSize", valid_589217
  var valid_589218 = query.getOrDefault("prettyPrint")
  valid_589218 = validateParameter(valid_589218, JBool, required = false,
                                 default = newJBool(true))
  if valid_589218 != nil:
    section.add "prettyPrint", valid_589218
  var valid_589219 = query.getOrDefault("interval.startTime")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "interval.startTime", valid_589219
  var valid_589220 = query.getOrDefault("filter")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "filter", valid_589220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589221: Call_MonitoringProjectsGroupsMembersList_589201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the monitored resources that are members of a group.
  ## 
  let valid = call_589221.validator(path, query, header, formData, body)
  let scheme = call_589221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589221.url(scheme.get, call_589221.host, call_589221.base,
                         call_589221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589221, url, valid)

proc call*(call_589222: Call_MonitoringProjectsGroupsMembersList_589201;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; intervalEndTime: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          intervalStartTime: string = ""; filter: string = ""): Recallable =
  ## monitoringProjectsGroupsMembersList
  ## Lists the monitored resources that are members of a group.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The group whose members are listed. The format is "projects/{project_id_or_number}/groups/{group_id}".
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
  ##   intervalEndTime: string
  ##                  : Required. The end of the time interval.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   intervalStartTime: string
  ##                    : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  ##   filter: string
  ##         : An optional list filter describing the members to be returned. The filter may reference the type, labels, and metadata of monitored resources that comprise the group. For example, to return only resources representing Compute Engine VM instances, use this filter:
  ## resource.type = "gce_instance"
  ## 
  var path_589223 = newJObject()
  var query_589224 = newJObject()
  add(query_589224, "upload_protocol", newJString(uploadProtocol))
  add(query_589224, "fields", newJString(fields))
  add(query_589224, "pageToken", newJString(pageToken))
  add(query_589224, "quotaUser", newJString(quotaUser))
  add(path_589223, "name", newJString(name))
  add(query_589224, "alt", newJString(alt))
  add(query_589224, "oauth_token", newJString(oauthToken))
  add(query_589224, "callback", newJString(callback))
  add(query_589224, "access_token", newJString(accessToken))
  add(query_589224, "uploadType", newJString(uploadType))
  add(query_589224, "interval.endTime", newJString(intervalEndTime))
  add(query_589224, "key", newJString(key))
  add(query_589224, "$.xgafv", newJString(Xgafv))
  add(query_589224, "pageSize", newJInt(pageSize))
  add(query_589224, "prettyPrint", newJBool(prettyPrint))
  add(query_589224, "interval.startTime", newJString(intervalStartTime))
  add(query_589224, "filter", newJString(filter))
  result = call_589222.call(path_589223, query_589224, nil, nil, nil)

var monitoringProjectsGroupsMembersList* = Call_MonitoringProjectsGroupsMembersList_589201(
    name: "monitoringProjectsGroupsMembersList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/members",
    validator: validate_MonitoringProjectsGroupsMembersList_589202, base: "/",
    url: url_MonitoringProjectsGroupsMembersList_589203, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsCreate_589247 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsMetricDescriptorsCreate_589249(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metricDescriptors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsMetricDescriptorsCreate_589248(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589250 = path.getOrDefault("name")
  valid_589250 = validateParameter(valid_589250, JString, required = true,
                                 default = nil)
  if valid_589250 != nil:
    section.add "name", valid_589250
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
  var valid_589251 = query.getOrDefault("upload_protocol")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "upload_protocol", valid_589251
  var valid_589252 = query.getOrDefault("fields")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "fields", valid_589252
  var valid_589253 = query.getOrDefault("quotaUser")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "quotaUser", valid_589253
  var valid_589254 = query.getOrDefault("alt")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = newJString("json"))
  if valid_589254 != nil:
    section.add "alt", valid_589254
  var valid_589255 = query.getOrDefault("oauth_token")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "oauth_token", valid_589255
  var valid_589256 = query.getOrDefault("callback")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "callback", valid_589256
  var valid_589257 = query.getOrDefault("access_token")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "access_token", valid_589257
  var valid_589258 = query.getOrDefault("uploadType")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "uploadType", valid_589258
  var valid_589259 = query.getOrDefault("key")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "key", valid_589259
  var valid_589260 = query.getOrDefault("$.xgafv")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("1"))
  if valid_589260 != nil:
    section.add "$.xgafv", valid_589260
  var valid_589261 = query.getOrDefault("prettyPrint")
  valid_589261 = validateParameter(valid_589261, JBool, required = false,
                                 default = newJBool(true))
  if valid_589261 != nil:
    section.add "prettyPrint", valid_589261
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

proc call*(call_589263: Call_MonitoringProjectsMetricDescriptorsCreate_589247;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
  ## 
  let valid = call_589263.validator(path, query, header, formData, body)
  let scheme = call_589263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589263.url(scheme.get, call_589263.host, call_589263.base,
                         call_589263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589263, url, valid)

proc call*(call_589264: Call_MonitoringProjectsMetricDescriptorsCreate_589247;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsMetricDescriptorsCreate
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
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
  var path_589265 = newJObject()
  var query_589266 = newJObject()
  var body_589267 = newJObject()
  add(query_589266, "upload_protocol", newJString(uploadProtocol))
  add(query_589266, "fields", newJString(fields))
  add(query_589266, "quotaUser", newJString(quotaUser))
  add(path_589265, "name", newJString(name))
  add(query_589266, "alt", newJString(alt))
  add(query_589266, "oauth_token", newJString(oauthToken))
  add(query_589266, "callback", newJString(callback))
  add(query_589266, "access_token", newJString(accessToken))
  add(query_589266, "uploadType", newJString(uploadType))
  add(query_589266, "key", newJString(key))
  add(query_589266, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589267 = body
  add(query_589266, "prettyPrint", newJBool(prettyPrint))
  result = call_589264.call(path_589265, query_589266, nil, nil, body_589267)

var monitoringProjectsMetricDescriptorsCreate* = Call_MonitoringProjectsMetricDescriptorsCreate_589247(
    name: "monitoringProjectsMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsCreate_589248,
    base: "/", url: url_MonitoringProjectsMetricDescriptorsCreate_589249,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsList_589225 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsMetricDescriptorsList_589227(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/metricDescriptors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsMetricDescriptorsList_589226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589228 = path.getOrDefault("name")
  valid_589228 = validateParameter(valid_589228, JString, required = true,
                                 default = nil)
  if valid_589228 != nil:
    section.add "name", valid_589228
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
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
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : If this field is empty, all custom and system-defined metric descriptors are returned. Otherwise, the filter specifies which metric descriptors are to be returned. For example, the following filter matches all custom metrics:
  ## metric.type = starts_with("custom.googleapis.com/")
  ## 
  section = newJObject()
  var valid_589229 = query.getOrDefault("upload_protocol")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "upload_protocol", valid_589229
  var valid_589230 = query.getOrDefault("fields")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "fields", valid_589230
  var valid_589231 = query.getOrDefault("pageToken")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "pageToken", valid_589231
  var valid_589232 = query.getOrDefault("quotaUser")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "quotaUser", valid_589232
  var valid_589233 = query.getOrDefault("alt")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = newJString("json"))
  if valid_589233 != nil:
    section.add "alt", valid_589233
  var valid_589234 = query.getOrDefault("oauth_token")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "oauth_token", valid_589234
  var valid_589235 = query.getOrDefault("callback")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "callback", valid_589235
  var valid_589236 = query.getOrDefault("access_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "access_token", valid_589236
  var valid_589237 = query.getOrDefault("uploadType")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "uploadType", valid_589237
  var valid_589238 = query.getOrDefault("key")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "key", valid_589238
  var valid_589239 = query.getOrDefault("$.xgafv")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = newJString("1"))
  if valid_589239 != nil:
    section.add "$.xgafv", valid_589239
  var valid_589240 = query.getOrDefault("pageSize")
  valid_589240 = validateParameter(valid_589240, JInt, required = false, default = nil)
  if valid_589240 != nil:
    section.add "pageSize", valid_589240
  var valid_589241 = query.getOrDefault("prettyPrint")
  valid_589241 = validateParameter(valid_589241, JBool, required = false,
                                 default = newJBool(true))
  if valid_589241 != nil:
    section.add "prettyPrint", valid_589241
  var valid_589242 = query.getOrDefault("filter")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "filter", valid_589242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589243: Call_MonitoringProjectsMetricDescriptorsList_589225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_589243.validator(path, query, header, formData, body)
  let scheme = call_589243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589243.url(scheme.get, call_589243.host, call_589243.base,
                         call_589243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589243, url, valid)

proc call*(call_589244: Call_MonitoringProjectsMetricDescriptorsList_589225;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## monitoringProjectsMetricDescriptorsList
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
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
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : If this field is empty, all custom and system-defined metric descriptors are returned. Otherwise, the filter specifies which metric descriptors are to be returned. For example, the following filter matches all custom metrics:
  ## metric.type = starts_with("custom.googleapis.com/")
  ## 
  var path_589245 = newJObject()
  var query_589246 = newJObject()
  add(query_589246, "upload_protocol", newJString(uploadProtocol))
  add(query_589246, "fields", newJString(fields))
  add(query_589246, "pageToken", newJString(pageToken))
  add(query_589246, "quotaUser", newJString(quotaUser))
  add(path_589245, "name", newJString(name))
  add(query_589246, "alt", newJString(alt))
  add(query_589246, "oauth_token", newJString(oauthToken))
  add(query_589246, "callback", newJString(callback))
  add(query_589246, "access_token", newJString(accessToken))
  add(query_589246, "uploadType", newJString(uploadType))
  add(query_589246, "key", newJString(key))
  add(query_589246, "$.xgafv", newJString(Xgafv))
  add(query_589246, "pageSize", newJInt(pageSize))
  add(query_589246, "prettyPrint", newJBool(prettyPrint))
  add(query_589246, "filter", newJString(filter))
  result = call_589244.call(path_589245, query_589246, nil, nil, nil)

var monitoringProjectsMetricDescriptorsList* = Call_MonitoringProjectsMetricDescriptorsList_589225(
    name: "monitoringProjectsMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsList_589226, base: "/",
    url: url_MonitoringProjectsMetricDescriptorsList_589227,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMonitoredResourceDescriptorsList_589268 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsMonitoredResourceDescriptorsList_589270(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/monitoredResourceDescriptors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsMonitoredResourceDescriptorsList_589269(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589271 = path.getOrDefault("name")
  valid_589271 = validateParameter(valid_589271, JString, required = true,
                                 default = nil)
  if valid_589271 != nil:
    section.add "name", valid_589271
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
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
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An optional filter describing the descriptors to be returned. The filter can reference the descriptor's type and labels. For example, the following filter returns only Google Compute Engine descriptors that have an id label:
  ## resource.type = starts_with("gce_") AND resource.label:id
  ## 
  section = newJObject()
  var valid_589272 = query.getOrDefault("upload_protocol")
  valid_589272 = validateParameter(valid_589272, JString, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "upload_protocol", valid_589272
  var valid_589273 = query.getOrDefault("fields")
  valid_589273 = validateParameter(valid_589273, JString, required = false,
                                 default = nil)
  if valid_589273 != nil:
    section.add "fields", valid_589273
  var valid_589274 = query.getOrDefault("pageToken")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "pageToken", valid_589274
  var valid_589275 = query.getOrDefault("quotaUser")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "quotaUser", valid_589275
  var valid_589276 = query.getOrDefault("alt")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = newJString("json"))
  if valid_589276 != nil:
    section.add "alt", valid_589276
  var valid_589277 = query.getOrDefault("oauth_token")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "oauth_token", valid_589277
  var valid_589278 = query.getOrDefault("callback")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "callback", valid_589278
  var valid_589279 = query.getOrDefault("access_token")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "access_token", valid_589279
  var valid_589280 = query.getOrDefault("uploadType")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "uploadType", valid_589280
  var valid_589281 = query.getOrDefault("key")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "key", valid_589281
  var valid_589282 = query.getOrDefault("$.xgafv")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = newJString("1"))
  if valid_589282 != nil:
    section.add "$.xgafv", valid_589282
  var valid_589283 = query.getOrDefault("pageSize")
  valid_589283 = validateParameter(valid_589283, JInt, required = false, default = nil)
  if valid_589283 != nil:
    section.add "pageSize", valid_589283
  var valid_589284 = query.getOrDefault("prettyPrint")
  valid_589284 = validateParameter(valid_589284, JBool, required = false,
                                 default = newJBool(true))
  if valid_589284 != nil:
    section.add "prettyPrint", valid_589284
  var valid_589285 = query.getOrDefault("filter")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "filter", valid_589285
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589286: Call_MonitoringProjectsMonitoredResourceDescriptorsList_589268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_589286.validator(path, query, header, formData, body)
  let scheme = call_589286.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589286.url(scheme.get, call_589286.host, call_589286.base,
                         call_589286.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589286, url, valid)

proc call*(call_589287: Call_MonitoringProjectsMonitoredResourceDescriptorsList_589268;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## monitoringProjectsMonitoredResourceDescriptorsList
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
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
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An optional filter describing the descriptors to be returned. The filter can reference the descriptor's type and labels. For example, the following filter returns only Google Compute Engine descriptors that have an id label:
  ## resource.type = starts_with("gce_") AND resource.label:id
  ## 
  var path_589288 = newJObject()
  var query_589289 = newJObject()
  add(query_589289, "upload_protocol", newJString(uploadProtocol))
  add(query_589289, "fields", newJString(fields))
  add(query_589289, "pageToken", newJString(pageToken))
  add(query_589289, "quotaUser", newJString(quotaUser))
  add(path_589288, "name", newJString(name))
  add(query_589289, "alt", newJString(alt))
  add(query_589289, "oauth_token", newJString(oauthToken))
  add(query_589289, "callback", newJString(callback))
  add(query_589289, "access_token", newJString(accessToken))
  add(query_589289, "uploadType", newJString(uploadType))
  add(query_589289, "key", newJString(key))
  add(query_589289, "$.xgafv", newJString(Xgafv))
  add(query_589289, "pageSize", newJInt(pageSize))
  add(query_589289, "prettyPrint", newJBool(prettyPrint))
  add(query_589289, "filter", newJString(filter))
  result = call_589287.call(path_589288, query_589289, nil, nil, nil)

var monitoringProjectsMonitoredResourceDescriptorsList* = Call_MonitoringProjectsMonitoredResourceDescriptorsList_589268(
    name: "monitoringProjectsMonitoredResourceDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/monitoredResourceDescriptors",
    validator: validate_MonitoringProjectsMonitoredResourceDescriptorsList_589269,
    base: "/", url: url_MonitoringProjectsMonitoredResourceDescriptorsList_589270,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelDescriptorsList_589290 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsNotificationChannelDescriptorsList_589292(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"), (kind: ConstantSegment,
        value: "/notificationChannelDescriptors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelDescriptorsList_589291(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The REST resource name of the parent from which to retrieve the notification channel descriptors. The expected syntax is:
  ## projects/[PROJECT_ID]
  ## Note that this names the parent container in which to look for the descriptors; to retrieve a single descriptor by name, use the GetNotificationChannelDescriptor operation, instead.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589293 = path.getOrDefault("name")
  valid_589293 = validateParameter(valid_589293, JString, required = true,
                                 default = nil)
  if valid_589293 != nil:
    section.add "name", valid_589293
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
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
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589294 = query.getOrDefault("upload_protocol")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "upload_protocol", valid_589294
  var valid_589295 = query.getOrDefault("fields")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "fields", valid_589295
  var valid_589296 = query.getOrDefault("pageToken")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "pageToken", valid_589296
  var valid_589297 = query.getOrDefault("quotaUser")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "quotaUser", valid_589297
  var valid_589298 = query.getOrDefault("alt")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("json"))
  if valid_589298 != nil:
    section.add "alt", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("callback")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "callback", valid_589300
  var valid_589301 = query.getOrDefault("access_token")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "access_token", valid_589301
  var valid_589302 = query.getOrDefault("uploadType")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "uploadType", valid_589302
  var valid_589303 = query.getOrDefault("key")
  valid_589303 = validateParameter(valid_589303, JString, required = false,
                                 default = nil)
  if valid_589303 != nil:
    section.add "key", valid_589303
  var valid_589304 = query.getOrDefault("$.xgafv")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = newJString("1"))
  if valid_589304 != nil:
    section.add "$.xgafv", valid_589304
  var valid_589305 = query.getOrDefault("pageSize")
  valid_589305 = validateParameter(valid_589305, JInt, required = false, default = nil)
  if valid_589305 != nil:
    section.add "pageSize", valid_589305
  var valid_589306 = query.getOrDefault("prettyPrint")
  valid_589306 = validateParameter(valid_589306, JBool, required = false,
                                 default = newJBool(true))
  if valid_589306 != nil:
    section.add "prettyPrint", valid_589306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589307: Call_MonitoringProjectsNotificationChannelDescriptorsList_589290;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ## 
  let valid = call_589307.validator(path, query, header, formData, body)
  let scheme = call_589307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589307.url(scheme.get, call_589307.host, call_589307.base,
                         call_589307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589307, url, valid)

proc call*(call_589308: Call_MonitoringProjectsNotificationChannelDescriptorsList_589290;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsNotificationChannelDescriptorsList
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The REST resource name of the parent from which to retrieve the notification channel descriptors. The expected syntax is:
  ## projects/[PROJECT_ID]
  ## Note that this names the parent container in which to look for the descriptors; to retrieve a single descriptor by name, use the GetNotificationChannelDescriptor operation, instead.
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
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589309 = newJObject()
  var query_589310 = newJObject()
  add(query_589310, "upload_protocol", newJString(uploadProtocol))
  add(query_589310, "fields", newJString(fields))
  add(query_589310, "pageToken", newJString(pageToken))
  add(query_589310, "quotaUser", newJString(quotaUser))
  add(path_589309, "name", newJString(name))
  add(query_589310, "alt", newJString(alt))
  add(query_589310, "oauth_token", newJString(oauthToken))
  add(query_589310, "callback", newJString(callback))
  add(query_589310, "access_token", newJString(accessToken))
  add(query_589310, "uploadType", newJString(uploadType))
  add(query_589310, "key", newJString(key))
  add(query_589310, "$.xgafv", newJString(Xgafv))
  add(query_589310, "pageSize", newJInt(pageSize))
  add(query_589310, "prettyPrint", newJBool(prettyPrint))
  result = call_589308.call(path_589309, query_589310, nil, nil, nil)

var monitoringProjectsNotificationChannelDescriptorsList* = Call_MonitoringProjectsNotificationChannelDescriptorsList_589290(
    name: "monitoringProjectsNotificationChannelDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannelDescriptors",
    validator: validate_MonitoringProjectsNotificationChannelDescriptorsList_589291,
    base: "/", url: url_MonitoringProjectsNotificationChannelDescriptorsList_589292,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsCreate_589334 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsNotificationChannelsCreate_589336(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notificationChannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsCreate_589335(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project on which to execute the request. The format is:
  ## projects/[PROJECT_ID]
  ## Note that this names the container into which the channel will be written. This does not name the newly created channel. The resulting channel's name will have a normalized version of this field as a prefix, but will add /notificationChannels/[CHANNEL_ID] to identify the channel.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589337 = path.getOrDefault("name")
  valid_589337 = validateParameter(valid_589337, JString, required = true,
                                 default = nil)
  if valid_589337 != nil:
    section.add "name", valid_589337
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
  var valid_589338 = query.getOrDefault("upload_protocol")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "upload_protocol", valid_589338
  var valid_589339 = query.getOrDefault("fields")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "fields", valid_589339
  var valid_589340 = query.getOrDefault("quotaUser")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "quotaUser", valid_589340
  var valid_589341 = query.getOrDefault("alt")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = newJString("json"))
  if valid_589341 != nil:
    section.add "alt", valid_589341
  var valid_589342 = query.getOrDefault("oauth_token")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "oauth_token", valid_589342
  var valid_589343 = query.getOrDefault("callback")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "callback", valid_589343
  var valid_589344 = query.getOrDefault("access_token")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "access_token", valid_589344
  var valid_589345 = query.getOrDefault("uploadType")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "uploadType", valid_589345
  var valid_589346 = query.getOrDefault("key")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "key", valid_589346
  var valid_589347 = query.getOrDefault("$.xgafv")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = newJString("1"))
  if valid_589347 != nil:
    section.add "$.xgafv", valid_589347
  var valid_589348 = query.getOrDefault("prettyPrint")
  valid_589348 = validateParameter(valid_589348, JBool, required = false,
                                 default = newJBool(true))
  if valid_589348 != nil:
    section.add "prettyPrint", valid_589348
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

proc call*(call_589350: Call_MonitoringProjectsNotificationChannelsCreate_589334;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
  ## 
  let valid = call_589350.validator(path, query, header, formData, body)
  let scheme = call_589350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589350.url(scheme.get, call_589350.host, call_589350.base,
                         call_589350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589350, url, valid)

proc call*(call_589351: Call_MonitoringProjectsNotificationChannelsCreate_589334;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsNotificationChannelsCreate
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is:
  ## projects/[PROJECT_ID]
  ## Note that this names the container into which the channel will be written. This does not name the newly created channel. The resulting channel's name will have a normalized version of this field as a prefix, but will add /notificationChannels/[CHANNEL_ID] to identify the channel.
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
  var path_589352 = newJObject()
  var query_589353 = newJObject()
  var body_589354 = newJObject()
  add(query_589353, "upload_protocol", newJString(uploadProtocol))
  add(query_589353, "fields", newJString(fields))
  add(query_589353, "quotaUser", newJString(quotaUser))
  add(path_589352, "name", newJString(name))
  add(query_589353, "alt", newJString(alt))
  add(query_589353, "oauth_token", newJString(oauthToken))
  add(query_589353, "callback", newJString(callback))
  add(query_589353, "access_token", newJString(accessToken))
  add(query_589353, "uploadType", newJString(uploadType))
  add(query_589353, "key", newJString(key))
  add(query_589353, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589354 = body
  add(query_589353, "prettyPrint", newJBool(prettyPrint))
  result = call_589351.call(path_589352, query_589353, nil, nil, body_589354)

var monitoringProjectsNotificationChannelsCreate* = Call_MonitoringProjectsNotificationChannelsCreate_589334(
    name: "monitoringProjectsNotificationChannelsCreate",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsCreate_589335,
    base: "/", url: url_MonitoringProjectsNotificationChannelsCreate_589336,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsList_589311 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsNotificationChannelsList_589313(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notificationChannels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsList_589312(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the notification channels that have been created for the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project on which to execute the request. The format is projects/[PROJECT_ID]. That is, this names the container in which to look for the notification channels; it does not name a specific channel. To query a specific channel by REST resource name, use the GetNotificationChannel operation.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589314 = path.getOrDefault("name")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "name", valid_589314
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
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
  ##   orderBy: JString
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of fields as in filter. Entries can be prefixed with a minus sign to sort in descending rather than ascending order.For more details, see sorting and filtering.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : If provided, this field specifies the criteria that must be met by notification channels to be included in the response.For more details, see sorting and filtering.
  section = newJObject()
  var valid_589315 = query.getOrDefault("upload_protocol")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "upload_protocol", valid_589315
  var valid_589316 = query.getOrDefault("fields")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "fields", valid_589316
  var valid_589317 = query.getOrDefault("pageToken")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "pageToken", valid_589317
  var valid_589318 = query.getOrDefault("quotaUser")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "quotaUser", valid_589318
  var valid_589319 = query.getOrDefault("alt")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = newJString("json"))
  if valid_589319 != nil:
    section.add "alt", valid_589319
  var valid_589320 = query.getOrDefault("oauth_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "oauth_token", valid_589320
  var valid_589321 = query.getOrDefault("callback")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "callback", valid_589321
  var valid_589322 = query.getOrDefault("access_token")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "access_token", valid_589322
  var valid_589323 = query.getOrDefault("uploadType")
  valid_589323 = validateParameter(valid_589323, JString, required = false,
                                 default = nil)
  if valid_589323 != nil:
    section.add "uploadType", valid_589323
  var valid_589324 = query.getOrDefault("orderBy")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "orderBy", valid_589324
  var valid_589325 = query.getOrDefault("key")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "key", valid_589325
  var valid_589326 = query.getOrDefault("$.xgafv")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = newJString("1"))
  if valid_589326 != nil:
    section.add "$.xgafv", valid_589326
  var valid_589327 = query.getOrDefault("pageSize")
  valid_589327 = validateParameter(valid_589327, JInt, required = false, default = nil)
  if valid_589327 != nil:
    section.add "pageSize", valid_589327
  var valid_589328 = query.getOrDefault("prettyPrint")
  valid_589328 = validateParameter(valid_589328, JBool, required = false,
                                 default = newJBool(true))
  if valid_589328 != nil:
    section.add "prettyPrint", valid_589328
  var valid_589329 = query.getOrDefault("filter")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "filter", valid_589329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589330: Call_MonitoringProjectsNotificationChannelsList_589311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the notification channels that have been created for the project.
  ## 
  let valid = call_589330.validator(path, query, header, formData, body)
  let scheme = call_589330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589330.url(scheme.get, call_589330.host, call_589330.base,
                         call_589330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589330, url, valid)

proc call*(call_589331: Call_MonitoringProjectsNotificationChannelsList_589311;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0; prettyPrint: bool = true;
          filter: string = ""): Recallable =
  ## monitoringProjectsNotificationChannelsList
  ## Lists the notification channels that have been created for the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is projects/[PROJECT_ID]. That is, this names the container in which to look for the notification channels; it does not name a specific channel. To query a specific channel by REST resource name, use the GetNotificationChannel operation.
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
  ##   orderBy: string
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of fields as in filter. Entries can be prefixed with a minus sign to sort in descending rather than ascending order.For more details, see sorting and filtering.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : If provided, this field specifies the criteria that must be met by notification channels to be included in the response.For more details, see sorting and filtering.
  var path_589332 = newJObject()
  var query_589333 = newJObject()
  add(query_589333, "upload_protocol", newJString(uploadProtocol))
  add(query_589333, "fields", newJString(fields))
  add(query_589333, "pageToken", newJString(pageToken))
  add(query_589333, "quotaUser", newJString(quotaUser))
  add(path_589332, "name", newJString(name))
  add(query_589333, "alt", newJString(alt))
  add(query_589333, "oauth_token", newJString(oauthToken))
  add(query_589333, "callback", newJString(callback))
  add(query_589333, "access_token", newJString(accessToken))
  add(query_589333, "uploadType", newJString(uploadType))
  add(query_589333, "orderBy", newJString(orderBy))
  add(query_589333, "key", newJString(key))
  add(query_589333, "$.xgafv", newJString(Xgafv))
  add(query_589333, "pageSize", newJInt(pageSize))
  add(query_589333, "prettyPrint", newJBool(prettyPrint))
  add(query_589333, "filter", newJString(filter))
  result = call_589331.call(path_589332, query_589333, nil, nil, nil)

var monitoringProjectsNotificationChannelsList* = Call_MonitoringProjectsNotificationChannelsList_589311(
    name: "monitoringProjectsNotificationChannelsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsList_589312,
    base: "/", url: url_MonitoringProjectsNotificationChannelsList_589313,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesCreate_589385 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsTimeSeriesCreate_589387(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/timeSeries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsTimeSeriesCreate_589386(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589388 = path.getOrDefault("name")
  valid_589388 = validateParameter(valid_589388, JString, required = true,
                                 default = nil)
  if valid_589388 != nil:
    section.add "name", valid_589388
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
  var valid_589389 = query.getOrDefault("upload_protocol")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "upload_protocol", valid_589389
  var valid_589390 = query.getOrDefault("fields")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "fields", valid_589390
  var valid_589391 = query.getOrDefault("quotaUser")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "quotaUser", valid_589391
  var valid_589392 = query.getOrDefault("alt")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = newJString("json"))
  if valid_589392 != nil:
    section.add "alt", valid_589392
  var valid_589393 = query.getOrDefault("oauth_token")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "oauth_token", valid_589393
  var valid_589394 = query.getOrDefault("callback")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "callback", valid_589394
  var valid_589395 = query.getOrDefault("access_token")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "access_token", valid_589395
  var valid_589396 = query.getOrDefault("uploadType")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "uploadType", valid_589396
  var valid_589397 = query.getOrDefault("key")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "key", valid_589397
  var valid_589398 = query.getOrDefault("$.xgafv")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = newJString("1"))
  if valid_589398 != nil:
    section.add "$.xgafv", valid_589398
  var valid_589399 = query.getOrDefault("prettyPrint")
  valid_589399 = validateParameter(valid_589399, JBool, required = false,
                                 default = newJBool(true))
  if valid_589399 != nil:
    section.add "prettyPrint", valid_589399
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

proc call*(call_589401: Call_MonitoringProjectsTimeSeriesCreate_589385;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
  ## 
  let valid = call_589401.validator(path, query, header, formData, body)
  let scheme = call_589401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589401.url(scheme.get, call_589401.host, call_589401.base,
                         call_589401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589401, url, valid)

proc call*(call_589402: Call_MonitoringProjectsTimeSeriesCreate_589385;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsTimeSeriesCreate
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
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
  var path_589403 = newJObject()
  var query_589404 = newJObject()
  var body_589405 = newJObject()
  add(query_589404, "upload_protocol", newJString(uploadProtocol))
  add(query_589404, "fields", newJString(fields))
  add(query_589404, "quotaUser", newJString(quotaUser))
  add(path_589403, "name", newJString(name))
  add(query_589404, "alt", newJString(alt))
  add(query_589404, "oauth_token", newJString(oauthToken))
  add(query_589404, "callback", newJString(callback))
  add(query_589404, "access_token", newJString(accessToken))
  add(query_589404, "uploadType", newJString(uploadType))
  add(query_589404, "key", newJString(key))
  add(query_589404, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589405 = body
  add(query_589404, "prettyPrint", newJBool(prettyPrint))
  result = call_589402.call(path_589403, query_589404, nil, nil, body_589405)

var monitoringProjectsTimeSeriesCreate* = Call_MonitoringProjectsTimeSeriesCreate_589385(
    name: "monitoringProjectsTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesCreate_589386, base: "/",
    url: url_MonitoringProjectsTimeSeriesCreate_589387, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesList_589355 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsTimeSeriesList_589357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/timeSeries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsTimeSeriesList_589356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589358 = path.getOrDefault("name")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "name", valid_589358
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Specifies which information is returned about the time series.
  ##   alt: JString
  ##      : Data format for response.
  ##   aggregation.alignmentPeriod: JString
  ##                              : The alignment period for per-time series alignment. If present, alignmentPeriod must be at least 60 seconds. After per-time series alignment, each time series will contain data points only on the period boundaries. If perSeriesAligner is not specified or equals ALIGN_NONE, then this field is ignored. If perSeriesAligner is specified and does not equal ALIGN_NONE, then this field must be defined; otherwise an error is returned.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   aggregation.crossSeriesReducer: JString
  ##                                 : The approach to be used to combine time series. Not all reducer functions may be applied to all time series, depending on the metric type and the value type of the original time series. Reduction may change the metric type of value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   interval.endTime: JString
  ##                   : Required. The end of the time interval.
  ##   orderBy: JString
  ##          : Unsupported: must be left blank. The points in each time series are returned in reverse time order.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : A positive number that is the maximum number of results to return. If page_size is empty or more than 100,000 results, the effective page_size is 100,000 results. If view is set to FULL, this is the maximum number of Points returned. If view is set to HEADERS, this is the maximum number of TimeSeries returned.
  ##   aggregation.perSeriesAligner: JString
  ##                               : The approach to be used to align individual time series. Not all alignment functions may be applied to all time series, depending on the metric type and value type of the original time series. Alignment may change the metric type or the value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   aggregation.groupByFields: JArray
  ##                            : The set of fields to preserve when crossSeriesReducer is specified. The groupByFields determine how the time series are partitioned into subsets prior to applying the aggregation function. Each subset contains time series that have the same value for each of the grouping fields. Each individual time series is a member of exactly one subset. The crossSeriesReducer is applied to each subset of time series. It is not possible to reduce across different resource types, so this field implicitly contains resource.type. Fields not specified in groupByFields are aggregated away. If groupByFields is not specified and all the time series have the same resource type, then the time series are aggregated into a single output time series. If crossSeriesReducer is not defined, this field is ignored.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   interval.startTime: JString
  ##                     : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  ##   filter: JString
  ##         : A monitoring filter that specifies which time series should be returned. The filter must specify a single metric type, and can additionally specify metric labels and other information. For example:
  ## metric.type = "compute.googleapis.com/instance/cpu/usage_time" AND
  ##     metric.labels.instance_name = "my-instance-name"
  ## 
  section = newJObject()
  var valid_589359 = query.getOrDefault("upload_protocol")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "upload_protocol", valid_589359
  var valid_589360 = query.getOrDefault("fields")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "fields", valid_589360
  var valid_589361 = query.getOrDefault("pageToken")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "pageToken", valid_589361
  var valid_589362 = query.getOrDefault("quotaUser")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "quotaUser", valid_589362
  var valid_589363 = query.getOrDefault("view")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = newJString("FULL"))
  if valid_589363 != nil:
    section.add "view", valid_589363
  var valid_589364 = query.getOrDefault("alt")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("json"))
  if valid_589364 != nil:
    section.add "alt", valid_589364
  var valid_589365 = query.getOrDefault("aggregation.alignmentPeriod")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "aggregation.alignmentPeriod", valid_589365
  var valid_589366 = query.getOrDefault("oauth_token")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "oauth_token", valid_589366
  var valid_589367 = query.getOrDefault("callback")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "callback", valid_589367
  var valid_589368 = query.getOrDefault("access_token")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "access_token", valid_589368
  var valid_589369 = query.getOrDefault("uploadType")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "uploadType", valid_589369
  var valid_589370 = query.getOrDefault("aggregation.crossSeriesReducer")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = newJString("REDUCE_NONE"))
  if valid_589370 != nil:
    section.add "aggregation.crossSeriesReducer", valid_589370
  var valid_589371 = query.getOrDefault("interval.endTime")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "interval.endTime", valid_589371
  var valid_589372 = query.getOrDefault("orderBy")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "orderBy", valid_589372
  var valid_589373 = query.getOrDefault("key")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "key", valid_589373
  var valid_589374 = query.getOrDefault("$.xgafv")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = newJString("1"))
  if valid_589374 != nil:
    section.add "$.xgafv", valid_589374
  var valid_589375 = query.getOrDefault("pageSize")
  valid_589375 = validateParameter(valid_589375, JInt, required = false, default = nil)
  if valid_589375 != nil:
    section.add "pageSize", valid_589375
  var valid_589376 = query.getOrDefault("aggregation.perSeriesAligner")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = newJString("ALIGN_NONE"))
  if valid_589376 != nil:
    section.add "aggregation.perSeriesAligner", valid_589376
  var valid_589377 = query.getOrDefault("aggregation.groupByFields")
  valid_589377 = validateParameter(valid_589377, JArray, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "aggregation.groupByFields", valid_589377
  var valid_589378 = query.getOrDefault("prettyPrint")
  valid_589378 = validateParameter(valid_589378, JBool, required = false,
                                 default = newJBool(true))
  if valid_589378 != nil:
    section.add "prettyPrint", valid_589378
  var valid_589379 = query.getOrDefault("interval.startTime")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "interval.startTime", valid_589379
  var valid_589380 = query.getOrDefault("filter")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "filter", valid_589380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589381: Call_MonitoringProjectsTimeSeriesList_589355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_589381.validator(path, query, header, formData, body)
  let scheme = call_589381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589381.url(scheme.get, call_589381.host, call_589381.base,
                         call_589381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589381, url, valid)

proc call*(call_589382: Call_MonitoringProjectsTimeSeriesList_589355; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; view: string = "FULL"; alt: string = "json";
          aggregationAlignmentPeriod: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          aggregationCrossSeriesReducer: string = "REDUCE_NONE";
          intervalEndTime: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0;
          aggregationPerSeriesAligner: string = "ALIGN_NONE";
          aggregationGroupByFields: JsonNode = nil; prettyPrint: bool = true;
          intervalStartTime: string = ""; filter: string = ""): Recallable =
  ## monitoringProjectsTimeSeriesList
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Specifies which information is returned about the time series.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  ##   alt: string
  ##      : Data format for response.
  ##   aggregationAlignmentPeriod: string
  ##                             : The alignment period for per-time series alignment. If present, alignmentPeriod must be at least 60 seconds. After per-time series alignment, each time series will contain data points only on the period boundaries. If perSeriesAligner is not specified or equals ALIGN_NONE, then this field is ignored. If perSeriesAligner is specified and does not equal ALIGN_NONE, then this field must be defined; otherwise an error is returned.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   aggregationCrossSeriesReducer: string
  ##                                : The approach to be used to combine time series. Not all reducer functions may be applied to all time series, depending on the metric type and the value type of the original time series. Reduction may change the metric type of value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   intervalEndTime: string
  ##                  : Required. The end of the time interval.
  ##   orderBy: string
  ##          : Unsupported: must be left blank. The points in each time series are returned in reverse time order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return. If page_size is empty or more than 100,000 results, the effective page_size is 100,000 results. If view is set to FULL, this is the maximum number of Points returned. If view is set to HEADERS, this is the maximum number of TimeSeries returned.
  ##   aggregationPerSeriesAligner: string
  ##                              : The approach to be used to align individual time series. Not all alignment functions may be applied to all time series, depending on the metric type and value type of the original time series. Alignment may change the metric type or the value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   aggregationGroupByFields: JArray
  ##                           : The set of fields to preserve when crossSeriesReducer is specified. The groupByFields determine how the time series are partitioned into subsets prior to applying the aggregation function. Each subset contains time series that have the same value for each of the grouping fields. Each individual time series is a member of exactly one subset. The crossSeriesReducer is applied to each subset of time series. It is not possible to reduce across different resource types, so this field implicitly contains resource.type. Fields not specified in groupByFields are aggregated away. If groupByFields is not specified and all the time series have the same resource type, then the time series are aggregated into a single output time series. If crossSeriesReducer is not defined, this field is ignored.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   intervalStartTime: string
  ##                    : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  ##   filter: string
  ##         : A monitoring filter that specifies which time series should be returned. The filter must specify a single metric type, and can additionally specify metric labels and other information. For example:
  ## metric.type = "compute.googleapis.com/instance/cpu/usage_time" AND
  ##     metric.labels.instance_name = "my-instance-name"
  ## 
  var path_589383 = newJObject()
  var query_589384 = newJObject()
  add(query_589384, "upload_protocol", newJString(uploadProtocol))
  add(query_589384, "fields", newJString(fields))
  add(query_589384, "pageToken", newJString(pageToken))
  add(query_589384, "quotaUser", newJString(quotaUser))
  add(query_589384, "view", newJString(view))
  add(path_589383, "name", newJString(name))
  add(query_589384, "alt", newJString(alt))
  add(query_589384, "aggregation.alignmentPeriod",
      newJString(aggregationAlignmentPeriod))
  add(query_589384, "oauth_token", newJString(oauthToken))
  add(query_589384, "callback", newJString(callback))
  add(query_589384, "access_token", newJString(accessToken))
  add(query_589384, "uploadType", newJString(uploadType))
  add(query_589384, "aggregation.crossSeriesReducer",
      newJString(aggregationCrossSeriesReducer))
  add(query_589384, "interval.endTime", newJString(intervalEndTime))
  add(query_589384, "orderBy", newJString(orderBy))
  add(query_589384, "key", newJString(key))
  add(query_589384, "$.xgafv", newJString(Xgafv))
  add(query_589384, "pageSize", newJInt(pageSize))
  add(query_589384, "aggregation.perSeriesAligner",
      newJString(aggregationPerSeriesAligner))
  if aggregationGroupByFields != nil:
    query_589384.add "aggregation.groupByFields", aggregationGroupByFields
  add(query_589384, "prettyPrint", newJBool(prettyPrint))
  add(query_589384, "interval.startTime", newJString(intervalStartTime))
  add(query_589384, "filter", newJString(filter))
  result = call_589382.call(path_589383, query_589384, nil, nil, nil)

var monitoringProjectsTimeSeriesList* = Call_MonitoringProjectsTimeSeriesList_589355(
    name: "monitoringProjectsTimeSeriesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesList_589356, base: "/",
    url: url_MonitoringProjectsTimeSeriesList_589357, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsGetVerificationCode_589406 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsNotificationChannelsGetVerificationCode_589408(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":getVerificationCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsGetVerificationCode_589407(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The notification channel for which a verification code is to be generated and retrieved. This must name a channel that is already verified; if the specified channel is not verified, the request will fail.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589409 = path.getOrDefault("name")
  valid_589409 = validateParameter(valid_589409, JString, required = true,
                                 default = nil)
  if valid_589409 != nil:
    section.add "name", valid_589409
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
  var valid_589410 = query.getOrDefault("upload_protocol")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "upload_protocol", valid_589410
  var valid_589411 = query.getOrDefault("fields")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "fields", valid_589411
  var valid_589412 = query.getOrDefault("quotaUser")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "quotaUser", valid_589412
  var valid_589413 = query.getOrDefault("alt")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = newJString("json"))
  if valid_589413 != nil:
    section.add "alt", valid_589413
  var valid_589414 = query.getOrDefault("oauth_token")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "oauth_token", valid_589414
  var valid_589415 = query.getOrDefault("callback")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "callback", valid_589415
  var valid_589416 = query.getOrDefault("access_token")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "access_token", valid_589416
  var valid_589417 = query.getOrDefault("uploadType")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "uploadType", valid_589417
  var valid_589418 = query.getOrDefault("key")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "key", valid_589418
  var valid_589419 = query.getOrDefault("$.xgafv")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = newJString("1"))
  if valid_589419 != nil:
    section.add "$.xgafv", valid_589419
  var valid_589420 = query.getOrDefault("prettyPrint")
  valid_589420 = validateParameter(valid_589420, JBool, required = false,
                                 default = newJBool(true))
  if valid_589420 != nil:
    section.add "prettyPrint", valid_589420
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

proc call*(call_589422: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_589406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
  ## 
  let valid = call_589422.validator(path, query, header, formData, body)
  let scheme = call_589422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589422.url(scheme.get, call_589422.host, call_589422.base,
                         call_589422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589422, url, valid)

proc call*(call_589423: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_589406;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsNotificationChannelsGetVerificationCode
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The notification channel for which a verification code is to be generated and retrieved. This must name a channel that is already verified; if the specified channel is not verified, the request will fail.
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
  var path_589424 = newJObject()
  var query_589425 = newJObject()
  var body_589426 = newJObject()
  add(query_589425, "upload_protocol", newJString(uploadProtocol))
  add(query_589425, "fields", newJString(fields))
  add(query_589425, "quotaUser", newJString(quotaUser))
  add(path_589424, "name", newJString(name))
  add(query_589425, "alt", newJString(alt))
  add(query_589425, "oauth_token", newJString(oauthToken))
  add(query_589425, "callback", newJString(callback))
  add(query_589425, "access_token", newJString(accessToken))
  add(query_589425, "uploadType", newJString(uploadType))
  add(query_589425, "key", newJString(key))
  add(query_589425, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589426 = body
  add(query_589425, "prettyPrint", newJBool(prettyPrint))
  result = call_589423.call(path_589424, query_589425, nil, nil, body_589426)

var monitoringProjectsNotificationChannelsGetVerificationCode* = Call_MonitoringProjectsNotificationChannelsGetVerificationCode_589406(
    name: "monitoringProjectsNotificationChannelsGetVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:getVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsGetVerificationCode_589407,
    base: "/", url: url_MonitoringProjectsNotificationChannelsGetVerificationCode_589408,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsSendVerificationCode_589427 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsNotificationChannelsSendVerificationCode_589429(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":sendVerificationCode")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsSendVerificationCode_589428(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The notification channel to which to send a verification code.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589430 = path.getOrDefault("name")
  valid_589430 = validateParameter(valid_589430, JString, required = true,
                                 default = nil)
  if valid_589430 != nil:
    section.add "name", valid_589430
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
  var valid_589431 = query.getOrDefault("upload_protocol")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "upload_protocol", valid_589431
  var valid_589432 = query.getOrDefault("fields")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "fields", valid_589432
  var valid_589433 = query.getOrDefault("quotaUser")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "quotaUser", valid_589433
  var valid_589434 = query.getOrDefault("alt")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = newJString("json"))
  if valid_589434 != nil:
    section.add "alt", valid_589434
  var valid_589435 = query.getOrDefault("oauth_token")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = nil)
  if valid_589435 != nil:
    section.add "oauth_token", valid_589435
  var valid_589436 = query.getOrDefault("callback")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "callback", valid_589436
  var valid_589437 = query.getOrDefault("access_token")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "access_token", valid_589437
  var valid_589438 = query.getOrDefault("uploadType")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "uploadType", valid_589438
  var valid_589439 = query.getOrDefault("key")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "key", valid_589439
  var valid_589440 = query.getOrDefault("$.xgafv")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = newJString("1"))
  if valid_589440 != nil:
    section.add "$.xgafv", valid_589440
  var valid_589441 = query.getOrDefault("prettyPrint")
  valid_589441 = validateParameter(valid_589441, JBool, required = false,
                                 default = newJBool(true))
  if valid_589441 != nil:
    section.add "prettyPrint", valid_589441
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

proc call*(call_589443: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_589427;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
  ## 
  let valid = call_589443.validator(path, query, header, formData, body)
  let scheme = call_589443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589443.url(scheme.get, call_589443.host, call_589443.base,
                         call_589443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589443, url, valid)

proc call*(call_589444: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_589427;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsNotificationChannelsSendVerificationCode
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The notification channel to which to send a verification code.
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
  var path_589445 = newJObject()
  var query_589446 = newJObject()
  var body_589447 = newJObject()
  add(query_589446, "upload_protocol", newJString(uploadProtocol))
  add(query_589446, "fields", newJString(fields))
  add(query_589446, "quotaUser", newJString(quotaUser))
  add(path_589445, "name", newJString(name))
  add(query_589446, "alt", newJString(alt))
  add(query_589446, "oauth_token", newJString(oauthToken))
  add(query_589446, "callback", newJString(callback))
  add(query_589446, "access_token", newJString(accessToken))
  add(query_589446, "uploadType", newJString(uploadType))
  add(query_589446, "key", newJString(key))
  add(query_589446, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589447 = body
  add(query_589446, "prettyPrint", newJBool(prettyPrint))
  result = call_589444.call(path_589445, query_589446, nil, nil, body_589447)

var monitoringProjectsNotificationChannelsSendVerificationCode* = Call_MonitoringProjectsNotificationChannelsSendVerificationCode_589427(
    name: "monitoringProjectsNotificationChannelsSendVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:sendVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsSendVerificationCode_589428,
    base: "/",
    url: url_MonitoringProjectsNotificationChannelsSendVerificationCode_589429,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsVerify_589448 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsNotificationChannelsVerify_589450(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":verify")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsVerify_589449(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The notification channel to verify.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589451 = path.getOrDefault("name")
  valid_589451 = validateParameter(valid_589451, JString, required = true,
                                 default = nil)
  if valid_589451 != nil:
    section.add "name", valid_589451
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
  var valid_589452 = query.getOrDefault("upload_protocol")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "upload_protocol", valid_589452
  var valid_589453 = query.getOrDefault("fields")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "fields", valid_589453
  var valid_589454 = query.getOrDefault("quotaUser")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "quotaUser", valid_589454
  var valid_589455 = query.getOrDefault("alt")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = newJString("json"))
  if valid_589455 != nil:
    section.add "alt", valid_589455
  var valid_589456 = query.getOrDefault("oauth_token")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "oauth_token", valid_589456
  var valid_589457 = query.getOrDefault("callback")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "callback", valid_589457
  var valid_589458 = query.getOrDefault("access_token")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "access_token", valid_589458
  var valid_589459 = query.getOrDefault("uploadType")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "uploadType", valid_589459
  var valid_589460 = query.getOrDefault("key")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "key", valid_589460
  var valid_589461 = query.getOrDefault("$.xgafv")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = newJString("1"))
  if valid_589461 != nil:
    section.add "$.xgafv", valid_589461
  var valid_589462 = query.getOrDefault("prettyPrint")
  valid_589462 = validateParameter(valid_589462, JBool, required = false,
                                 default = newJBool(true))
  if valid_589462 != nil:
    section.add "prettyPrint", valid_589462
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

proc call*(call_589464: Call_MonitoringProjectsNotificationChannelsVerify_589448;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
  ## 
  let valid = call_589464.validator(path, query, header, formData, body)
  let scheme = call_589464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589464.url(scheme.get, call_589464.host, call_589464.base,
                         call_589464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589464, url, valid)

proc call*(call_589465: Call_MonitoringProjectsNotificationChannelsVerify_589448;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsNotificationChannelsVerify
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The notification channel to verify.
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
  var path_589466 = newJObject()
  var query_589467 = newJObject()
  var body_589468 = newJObject()
  add(query_589467, "upload_protocol", newJString(uploadProtocol))
  add(query_589467, "fields", newJString(fields))
  add(query_589467, "quotaUser", newJString(quotaUser))
  add(path_589466, "name", newJString(name))
  add(query_589467, "alt", newJString(alt))
  add(query_589467, "oauth_token", newJString(oauthToken))
  add(query_589467, "callback", newJString(callback))
  add(query_589467, "access_token", newJString(accessToken))
  add(query_589467, "uploadType", newJString(uploadType))
  add(query_589467, "key", newJString(key))
  add(query_589467, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589468 = body
  add(query_589467, "prettyPrint", newJBool(prettyPrint))
  result = call_589465.call(path_589466, query_589467, nil, nil, body_589468)

var monitoringProjectsNotificationChannelsVerify* = Call_MonitoringProjectsNotificationChannelsVerify_589448(
    name: "monitoringProjectsNotificationChannelsVerify",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:verify",
    validator: validate_MonitoringProjectsNotificationChannelsVerify_589449,
    base: "/", url: url_MonitoringProjectsNotificationChannelsVerify_589450,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsCreate_589490 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsUptimeCheckConfigsCreate_589492(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/uptimeCheckConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsCreate_589491(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Uptime check configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project in which to create the Uptime check. The format  is projects/[PROJECT_ID].
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589493 = path.getOrDefault("parent")
  valid_589493 = validateParameter(valid_589493, JString, required = true,
                                 default = nil)
  if valid_589493 != nil:
    section.add "parent", valid_589493
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
  var valid_589494 = query.getOrDefault("upload_protocol")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "upload_protocol", valid_589494
  var valid_589495 = query.getOrDefault("fields")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "fields", valid_589495
  var valid_589496 = query.getOrDefault("quotaUser")
  valid_589496 = validateParameter(valid_589496, JString, required = false,
                                 default = nil)
  if valid_589496 != nil:
    section.add "quotaUser", valid_589496
  var valid_589497 = query.getOrDefault("alt")
  valid_589497 = validateParameter(valid_589497, JString, required = false,
                                 default = newJString("json"))
  if valid_589497 != nil:
    section.add "alt", valid_589497
  var valid_589498 = query.getOrDefault("oauth_token")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "oauth_token", valid_589498
  var valid_589499 = query.getOrDefault("callback")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "callback", valid_589499
  var valid_589500 = query.getOrDefault("access_token")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "access_token", valid_589500
  var valid_589501 = query.getOrDefault("uploadType")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "uploadType", valid_589501
  var valid_589502 = query.getOrDefault("key")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "key", valid_589502
  var valid_589503 = query.getOrDefault("$.xgafv")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = newJString("1"))
  if valid_589503 != nil:
    section.add "$.xgafv", valid_589503
  var valid_589504 = query.getOrDefault("prettyPrint")
  valid_589504 = validateParameter(valid_589504, JBool, required = false,
                                 default = newJBool(true))
  if valid_589504 != nil:
    section.add "prettyPrint", valid_589504
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

proc call*(call_589506: Call_MonitoringProjectsUptimeCheckConfigsCreate_589490;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Uptime check configuration.
  ## 
  let valid = call_589506.validator(path, query, header, formData, body)
  let scheme = call_589506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589506.url(scheme.get, call_589506.host, call_589506.base,
                         call_589506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589506, url, valid)

proc call*(call_589507: Call_MonitoringProjectsUptimeCheckConfigsCreate_589490;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsUptimeCheckConfigsCreate
  ## Creates a new Uptime check configuration.
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
  ##   parent: string (required)
  ##         : The project in which to create the Uptime check. The format  is projects/[PROJECT_ID].
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589508 = newJObject()
  var query_589509 = newJObject()
  var body_589510 = newJObject()
  add(query_589509, "upload_protocol", newJString(uploadProtocol))
  add(query_589509, "fields", newJString(fields))
  add(query_589509, "quotaUser", newJString(quotaUser))
  add(query_589509, "alt", newJString(alt))
  add(query_589509, "oauth_token", newJString(oauthToken))
  add(query_589509, "callback", newJString(callback))
  add(query_589509, "access_token", newJString(accessToken))
  add(query_589509, "uploadType", newJString(uploadType))
  add(path_589508, "parent", newJString(parent))
  add(query_589509, "key", newJString(key))
  add(query_589509, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589510 = body
  add(query_589509, "prettyPrint", newJBool(prettyPrint))
  result = call_589507.call(path_589508, query_589509, nil, nil, body_589510)

var monitoringProjectsUptimeCheckConfigsCreate* = Call_MonitoringProjectsUptimeCheckConfigsCreate_589490(
    name: "monitoringProjectsUptimeCheckConfigsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsCreate_589491,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsCreate_589492,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsList_589469 = ref object of OpenApiRestCall_588450
proc url_MonitoringProjectsUptimeCheckConfigsList_589471(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/uptimeCheckConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsList_589470(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project whose Uptime check configurations are listed. The format  is projects/[PROJECT_ID].
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589472 = path.getOrDefault("parent")
  valid_589472 = validateParameter(valid_589472, JString, required = true,
                                 default = nil)
  if valid_589472 != nil:
    section.add "parent", valid_589472
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
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
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589473 = query.getOrDefault("upload_protocol")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = nil)
  if valid_589473 != nil:
    section.add "upload_protocol", valid_589473
  var valid_589474 = query.getOrDefault("fields")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "fields", valid_589474
  var valid_589475 = query.getOrDefault("pageToken")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "pageToken", valid_589475
  var valid_589476 = query.getOrDefault("quotaUser")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "quotaUser", valid_589476
  var valid_589477 = query.getOrDefault("alt")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = newJString("json"))
  if valid_589477 != nil:
    section.add "alt", valid_589477
  var valid_589478 = query.getOrDefault("oauth_token")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "oauth_token", valid_589478
  var valid_589479 = query.getOrDefault("callback")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "callback", valid_589479
  var valid_589480 = query.getOrDefault("access_token")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "access_token", valid_589480
  var valid_589481 = query.getOrDefault("uploadType")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "uploadType", valid_589481
  var valid_589482 = query.getOrDefault("key")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "key", valid_589482
  var valid_589483 = query.getOrDefault("$.xgafv")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = newJString("1"))
  if valid_589483 != nil:
    section.add "$.xgafv", valid_589483
  var valid_589484 = query.getOrDefault("pageSize")
  valid_589484 = validateParameter(valid_589484, JInt, required = false, default = nil)
  if valid_589484 != nil:
    section.add "pageSize", valid_589484
  var valid_589485 = query.getOrDefault("prettyPrint")
  valid_589485 = validateParameter(valid_589485, JBool, required = false,
                                 default = newJBool(true))
  if valid_589485 != nil:
    section.add "prettyPrint", valid_589485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589486: Call_MonitoringProjectsUptimeCheckConfigsList_589469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ## 
  let valid = call_589486.validator(path, query, header, formData, body)
  let scheme = call_589486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589486.url(scheme.get, call_589486.host, call_589486.base,
                         call_589486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589486, url, valid)

proc call*(call_589487: Call_MonitoringProjectsUptimeCheckConfigsList_589469;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsUptimeCheckConfigsList
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
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
  ##   parent: string (required)
  ##         : The project whose Uptime check configurations are listed. The format  is projects/[PROJECT_ID].
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589488 = newJObject()
  var query_589489 = newJObject()
  add(query_589489, "upload_protocol", newJString(uploadProtocol))
  add(query_589489, "fields", newJString(fields))
  add(query_589489, "pageToken", newJString(pageToken))
  add(query_589489, "quotaUser", newJString(quotaUser))
  add(query_589489, "alt", newJString(alt))
  add(query_589489, "oauth_token", newJString(oauthToken))
  add(query_589489, "callback", newJString(callback))
  add(query_589489, "access_token", newJString(accessToken))
  add(query_589489, "uploadType", newJString(uploadType))
  add(path_589488, "parent", newJString(parent))
  add(query_589489, "key", newJString(key))
  add(query_589489, "$.xgafv", newJString(Xgafv))
  add(query_589489, "pageSize", newJInt(pageSize))
  add(query_589489, "prettyPrint", newJBool(prettyPrint))
  result = call_589487.call(path_589488, query_589489, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsList* = Call_MonitoringProjectsUptimeCheckConfigsList_589469(
    name: "monitoringProjectsUptimeCheckConfigsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsList_589470,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsList_589471,
    schemes: {Scheme.Https})
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
