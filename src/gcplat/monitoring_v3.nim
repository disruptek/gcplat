
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
  gcpServiceName = "monitoring"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MonitoringUptimeCheckIpsList_578619 = ref object of OpenApiRestCall_578348
proc url_MonitoringUptimeCheckIpsList_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MonitoringUptimeCheckIpsList_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of IP addresses that checkers run from
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
  ##   pageSize: JInt
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned. NOTE: this field is not yet implemented
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call. NOTE: this field is not yet implemented
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578733 = query.getOrDefault("key")
  valid_578733 = validateParameter(valid_578733, JString, required = false,
                                 default = nil)
  if valid_578733 != nil:
    section.add "key", valid_578733
  var valid_578747 = query.getOrDefault("prettyPrint")
  valid_578747 = validateParameter(valid_578747, JBool, required = false,
                                 default = newJBool(true))
  if valid_578747 != nil:
    section.add "prettyPrint", valid_578747
  var valid_578748 = query.getOrDefault("oauth_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "oauth_token", valid_578748
  var valid_578749 = query.getOrDefault("$.xgafv")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = newJString("1"))
  if valid_578749 != nil:
    section.add "$.xgafv", valid_578749
  var valid_578750 = query.getOrDefault("pageSize")
  valid_578750 = validateParameter(valid_578750, JInt, required = false, default = nil)
  if valid_578750 != nil:
    section.add "pageSize", valid_578750
  var valid_578751 = query.getOrDefault("alt")
  valid_578751 = validateParameter(valid_578751, JString, required = false,
                                 default = newJString("json"))
  if valid_578751 != nil:
    section.add "alt", valid_578751
  var valid_578752 = query.getOrDefault("uploadType")
  valid_578752 = validateParameter(valid_578752, JString, required = false,
                                 default = nil)
  if valid_578752 != nil:
    section.add "uploadType", valid_578752
  var valid_578753 = query.getOrDefault("quotaUser")
  valid_578753 = validateParameter(valid_578753, JString, required = false,
                                 default = nil)
  if valid_578753 != nil:
    section.add "quotaUser", valid_578753
  var valid_578754 = query.getOrDefault("pageToken")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "pageToken", valid_578754
  var valid_578755 = query.getOrDefault("callback")
  valid_578755 = validateParameter(valid_578755, JString, required = false,
                                 default = nil)
  if valid_578755 != nil:
    section.add "callback", valid_578755
  var valid_578756 = query.getOrDefault("fields")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = nil)
  if valid_578756 != nil:
    section.add "fields", valid_578756
  var valid_578757 = query.getOrDefault("access_token")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "access_token", valid_578757
  var valid_578758 = query.getOrDefault("upload_protocol")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "upload_protocol", valid_578758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578781: Call_MonitoringUptimeCheckIpsList_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of IP addresses that checkers run from
  ## 
  let valid = call_578781.validator(path, query, header, formData, body)
  let scheme = call_578781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578781.url(scheme.get, call_578781.host, call_578781.base,
                         call_578781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578781, url, valid)

proc call*(call_578852: Call_MonitoringUptimeCheckIpsList_578619; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringUptimeCheckIpsList
  ## Returns the list of IP addresses that checkers run from
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned. NOTE: this field is not yet implemented
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call. NOTE: this field is not yet implemented
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578853 = newJObject()
  add(query_578853, "key", newJString(key))
  add(query_578853, "prettyPrint", newJBool(prettyPrint))
  add(query_578853, "oauth_token", newJString(oauthToken))
  add(query_578853, "$.xgafv", newJString(Xgafv))
  add(query_578853, "pageSize", newJInt(pageSize))
  add(query_578853, "alt", newJString(alt))
  add(query_578853, "uploadType", newJString(uploadType))
  add(query_578853, "quotaUser", newJString(quotaUser))
  add(query_578853, "pageToken", newJString(pageToken))
  add(query_578853, "callback", newJString(callback))
  add(query_578853, "fields", newJString(fields))
  add(query_578853, "access_token", newJString(accessToken))
  add(query_578853, "upload_protocol", newJString(uploadProtocol))
  result = call_578852.call(nil, query_578853, nil, nil, nil)

var monitoringUptimeCheckIpsList* = Call_MonitoringUptimeCheckIpsList_578619(
    name: "monitoringUptimeCheckIpsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/uptimeCheckIps",
    validator: validate_MonitoringUptimeCheckIpsList_578620, base: "/",
    url: url_MonitoringUptimeCheckIpsList_578621, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsUpdate_578926 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsGroupsUpdate_578928(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsUpdate_578927(path: JsonNode;
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
  var valid_578929 = path.getOrDefault("name")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "name", valid_578929
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
  ##   validateOnly: JBool
  ##               : If true, validate this request but do not update the existing group.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("$.xgafv")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("1"))
  if valid_578933 != nil:
    section.add "$.xgafv", valid_578933
  var valid_578934 = query.getOrDefault("alt")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("json"))
  if valid_578934 != nil:
    section.add "alt", valid_578934
  var valid_578935 = query.getOrDefault("uploadType")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "uploadType", valid_578935
  var valid_578936 = query.getOrDefault("quotaUser")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "quotaUser", valid_578936
  var valid_578937 = query.getOrDefault("validateOnly")
  valid_578937 = validateParameter(valid_578937, JBool, required = false, default = nil)
  if valid_578937 != nil:
    section.add "validateOnly", valid_578937
  var valid_578938 = query.getOrDefault("callback")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "callback", valid_578938
  var valid_578939 = query.getOrDefault("fields")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "fields", valid_578939
  var valid_578940 = query.getOrDefault("access_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "access_token", valid_578940
  var valid_578941 = query.getOrDefault("upload_protocol")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "upload_protocol", valid_578941
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

proc call*(call_578943: Call_MonitoringProjectsGroupsUpdate_578926; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing group. You can change any group attributes except name.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_MonitoringProjectsGroupsUpdate_578926; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; validateOnly: bool = false; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsGroupsUpdate
  ## Updates an existing group. You can change any group attributes except name.
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
  ##   name: string (required)
  ##       : Output only. The name of this group. The format is "projects/{project_id_or_number}/groups/{group_id}". When creating a group, this field is ignored and a new name is created consisting of the project specified in the call to CreateGroup and a unique {group_id} that is generated automatically.
  ##   validateOnly: bool
  ##               : If true, validate this request but do not update the existing group.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  var body_578947 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "$.xgafv", newJString(Xgafv))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "uploadType", newJString(uploadType))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "name", newJString(name))
  add(query_578946, "validateOnly", newJBool(validateOnly))
  if body != nil:
    body_578947 = body
  add(query_578946, "callback", newJString(callback))
  add(query_578946, "fields", newJString(fields))
  add(query_578946, "access_token", newJString(accessToken))
  add(query_578946, "upload_protocol", newJString(uploadProtocol))
  result = call_578944.call(path_578945, query_578946, nil, nil, body_578947)

var monitoringProjectsGroupsUpdate* = Call_MonitoringProjectsGroupsUpdate_578926(
    name: "monitoringProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsGroupsUpdate_578927, base: "/",
    url: url_MonitoringProjectsGroupsUpdate_578928, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsGet_578893 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsUptimeCheckConfigsGet_578895(protocol: Scheme;
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

proc validate_MonitoringProjectsUptimeCheckConfigsGet_578894(path: JsonNode;
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
  var valid_578910 = path.getOrDefault("name")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "name", valid_578910
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
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_MonitoringProjectsUptimeCheckConfigsGet_578893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a single Uptime check configuration.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_MonitoringProjectsUptimeCheckConfigsGet_578893;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsUptimeCheckConfigsGet
  ## Gets a single Uptime check configuration.
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
  ##   name: string (required)
  ##       : The Uptime check configuration to retrieve. The format  is projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578924 = newJObject()
  var query_578925 = newJObject()
  add(query_578925, "key", newJString(key))
  add(query_578925, "prettyPrint", newJBool(prettyPrint))
  add(query_578925, "oauth_token", newJString(oauthToken))
  add(query_578925, "$.xgafv", newJString(Xgafv))
  add(query_578925, "alt", newJString(alt))
  add(query_578925, "uploadType", newJString(uploadType))
  add(query_578925, "quotaUser", newJString(quotaUser))
  add(path_578924, "name", newJString(name))
  add(query_578925, "callback", newJString(callback))
  add(query_578925, "fields", newJString(fields))
  add(query_578925, "access_token", newJString(accessToken))
  add(query_578925, "upload_protocol", newJString(uploadProtocol))
  result = call_578923.call(path_578924, query_578925, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsGet* = Call_MonitoringProjectsUptimeCheckConfigsGet_578893(
    name: "monitoringProjectsUptimeCheckConfigsGet", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsGet_578894, base: "/",
    url: url_MonitoringProjectsUptimeCheckConfigsGet_578895,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsPatch_578968 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsUptimeCheckConfigsPatch_578970(protocol: Scheme;
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

proc validate_MonitoringProjectsUptimeCheckConfigsPatch_578969(path: JsonNode;
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
  var valid_578971 = path.getOrDefault("name")
  valid_578971 = validateParameter(valid_578971, JString, required = true,
                                 default = nil)
  if valid_578971 != nil:
    section.add "name", valid_578971
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
  ##   updateMask: JString
  ##             : Optional. If present, only the listed fields in the current Uptime check configuration are updated with values from the new configuration. If this field is empty, then the current configuration is completely replaced with the new configuration.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578972 = query.getOrDefault("key")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "key", valid_578972
  var valid_578973 = query.getOrDefault("prettyPrint")
  valid_578973 = validateParameter(valid_578973, JBool, required = false,
                                 default = newJBool(true))
  if valid_578973 != nil:
    section.add "prettyPrint", valid_578973
  var valid_578974 = query.getOrDefault("oauth_token")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "oauth_token", valid_578974
  var valid_578975 = query.getOrDefault("$.xgafv")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = newJString("1"))
  if valid_578975 != nil:
    section.add "$.xgafv", valid_578975
  var valid_578976 = query.getOrDefault("alt")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("json"))
  if valid_578976 != nil:
    section.add "alt", valid_578976
  var valid_578977 = query.getOrDefault("uploadType")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "uploadType", valid_578977
  var valid_578978 = query.getOrDefault("quotaUser")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "quotaUser", valid_578978
  var valid_578979 = query.getOrDefault("updateMask")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "updateMask", valid_578979
  var valid_578980 = query.getOrDefault("callback")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "callback", valid_578980
  var valid_578981 = query.getOrDefault("fields")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "fields", valid_578981
  var valid_578982 = query.getOrDefault("access_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "access_token", valid_578982
  var valid_578983 = query.getOrDefault("upload_protocol")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "upload_protocol", valid_578983
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

proc call*(call_578985: Call_MonitoringProjectsUptimeCheckConfigsPatch_578968;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an Uptime check configuration. You can either replace the entire configuration with a new one or replace only certain fields in the current configuration by specifying the fields to be updated via updateMask. Returns the updated configuration.
  ## 
  let valid = call_578985.validator(path, query, header, formData, body)
  let scheme = call_578985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578985.url(scheme.get, call_578985.host, call_578985.base,
                         call_578985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578985, url, valid)

proc call*(call_578986: Call_MonitoringProjectsUptimeCheckConfigsPatch_578968;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsUptimeCheckConfigsPatch
  ## Updates an Uptime check configuration. You can either replace the entire configuration with a new one or replace only certain fields in the current configuration by specifying the fields to be updated via updateMask. Returns the updated configuration.
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
  ##   name: string (required)
  ##       : A unique resource name for this Uptime check configuration. The format is:projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].This field should be omitted when creating the Uptime check configuration; on create, the resource name is assigned by the server and included in the response.
  ##   updateMask: string
  ##             : Optional. If present, only the listed fields in the current Uptime check configuration are updated with values from the new configuration. If this field is empty, then the current configuration is completely replaced with the new configuration.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578987 = newJObject()
  var query_578988 = newJObject()
  var body_578989 = newJObject()
  add(query_578988, "key", newJString(key))
  add(query_578988, "prettyPrint", newJBool(prettyPrint))
  add(query_578988, "oauth_token", newJString(oauthToken))
  add(query_578988, "$.xgafv", newJString(Xgafv))
  add(query_578988, "alt", newJString(alt))
  add(query_578988, "uploadType", newJString(uploadType))
  add(query_578988, "quotaUser", newJString(quotaUser))
  add(path_578987, "name", newJString(name))
  add(query_578988, "updateMask", newJString(updateMask))
  if body != nil:
    body_578989 = body
  add(query_578988, "callback", newJString(callback))
  add(query_578988, "fields", newJString(fields))
  add(query_578988, "access_token", newJString(accessToken))
  add(query_578988, "upload_protocol", newJString(uploadProtocol))
  result = call_578986.call(path_578987, query_578988, nil, nil, body_578989)

var monitoringProjectsUptimeCheckConfigsPatch* = Call_MonitoringProjectsUptimeCheckConfigsPatch_578968(
    name: "monitoringProjectsUptimeCheckConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsPatch_578969,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsPatch_578970,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsDelete_578948 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsUptimeCheckConfigsDelete_578950(protocol: Scheme;
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

proc validate_MonitoringProjectsUptimeCheckConfigsDelete_578949(path: JsonNode;
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
  var valid_578951 = path.getOrDefault("name")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "name", valid_578951
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
  ##   force: JBool
  ##        : If true, the notification channel will be deleted regardless of its use in alert policies (the policies will be updated to remove the channel). If false, channels that are still referenced by an existing alerting policy will fail to be deleted in a delete operation.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("$.xgafv")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("1"))
  if valid_578955 != nil:
    section.add "$.xgafv", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("force")
  valid_578959 = validateParameter(valid_578959, JBool, required = false, default = nil)
  if valid_578959 != nil:
    section.add "force", valid_578959
  var valid_578960 = query.getOrDefault("callback")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "callback", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
  var valid_578962 = query.getOrDefault("access_token")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "access_token", valid_578962
  var valid_578963 = query.getOrDefault("upload_protocol")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "upload_protocol", valid_578963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578964: Call_MonitoringProjectsUptimeCheckConfigsDelete_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an Uptime check configuration. Note that this method will fail if the Uptime check configuration is referenced by an alert policy or other dependent configs that would be rendered invalid by the deletion.
  ## 
  let valid = call_578964.validator(path, query, header, formData, body)
  let scheme = call_578964.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578964.url(scheme.get, call_578964.host, call_578964.base,
                         call_578964.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578964, url, valid)

proc call*(call_578965: Call_MonitoringProjectsUptimeCheckConfigsDelete_578948;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; force: bool = false;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsUptimeCheckConfigsDelete
  ## Deletes an Uptime check configuration. Note that this method will fail if the Uptime check configuration is referenced by an alert policy or other dependent configs that would be rendered invalid by the deletion.
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
  ##   name: string (required)
  ##       : The Uptime check configuration to delete. The format  is projects/[PROJECT_ID]/uptimeCheckConfigs/[UPTIME_CHECK_ID].
  ##   force: bool
  ##        : If true, the notification channel will be deleted regardless of its use in alert policies (the policies will be updated to remove the channel). If false, channels that are still referenced by an existing alerting policy will fail to be deleted in a delete operation.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578966 = newJObject()
  var query_578967 = newJObject()
  add(query_578967, "key", newJString(key))
  add(query_578967, "prettyPrint", newJBool(prettyPrint))
  add(query_578967, "oauth_token", newJString(oauthToken))
  add(query_578967, "$.xgafv", newJString(Xgafv))
  add(query_578967, "alt", newJString(alt))
  add(query_578967, "uploadType", newJString(uploadType))
  add(query_578967, "quotaUser", newJString(quotaUser))
  add(path_578966, "name", newJString(name))
  add(query_578967, "force", newJBool(force))
  add(query_578967, "callback", newJString(callback))
  add(query_578967, "fields", newJString(fields))
  add(query_578967, "access_token", newJString(accessToken))
  add(query_578967, "upload_protocol", newJString(uploadProtocol))
  result = call_578965.call(path_578966, query_578967, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsDelete* = Call_MonitoringProjectsUptimeCheckConfigsDelete_578948(
    name: "monitoringProjectsUptimeCheckConfigsDelete",
    meth: HttpMethod.HttpDelete, host: "monitoring.googleapis.com",
    route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsDelete_578949,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsDelete_578950,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesCreate_579013 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsAlertPoliciesCreate_579015(protocol: Scheme;
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

proc validate_MonitoringProjectsAlertPoliciesCreate_579014(path: JsonNode;
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
  var valid_579016 = path.getOrDefault("name")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "name", valid_579016
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
  var valid_579021 = query.getOrDefault("alt")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("json"))
  if valid_579021 != nil:
    section.add "alt", valid_579021
  var valid_579022 = query.getOrDefault("uploadType")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "uploadType", valid_579022
  var valid_579023 = query.getOrDefault("quotaUser")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "quotaUser", valid_579023
  var valid_579024 = query.getOrDefault("callback")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "callback", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
  var valid_579026 = query.getOrDefault("access_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "access_token", valid_579026
  var valid_579027 = query.getOrDefault("upload_protocol")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "upload_protocol", valid_579027
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

proc call*(call_579029: Call_MonitoringProjectsAlertPoliciesCreate_579013;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new alerting policy.
  ## 
  let valid = call_579029.validator(path, query, header, formData, body)
  let scheme = call_579029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579029.url(scheme.get, call_579029.host, call_579029.base,
                         call_579029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579029, url, valid)

proc call*(call_579030: Call_MonitoringProjectsAlertPoliciesCreate_579013;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsAlertPoliciesCreate
  ## Creates a new alerting policy.
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
  ##   name: string (required)
  ##       : The project in which to create the alerting policy. The format is projects/[PROJECT_ID].Note that this field names the parent container in which the alerting policy will be written, not the name of the created policy. The alerting policy that is returned will have a name that contains a normalized representation of this name as a prefix but adds a suffix of the form /alertPolicies/[POLICY_ID], identifying the policy in the container.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579031 = newJObject()
  var query_579032 = newJObject()
  var body_579033 = newJObject()
  add(query_579032, "key", newJString(key))
  add(query_579032, "prettyPrint", newJBool(prettyPrint))
  add(query_579032, "oauth_token", newJString(oauthToken))
  add(query_579032, "$.xgafv", newJString(Xgafv))
  add(query_579032, "alt", newJString(alt))
  add(query_579032, "uploadType", newJString(uploadType))
  add(query_579032, "quotaUser", newJString(quotaUser))
  add(path_579031, "name", newJString(name))
  if body != nil:
    body_579033 = body
  add(query_579032, "callback", newJString(callback))
  add(query_579032, "fields", newJString(fields))
  add(query_579032, "access_token", newJString(accessToken))
  add(query_579032, "upload_protocol", newJString(uploadProtocol))
  result = call_579030.call(path_579031, query_579032, nil, nil, body_579033)

var monitoringProjectsAlertPoliciesCreate* = Call_MonitoringProjectsAlertPoliciesCreate_579013(
    name: "monitoringProjectsAlertPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesCreate_579014, base: "/",
    url: url_MonitoringProjectsAlertPoliciesCreate_579015, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesList_578990 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsAlertPoliciesList_578992(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsAlertPoliciesList_578991(path: JsonNode;
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
  var valid_578993 = path.getOrDefault("name")
  valid_578993 = validateParameter(valid_578993, JString, required = true,
                                 default = nil)
  if valid_578993 != nil:
    section.add "name", valid_578993
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
  ##           : The maximum number of results to return in a single response.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of field references as the filter field. Entries can be prefixed with a minus sign to sort by the field in descending order.For more details, see sorting and filtering.
  ##   filter: JString
  ##         : If provided, this field specifies the criteria that must be met by alert policies to be included in the response.For more details, see sorting and filtering.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578994 = query.getOrDefault("key")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "key", valid_578994
  var valid_578995 = query.getOrDefault("prettyPrint")
  valid_578995 = validateParameter(valid_578995, JBool, required = false,
                                 default = newJBool(true))
  if valid_578995 != nil:
    section.add "prettyPrint", valid_578995
  var valid_578996 = query.getOrDefault("oauth_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "oauth_token", valid_578996
  var valid_578997 = query.getOrDefault("$.xgafv")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("1"))
  if valid_578997 != nil:
    section.add "$.xgafv", valid_578997
  var valid_578998 = query.getOrDefault("pageSize")
  valid_578998 = validateParameter(valid_578998, JInt, required = false, default = nil)
  if valid_578998 != nil:
    section.add "pageSize", valid_578998
  var valid_578999 = query.getOrDefault("alt")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = newJString("json"))
  if valid_578999 != nil:
    section.add "alt", valid_578999
  var valid_579000 = query.getOrDefault("uploadType")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "uploadType", valid_579000
  var valid_579001 = query.getOrDefault("quotaUser")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "quotaUser", valid_579001
  var valid_579002 = query.getOrDefault("orderBy")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "orderBy", valid_579002
  var valid_579003 = query.getOrDefault("filter")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "filter", valid_579003
  var valid_579004 = query.getOrDefault("pageToken")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "pageToken", valid_579004
  var valid_579005 = query.getOrDefault("callback")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "callback", valid_579005
  var valid_579006 = query.getOrDefault("fields")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "fields", valid_579006
  var valid_579007 = query.getOrDefault("access_token")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "access_token", valid_579007
  var valid_579008 = query.getOrDefault("upload_protocol")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "upload_protocol", valid_579008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579009: Call_MonitoringProjectsAlertPoliciesList_578990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing alerting policies for the project.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_MonitoringProjectsAlertPoliciesList_578990;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsAlertPoliciesList
  ## Lists the existing alerting policies for the project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project whose alert policies are to be listed. The format is
  ## projects/[PROJECT_ID]
  ## Note that this field names the parent container in which the alerting policies to be listed are stored. To retrieve a single alerting policy by name, use the GetAlertPolicy operation, instead.
  ##   orderBy: string
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of field references as the filter field. Entries can be prefixed with a minus sign to sort by the field in descending order.For more details, see sorting and filtering.
  ##   filter: string
  ##         : If provided, this field specifies the criteria that must be met by alert policies to be included in the response.For more details, see sorting and filtering.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579011 = newJObject()
  var query_579012 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "$.xgafv", newJString(Xgafv))
  add(query_579012, "pageSize", newJInt(pageSize))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "uploadType", newJString(uploadType))
  add(query_579012, "quotaUser", newJString(quotaUser))
  add(path_579011, "name", newJString(name))
  add(query_579012, "orderBy", newJString(orderBy))
  add(query_579012, "filter", newJString(filter))
  add(query_579012, "pageToken", newJString(pageToken))
  add(query_579012, "callback", newJString(callback))
  add(query_579012, "fields", newJString(fields))
  add(query_579012, "access_token", newJString(accessToken))
  add(query_579012, "upload_protocol", newJString(uploadProtocol))
  result = call_579010.call(path_579011, query_579012, nil, nil, nil)

var monitoringProjectsAlertPoliciesList* = Call_MonitoringProjectsAlertPoliciesList_578990(
    name: "monitoringProjectsAlertPoliciesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesList_578991, base: "/",
    url: url_MonitoringProjectsAlertPoliciesList_578992, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsCollectdTimeSeriesCreate_579034 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsCollectdTimeSeriesCreate_579036(protocol: Scheme;
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

proc validate_MonitoringProjectsCollectdTimeSeriesCreate_579035(path: JsonNode;
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
  var valid_579037 = path.getOrDefault("name")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "name", valid_579037
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

proc call*(call_579050: Call_MonitoringProjectsCollectdTimeSeriesCreate_579034;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
  ## 
  let valid = call_579050.validator(path, query, header, formData, body)
  let scheme = call_579050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579050.url(scheme.get, call_579050.host, call_579050.base,
                         call_579050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579050, url, valid)

proc call*(call_579051: Call_MonitoringProjectsCollectdTimeSeriesCreate_579034;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsCollectdTimeSeriesCreate
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
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
  ##   name: string (required)
  ##       : The project in which to create the time series. The format is "projects/PROJECT_ID_OR_NUMBER".
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
  add(path_579052, "name", newJString(name))
  if body != nil:
    body_579054 = body
  add(query_579053, "callback", newJString(callback))
  add(query_579053, "fields", newJString(fields))
  add(query_579053, "access_token", newJString(accessToken))
  add(query_579053, "upload_protocol", newJString(uploadProtocol))
  result = call_579051.call(path_579052, query_579053, nil, nil, body_579054)

var monitoringProjectsCollectdTimeSeriesCreate* = Call_MonitoringProjectsCollectdTimeSeriesCreate_579034(
    name: "monitoringProjectsCollectdTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/collectdTimeSeries",
    validator: validate_MonitoringProjectsCollectdTimeSeriesCreate_579035,
    base: "/", url: url_MonitoringProjectsCollectdTimeSeriesCreate_579036,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsCreate_579079 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsGroupsCreate_579081(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsCreate_579080(path: JsonNode;
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
  var valid_579082 = path.getOrDefault("name")
  valid_579082 = validateParameter(valid_579082, JString, required = true,
                                 default = nil)
  if valid_579082 != nil:
    section.add "name", valid_579082
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
  ##   validateOnly: JBool
  ##               : If true, validate this request but do not create the group.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579083 = query.getOrDefault("key")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "key", valid_579083
  var valid_579084 = query.getOrDefault("prettyPrint")
  valid_579084 = validateParameter(valid_579084, JBool, required = false,
                                 default = newJBool(true))
  if valid_579084 != nil:
    section.add "prettyPrint", valid_579084
  var valid_579085 = query.getOrDefault("oauth_token")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "oauth_token", valid_579085
  var valid_579086 = query.getOrDefault("$.xgafv")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = newJString("1"))
  if valid_579086 != nil:
    section.add "$.xgafv", valid_579086
  var valid_579087 = query.getOrDefault("alt")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = newJString("json"))
  if valid_579087 != nil:
    section.add "alt", valid_579087
  var valid_579088 = query.getOrDefault("uploadType")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "uploadType", valid_579088
  var valid_579089 = query.getOrDefault("quotaUser")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "quotaUser", valid_579089
  var valid_579090 = query.getOrDefault("validateOnly")
  valid_579090 = validateParameter(valid_579090, JBool, required = false, default = nil)
  if valid_579090 != nil:
    section.add "validateOnly", valid_579090
  var valid_579091 = query.getOrDefault("callback")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "callback", valid_579091
  var valid_579092 = query.getOrDefault("fields")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "fields", valid_579092
  var valid_579093 = query.getOrDefault("access_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "access_token", valid_579093
  var valid_579094 = query.getOrDefault("upload_protocol")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = nil)
  if valid_579094 != nil:
    section.add "upload_protocol", valid_579094
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

proc call*(call_579096: Call_MonitoringProjectsGroupsCreate_579079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new group.
  ## 
  let valid = call_579096.validator(path, query, header, formData, body)
  let scheme = call_579096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579096.url(scheme.get, call_579096.host, call_579096.base,
                         call_579096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579096, url, valid)

proc call*(call_579097: Call_MonitoringProjectsGroupsCreate_579079; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; validateOnly: bool = false; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsGroupsCreate
  ## Creates a new group.
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
  ##   name: string (required)
  ##       : The project in which to create the group. The format is "projects/{project_id_or_number}".
  ##   validateOnly: bool
  ##               : If true, validate this request but do not create the group.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579098 = newJObject()
  var query_579099 = newJObject()
  var body_579100 = newJObject()
  add(query_579099, "key", newJString(key))
  add(query_579099, "prettyPrint", newJBool(prettyPrint))
  add(query_579099, "oauth_token", newJString(oauthToken))
  add(query_579099, "$.xgafv", newJString(Xgafv))
  add(query_579099, "alt", newJString(alt))
  add(query_579099, "uploadType", newJString(uploadType))
  add(query_579099, "quotaUser", newJString(quotaUser))
  add(path_579098, "name", newJString(name))
  add(query_579099, "validateOnly", newJBool(validateOnly))
  if body != nil:
    body_579100 = body
  add(query_579099, "callback", newJString(callback))
  add(query_579099, "fields", newJString(fields))
  add(query_579099, "access_token", newJString(accessToken))
  add(query_579099, "upload_protocol", newJString(uploadProtocol))
  result = call_579097.call(path_579098, query_579099, nil, nil, body_579100)

var monitoringProjectsGroupsCreate* = Call_MonitoringProjectsGroupsCreate_579079(
    name: "monitoringProjectsGroupsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsCreate_579080, base: "/",
    url: url_MonitoringProjectsGroupsCreate_579081, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsList_579055 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsGroupsList_579057(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsList_579056(path: JsonNode; query: JsonNode;
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
  var valid_579058 = path.getOrDefault("name")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "name", valid_579058
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
  ##           : A positive number that is the maximum number of results to return.
  ##   descendantsOfGroup: JString
  ##                     : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns the descendants of the specified group. This is a superset of the results returned by the childrenOfGroup filter, and includes children-of-children, and so forth.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   childrenOfGroup: JString
  ##                  : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups whose parentName field contains the group name. If no groups have this parent, the results are empty.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   ancestorsOfGroup: JString
  ##                   : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups that are ancestors of the specified group. The groups are returned in order, starting with the immediate parent and ending with the most distant ancestor. If the specified group has no immediate parent, the results are empty.
  section = newJObject()
  var valid_579059 = query.getOrDefault("key")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "key", valid_579059
  var valid_579060 = query.getOrDefault("prettyPrint")
  valid_579060 = validateParameter(valid_579060, JBool, required = false,
                                 default = newJBool(true))
  if valid_579060 != nil:
    section.add "prettyPrint", valid_579060
  var valid_579061 = query.getOrDefault("oauth_token")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "oauth_token", valid_579061
  var valid_579062 = query.getOrDefault("$.xgafv")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("1"))
  if valid_579062 != nil:
    section.add "$.xgafv", valid_579062
  var valid_579063 = query.getOrDefault("pageSize")
  valid_579063 = validateParameter(valid_579063, JInt, required = false, default = nil)
  if valid_579063 != nil:
    section.add "pageSize", valid_579063
  var valid_579064 = query.getOrDefault("descendantsOfGroup")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "descendantsOfGroup", valid_579064
  var valid_579065 = query.getOrDefault("alt")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = newJString("json"))
  if valid_579065 != nil:
    section.add "alt", valid_579065
  var valid_579066 = query.getOrDefault("uploadType")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "uploadType", valid_579066
  var valid_579067 = query.getOrDefault("quotaUser")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "quotaUser", valid_579067
  var valid_579068 = query.getOrDefault("pageToken")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "pageToken", valid_579068
  var valid_579069 = query.getOrDefault("childrenOfGroup")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "childrenOfGroup", valid_579069
  var valid_579070 = query.getOrDefault("callback")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "callback", valid_579070
  var valid_579071 = query.getOrDefault("fields")
  valid_579071 = validateParameter(valid_579071, JString, required = false,
                                 default = nil)
  if valid_579071 != nil:
    section.add "fields", valid_579071
  var valid_579072 = query.getOrDefault("access_token")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = nil)
  if valid_579072 != nil:
    section.add "access_token", valid_579072
  var valid_579073 = query.getOrDefault("upload_protocol")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "upload_protocol", valid_579073
  var valid_579074 = query.getOrDefault("ancestorsOfGroup")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "ancestorsOfGroup", valid_579074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579075: Call_MonitoringProjectsGroupsList_579055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing groups.
  ## 
  let valid = call_579075.validator(path, query, header, formData, body)
  let scheme = call_579075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579075.url(scheme.get, call_579075.host, call_579075.base,
                         call_579075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579075, url, valid)

proc call*(call_579076: Call_MonitoringProjectsGroupsList_579055; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; descendantsOfGroup: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; childrenOfGroup: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          ancestorsOfGroup: string = ""): Recallable =
  ## monitoringProjectsGroupsList
  ## Lists the existing groups.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   descendantsOfGroup: string
  ##                     : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns the descendants of the specified group. This is a superset of the results returned by the childrenOfGroup filter, and includes children-of-children, and so forth.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project whose groups are to be listed. The format is "projects/{project_id_or_number}".
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   childrenOfGroup: string
  ##                  : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups whose parentName field contains the group name. If no groups have this parent, the results are empty.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   ancestorsOfGroup: string
  ##                   : A group name: "projects/{project_id_or_number}/groups/{group_id}". Returns groups that are ancestors of the specified group. The groups are returned in order, starting with the immediate parent and ending with the most distant ancestor. If the specified group has no immediate parent, the results are empty.
  var path_579077 = newJObject()
  var query_579078 = newJObject()
  add(query_579078, "key", newJString(key))
  add(query_579078, "prettyPrint", newJBool(prettyPrint))
  add(query_579078, "oauth_token", newJString(oauthToken))
  add(query_579078, "$.xgafv", newJString(Xgafv))
  add(query_579078, "pageSize", newJInt(pageSize))
  add(query_579078, "descendantsOfGroup", newJString(descendantsOfGroup))
  add(query_579078, "alt", newJString(alt))
  add(query_579078, "uploadType", newJString(uploadType))
  add(query_579078, "quotaUser", newJString(quotaUser))
  add(path_579077, "name", newJString(name))
  add(query_579078, "pageToken", newJString(pageToken))
  add(query_579078, "childrenOfGroup", newJString(childrenOfGroup))
  add(query_579078, "callback", newJString(callback))
  add(query_579078, "fields", newJString(fields))
  add(query_579078, "access_token", newJString(accessToken))
  add(query_579078, "upload_protocol", newJString(uploadProtocol))
  add(query_579078, "ancestorsOfGroup", newJString(ancestorsOfGroup))
  result = call_579076.call(path_579077, query_579078, nil, nil, nil)

var monitoringProjectsGroupsList* = Call_MonitoringProjectsGroupsList_579055(
    name: "monitoringProjectsGroupsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsList_579056, base: "/",
    url: url_MonitoringProjectsGroupsList_579057, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsMembersList_579101 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsGroupsMembersList_579103(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsMembersList_579102(path: JsonNode;
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
  var valid_579104 = path.getOrDefault("name")
  valid_579104 = validateParameter(valid_579104, JString, required = true,
                                 default = nil)
  if valid_579104 != nil:
    section.add "name", valid_579104
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
  ##           : A positive number that is the maximum number of results to return.
  ##   interval.endTime: JString
  ##                   : Required. The end of the time interval.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : An optional list filter describing the members to be returned. The filter may reference the type, labels, and metadata of monitored resources that comprise the group. For example, to return only resources representing Compute Engine VM instances, use this filter:
  ## resource.type = "gce_instance"
  ## 
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   interval.startTime: JString
  ##                     : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  section = newJObject()
  var valid_579105 = query.getOrDefault("key")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "key", valid_579105
  var valid_579106 = query.getOrDefault("prettyPrint")
  valid_579106 = validateParameter(valid_579106, JBool, required = false,
                                 default = newJBool(true))
  if valid_579106 != nil:
    section.add "prettyPrint", valid_579106
  var valid_579107 = query.getOrDefault("oauth_token")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "oauth_token", valid_579107
  var valid_579108 = query.getOrDefault("$.xgafv")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = newJString("1"))
  if valid_579108 != nil:
    section.add "$.xgafv", valid_579108
  var valid_579109 = query.getOrDefault("pageSize")
  valid_579109 = validateParameter(valid_579109, JInt, required = false, default = nil)
  if valid_579109 != nil:
    section.add "pageSize", valid_579109
  var valid_579110 = query.getOrDefault("interval.endTime")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "interval.endTime", valid_579110
  var valid_579111 = query.getOrDefault("alt")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = newJString("json"))
  if valid_579111 != nil:
    section.add "alt", valid_579111
  var valid_579112 = query.getOrDefault("uploadType")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "uploadType", valid_579112
  var valid_579113 = query.getOrDefault("quotaUser")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "quotaUser", valid_579113
  var valid_579114 = query.getOrDefault("filter")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "filter", valid_579114
  var valid_579115 = query.getOrDefault("pageToken")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "pageToken", valid_579115
  var valid_579116 = query.getOrDefault("callback")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "callback", valid_579116
  var valid_579117 = query.getOrDefault("fields")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "fields", valid_579117
  var valid_579118 = query.getOrDefault("access_token")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "access_token", valid_579118
  var valid_579119 = query.getOrDefault("upload_protocol")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "upload_protocol", valid_579119
  var valid_579120 = query.getOrDefault("interval.startTime")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "interval.startTime", valid_579120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579121: Call_MonitoringProjectsGroupsMembersList_579101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the monitored resources that are members of a group.
  ## 
  let valid = call_579121.validator(path, query, header, formData, body)
  let scheme = call_579121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579121.url(scheme.get, call_579121.host, call_579121.base,
                         call_579121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579121, url, valid)

proc call*(call_579122: Call_MonitoringProjectsGroupsMembersList_579101;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          intervalEndTime: string = ""; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""; intervalStartTime: string = ""): Recallable =
  ## monitoringProjectsGroupsMembersList
  ## Lists the monitored resources that are members of a group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   intervalEndTime: string
  ##                  : Required. The end of the time interval.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The group whose members are listed. The format is "projects/{project_id_or_number}/groups/{group_id}".
  ##   filter: string
  ##         : An optional list filter describing the members to be returned. The filter may reference the type, labels, and metadata of monitored resources that comprise the group. For example, to return only resources representing Compute Engine VM instances, use this filter:
  ## resource.type = "gce_instance"
  ## 
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   intervalStartTime: string
  ##                    : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  var path_579123 = newJObject()
  var query_579124 = newJObject()
  add(query_579124, "key", newJString(key))
  add(query_579124, "prettyPrint", newJBool(prettyPrint))
  add(query_579124, "oauth_token", newJString(oauthToken))
  add(query_579124, "$.xgafv", newJString(Xgafv))
  add(query_579124, "pageSize", newJInt(pageSize))
  add(query_579124, "interval.endTime", newJString(intervalEndTime))
  add(query_579124, "alt", newJString(alt))
  add(query_579124, "uploadType", newJString(uploadType))
  add(query_579124, "quotaUser", newJString(quotaUser))
  add(path_579123, "name", newJString(name))
  add(query_579124, "filter", newJString(filter))
  add(query_579124, "pageToken", newJString(pageToken))
  add(query_579124, "callback", newJString(callback))
  add(query_579124, "fields", newJString(fields))
  add(query_579124, "access_token", newJString(accessToken))
  add(query_579124, "upload_protocol", newJString(uploadProtocol))
  add(query_579124, "interval.startTime", newJString(intervalStartTime))
  result = call_579122.call(path_579123, query_579124, nil, nil, nil)

var monitoringProjectsGroupsMembersList* = Call_MonitoringProjectsGroupsMembersList_579101(
    name: "monitoringProjectsGroupsMembersList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/members",
    validator: validate_MonitoringProjectsGroupsMembersList_579102, base: "/",
    url: url_MonitoringProjectsGroupsMembersList_579103, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsCreate_579147 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsMetricDescriptorsCreate_579149(protocol: Scheme;
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

proc validate_MonitoringProjectsMetricDescriptorsCreate_579148(path: JsonNode;
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
  var valid_579150 = path.getOrDefault("name")
  valid_579150 = validateParameter(valid_579150, JString, required = true,
                                 default = nil)
  if valid_579150 != nil:
    section.add "name", valid_579150
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
  var valid_579151 = query.getOrDefault("key")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "key", valid_579151
  var valid_579152 = query.getOrDefault("prettyPrint")
  valid_579152 = validateParameter(valid_579152, JBool, required = false,
                                 default = newJBool(true))
  if valid_579152 != nil:
    section.add "prettyPrint", valid_579152
  var valid_579153 = query.getOrDefault("oauth_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "oauth_token", valid_579153
  var valid_579154 = query.getOrDefault("$.xgafv")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = newJString("1"))
  if valid_579154 != nil:
    section.add "$.xgafv", valid_579154
  var valid_579155 = query.getOrDefault("alt")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = newJString("json"))
  if valid_579155 != nil:
    section.add "alt", valid_579155
  var valid_579156 = query.getOrDefault("uploadType")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "uploadType", valid_579156
  var valid_579157 = query.getOrDefault("quotaUser")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "quotaUser", valid_579157
  var valid_579158 = query.getOrDefault("callback")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "callback", valid_579158
  var valid_579159 = query.getOrDefault("fields")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "fields", valid_579159
  var valid_579160 = query.getOrDefault("access_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "access_token", valid_579160
  var valid_579161 = query.getOrDefault("upload_protocol")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "upload_protocol", valid_579161
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

proc call*(call_579163: Call_MonitoringProjectsMetricDescriptorsCreate_579147;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
  ## 
  let valid = call_579163.validator(path, query, header, formData, body)
  let scheme = call_579163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579163.url(scheme.get, call_579163.host, call_579163.base,
                         call_579163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579163, url, valid)

proc call*(call_579164: Call_MonitoringProjectsMetricDescriptorsCreate_579147;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsMetricDescriptorsCreate
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
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
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579165 = newJObject()
  var query_579166 = newJObject()
  var body_579167 = newJObject()
  add(query_579166, "key", newJString(key))
  add(query_579166, "prettyPrint", newJBool(prettyPrint))
  add(query_579166, "oauth_token", newJString(oauthToken))
  add(query_579166, "$.xgafv", newJString(Xgafv))
  add(query_579166, "alt", newJString(alt))
  add(query_579166, "uploadType", newJString(uploadType))
  add(query_579166, "quotaUser", newJString(quotaUser))
  add(path_579165, "name", newJString(name))
  if body != nil:
    body_579167 = body
  add(query_579166, "callback", newJString(callback))
  add(query_579166, "fields", newJString(fields))
  add(query_579166, "access_token", newJString(accessToken))
  add(query_579166, "upload_protocol", newJString(uploadProtocol))
  result = call_579164.call(path_579165, query_579166, nil, nil, body_579167)

var monitoringProjectsMetricDescriptorsCreate* = Call_MonitoringProjectsMetricDescriptorsCreate_579147(
    name: "monitoringProjectsMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsCreate_579148,
    base: "/", url: url_MonitoringProjectsMetricDescriptorsCreate_579149,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsList_579125 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsMetricDescriptorsList_579127(protocol: Scheme;
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

proc validate_MonitoringProjectsMetricDescriptorsList_579126(path: JsonNode;
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
  var valid_579128 = path.getOrDefault("name")
  valid_579128 = validateParameter(valid_579128, JString, required = true,
                                 default = nil)
  if valid_579128 != nil:
    section.add "name", valid_579128
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
  ##           : A positive number that is the maximum number of results to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : If this field is empty, all custom and system-defined metric descriptors are returned. Otherwise, the filter specifies which metric descriptors are to be returned. For example, the following filter matches all custom metrics:
  ## metric.type = starts_with("custom.googleapis.com/")
  ## 
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579129 = query.getOrDefault("key")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "key", valid_579129
  var valid_579130 = query.getOrDefault("prettyPrint")
  valid_579130 = validateParameter(valid_579130, JBool, required = false,
                                 default = newJBool(true))
  if valid_579130 != nil:
    section.add "prettyPrint", valid_579130
  var valid_579131 = query.getOrDefault("oauth_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "oauth_token", valid_579131
  var valid_579132 = query.getOrDefault("$.xgafv")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = newJString("1"))
  if valid_579132 != nil:
    section.add "$.xgafv", valid_579132
  var valid_579133 = query.getOrDefault("pageSize")
  valid_579133 = validateParameter(valid_579133, JInt, required = false, default = nil)
  if valid_579133 != nil:
    section.add "pageSize", valid_579133
  var valid_579134 = query.getOrDefault("alt")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = newJString("json"))
  if valid_579134 != nil:
    section.add "alt", valid_579134
  var valid_579135 = query.getOrDefault("uploadType")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "uploadType", valid_579135
  var valid_579136 = query.getOrDefault("quotaUser")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = nil)
  if valid_579136 != nil:
    section.add "quotaUser", valid_579136
  var valid_579137 = query.getOrDefault("filter")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "filter", valid_579137
  var valid_579138 = query.getOrDefault("pageToken")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "pageToken", valid_579138
  var valid_579139 = query.getOrDefault("callback")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "callback", valid_579139
  var valid_579140 = query.getOrDefault("fields")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "fields", valid_579140
  var valid_579141 = query.getOrDefault("access_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "access_token", valid_579141
  var valid_579142 = query.getOrDefault("upload_protocol")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "upload_protocol", valid_579142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579143: Call_MonitoringProjectsMetricDescriptorsList_579125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_579143.validator(path, query, header, formData, body)
  let scheme = call_579143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579143.url(scheme.get, call_579143.host, call_579143.base,
                         call_579143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579143, url, valid)

proc call*(call_579144: Call_MonitoringProjectsMetricDescriptorsList_579125;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsMetricDescriptorsList
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  ##   filter: string
  ##         : If this field is empty, all custom and system-defined metric descriptors are returned. Otherwise, the filter specifies which metric descriptors are to be returned. For example, the following filter matches all custom metrics:
  ## metric.type = starts_with("custom.googleapis.com/")
  ## 
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579145 = newJObject()
  var query_579146 = newJObject()
  add(query_579146, "key", newJString(key))
  add(query_579146, "prettyPrint", newJBool(prettyPrint))
  add(query_579146, "oauth_token", newJString(oauthToken))
  add(query_579146, "$.xgafv", newJString(Xgafv))
  add(query_579146, "pageSize", newJInt(pageSize))
  add(query_579146, "alt", newJString(alt))
  add(query_579146, "uploadType", newJString(uploadType))
  add(query_579146, "quotaUser", newJString(quotaUser))
  add(path_579145, "name", newJString(name))
  add(query_579146, "filter", newJString(filter))
  add(query_579146, "pageToken", newJString(pageToken))
  add(query_579146, "callback", newJString(callback))
  add(query_579146, "fields", newJString(fields))
  add(query_579146, "access_token", newJString(accessToken))
  add(query_579146, "upload_protocol", newJString(uploadProtocol))
  result = call_579144.call(path_579145, query_579146, nil, nil, nil)

var monitoringProjectsMetricDescriptorsList* = Call_MonitoringProjectsMetricDescriptorsList_579125(
    name: "monitoringProjectsMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsList_579126, base: "/",
    url: url_MonitoringProjectsMetricDescriptorsList_579127,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMonitoredResourceDescriptorsList_579168 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsMonitoredResourceDescriptorsList_579170(
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

proc validate_MonitoringProjectsMonitoredResourceDescriptorsList_579169(
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
  var valid_579171 = path.getOrDefault("name")
  valid_579171 = validateParameter(valid_579171, JString, required = true,
                                 default = nil)
  if valid_579171 != nil:
    section.add "name", valid_579171
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
  ##           : A positive number that is the maximum number of results to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : An optional filter describing the descriptors to be returned. The filter can reference the descriptor's type and labels. For example, the following filter returns only Google Compute Engine descriptors that have an id label:
  ## resource.type = starts_with("gce_") AND resource.label:id
  ## 
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579172 = query.getOrDefault("key")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "key", valid_579172
  var valid_579173 = query.getOrDefault("prettyPrint")
  valid_579173 = validateParameter(valid_579173, JBool, required = false,
                                 default = newJBool(true))
  if valid_579173 != nil:
    section.add "prettyPrint", valid_579173
  var valid_579174 = query.getOrDefault("oauth_token")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "oauth_token", valid_579174
  var valid_579175 = query.getOrDefault("$.xgafv")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = newJString("1"))
  if valid_579175 != nil:
    section.add "$.xgafv", valid_579175
  var valid_579176 = query.getOrDefault("pageSize")
  valid_579176 = validateParameter(valid_579176, JInt, required = false, default = nil)
  if valid_579176 != nil:
    section.add "pageSize", valid_579176
  var valid_579177 = query.getOrDefault("alt")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = newJString("json"))
  if valid_579177 != nil:
    section.add "alt", valid_579177
  var valid_579178 = query.getOrDefault("uploadType")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "uploadType", valid_579178
  var valid_579179 = query.getOrDefault("quotaUser")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "quotaUser", valid_579179
  var valid_579180 = query.getOrDefault("filter")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "filter", valid_579180
  var valid_579181 = query.getOrDefault("pageToken")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "pageToken", valid_579181
  var valid_579182 = query.getOrDefault("callback")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "callback", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  var valid_579184 = query.getOrDefault("access_token")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "access_token", valid_579184
  var valid_579185 = query.getOrDefault("upload_protocol")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "upload_protocol", valid_579185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579186: Call_MonitoringProjectsMonitoredResourceDescriptorsList_579168;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_579186.validator(path, query, header, formData, body)
  let scheme = call_579186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579186.url(scheme.get, call_579186.host, call_579186.base,
                         call_579186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579186, url, valid)

proc call*(call_579187: Call_MonitoringProjectsMonitoredResourceDescriptorsList_579168;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsMonitoredResourceDescriptorsList
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  ##   filter: string
  ##         : An optional filter describing the descriptors to be returned. The filter can reference the descriptor's type and labels. For example, the following filter returns only Google Compute Engine descriptors that have an id label:
  ## resource.type = starts_with("gce_") AND resource.label:id
  ## 
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579188 = newJObject()
  var query_579189 = newJObject()
  add(query_579189, "key", newJString(key))
  add(query_579189, "prettyPrint", newJBool(prettyPrint))
  add(query_579189, "oauth_token", newJString(oauthToken))
  add(query_579189, "$.xgafv", newJString(Xgafv))
  add(query_579189, "pageSize", newJInt(pageSize))
  add(query_579189, "alt", newJString(alt))
  add(query_579189, "uploadType", newJString(uploadType))
  add(query_579189, "quotaUser", newJString(quotaUser))
  add(path_579188, "name", newJString(name))
  add(query_579189, "filter", newJString(filter))
  add(query_579189, "pageToken", newJString(pageToken))
  add(query_579189, "callback", newJString(callback))
  add(query_579189, "fields", newJString(fields))
  add(query_579189, "access_token", newJString(accessToken))
  add(query_579189, "upload_protocol", newJString(uploadProtocol))
  result = call_579187.call(path_579188, query_579189, nil, nil, nil)

var monitoringProjectsMonitoredResourceDescriptorsList* = Call_MonitoringProjectsMonitoredResourceDescriptorsList_579168(
    name: "monitoringProjectsMonitoredResourceDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/monitoredResourceDescriptors",
    validator: validate_MonitoringProjectsMonitoredResourceDescriptorsList_579169,
    base: "/", url: url_MonitoringProjectsMonitoredResourceDescriptorsList_579170,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelDescriptorsList_579190 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsNotificationChannelDescriptorsList_579192(
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

proc validate_MonitoringProjectsNotificationChannelDescriptorsList_579191(
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
  var valid_579193 = path.getOrDefault("name")
  valid_579193 = validateParameter(valid_579193, JString, required = true,
                                 default = nil)
  if valid_579193 != nil:
    section.add "name", valid_579193
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
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579194 = query.getOrDefault("key")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "key", valid_579194
  var valid_579195 = query.getOrDefault("prettyPrint")
  valid_579195 = validateParameter(valid_579195, JBool, required = false,
                                 default = newJBool(true))
  if valid_579195 != nil:
    section.add "prettyPrint", valid_579195
  var valid_579196 = query.getOrDefault("oauth_token")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "oauth_token", valid_579196
  var valid_579197 = query.getOrDefault("$.xgafv")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = newJString("1"))
  if valid_579197 != nil:
    section.add "$.xgafv", valid_579197
  var valid_579198 = query.getOrDefault("pageSize")
  valid_579198 = validateParameter(valid_579198, JInt, required = false, default = nil)
  if valid_579198 != nil:
    section.add "pageSize", valid_579198
  var valid_579199 = query.getOrDefault("alt")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = newJString("json"))
  if valid_579199 != nil:
    section.add "alt", valid_579199
  var valid_579200 = query.getOrDefault("uploadType")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "uploadType", valid_579200
  var valid_579201 = query.getOrDefault("quotaUser")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "quotaUser", valid_579201
  var valid_579202 = query.getOrDefault("pageToken")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "pageToken", valid_579202
  var valid_579203 = query.getOrDefault("callback")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "callback", valid_579203
  var valid_579204 = query.getOrDefault("fields")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "fields", valid_579204
  var valid_579205 = query.getOrDefault("access_token")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "access_token", valid_579205
  var valid_579206 = query.getOrDefault("upload_protocol")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "upload_protocol", valid_579206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579207: Call_MonitoringProjectsNotificationChannelDescriptorsList_579190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ## 
  let valid = call_579207.validator(path, query, header, formData, body)
  let scheme = call_579207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579207.url(scheme.get, call_579207.host, call_579207.base,
                         call_579207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579207, url, valid)

proc call*(call_579208: Call_MonitoringProjectsNotificationChannelDescriptorsList_579190;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsNotificationChannelDescriptorsList
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The REST resource name of the parent from which to retrieve the notification channel descriptors. The expected syntax is:
  ## projects/[PROJECT_ID]
  ## Note that this names the parent container in which to look for the descriptors; to retrieve a single descriptor by name, use the GetNotificationChannelDescriptor operation, instead.
  ##   pageToken: string
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579209 = newJObject()
  var query_579210 = newJObject()
  add(query_579210, "key", newJString(key))
  add(query_579210, "prettyPrint", newJBool(prettyPrint))
  add(query_579210, "oauth_token", newJString(oauthToken))
  add(query_579210, "$.xgafv", newJString(Xgafv))
  add(query_579210, "pageSize", newJInt(pageSize))
  add(query_579210, "alt", newJString(alt))
  add(query_579210, "uploadType", newJString(uploadType))
  add(query_579210, "quotaUser", newJString(quotaUser))
  add(path_579209, "name", newJString(name))
  add(query_579210, "pageToken", newJString(pageToken))
  add(query_579210, "callback", newJString(callback))
  add(query_579210, "fields", newJString(fields))
  add(query_579210, "access_token", newJString(accessToken))
  add(query_579210, "upload_protocol", newJString(uploadProtocol))
  result = call_579208.call(path_579209, query_579210, nil, nil, nil)

var monitoringProjectsNotificationChannelDescriptorsList* = Call_MonitoringProjectsNotificationChannelDescriptorsList_579190(
    name: "monitoringProjectsNotificationChannelDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannelDescriptors",
    validator: validate_MonitoringProjectsNotificationChannelDescriptorsList_579191,
    base: "/", url: url_MonitoringProjectsNotificationChannelDescriptorsList_579192,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsCreate_579234 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsNotificationChannelsCreate_579236(protocol: Scheme;
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

proc validate_MonitoringProjectsNotificationChannelsCreate_579235(path: JsonNode;
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
  var valid_579237 = path.getOrDefault("name")
  valid_579237 = validateParameter(valid_579237, JString, required = true,
                                 default = nil)
  if valid_579237 != nil:
    section.add "name", valid_579237
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
  var valid_579238 = query.getOrDefault("key")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "key", valid_579238
  var valid_579239 = query.getOrDefault("prettyPrint")
  valid_579239 = validateParameter(valid_579239, JBool, required = false,
                                 default = newJBool(true))
  if valid_579239 != nil:
    section.add "prettyPrint", valid_579239
  var valid_579240 = query.getOrDefault("oauth_token")
  valid_579240 = validateParameter(valid_579240, JString, required = false,
                                 default = nil)
  if valid_579240 != nil:
    section.add "oauth_token", valid_579240
  var valid_579241 = query.getOrDefault("$.xgafv")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = newJString("1"))
  if valid_579241 != nil:
    section.add "$.xgafv", valid_579241
  var valid_579242 = query.getOrDefault("alt")
  valid_579242 = validateParameter(valid_579242, JString, required = false,
                                 default = newJString("json"))
  if valid_579242 != nil:
    section.add "alt", valid_579242
  var valid_579243 = query.getOrDefault("uploadType")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "uploadType", valid_579243
  var valid_579244 = query.getOrDefault("quotaUser")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "quotaUser", valid_579244
  var valid_579245 = query.getOrDefault("callback")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "callback", valid_579245
  var valid_579246 = query.getOrDefault("fields")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "fields", valid_579246
  var valid_579247 = query.getOrDefault("access_token")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "access_token", valid_579247
  var valid_579248 = query.getOrDefault("upload_protocol")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "upload_protocol", valid_579248
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

proc call*(call_579250: Call_MonitoringProjectsNotificationChannelsCreate_579234;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
  ## 
  let valid = call_579250.validator(path, query, header, formData, body)
  let scheme = call_579250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579250.url(scheme.get, call_579250.host, call_579250.base,
                         call_579250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579250, url, valid)

proc call*(call_579251: Call_MonitoringProjectsNotificationChannelsCreate_579234;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsNotificationChannelsCreate
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
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
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is:
  ## projects/[PROJECT_ID]
  ## Note that this names the container into which the channel will be written. This does not name the newly created channel. The resulting channel's name will have a normalized version of this field as a prefix, but will add /notificationChannels/[CHANNEL_ID] to identify the channel.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579252 = newJObject()
  var query_579253 = newJObject()
  var body_579254 = newJObject()
  add(query_579253, "key", newJString(key))
  add(query_579253, "prettyPrint", newJBool(prettyPrint))
  add(query_579253, "oauth_token", newJString(oauthToken))
  add(query_579253, "$.xgafv", newJString(Xgafv))
  add(query_579253, "alt", newJString(alt))
  add(query_579253, "uploadType", newJString(uploadType))
  add(query_579253, "quotaUser", newJString(quotaUser))
  add(path_579252, "name", newJString(name))
  if body != nil:
    body_579254 = body
  add(query_579253, "callback", newJString(callback))
  add(query_579253, "fields", newJString(fields))
  add(query_579253, "access_token", newJString(accessToken))
  add(query_579253, "upload_protocol", newJString(uploadProtocol))
  result = call_579251.call(path_579252, query_579253, nil, nil, body_579254)

var monitoringProjectsNotificationChannelsCreate* = Call_MonitoringProjectsNotificationChannelsCreate_579234(
    name: "monitoringProjectsNotificationChannelsCreate",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsCreate_579235,
    base: "/", url: url_MonitoringProjectsNotificationChannelsCreate_579236,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsList_579211 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsNotificationChannelsList_579213(protocol: Scheme;
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

proc validate_MonitoringProjectsNotificationChannelsList_579212(path: JsonNode;
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
  var valid_579214 = path.getOrDefault("name")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "name", valid_579214
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
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of fields as in filter. Entries can be prefixed with a minus sign to sort in descending rather than ascending order.For more details, see sorting and filtering.
  ##   filter: JString
  ##         : If provided, this field specifies the criteria that must be met by notification channels to be included in the response.For more details, see sorting and filtering.
  ##   pageToken: JString
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579215 = query.getOrDefault("key")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "key", valid_579215
  var valid_579216 = query.getOrDefault("prettyPrint")
  valid_579216 = validateParameter(valid_579216, JBool, required = false,
                                 default = newJBool(true))
  if valid_579216 != nil:
    section.add "prettyPrint", valid_579216
  var valid_579217 = query.getOrDefault("oauth_token")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "oauth_token", valid_579217
  var valid_579218 = query.getOrDefault("$.xgafv")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = newJString("1"))
  if valid_579218 != nil:
    section.add "$.xgafv", valid_579218
  var valid_579219 = query.getOrDefault("pageSize")
  valid_579219 = validateParameter(valid_579219, JInt, required = false, default = nil)
  if valid_579219 != nil:
    section.add "pageSize", valid_579219
  var valid_579220 = query.getOrDefault("alt")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("json"))
  if valid_579220 != nil:
    section.add "alt", valid_579220
  var valid_579221 = query.getOrDefault("uploadType")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "uploadType", valid_579221
  var valid_579222 = query.getOrDefault("quotaUser")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "quotaUser", valid_579222
  var valid_579223 = query.getOrDefault("orderBy")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "orderBy", valid_579223
  var valid_579224 = query.getOrDefault("filter")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "filter", valid_579224
  var valid_579225 = query.getOrDefault("pageToken")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "pageToken", valid_579225
  var valid_579226 = query.getOrDefault("callback")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "callback", valid_579226
  var valid_579227 = query.getOrDefault("fields")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "fields", valid_579227
  var valid_579228 = query.getOrDefault("access_token")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "access_token", valid_579228
  var valid_579229 = query.getOrDefault("upload_protocol")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "upload_protocol", valid_579229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579230: Call_MonitoringProjectsNotificationChannelsList_579211;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the notification channels that have been created for the project.
  ## 
  let valid = call_579230.validator(path, query, header, formData, body)
  let scheme = call_579230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579230.url(scheme.get, call_579230.host, call_579230.base,
                         call_579230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579230, url, valid)

proc call*(call_579231: Call_MonitoringProjectsNotificationChannelsList_579211;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          orderBy: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsNotificationChannelsList
  ## Lists the notification channels that have been created for the project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. If not set to a positive number, a reasonable value will be chosen by the service.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is projects/[PROJECT_ID]. That is, this names the container in which to look for the notification channels; it does not name a specific channel. To query a specific channel by REST resource name, use the GetNotificationChannel operation.
  ##   orderBy: string
  ##          : A comma-separated list of fields by which to sort the result. Supports the same set of fields as in filter. Entries can be prefixed with a minus sign to sort in descending rather than ascending order.For more details, see sorting and filtering.
  ##   filter: string
  ##         : If provided, this field specifies the criteria that must be met by notification channels to be included in the response.For more details, see sorting and filtering.
  ##   pageToken: string
  ##            : If non-empty, page_token must contain a value returned as the next_page_token in a previous response to request the next set of results.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579232 = newJObject()
  var query_579233 = newJObject()
  add(query_579233, "key", newJString(key))
  add(query_579233, "prettyPrint", newJBool(prettyPrint))
  add(query_579233, "oauth_token", newJString(oauthToken))
  add(query_579233, "$.xgafv", newJString(Xgafv))
  add(query_579233, "pageSize", newJInt(pageSize))
  add(query_579233, "alt", newJString(alt))
  add(query_579233, "uploadType", newJString(uploadType))
  add(query_579233, "quotaUser", newJString(quotaUser))
  add(path_579232, "name", newJString(name))
  add(query_579233, "orderBy", newJString(orderBy))
  add(query_579233, "filter", newJString(filter))
  add(query_579233, "pageToken", newJString(pageToken))
  add(query_579233, "callback", newJString(callback))
  add(query_579233, "fields", newJString(fields))
  add(query_579233, "access_token", newJString(accessToken))
  add(query_579233, "upload_protocol", newJString(uploadProtocol))
  result = call_579231.call(path_579232, query_579233, nil, nil, nil)

var monitoringProjectsNotificationChannelsList* = Call_MonitoringProjectsNotificationChannelsList_579211(
    name: "monitoringProjectsNotificationChannelsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsList_579212,
    base: "/", url: url_MonitoringProjectsNotificationChannelsList_579213,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesCreate_579285 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsTimeSeriesCreate_579287(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsTimeSeriesCreate_579286(path: JsonNode;
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
  var valid_579288 = path.getOrDefault("name")
  valid_579288 = validateParameter(valid_579288, JString, required = true,
                                 default = nil)
  if valid_579288 != nil:
    section.add "name", valid_579288
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
  var valid_579289 = query.getOrDefault("key")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "key", valid_579289
  var valid_579290 = query.getOrDefault("prettyPrint")
  valid_579290 = validateParameter(valid_579290, JBool, required = false,
                                 default = newJBool(true))
  if valid_579290 != nil:
    section.add "prettyPrint", valid_579290
  var valid_579291 = query.getOrDefault("oauth_token")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "oauth_token", valid_579291
  var valid_579292 = query.getOrDefault("$.xgafv")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = newJString("1"))
  if valid_579292 != nil:
    section.add "$.xgafv", valid_579292
  var valid_579293 = query.getOrDefault("alt")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = newJString("json"))
  if valid_579293 != nil:
    section.add "alt", valid_579293
  var valid_579294 = query.getOrDefault("uploadType")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "uploadType", valid_579294
  var valid_579295 = query.getOrDefault("quotaUser")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "quotaUser", valid_579295
  var valid_579296 = query.getOrDefault("callback")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "callback", valid_579296
  var valid_579297 = query.getOrDefault("fields")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "fields", valid_579297
  var valid_579298 = query.getOrDefault("access_token")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "access_token", valid_579298
  var valid_579299 = query.getOrDefault("upload_protocol")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "upload_protocol", valid_579299
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

proc call*(call_579301: Call_MonitoringProjectsTimeSeriesCreate_579285;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
  ## 
  let valid = call_579301.validator(path, query, header, formData, body)
  let scheme = call_579301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579301.url(scheme.get, call_579301.host, call_579301.base,
                         call_579301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579301, url, valid)

proc call*(call_579302: Call_MonitoringProjectsTimeSeriesCreate_579285;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsTimeSeriesCreate
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
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
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579303 = newJObject()
  var query_579304 = newJObject()
  var body_579305 = newJObject()
  add(query_579304, "key", newJString(key))
  add(query_579304, "prettyPrint", newJBool(prettyPrint))
  add(query_579304, "oauth_token", newJString(oauthToken))
  add(query_579304, "$.xgafv", newJString(Xgafv))
  add(query_579304, "alt", newJString(alt))
  add(query_579304, "uploadType", newJString(uploadType))
  add(query_579304, "quotaUser", newJString(quotaUser))
  add(path_579303, "name", newJString(name))
  if body != nil:
    body_579305 = body
  add(query_579304, "callback", newJString(callback))
  add(query_579304, "fields", newJString(fields))
  add(query_579304, "access_token", newJString(accessToken))
  add(query_579304, "upload_protocol", newJString(uploadProtocol))
  result = call_579302.call(path_579303, query_579304, nil, nil, body_579305)

var monitoringProjectsTimeSeriesCreate* = Call_MonitoringProjectsTimeSeriesCreate_579285(
    name: "monitoringProjectsTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesCreate_579286, base: "/",
    url: url_MonitoringProjectsTimeSeriesCreate_579287, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesList_579255 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsTimeSeriesList_579257(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsTimeSeriesList_579256(path: JsonNode;
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
  var valid_579258 = path.getOrDefault("name")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "name", valid_579258
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   aggregation.alignmentPeriod: JString
  ##                              : The alignment period for per-time series alignment. If present, alignmentPeriod must be at least 60 seconds. After per-time series alignment, each time series will contain data points only on the period boundaries. If perSeriesAligner is not specified or equals ALIGN_NONE, then this field is ignored. If perSeriesAligner is specified and does not equal ALIGN_NONE, then this field must be defined; otherwise an error is returned.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : A positive number that is the maximum number of results to return. If page_size is empty or more than 100,000 results, the effective page_size is 100,000 results. If view is set to FULL, this is the maximum number of Points returned. If view is set to HEADERS, this is the maximum number of TimeSeries returned.
  ##   interval.endTime: JString
  ##                   : Required. The end of the time interval.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   orderBy: JString
  ##          : Unsupported: must be left blank. The points in each time series are returned in reverse time order.
  ##   filter: JString
  ##         : A monitoring filter that specifies which time series should be returned. The filter must specify a single metric type, and can additionally specify metric labels and other information. For example:
  ## metric.type = "compute.googleapis.com/instance/cpu/usage_time" AND
  ##     metric.labels.instance_name = "my-instance-name"
  ## 
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: JString
  ##           : JSONP
  ##   aggregation.crossSeriesReducer: JString
  ##                                 : The approach to be used to combine time series. Not all reducer functions may be applied to all time series, depending on the metric type and the value type of the original time series. Reduction may change the metric type of value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   aggregation.perSeriesAligner: JString
  ##                               : The approach to be used to align individual time series. Not all alignment functions may be applied to all time series, depending on the metric type and value type of the original time series. Alignment may change the metric type or the value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   aggregation.groupByFields: JArray
  ##                            : The set of fields to preserve when crossSeriesReducer is specified. The groupByFields determine how the time series are partitioned into subsets prior to applying the aggregation function. Each subset contains time series that have the same value for each of the grouping fields. Each individual time series is a member of exactly one subset. The crossSeriesReducer is applied to each subset of time series. It is not possible to reduce across different resource types, so this field implicitly contains resource.type. Fields not specified in groupByFields are aggregated away. If groupByFields is not specified and all the time series have the same resource type, then the time series are aggregated into a single output time series. If crossSeriesReducer is not defined, this field is ignored.
  ##   interval.startTime: JString
  ##                     : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  ##   view: JString
  ##       : Specifies which information is returned about the time series.
  section = newJObject()
  var valid_579259 = query.getOrDefault("key")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "key", valid_579259
  var valid_579260 = query.getOrDefault("prettyPrint")
  valid_579260 = validateParameter(valid_579260, JBool, required = false,
                                 default = newJBool(true))
  if valid_579260 != nil:
    section.add "prettyPrint", valid_579260
  var valid_579261 = query.getOrDefault("oauth_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "oauth_token", valid_579261
  var valid_579262 = query.getOrDefault("aggregation.alignmentPeriod")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "aggregation.alignmentPeriod", valid_579262
  var valid_579263 = query.getOrDefault("$.xgafv")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = newJString("1"))
  if valid_579263 != nil:
    section.add "$.xgafv", valid_579263
  var valid_579264 = query.getOrDefault("pageSize")
  valid_579264 = validateParameter(valid_579264, JInt, required = false, default = nil)
  if valid_579264 != nil:
    section.add "pageSize", valid_579264
  var valid_579265 = query.getOrDefault("interval.endTime")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "interval.endTime", valid_579265
  var valid_579266 = query.getOrDefault("alt")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = newJString("json"))
  if valid_579266 != nil:
    section.add "alt", valid_579266
  var valid_579267 = query.getOrDefault("uploadType")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "uploadType", valid_579267
  var valid_579268 = query.getOrDefault("quotaUser")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "quotaUser", valid_579268
  var valid_579269 = query.getOrDefault("orderBy")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "orderBy", valid_579269
  var valid_579270 = query.getOrDefault("filter")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "filter", valid_579270
  var valid_579271 = query.getOrDefault("pageToken")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "pageToken", valid_579271
  var valid_579272 = query.getOrDefault("callback")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "callback", valid_579272
  var valid_579273 = query.getOrDefault("aggregation.crossSeriesReducer")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = newJString("REDUCE_NONE"))
  if valid_579273 != nil:
    section.add "aggregation.crossSeriesReducer", valid_579273
  var valid_579274 = query.getOrDefault("aggregation.perSeriesAligner")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = newJString("ALIGN_NONE"))
  if valid_579274 != nil:
    section.add "aggregation.perSeriesAligner", valid_579274
  var valid_579275 = query.getOrDefault("fields")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "fields", valid_579275
  var valid_579276 = query.getOrDefault("access_token")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = nil)
  if valid_579276 != nil:
    section.add "access_token", valid_579276
  var valid_579277 = query.getOrDefault("upload_protocol")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "upload_protocol", valid_579277
  var valid_579278 = query.getOrDefault("aggregation.groupByFields")
  valid_579278 = validateParameter(valid_579278, JArray, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "aggregation.groupByFields", valid_579278
  var valid_579279 = query.getOrDefault("interval.startTime")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "interval.startTime", valid_579279
  var valid_579280 = query.getOrDefault("view")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = newJString("FULL"))
  if valid_579280 != nil:
    section.add "view", valid_579280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579281: Call_MonitoringProjectsTimeSeriesList_579255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_579281.validator(path, query, header, formData, body)
  let scheme = call_579281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579281.url(scheme.get, call_579281.host, call_579281.base,
                         call_579281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579281, url, valid)

proc call*(call_579282: Call_MonitoringProjectsTimeSeriesList_579255; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          aggregationAlignmentPeriod: string = ""; Xgafv: string = "1";
          pageSize: int = 0; intervalEndTime: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; orderBy: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          aggregationCrossSeriesReducer: string = "REDUCE_NONE";
          aggregationPerSeriesAligner: string = "ALIGN_NONE"; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          aggregationGroupByFields: JsonNode = nil; intervalStartTime: string = "";
          view: string = "FULL"): Recallable =
  ## monitoringProjectsTimeSeriesList
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   aggregationAlignmentPeriod: string
  ##                             : The alignment period for per-time series alignment. If present, alignmentPeriod must be at least 60 seconds. After per-time series alignment, each time series will contain data points only on the period boundaries. If perSeriesAligner is not specified or equals ALIGN_NONE, then this field is ignored. If perSeriesAligner is specified and does not equal ALIGN_NONE, then this field must be defined; otherwise an error is returned.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : A positive number that is the maximum number of results to return. If page_size is empty or more than 100,000 results, the effective page_size is 100,000 results. If view is set to FULL, this is the maximum number of Points returned. If view is set to HEADERS, this is the maximum number of TimeSeries returned.
  ##   intervalEndTime: string
  ##                  : Required. The end of the time interval.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The project on which to execute the request. The format is "projects/{project_id_or_number}".
  ##   orderBy: string
  ##          : Unsupported: must be left blank. The points in each time series are returned in reverse time order.
  ##   filter: string
  ##         : A monitoring filter that specifies which time series should be returned. The filter must specify a single metric type, and can additionally specify metric labels and other information. For example:
  ## metric.type = "compute.googleapis.com/instance/cpu/usage_time" AND
  ##     metric.labels.instance_name = "my-instance-name"
  ## 
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return additional results from the previous method call.
  ##   callback: string
  ##           : JSONP
  ##   aggregationCrossSeriesReducer: string
  ##                                : The approach to be used to combine time series. Not all reducer functions may be applied to all time series, depending on the metric type and the value type of the original time series. Reduction may change the metric type of value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   aggregationPerSeriesAligner: string
  ##                              : The approach to be used to align individual time series. Not all alignment functions may be applied to all time series, depending on the metric type and value type of the original time series. Alignment may change the metric type or the value type of the time series.Time series data must be aligned in order to perform cross-time series reduction. If crossSeriesReducer is specified, then perSeriesAligner must be specified and not equal ALIGN_NONE and alignmentPeriod must be specified; otherwise, an error is returned.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   aggregationGroupByFields: JArray
  ##                           : The set of fields to preserve when crossSeriesReducer is specified. The groupByFields determine how the time series are partitioned into subsets prior to applying the aggregation function. Each subset contains time series that have the same value for each of the grouping fields. Each individual time series is a member of exactly one subset. The crossSeriesReducer is applied to each subset of time series. It is not possible to reduce across different resource types, so this field implicitly contains resource.type. Fields not specified in groupByFields are aggregated away. If groupByFields is not specified and all the time series have the same resource type, then the time series are aggregated into a single output time series. If crossSeriesReducer is not defined, this field is ignored.
  ##   intervalStartTime: string
  ##                    : Optional. The beginning of the time interval. The default value for the start time is the end time. The start time must not be later than the end time.
  ##   view: string
  ##       : Specifies which information is returned about the time series.
  var path_579283 = newJObject()
  var query_579284 = newJObject()
  add(query_579284, "key", newJString(key))
  add(query_579284, "prettyPrint", newJBool(prettyPrint))
  add(query_579284, "oauth_token", newJString(oauthToken))
  add(query_579284, "aggregation.alignmentPeriod",
      newJString(aggregationAlignmentPeriod))
  add(query_579284, "$.xgafv", newJString(Xgafv))
  add(query_579284, "pageSize", newJInt(pageSize))
  add(query_579284, "interval.endTime", newJString(intervalEndTime))
  add(query_579284, "alt", newJString(alt))
  add(query_579284, "uploadType", newJString(uploadType))
  add(query_579284, "quotaUser", newJString(quotaUser))
  add(path_579283, "name", newJString(name))
  add(query_579284, "orderBy", newJString(orderBy))
  add(query_579284, "filter", newJString(filter))
  add(query_579284, "pageToken", newJString(pageToken))
  add(query_579284, "callback", newJString(callback))
  add(query_579284, "aggregation.crossSeriesReducer",
      newJString(aggregationCrossSeriesReducer))
  add(query_579284, "aggregation.perSeriesAligner",
      newJString(aggregationPerSeriesAligner))
  add(query_579284, "fields", newJString(fields))
  add(query_579284, "access_token", newJString(accessToken))
  add(query_579284, "upload_protocol", newJString(uploadProtocol))
  if aggregationGroupByFields != nil:
    query_579284.add "aggregation.groupByFields", aggregationGroupByFields
  add(query_579284, "interval.startTime", newJString(intervalStartTime))
  add(query_579284, "view", newJString(view))
  result = call_579282.call(path_579283, query_579284, nil, nil, nil)

var monitoringProjectsTimeSeriesList* = Call_MonitoringProjectsTimeSeriesList_579255(
    name: "monitoringProjectsTimeSeriesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesList_579256, base: "/",
    url: url_MonitoringProjectsTimeSeriesList_579257, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsGetVerificationCode_579306 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsNotificationChannelsGetVerificationCode_579308(
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

proc validate_MonitoringProjectsNotificationChannelsGetVerificationCode_579307(
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
  var valid_579309 = path.getOrDefault("name")
  valid_579309 = validateParameter(valid_579309, JString, required = true,
                                 default = nil)
  if valid_579309 != nil:
    section.add "name", valid_579309
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
  var valid_579310 = query.getOrDefault("key")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "key", valid_579310
  var valid_579311 = query.getOrDefault("prettyPrint")
  valid_579311 = validateParameter(valid_579311, JBool, required = false,
                                 default = newJBool(true))
  if valid_579311 != nil:
    section.add "prettyPrint", valid_579311
  var valid_579312 = query.getOrDefault("oauth_token")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "oauth_token", valid_579312
  var valid_579313 = query.getOrDefault("$.xgafv")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = newJString("1"))
  if valid_579313 != nil:
    section.add "$.xgafv", valid_579313
  var valid_579314 = query.getOrDefault("alt")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = newJString("json"))
  if valid_579314 != nil:
    section.add "alt", valid_579314
  var valid_579315 = query.getOrDefault("uploadType")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "uploadType", valid_579315
  var valid_579316 = query.getOrDefault("quotaUser")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "quotaUser", valid_579316
  var valid_579317 = query.getOrDefault("callback")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "callback", valid_579317
  var valid_579318 = query.getOrDefault("fields")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "fields", valid_579318
  var valid_579319 = query.getOrDefault("access_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "access_token", valid_579319
  var valid_579320 = query.getOrDefault("upload_protocol")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "upload_protocol", valid_579320
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

proc call*(call_579322: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_579306;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
  ## 
  let valid = call_579322.validator(path, query, header, formData, body)
  let scheme = call_579322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579322.url(scheme.get, call_579322.host, call_579322.base,
                         call_579322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579322, url, valid)

proc call*(call_579323: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_579306;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsNotificationChannelsGetVerificationCode
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
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
  ##   name: string (required)
  ##       : The notification channel for which a verification code is to be generated and retrieved. This must name a channel that is already verified; if the specified channel is not verified, the request will fail.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579324 = newJObject()
  var query_579325 = newJObject()
  var body_579326 = newJObject()
  add(query_579325, "key", newJString(key))
  add(query_579325, "prettyPrint", newJBool(prettyPrint))
  add(query_579325, "oauth_token", newJString(oauthToken))
  add(query_579325, "$.xgafv", newJString(Xgafv))
  add(query_579325, "alt", newJString(alt))
  add(query_579325, "uploadType", newJString(uploadType))
  add(query_579325, "quotaUser", newJString(quotaUser))
  add(path_579324, "name", newJString(name))
  if body != nil:
    body_579326 = body
  add(query_579325, "callback", newJString(callback))
  add(query_579325, "fields", newJString(fields))
  add(query_579325, "access_token", newJString(accessToken))
  add(query_579325, "upload_protocol", newJString(uploadProtocol))
  result = call_579323.call(path_579324, query_579325, nil, nil, body_579326)

var monitoringProjectsNotificationChannelsGetVerificationCode* = Call_MonitoringProjectsNotificationChannelsGetVerificationCode_579306(
    name: "monitoringProjectsNotificationChannelsGetVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:getVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsGetVerificationCode_579307,
    base: "/", url: url_MonitoringProjectsNotificationChannelsGetVerificationCode_579308,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsSendVerificationCode_579327 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsNotificationChannelsSendVerificationCode_579329(
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

proc validate_MonitoringProjectsNotificationChannelsSendVerificationCode_579328(
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
  var valid_579330 = path.getOrDefault("name")
  valid_579330 = validateParameter(valid_579330, JString, required = true,
                                 default = nil)
  if valid_579330 != nil:
    section.add "name", valid_579330
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
  var valid_579331 = query.getOrDefault("key")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "key", valid_579331
  var valid_579332 = query.getOrDefault("prettyPrint")
  valid_579332 = validateParameter(valid_579332, JBool, required = false,
                                 default = newJBool(true))
  if valid_579332 != nil:
    section.add "prettyPrint", valid_579332
  var valid_579333 = query.getOrDefault("oauth_token")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "oauth_token", valid_579333
  var valid_579334 = query.getOrDefault("$.xgafv")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("1"))
  if valid_579334 != nil:
    section.add "$.xgafv", valid_579334
  var valid_579335 = query.getOrDefault("alt")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = newJString("json"))
  if valid_579335 != nil:
    section.add "alt", valid_579335
  var valid_579336 = query.getOrDefault("uploadType")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "uploadType", valid_579336
  var valid_579337 = query.getOrDefault("quotaUser")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "quotaUser", valid_579337
  var valid_579338 = query.getOrDefault("callback")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "callback", valid_579338
  var valid_579339 = query.getOrDefault("fields")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "fields", valid_579339
  var valid_579340 = query.getOrDefault("access_token")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "access_token", valid_579340
  var valid_579341 = query.getOrDefault("upload_protocol")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "upload_protocol", valid_579341
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

proc call*(call_579343: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_579327;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
  ## 
  let valid = call_579343.validator(path, query, header, formData, body)
  let scheme = call_579343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579343.url(scheme.get, call_579343.host, call_579343.base,
                         call_579343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579343, url, valid)

proc call*(call_579344: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_579327;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsNotificationChannelsSendVerificationCode
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
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
  ##   name: string (required)
  ##       : The notification channel to which to send a verification code.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579345 = newJObject()
  var query_579346 = newJObject()
  var body_579347 = newJObject()
  add(query_579346, "key", newJString(key))
  add(query_579346, "prettyPrint", newJBool(prettyPrint))
  add(query_579346, "oauth_token", newJString(oauthToken))
  add(query_579346, "$.xgafv", newJString(Xgafv))
  add(query_579346, "alt", newJString(alt))
  add(query_579346, "uploadType", newJString(uploadType))
  add(query_579346, "quotaUser", newJString(quotaUser))
  add(path_579345, "name", newJString(name))
  if body != nil:
    body_579347 = body
  add(query_579346, "callback", newJString(callback))
  add(query_579346, "fields", newJString(fields))
  add(query_579346, "access_token", newJString(accessToken))
  add(query_579346, "upload_protocol", newJString(uploadProtocol))
  result = call_579344.call(path_579345, query_579346, nil, nil, body_579347)

var monitoringProjectsNotificationChannelsSendVerificationCode* = Call_MonitoringProjectsNotificationChannelsSendVerificationCode_579327(
    name: "monitoringProjectsNotificationChannelsSendVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:sendVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsSendVerificationCode_579328,
    base: "/",
    url: url_MonitoringProjectsNotificationChannelsSendVerificationCode_579329,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsVerify_579348 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsNotificationChannelsVerify_579350(protocol: Scheme;
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

proc validate_MonitoringProjectsNotificationChannelsVerify_579349(path: JsonNode;
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
  var valid_579351 = path.getOrDefault("name")
  valid_579351 = validateParameter(valid_579351, JString, required = true,
                                 default = nil)
  if valid_579351 != nil:
    section.add "name", valid_579351
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
  var valid_579352 = query.getOrDefault("key")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "key", valid_579352
  var valid_579353 = query.getOrDefault("prettyPrint")
  valid_579353 = validateParameter(valid_579353, JBool, required = false,
                                 default = newJBool(true))
  if valid_579353 != nil:
    section.add "prettyPrint", valid_579353
  var valid_579354 = query.getOrDefault("oauth_token")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "oauth_token", valid_579354
  var valid_579355 = query.getOrDefault("$.xgafv")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = newJString("1"))
  if valid_579355 != nil:
    section.add "$.xgafv", valid_579355
  var valid_579356 = query.getOrDefault("alt")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = newJString("json"))
  if valid_579356 != nil:
    section.add "alt", valid_579356
  var valid_579357 = query.getOrDefault("uploadType")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "uploadType", valid_579357
  var valid_579358 = query.getOrDefault("quotaUser")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "quotaUser", valid_579358
  var valid_579359 = query.getOrDefault("callback")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "callback", valid_579359
  var valid_579360 = query.getOrDefault("fields")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "fields", valid_579360
  var valid_579361 = query.getOrDefault("access_token")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "access_token", valid_579361
  var valid_579362 = query.getOrDefault("upload_protocol")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "upload_protocol", valid_579362
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

proc call*(call_579364: Call_MonitoringProjectsNotificationChannelsVerify_579348;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
  ## 
  let valid = call_579364.validator(path, query, header, formData, body)
  let scheme = call_579364.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579364.url(scheme.get, call_579364.host, call_579364.base,
                         call_579364.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579364, url, valid)

proc call*(call_579365: Call_MonitoringProjectsNotificationChannelsVerify_579348;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsNotificationChannelsVerify
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
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
  ##   name: string (required)
  ##       : The notification channel to verify.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579366 = newJObject()
  var query_579367 = newJObject()
  var body_579368 = newJObject()
  add(query_579367, "key", newJString(key))
  add(query_579367, "prettyPrint", newJBool(prettyPrint))
  add(query_579367, "oauth_token", newJString(oauthToken))
  add(query_579367, "$.xgafv", newJString(Xgafv))
  add(query_579367, "alt", newJString(alt))
  add(query_579367, "uploadType", newJString(uploadType))
  add(query_579367, "quotaUser", newJString(quotaUser))
  add(path_579366, "name", newJString(name))
  if body != nil:
    body_579368 = body
  add(query_579367, "callback", newJString(callback))
  add(query_579367, "fields", newJString(fields))
  add(query_579367, "access_token", newJString(accessToken))
  add(query_579367, "upload_protocol", newJString(uploadProtocol))
  result = call_579365.call(path_579366, query_579367, nil, nil, body_579368)

var monitoringProjectsNotificationChannelsVerify* = Call_MonitoringProjectsNotificationChannelsVerify_579348(
    name: "monitoringProjectsNotificationChannelsVerify",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:verify",
    validator: validate_MonitoringProjectsNotificationChannelsVerify_579349,
    base: "/", url: url_MonitoringProjectsNotificationChannelsVerify_579350,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsCreate_579390 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsUptimeCheckConfigsCreate_579392(protocol: Scheme;
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

proc validate_MonitoringProjectsUptimeCheckConfigsCreate_579391(path: JsonNode;
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
  var valid_579393 = path.getOrDefault("parent")
  valid_579393 = validateParameter(valid_579393, JString, required = true,
                                 default = nil)
  if valid_579393 != nil:
    section.add "parent", valid_579393
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
  var valid_579394 = query.getOrDefault("key")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "key", valid_579394
  var valid_579395 = query.getOrDefault("prettyPrint")
  valid_579395 = validateParameter(valid_579395, JBool, required = false,
                                 default = newJBool(true))
  if valid_579395 != nil:
    section.add "prettyPrint", valid_579395
  var valid_579396 = query.getOrDefault("oauth_token")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "oauth_token", valid_579396
  var valid_579397 = query.getOrDefault("$.xgafv")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = newJString("1"))
  if valid_579397 != nil:
    section.add "$.xgafv", valid_579397
  var valid_579398 = query.getOrDefault("alt")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = newJString("json"))
  if valid_579398 != nil:
    section.add "alt", valid_579398
  var valid_579399 = query.getOrDefault("uploadType")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = nil)
  if valid_579399 != nil:
    section.add "uploadType", valid_579399
  var valid_579400 = query.getOrDefault("quotaUser")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "quotaUser", valid_579400
  var valid_579401 = query.getOrDefault("callback")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "callback", valid_579401
  var valid_579402 = query.getOrDefault("fields")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "fields", valid_579402
  var valid_579403 = query.getOrDefault("access_token")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "access_token", valid_579403
  var valid_579404 = query.getOrDefault("upload_protocol")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "upload_protocol", valid_579404
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

proc call*(call_579406: Call_MonitoringProjectsUptimeCheckConfigsCreate_579390;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Uptime check configuration.
  ## 
  let valid = call_579406.validator(path, query, header, formData, body)
  let scheme = call_579406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579406.url(scheme.get, call_579406.host, call_579406.base,
                         call_579406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579406, url, valid)

proc call*(call_579407: Call_MonitoringProjectsUptimeCheckConfigsCreate_579390;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsUptimeCheckConfigsCreate
  ## Creates a new Uptime check configuration.
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
  ##   parent: string (required)
  ##         : The project in which to create the Uptime check. The format  is projects/[PROJECT_ID].
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579408 = newJObject()
  var query_579409 = newJObject()
  var body_579410 = newJObject()
  add(query_579409, "key", newJString(key))
  add(query_579409, "prettyPrint", newJBool(prettyPrint))
  add(query_579409, "oauth_token", newJString(oauthToken))
  add(query_579409, "$.xgafv", newJString(Xgafv))
  add(query_579409, "alt", newJString(alt))
  add(query_579409, "uploadType", newJString(uploadType))
  add(query_579409, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579410 = body
  add(query_579409, "callback", newJString(callback))
  add(path_579408, "parent", newJString(parent))
  add(query_579409, "fields", newJString(fields))
  add(query_579409, "access_token", newJString(accessToken))
  add(query_579409, "upload_protocol", newJString(uploadProtocol))
  result = call_579407.call(path_579408, query_579409, nil, nil, body_579410)

var monitoringProjectsUptimeCheckConfigsCreate* = Call_MonitoringProjectsUptimeCheckConfigsCreate_579390(
    name: "monitoringProjectsUptimeCheckConfigsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsCreate_579391,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsCreate_579392,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsList_579369 = ref object of OpenApiRestCall_578348
proc url_MonitoringProjectsUptimeCheckConfigsList_579371(protocol: Scheme;
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

proc validate_MonitoringProjectsUptimeCheckConfigsList_579370(path: JsonNode;
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
  var valid_579372 = path.getOrDefault("parent")
  valid_579372 = validateParameter(valid_579372, JString, required = true,
                                 default = nil)
  if valid_579372 != nil:
    section.add "parent", valid_579372
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
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579373 = query.getOrDefault("key")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "key", valid_579373
  var valid_579374 = query.getOrDefault("prettyPrint")
  valid_579374 = validateParameter(valid_579374, JBool, required = false,
                                 default = newJBool(true))
  if valid_579374 != nil:
    section.add "prettyPrint", valid_579374
  var valid_579375 = query.getOrDefault("oauth_token")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "oauth_token", valid_579375
  var valid_579376 = query.getOrDefault("$.xgafv")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = newJString("1"))
  if valid_579376 != nil:
    section.add "$.xgafv", valid_579376
  var valid_579377 = query.getOrDefault("pageSize")
  valid_579377 = validateParameter(valid_579377, JInt, required = false, default = nil)
  if valid_579377 != nil:
    section.add "pageSize", valid_579377
  var valid_579378 = query.getOrDefault("alt")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = newJString("json"))
  if valid_579378 != nil:
    section.add "alt", valid_579378
  var valid_579379 = query.getOrDefault("uploadType")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "uploadType", valid_579379
  var valid_579380 = query.getOrDefault("quotaUser")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "quotaUser", valid_579380
  var valid_579381 = query.getOrDefault("pageToken")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "pageToken", valid_579381
  var valid_579382 = query.getOrDefault("callback")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "callback", valid_579382
  var valid_579383 = query.getOrDefault("fields")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "fields", valid_579383
  var valid_579384 = query.getOrDefault("access_token")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "access_token", valid_579384
  var valid_579385 = query.getOrDefault("upload_protocol")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "upload_protocol", valid_579385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579386: Call_MonitoringProjectsUptimeCheckConfigsList_579369;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ## 
  let valid = call_579386.validator(path, query, header, formData, body)
  let scheme = call_579386.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579386.url(scheme.get, call_579386.host, call_579386.base,
                         call_579386.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579386, url, valid)

proc call*(call_579387: Call_MonitoringProjectsUptimeCheckConfigsList_579369;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsUptimeCheckConfigsList
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of results to return in a single response. The server may further constrain the maximum number of results returned in a single page. If the page_size is <=0, the server will decide the number of results to be returned.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If this field is not empty then it must contain the nextPageToken value returned by a previous call to this method. Using this field causes the method to return more results from the previous method call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The project whose Uptime check configurations are listed. The format  is projects/[PROJECT_ID].
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579388 = newJObject()
  var query_579389 = newJObject()
  add(query_579389, "key", newJString(key))
  add(query_579389, "prettyPrint", newJBool(prettyPrint))
  add(query_579389, "oauth_token", newJString(oauthToken))
  add(query_579389, "$.xgafv", newJString(Xgafv))
  add(query_579389, "pageSize", newJInt(pageSize))
  add(query_579389, "alt", newJString(alt))
  add(query_579389, "uploadType", newJString(uploadType))
  add(query_579389, "quotaUser", newJString(quotaUser))
  add(query_579389, "pageToken", newJString(pageToken))
  add(query_579389, "callback", newJString(callback))
  add(path_579388, "parent", newJString(parent))
  add(query_579389, "fields", newJString(fields))
  add(query_579389, "access_token", newJString(accessToken))
  add(query_579389, "upload_protocol", newJString(uploadProtocol))
  result = call_579387.call(path_579388, query_579389, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsList* = Call_MonitoringProjectsUptimeCheckConfigsList_579369(
    name: "monitoringProjectsUptimeCheckConfigsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsList_579370,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsList_579371,
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
