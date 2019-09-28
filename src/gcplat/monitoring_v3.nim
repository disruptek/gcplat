
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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
  gcpServiceName = "monitoring"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MonitoringUptimeCheckIpsList_579690 = ref object of OpenApiRestCall_579421
proc url_MonitoringUptimeCheckIpsList_579692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_MonitoringUptimeCheckIpsList_579691(path: JsonNode; query: JsonNode;
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
  var valid_579804 = query.getOrDefault("upload_protocol")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "upload_protocol", valid_579804
  var valid_579805 = query.getOrDefault("fields")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "fields", valid_579805
  var valid_579806 = query.getOrDefault("pageToken")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "pageToken", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("callback")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "callback", valid_579823
  var valid_579824 = query.getOrDefault("access_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "access_token", valid_579824
  var valid_579825 = query.getOrDefault("uploadType")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "uploadType", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("$.xgafv")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = newJString("1"))
  if valid_579827 != nil:
    section.add "$.xgafv", valid_579827
  var valid_579828 = query.getOrDefault("pageSize")
  valid_579828 = validateParameter(valid_579828, JInt, required = false, default = nil)
  if valid_579828 != nil:
    section.add "pageSize", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_MonitoringUptimeCheckIpsList_579690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of IP addresses that checkers run from
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_MonitoringUptimeCheckIpsList_579690;
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
  var query_579924 = newJObject()
  add(query_579924, "upload_protocol", newJString(uploadProtocol))
  add(query_579924, "fields", newJString(fields))
  add(query_579924, "pageToken", newJString(pageToken))
  add(query_579924, "quotaUser", newJString(quotaUser))
  add(query_579924, "alt", newJString(alt))
  add(query_579924, "oauth_token", newJString(oauthToken))
  add(query_579924, "callback", newJString(callback))
  add(query_579924, "access_token", newJString(accessToken))
  add(query_579924, "uploadType", newJString(uploadType))
  add(query_579924, "key", newJString(key))
  add(query_579924, "$.xgafv", newJString(Xgafv))
  add(query_579924, "pageSize", newJInt(pageSize))
  add(query_579924, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(nil, query_579924, nil, nil, nil)

var monitoringUptimeCheckIpsList* = Call_MonitoringUptimeCheckIpsList_579690(
    name: "monitoringUptimeCheckIpsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/uptimeCheckIps",
    validator: validate_MonitoringUptimeCheckIpsList_579691, base: "/",
    url: url_MonitoringUptimeCheckIpsList_579692, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsUpdate_579997 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsGroupsUpdate_579999(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsUpdate_579998(path: JsonNode;
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
  var valid_580000 = path.getOrDefault("name")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "name", valid_580000
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
  var valid_580001 = query.getOrDefault("upload_protocol")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "upload_protocol", valid_580001
  var valid_580002 = query.getOrDefault("fields")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "fields", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("alt")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("json"))
  if valid_580004 != nil:
    section.add "alt", valid_580004
  var valid_580005 = query.getOrDefault("oauth_token")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "oauth_token", valid_580005
  var valid_580006 = query.getOrDefault("callback")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "callback", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("uploadType")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "uploadType", valid_580008
  var valid_580009 = query.getOrDefault("validateOnly")
  valid_580009 = validateParameter(valid_580009, JBool, required = false, default = nil)
  if valid_580009 != nil:
    section.add "validateOnly", valid_580009
  var valid_580010 = query.getOrDefault("key")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "key", valid_580010
  var valid_580011 = query.getOrDefault("$.xgafv")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("1"))
  if valid_580011 != nil:
    section.add "$.xgafv", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
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

proc call*(call_580014: Call_MonitoringProjectsGroupsUpdate_579997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing group. You can change any group attributes except name.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_MonitoringProjectsGroupsUpdate_579997; name: string;
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
  var path_580016 = newJObject()
  var query_580017 = newJObject()
  var body_580018 = newJObject()
  add(query_580017, "upload_protocol", newJString(uploadProtocol))
  add(query_580017, "fields", newJString(fields))
  add(query_580017, "quotaUser", newJString(quotaUser))
  add(path_580016, "name", newJString(name))
  add(query_580017, "alt", newJString(alt))
  add(query_580017, "oauth_token", newJString(oauthToken))
  add(query_580017, "callback", newJString(callback))
  add(query_580017, "access_token", newJString(accessToken))
  add(query_580017, "uploadType", newJString(uploadType))
  add(query_580017, "validateOnly", newJBool(validateOnly))
  add(query_580017, "key", newJString(key))
  add(query_580017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580018 = body
  add(query_580017, "prettyPrint", newJBool(prettyPrint))
  result = call_580015.call(path_580016, query_580017, nil, nil, body_580018)

var monitoringProjectsGroupsUpdate* = Call_MonitoringProjectsGroupsUpdate_579997(
    name: "monitoringProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsGroupsUpdate_579998, base: "/",
    url: url_MonitoringProjectsGroupsUpdate_579999, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsGet_579964 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsMetricDescriptorsGet_579966(protocol: Scheme;
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

proc validate_MonitoringProjectsMetricDescriptorsGet_579965(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single metric descriptor. This method does not require a Stackdriver account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The metric descriptor on which to execute the request. The format is "projects/{project_id_or_number}/metricDescriptors/{metric_id}". An example value of {metric_id} is "compute.googleapis.com/instance/disk/read_bytes_count".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579981 = path.getOrDefault("name")
  valid_579981 = validateParameter(valid_579981, JString, required = true,
                                 default = nil)
  if valid_579981 != nil:
    section.add "name", valid_579981
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
  var valid_579982 = query.getOrDefault("upload_protocol")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "upload_protocol", valid_579982
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("callback")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "callback", valid_579987
  var valid_579988 = query.getOrDefault("access_token")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "access_token", valid_579988
  var valid_579989 = query.getOrDefault("uploadType")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "uploadType", valid_579989
  var valid_579990 = query.getOrDefault("key")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "key", valid_579990
  var valid_579991 = query.getOrDefault("$.xgafv")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("1"))
  if valid_579991 != nil:
    section.add "$.xgafv", valid_579991
  var valid_579992 = query.getOrDefault("prettyPrint")
  valid_579992 = validateParameter(valid_579992, JBool, required = false,
                                 default = newJBool(true))
  if valid_579992 != nil:
    section.add "prettyPrint", valid_579992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579993: Call_MonitoringProjectsMetricDescriptorsGet_579964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a single metric descriptor. This method does not require a Stackdriver account.
  ## 
  let valid = call_579993.validator(path, query, header, formData, body)
  let scheme = call_579993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579993.url(scheme.get, call_579993.host, call_579993.base,
                         call_579993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579993, url, valid)

proc call*(call_579994: Call_MonitoringProjectsMetricDescriptorsGet_579964;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## monitoringProjectsMetricDescriptorsGet
  ## Gets a single metric descriptor. This method does not require a Stackdriver account.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The metric descriptor on which to execute the request. The format is "projects/{project_id_or_number}/metricDescriptors/{metric_id}". An example value of {metric_id} is "compute.googleapis.com/instance/disk/read_bytes_count".
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
  var path_579995 = newJObject()
  var query_579996 = newJObject()
  add(query_579996, "upload_protocol", newJString(uploadProtocol))
  add(query_579996, "fields", newJString(fields))
  add(query_579996, "quotaUser", newJString(quotaUser))
  add(path_579995, "name", newJString(name))
  add(query_579996, "alt", newJString(alt))
  add(query_579996, "oauth_token", newJString(oauthToken))
  add(query_579996, "callback", newJString(callback))
  add(query_579996, "access_token", newJString(accessToken))
  add(query_579996, "uploadType", newJString(uploadType))
  add(query_579996, "key", newJString(key))
  add(query_579996, "$.xgafv", newJString(Xgafv))
  add(query_579996, "prettyPrint", newJBool(prettyPrint))
  result = call_579994.call(path_579995, query_579996, nil, nil, nil)

var monitoringProjectsMetricDescriptorsGet* = Call_MonitoringProjectsMetricDescriptorsGet_579964(
    name: "monitoringProjectsMetricDescriptorsGet", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsMetricDescriptorsGet_579965, base: "/",
    url: url_MonitoringProjectsMetricDescriptorsGet_579966,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesPatch_580039 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsAlertPoliciesPatch_580041(protocol: Scheme;
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

proc validate_MonitoringProjectsAlertPoliciesPatch_580040(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an alerting policy. You can either replace the entire policy with a new one or replace only certain fields in the current alerting policy by specifying the fields to be updated via updateMask. Returns the updated alerting policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required if the policy exists. The resource name for this policy. The syntax is:
  ## projects/[PROJECT_ID]/alertPolicies/[ALERT_POLICY_ID]
  ## [ALERT_POLICY_ID] is assigned by Stackdriver Monitoring when the policy is created. When calling the alertPolicies.create method, do not include the name field in the alerting policy passed as part of the request.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580042 = path.getOrDefault("name")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "name", valid_580042
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
  ##             : Optional. A list of alerting policy field names. If this field is not empty, each listed field in the existing alerting policy is set to the value of the corresponding field in the supplied policy (alert_policy), or to the field's default value if the field is not in the supplied alerting policy. Fields not listed retain their previous value.Examples of valid field masks include display_name, documentation, documentation.content, documentation.mime_type, user_labels, user_label.nameofkey, enabled, conditions, combiner, etc.If this field is empty, then the supplied alerting policy replaces the existing policy. It is the same as deleting the existing policy and adding the supplied policy, except for the following:
  ## The new policy will have the same [ALERT_POLICY_ID] as the former policy. This gives you continuity with the former policy in your notifications and incidents.
  ## Conditions in the new policy will keep their former [CONDITION_ID] if the supplied condition includes the name field with that [CONDITION_ID]. If the supplied condition omits the name field, then a new [CONDITION_ID] is created.
  section = newJObject()
  var valid_580043 = query.getOrDefault("upload_protocol")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "upload_protocol", valid_580043
  var valid_580044 = query.getOrDefault("fields")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "fields", valid_580044
  var valid_580045 = query.getOrDefault("quotaUser")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "quotaUser", valid_580045
  var valid_580046 = query.getOrDefault("alt")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("json"))
  if valid_580046 != nil:
    section.add "alt", valid_580046
  var valid_580047 = query.getOrDefault("oauth_token")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "oauth_token", valid_580047
  var valid_580048 = query.getOrDefault("callback")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "callback", valid_580048
  var valid_580049 = query.getOrDefault("access_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "access_token", valid_580049
  var valid_580050 = query.getOrDefault("uploadType")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "uploadType", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("$.xgafv")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = newJString("1"))
  if valid_580052 != nil:
    section.add "$.xgafv", valid_580052
  var valid_580053 = query.getOrDefault("prettyPrint")
  valid_580053 = validateParameter(valid_580053, JBool, required = false,
                                 default = newJBool(true))
  if valid_580053 != nil:
    section.add "prettyPrint", valid_580053
  var valid_580054 = query.getOrDefault("updateMask")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "updateMask", valid_580054
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

proc call*(call_580056: Call_MonitoringProjectsAlertPoliciesPatch_580039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an alerting policy. You can either replace the entire policy with a new one or replace only certain fields in the current alerting policy by specifying the fields to be updated via updateMask. Returns the updated alerting policy.
  ## 
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_MonitoringProjectsAlertPoliciesPatch_580039;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## monitoringProjectsAlertPoliciesPatch
  ## Updates an alerting policy. You can either replace the entire policy with a new one or replace only certain fields in the current alerting policy by specifying the fields to be updated via updateMask. Returns the updated alerting policy.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required if the policy exists. The resource name for this policy. The syntax is:
  ## projects/[PROJECT_ID]/alertPolicies/[ALERT_POLICY_ID]
  ## [ALERT_POLICY_ID] is assigned by Stackdriver Monitoring when the policy is created. When calling the alertPolicies.create method, do not include the name field in the alerting policy passed as part of the request.
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
  ##             : Optional. A list of alerting policy field names. If this field is not empty, each listed field in the existing alerting policy is set to the value of the corresponding field in the supplied policy (alert_policy), or to the field's default value if the field is not in the supplied alerting policy. Fields not listed retain their previous value.Examples of valid field masks include display_name, documentation, documentation.content, documentation.mime_type, user_labels, user_label.nameofkey, enabled, conditions, combiner, etc.If this field is empty, then the supplied alerting policy replaces the existing policy. It is the same as deleting the existing policy and adding the supplied policy, except for the following:
  ## The new policy will have the same [ALERT_POLICY_ID] as the former policy. This gives you continuity with the former policy in your notifications and incidents.
  ## Conditions in the new policy will keep their former [CONDITION_ID] if the supplied condition includes the name field with that [CONDITION_ID]. If the supplied condition omits the name field, then a new [CONDITION_ID] is created.
  var path_580058 = newJObject()
  var query_580059 = newJObject()
  var body_580060 = newJObject()
  add(query_580059, "upload_protocol", newJString(uploadProtocol))
  add(query_580059, "fields", newJString(fields))
  add(query_580059, "quotaUser", newJString(quotaUser))
  add(path_580058, "name", newJString(name))
  add(query_580059, "alt", newJString(alt))
  add(query_580059, "oauth_token", newJString(oauthToken))
  add(query_580059, "callback", newJString(callback))
  add(query_580059, "access_token", newJString(accessToken))
  add(query_580059, "uploadType", newJString(uploadType))
  add(query_580059, "key", newJString(key))
  add(query_580059, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580060 = body
  add(query_580059, "prettyPrint", newJBool(prettyPrint))
  add(query_580059, "updateMask", newJString(updateMask))
  result = call_580057.call(path_580058, query_580059, nil, nil, body_580060)

var monitoringProjectsAlertPoliciesPatch* = Call_MonitoringProjectsAlertPoliciesPatch_580039(
    name: "monitoringProjectsAlertPoliciesPatch", meth: HttpMethod.HttpPatch,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsAlertPoliciesPatch_580040, base: "/",
    url: url_MonitoringProjectsAlertPoliciesPatch_580041, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsDelete_580019 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsMetricDescriptorsDelete_580021(protocol: Scheme;
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

proc validate_MonitoringProjectsMetricDescriptorsDelete_580020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a metric descriptor. Only user-created custom metrics can be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The metric descriptor on which to execute the request. The format is "projects/{project_id_or_number}/metricDescriptors/{metric_id}". An example of {metric_id} is: "custom.googleapis.com/my_test_metric".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580022 = path.getOrDefault("name")
  valid_580022 = validateParameter(valid_580022, JString, required = true,
                                 default = nil)
  if valid_580022 != nil:
    section.add "name", valid_580022
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
  var valid_580023 = query.getOrDefault("upload_protocol")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "upload_protocol", valid_580023
  var valid_580024 = query.getOrDefault("fields")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "fields", valid_580024
  var valid_580025 = query.getOrDefault("force")
  valid_580025 = validateParameter(valid_580025, JBool, required = false, default = nil)
  if valid_580025 != nil:
    section.add "force", valid_580025
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

proc call*(call_580035: Call_MonitoringProjectsMetricDescriptorsDelete_580019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a metric descriptor. Only user-created custom metrics can be deleted.
  ## 
  let valid = call_580035.validator(path, query, header, formData, body)
  let scheme = call_580035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580035.url(scheme.get, call_580035.host, call_580035.base,
                         call_580035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580035, url, valid)

proc call*(call_580036: Call_MonitoringProjectsMetricDescriptorsDelete_580019;
          name: string; uploadProtocol: string = ""; fields: string = "";
          force: bool = false; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## monitoringProjectsMetricDescriptorsDelete
  ## Deletes a metric descriptor. Only user-created custom metrics can be deleted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   force: bool
  ##        : If true, the notification channel will be deleted regardless of its use in alert policies (the policies will be updated to remove the channel). If false, channels that are still referenced by an existing alerting policy will fail to be deleted in a delete operation.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The metric descriptor on which to execute the request. The format is "projects/{project_id_or_number}/metricDescriptors/{metric_id}". An example of {metric_id} is: "custom.googleapis.com/my_test_metric".
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
  var path_580037 = newJObject()
  var query_580038 = newJObject()
  add(query_580038, "upload_protocol", newJString(uploadProtocol))
  add(query_580038, "fields", newJString(fields))
  add(query_580038, "force", newJBool(force))
  add(query_580038, "quotaUser", newJString(quotaUser))
  add(path_580037, "name", newJString(name))
  add(query_580038, "alt", newJString(alt))
  add(query_580038, "oauth_token", newJString(oauthToken))
  add(query_580038, "callback", newJString(callback))
  add(query_580038, "access_token", newJString(accessToken))
  add(query_580038, "uploadType", newJString(uploadType))
  add(query_580038, "key", newJString(key))
  add(query_580038, "$.xgafv", newJString(Xgafv))
  add(query_580038, "prettyPrint", newJBool(prettyPrint))
  result = call_580036.call(path_580037, query_580038, nil, nil, nil)

var monitoringProjectsMetricDescriptorsDelete* = Call_MonitoringProjectsMetricDescriptorsDelete_580019(
    name: "monitoringProjectsMetricDescriptorsDelete",
    meth: HttpMethod.HttpDelete, host: "monitoring.googleapis.com",
    route: "/v3/{name}",
    validator: validate_MonitoringProjectsMetricDescriptorsDelete_580020,
    base: "/", url: url_MonitoringProjectsMetricDescriptorsDelete_580021,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesCreate_580084 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsAlertPoliciesCreate_580086(protocol: Scheme;
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

proc validate_MonitoringProjectsAlertPoliciesCreate_580085(path: JsonNode;
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
  var valid_580087 = path.getOrDefault("name")
  valid_580087 = validateParameter(valid_580087, JString, required = true,
                                 default = nil)
  if valid_580087 != nil:
    section.add "name", valid_580087
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
  var valid_580088 = query.getOrDefault("upload_protocol")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "upload_protocol", valid_580088
  var valid_580089 = query.getOrDefault("fields")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "fields", valid_580089
  var valid_580090 = query.getOrDefault("quotaUser")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "quotaUser", valid_580090
  var valid_580091 = query.getOrDefault("alt")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("json"))
  if valid_580091 != nil:
    section.add "alt", valid_580091
  var valid_580092 = query.getOrDefault("oauth_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "oauth_token", valid_580092
  var valid_580093 = query.getOrDefault("callback")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "callback", valid_580093
  var valid_580094 = query.getOrDefault("access_token")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "access_token", valid_580094
  var valid_580095 = query.getOrDefault("uploadType")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "uploadType", valid_580095
  var valid_580096 = query.getOrDefault("key")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "key", valid_580096
  var valid_580097 = query.getOrDefault("$.xgafv")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("1"))
  if valid_580097 != nil:
    section.add "$.xgafv", valid_580097
  var valid_580098 = query.getOrDefault("prettyPrint")
  valid_580098 = validateParameter(valid_580098, JBool, required = false,
                                 default = newJBool(true))
  if valid_580098 != nil:
    section.add "prettyPrint", valid_580098
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

proc call*(call_580100: Call_MonitoringProjectsAlertPoliciesCreate_580084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new alerting policy.
  ## 
  let valid = call_580100.validator(path, query, header, formData, body)
  let scheme = call_580100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580100.url(scheme.get, call_580100.host, call_580100.base,
                         call_580100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580100, url, valid)

proc call*(call_580101: Call_MonitoringProjectsAlertPoliciesCreate_580084;
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
  var path_580102 = newJObject()
  var query_580103 = newJObject()
  var body_580104 = newJObject()
  add(query_580103, "upload_protocol", newJString(uploadProtocol))
  add(query_580103, "fields", newJString(fields))
  add(query_580103, "quotaUser", newJString(quotaUser))
  add(path_580102, "name", newJString(name))
  add(query_580103, "alt", newJString(alt))
  add(query_580103, "oauth_token", newJString(oauthToken))
  add(query_580103, "callback", newJString(callback))
  add(query_580103, "access_token", newJString(accessToken))
  add(query_580103, "uploadType", newJString(uploadType))
  add(query_580103, "key", newJString(key))
  add(query_580103, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580104 = body
  add(query_580103, "prettyPrint", newJBool(prettyPrint))
  result = call_580101.call(path_580102, query_580103, nil, nil, body_580104)

var monitoringProjectsAlertPoliciesCreate* = Call_MonitoringProjectsAlertPoliciesCreate_580084(
    name: "monitoringProjectsAlertPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesCreate_580085, base: "/",
    url: url_MonitoringProjectsAlertPoliciesCreate_580086, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesList_580061 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsAlertPoliciesList_580063(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsAlertPoliciesList_580062(path: JsonNode;
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
  var valid_580064 = path.getOrDefault("name")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "name", valid_580064
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
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("pageToken")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "pageToken", valid_580067
  var valid_580068 = query.getOrDefault("quotaUser")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "quotaUser", valid_580068
  var valid_580069 = query.getOrDefault("alt")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("json"))
  if valid_580069 != nil:
    section.add "alt", valid_580069
  var valid_580070 = query.getOrDefault("oauth_token")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "oauth_token", valid_580070
  var valid_580071 = query.getOrDefault("callback")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "callback", valid_580071
  var valid_580072 = query.getOrDefault("access_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "access_token", valid_580072
  var valid_580073 = query.getOrDefault("uploadType")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "uploadType", valid_580073
  var valid_580074 = query.getOrDefault("orderBy")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "orderBy", valid_580074
  var valid_580075 = query.getOrDefault("key")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "key", valid_580075
  var valid_580076 = query.getOrDefault("$.xgafv")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("1"))
  if valid_580076 != nil:
    section.add "$.xgafv", valid_580076
  var valid_580077 = query.getOrDefault("pageSize")
  valid_580077 = validateParameter(valid_580077, JInt, required = false, default = nil)
  if valid_580077 != nil:
    section.add "pageSize", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
  var valid_580079 = query.getOrDefault("filter")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "filter", valid_580079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580080: Call_MonitoringProjectsAlertPoliciesList_580061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing alerting policies for the project.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_MonitoringProjectsAlertPoliciesList_580061;
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
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  add(query_580083, "upload_protocol", newJString(uploadProtocol))
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "pageToken", newJString(pageToken))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(path_580082, "name", newJString(name))
  add(query_580083, "alt", newJString(alt))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "callback", newJString(callback))
  add(query_580083, "access_token", newJString(accessToken))
  add(query_580083, "uploadType", newJString(uploadType))
  add(query_580083, "orderBy", newJString(orderBy))
  add(query_580083, "key", newJString(key))
  add(query_580083, "$.xgafv", newJString(Xgafv))
  add(query_580083, "pageSize", newJInt(pageSize))
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  add(query_580083, "filter", newJString(filter))
  result = call_580081.call(path_580082, query_580083, nil, nil, nil)

var monitoringProjectsAlertPoliciesList* = Call_MonitoringProjectsAlertPoliciesList_580061(
    name: "monitoringProjectsAlertPoliciesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesList_580062, base: "/",
    url: url_MonitoringProjectsAlertPoliciesList_580063, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsCollectdTimeSeriesCreate_580105 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsCollectdTimeSeriesCreate_580107(protocol: Scheme;
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

proc validate_MonitoringProjectsCollectdTimeSeriesCreate_580106(path: JsonNode;
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
  var valid_580108 = path.getOrDefault("name")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "name", valid_580108
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
  var valid_580109 = query.getOrDefault("upload_protocol")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "upload_protocol", valid_580109
  var valid_580110 = query.getOrDefault("fields")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "fields", valid_580110
  var valid_580111 = query.getOrDefault("quotaUser")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "quotaUser", valid_580111
  var valid_580112 = query.getOrDefault("alt")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("json"))
  if valid_580112 != nil:
    section.add "alt", valid_580112
  var valid_580113 = query.getOrDefault("oauth_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "oauth_token", valid_580113
  var valid_580114 = query.getOrDefault("callback")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "callback", valid_580114
  var valid_580115 = query.getOrDefault("access_token")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "access_token", valid_580115
  var valid_580116 = query.getOrDefault("uploadType")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "uploadType", valid_580116
  var valid_580117 = query.getOrDefault("key")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "key", valid_580117
  var valid_580118 = query.getOrDefault("$.xgafv")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("1"))
  if valid_580118 != nil:
    section.add "$.xgafv", valid_580118
  var valid_580119 = query.getOrDefault("prettyPrint")
  valid_580119 = validateParameter(valid_580119, JBool, required = false,
                                 default = newJBool(true))
  if valid_580119 != nil:
    section.add "prettyPrint", valid_580119
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

proc call*(call_580121: Call_MonitoringProjectsCollectdTimeSeriesCreate_580105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_MonitoringProjectsCollectdTimeSeriesCreate_580105;
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
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  var body_580125 = newJObject()
  add(query_580124, "upload_protocol", newJString(uploadProtocol))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(path_580123, "name", newJString(name))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "callback", newJString(callback))
  add(query_580124, "access_token", newJString(accessToken))
  add(query_580124, "uploadType", newJString(uploadType))
  add(query_580124, "key", newJString(key))
  add(query_580124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580125 = body
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  result = call_580122.call(path_580123, query_580124, nil, nil, body_580125)

var monitoringProjectsCollectdTimeSeriesCreate* = Call_MonitoringProjectsCollectdTimeSeriesCreate_580105(
    name: "monitoringProjectsCollectdTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/collectdTimeSeries",
    validator: validate_MonitoringProjectsCollectdTimeSeriesCreate_580106,
    base: "/", url: url_MonitoringProjectsCollectdTimeSeriesCreate_580107,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsCreate_580150 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsGroupsCreate_580152(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsCreate_580151(path: JsonNode;
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
  var valid_580153 = path.getOrDefault("name")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "name", valid_580153
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
  var valid_580154 = query.getOrDefault("upload_protocol")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "upload_protocol", valid_580154
  var valid_580155 = query.getOrDefault("fields")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "fields", valid_580155
  var valid_580156 = query.getOrDefault("quotaUser")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "quotaUser", valid_580156
  var valid_580157 = query.getOrDefault("alt")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("json"))
  if valid_580157 != nil:
    section.add "alt", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("callback")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "callback", valid_580159
  var valid_580160 = query.getOrDefault("access_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "access_token", valid_580160
  var valid_580161 = query.getOrDefault("uploadType")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "uploadType", valid_580161
  var valid_580162 = query.getOrDefault("validateOnly")
  valid_580162 = validateParameter(valid_580162, JBool, required = false, default = nil)
  if valid_580162 != nil:
    section.add "validateOnly", valid_580162
  var valid_580163 = query.getOrDefault("key")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "key", valid_580163
  var valid_580164 = query.getOrDefault("$.xgafv")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("1"))
  if valid_580164 != nil:
    section.add "$.xgafv", valid_580164
  var valid_580165 = query.getOrDefault("prettyPrint")
  valid_580165 = validateParameter(valid_580165, JBool, required = false,
                                 default = newJBool(true))
  if valid_580165 != nil:
    section.add "prettyPrint", valid_580165
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

proc call*(call_580167: Call_MonitoringProjectsGroupsCreate_580150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new group.
  ## 
  let valid = call_580167.validator(path, query, header, formData, body)
  let scheme = call_580167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580167.url(scheme.get, call_580167.host, call_580167.base,
                         call_580167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580167, url, valid)

proc call*(call_580168: Call_MonitoringProjectsGroupsCreate_580150; name: string;
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
  var path_580169 = newJObject()
  var query_580170 = newJObject()
  var body_580171 = newJObject()
  add(query_580170, "upload_protocol", newJString(uploadProtocol))
  add(query_580170, "fields", newJString(fields))
  add(query_580170, "quotaUser", newJString(quotaUser))
  add(path_580169, "name", newJString(name))
  add(query_580170, "alt", newJString(alt))
  add(query_580170, "oauth_token", newJString(oauthToken))
  add(query_580170, "callback", newJString(callback))
  add(query_580170, "access_token", newJString(accessToken))
  add(query_580170, "uploadType", newJString(uploadType))
  add(query_580170, "validateOnly", newJBool(validateOnly))
  add(query_580170, "key", newJString(key))
  add(query_580170, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580171 = body
  add(query_580170, "prettyPrint", newJBool(prettyPrint))
  result = call_580168.call(path_580169, query_580170, nil, nil, body_580171)

var monitoringProjectsGroupsCreate* = Call_MonitoringProjectsGroupsCreate_580150(
    name: "monitoringProjectsGroupsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsCreate_580151, base: "/",
    url: url_MonitoringProjectsGroupsCreate_580152, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsList_580126 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsGroupsList_580128(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsList_580127(path: JsonNode; query: JsonNode;
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
  var valid_580129 = path.getOrDefault("name")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "name", valid_580129
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
  var valid_580130 = query.getOrDefault("upload_protocol")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "upload_protocol", valid_580130
  var valid_580131 = query.getOrDefault("fields")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "fields", valid_580131
  var valid_580132 = query.getOrDefault("pageToken")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "pageToken", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("childrenOfGroup")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "childrenOfGroup", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("callback")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "callback", valid_580137
  var valid_580138 = query.getOrDefault("access_token")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "access_token", valid_580138
  var valid_580139 = query.getOrDefault("uploadType")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "uploadType", valid_580139
  var valid_580140 = query.getOrDefault("descendantsOfGroup")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "descendantsOfGroup", valid_580140
  var valid_580141 = query.getOrDefault("key")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "key", valid_580141
  var valid_580142 = query.getOrDefault("$.xgafv")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("1"))
  if valid_580142 != nil:
    section.add "$.xgafv", valid_580142
  var valid_580143 = query.getOrDefault("pageSize")
  valid_580143 = validateParameter(valid_580143, JInt, required = false, default = nil)
  if valid_580143 != nil:
    section.add "pageSize", valid_580143
  var valid_580144 = query.getOrDefault("prettyPrint")
  valid_580144 = validateParameter(valid_580144, JBool, required = false,
                                 default = newJBool(true))
  if valid_580144 != nil:
    section.add "prettyPrint", valid_580144
  var valid_580145 = query.getOrDefault("ancestorsOfGroup")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "ancestorsOfGroup", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_MonitoringProjectsGroupsList_580126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing groups.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_MonitoringProjectsGroupsList_580126; name: string;
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
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(query_580149, "upload_protocol", newJString(uploadProtocol))
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "pageToken", newJString(pageToken))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(path_580148, "name", newJString(name))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "childrenOfGroup", newJString(childrenOfGroup))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "callback", newJString(callback))
  add(query_580149, "access_token", newJString(accessToken))
  add(query_580149, "uploadType", newJString(uploadType))
  add(query_580149, "descendantsOfGroup", newJString(descendantsOfGroup))
  add(query_580149, "key", newJString(key))
  add(query_580149, "$.xgafv", newJString(Xgafv))
  add(query_580149, "pageSize", newJInt(pageSize))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  add(query_580149, "ancestorsOfGroup", newJString(ancestorsOfGroup))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var monitoringProjectsGroupsList* = Call_MonitoringProjectsGroupsList_580126(
    name: "monitoringProjectsGroupsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsList_580127, base: "/",
    url: url_MonitoringProjectsGroupsList_580128, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsMembersList_580172 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsGroupsMembersList_580174(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsGroupsMembersList_580173(path: JsonNode;
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
  var valid_580175 = path.getOrDefault("name")
  valid_580175 = validateParameter(valid_580175, JString, required = true,
                                 default = nil)
  if valid_580175 != nil:
    section.add "name", valid_580175
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
  var valid_580176 = query.getOrDefault("upload_protocol")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "upload_protocol", valid_580176
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
  var valid_580178 = query.getOrDefault("pageToken")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "pageToken", valid_580178
  var valid_580179 = query.getOrDefault("quotaUser")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "quotaUser", valid_580179
  var valid_580180 = query.getOrDefault("alt")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("json"))
  if valid_580180 != nil:
    section.add "alt", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("callback")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "callback", valid_580182
  var valid_580183 = query.getOrDefault("access_token")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "access_token", valid_580183
  var valid_580184 = query.getOrDefault("uploadType")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "uploadType", valid_580184
  var valid_580185 = query.getOrDefault("interval.endTime")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "interval.endTime", valid_580185
  var valid_580186 = query.getOrDefault("key")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "key", valid_580186
  var valid_580187 = query.getOrDefault("$.xgafv")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("1"))
  if valid_580187 != nil:
    section.add "$.xgafv", valid_580187
  var valid_580188 = query.getOrDefault("pageSize")
  valid_580188 = validateParameter(valid_580188, JInt, required = false, default = nil)
  if valid_580188 != nil:
    section.add "pageSize", valid_580188
  var valid_580189 = query.getOrDefault("prettyPrint")
  valid_580189 = validateParameter(valid_580189, JBool, required = false,
                                 default = newJBool(true))
  if valid_580189 != nil:
    section.add "prettyPrint", valid_580189
  var valid_580190 = query.getOrDefault("interval.startTime")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "interval.startTime", valid_580190
  var valid_580191 = query.getOrDefault("filter")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "filter", valid_580191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580192: Call_MonitoringProjectsGroupsMembersList_580172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the monitored resources that are members of a group.
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_MonitoringProjectsGroupsMembersList_580172;
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
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  add(query_580195, "upload_protocol", newJString(uploadProtocol))
  add(query_580195, "fields", newJString(fields))
  add(query_580195, "pageToken", newJString(pageToken))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(path_580194, "name", newJString(name))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "callback", newJString(callback))
  add(query_580195, "access_token", newJString(accessToken))
  add(query_580195, "uploadType", newJString(uploadType))
  add(query_580195, "interval.endTime", newJString(intervalEndTime))
  add(query_580195, "key", newJString(key))
  add(query_580195, "$.xgafv", newJString(Xgafv))
  add(query_580195, "pageSize", newJInt(pageSize))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "interval.startTime", newJString(intervalStartTime))
  add(query_580195, "filter", newJString(filter))
  result = call_580193.call(path_580194, query_580195, nil, nil, nil)

var monitoringProjectsGroupsMembersList* = Call_MonitoringProjectsGroupsMembersList_580172(
    name: "monitoringProjectsGroupsMembersList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/members",
    validator: validate_MonitoringProjectsGroupsMembersList_580173, base: "/",
    url: url_MonitoringProjectsGroupsMembersList_580174, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsCreate_580218 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsMetricDescriptorsCreate_580220(protocol: Scheme;
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

proc validate_MonitoringProjectsMetricDescriptorsCreate_580219(path: JsonNode;
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
  var valid_580221 = path.getOrDefault("name")
  valid_580221 = validateParameter(valid_580221, JString, required = true,
                                 default = nil)
  if valid_580221 != nil:
    section.add "name", valid_580221
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
  var valid_580222 = query.getOrDefault("upload_protocol")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "upload_protocol", valid_580222
  var valid_580223 = query.getOrDefault("fields")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "fields", valid_580223
  var valid_580224 = query.getOrDefault("quotaUser")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "quotaUser", valid_580224
  var valid_580225 = query.getOrDefault("alt")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = newJString("json"))
  if valid_580225 != nil:
    section.add "alt", valid_580225
  var valid_580226 = query.getOrDefault("oauth_token")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "oauth_token", valid_580226
  var valid_580227 = query.getOrDefault("callback")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "callback", valid_580227
  var valid_580228 = query.getOrDefault("access_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "access_token", valid_580228
  var valid_580229 = query.getOrDefault("uploadType")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "uploadType", valid_580229
  var valid_580230 = query.getOrDefault("key")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "key", valid_580230
  var valid_580231 = query.getOrDefault("$.xgafv")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("1"))
  if valid_580231 != nil:
    section.add "$.xgafv", valid_580231
  var valid_580232 = query.getOrDefault("prettyPrint")
  valid_580232 = validateParameter(valid_580232, JBool, required = false,
                                 default = newJBool(true))
  if valid_580232 != nil:
    section.add "prettyPrint", valid_580232
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

proc call*(call_580234: Call_MonitoringProjectsMetricDescriptorsCreate_580218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
  ## 
  let valid = call_580234.validator(path, query, header, formData, body)
  let scheme = call_580234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580234.url(scheme.get, call_580234.host, call_580234.base,
                         call_580234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580234, url, valid)

proc call*(call_580235: Call_MonitoringProjectsMetricDescriptorsCreate_580218;
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
  var path_580236 = newJObject()
  var query_580237 = newJObject()
  var body_580238 = newJObject()
  add(query_580237, "upload_protocol", newJString(uploadProtocol))
  add(query_580237, "fields", newJString(fields))
  add(query_580237, "quotaUser", newJString(quotaUser))
  add(path_580236, "name", newJString(name))
  add(query_580237, "alt", newJString(alt))
  add(query_580237, "oauth_token", newJString(oauthToken))
  add(query_580237, "callback", newJString(callback))
  add(query_580237, "access_token", newJString(accessToken))
  add(query_580237, "uploadType", newJString(uploadType))
  add(query_580237, "key", newJString(key))
  add(query_580237, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580238 = body
  add(query_580237, "prettyPrint", newJBool(prettyPrint))
  result = call_580235.call(path_580236, query_580237, nil, nil, body_580238)

var monitoringProjectsMetricDescriptorsCreate* = Call_MonitoringProjectsMetricDescriptorsCreate_580218(
    name: "monitoringProjectsMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsCreate_580219,
    base: "/", url: url_MonitoringProjectsMetricDescriptorsCreate_580220,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsList_580196 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsMetricDescriptorsList_580198(protocol: Scheme;
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

proc validate_MonitoringProjectsMetricDescriptorsList_580197(path: JsonNode;
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
  var valid_580199 = path.getOrDefault("name")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "name", valid_580199
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
  var valid_580200 = query.getOrDefault("upload_protocol")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "upload_protocol", valid_580200
  var valid_580201 = query.getOrDefault("fields")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "fields", valid_580201
  var valid_580202 = query.getOrDefault("pageToken")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "pageToken", valid_580202
  var valid_580203 = query.getOrDefault("quotaUser")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "quotaUser", valid_580203
  var valid_580204 = query.getOrDefault("alt")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = newJString("json"))
  if valid_580204 != nil:
    section.add "alt", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("callback")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "callback", valid_580206
  var valid_580207 = query.getOrDefault("access_token")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "access_token", valid_580207
  var valid_580208 = query.getOrDefault("uploadType")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "uploadType", valid_580208
  var valid_580209 = query.getOrDefault("key")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "key", valid_580209
  var valid_580210 = query.getOrDefault("$.xgafv")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = newJString("1"))
  if valid_580210 != nil:
    section.add "$.xgafv", valid_580210
  var valid_580211 = query.getOrDefault("pageSize")
  valid_580211 = validateParameter(valid_580211, JInt, required = false, default = nil)
  if valid_580211 != nil:
    section.add "pageSize", valid_580211
  var valid_580212 = query.getOrDefault("prettyPrint")
  valid_580212 = validateParameter(valid_580212, JBool, required = false,
                                 default = newJBool(true))
  if valid_580212 != nil:
    section.add "prettyPrint", valid_580212
  var valid_580213 = query.getOrDefault("filter")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "filter", valid_580213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580214: Call_MonitoringProjectsMetricDescriptorsList_580196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_580214.validator(path, query, header, formData, body)
  let scheme = call_580214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580214.url(scheme.get, call_580214.host, call_580214.base,
                         call_580214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580214, url, valid)

proc call*(call_580215: Call_MonitoringProjectsMetricDescriptorsList_580196;
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
  var path_580216 = newJObject()
  var query_580217 = newJObject()
  add(query_580217, "upload_protocol", newJString(uploadProtocol))
  add(query_580217, "fields", newJString(fields))
  add(query_580217, "pageToken", newJString(pageToken))
  add(query_580217, "quotaUser", newJString(quotaUser))
  add(path_580216, "name", newJString(name))
  add(query_580217, "alt", newJString(alt))
  add(query_580217, "oauth_token", newJString(oauthToken))
  add(query_580217, "callback", newJString(callback))
  add(query_580217, "access_token", newJString(accessToken))
  add(query_580217, "uploadType", newJString(uploadType))
  add(query_580217, "key", newJString(key))
  add(query_580217, "$.xgafv", newJString(Xgafv))
  add(query_580217, "pageSize", newJInt(pageSize))
  add(query_580217, "prettyPrint", newJBool(prettyPrint))
  add(query_580217, "filter", newJString(filter))
  result = call_580215.call(path_580216, query_580217, nil, nil, nil)

var monitoringProjectsMetricDescriptorsList* = Call_MonitoringProjectsMetricDescriptorsList_580196(
    name: "monitoringProjectsMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsList_580197, base: "/",
    url: url_MonitoringProjectsMetricDescriptorsList_580198,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMonitoredResourceDescriptorsList_580239 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsMonitoredResourceDescriptorsList_580241(
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

proc validate_MonitoringProjectsMonitoredResourceDescriptorsList_580240(
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
  var valid_580242 = path.getOrDefault("name")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "name", valid_580242
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
  var valid_580243 = query.getOrDefault("upload_protocol")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "upload_protocol", valid_580243
  var valid_580244 = query.getOrDefault("fields")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "fields", valid_580244
  var valid_580245 = query.getOrDefault("pageToken")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "pageToken", valid_580245
  var valid_580246 = query.getOrDefault("quotaUser")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "quotaUser", valid_580246
  var valid_580247 = query.getOrDefault("alt")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = newJString("json"))
  if valid_580247 != nil:
    section.add "alt", valid_580247
  var valid_580248 = query.getOrDefault("oauth_token")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "oauth_token", valid_580248
  var valid_580249 = query.getOrDefault("callback")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "callback", valid_580249
  var valid_580250 = query.getOrDefault("access_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "access_token", valid_580250
  var valid_580251 = query.getOrDefault("uploadType")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "uploadType", valid_580251
  var valid_580252 = query.getOrDefault("key")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "key", valid_580252
  var valid_580253 = query.getOrDefault("$.xgafv")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("1"))
  if valid_580253 != nil:
    section.add "$.xgafv", valid_580253
  var valid_580254 = query.getOrDefault("pageSize")
  valid_580254 = validateParameter(valid_580254, JInt, required = false, default = nil)
  if valid_580254 != nil:
    section.add "pageSize", valid_580254
  var valid_580255 = query.getOrDefault("prettyPrint")
  valid_580255 = validateParameter(valid_580255, JBool, required = false,
                                 default = newJBool(true))
  if valid_580255 != nil:
    section.add "prettyPrint", valid_580255
  var valid_580256 = query.getOrDefault("filter")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "filter", valid_580256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580257: Call_MonitoringProjectsMonitoredResourceDescriptorsList_580239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_580257.validator(path, query, header, formData, body)
  let scheme = call_580257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580257.url(scheme.get, call_580257.host, call_580257.base,
                         call_580257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580257, url, valid)

proc call*(call_580258: Call_MonitoringProjectsMonitoredResourceDescriptorsList_580239;
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
  var path_580259 = newJObject()
  var query_580260 = newJObject()
  add(query_580260, "upload_protocol", newJString(uploadProtocol))
  add(query_580260, "fields", newJString(fields))
  add(query_580260, "pageToken", newJString(pageToken))
  add(query_580260, "quotaUser", newJString(quotaUser))
  add(path_580259, "name", newJString(name))
  add(query_580260, "alt", newJString(alt))
  add(query_580260, "oauth_token", newJString(oauthToken))
  add(query_580260, "callback", newJString(callback))
  add(query_580260, "access_token", newJString(accessToken))
  add(query_580260, "uploadType", newJString(uploadType))
  add(query_580260, "key", newJString(key))
  add(query_580260, "$.xgafv", newJString(Xgafv))
  add(query_580260, "pageSize", newJInt(pageSize))
  add(query_580260, "prettyPrint", newJBool(prettyPrint))
  add(query_580260, "filter", newJString(filter))
  result = call_580258.call(path_580259, query_580260, nil, nil, nil)

var monitoringProjectsMonitoredResourceDescriptorsList* = Call_MonitoringProjectsMonitoredResourceDescriptorsList_580239(
    name: "monitoringProjectsMonitoredResourceDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/monitoredResourceDescriptors",
    validator: validate_MonitoringProjectsMonitoredResourceDescriptorsList_580240,
    base: "/", url: url_MonitoringProjectsMonitoredResourceDescriptorsList_580241,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelDescriptorsList_580261 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsNotificationChannelDescriptorsList_580263(
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

proc validate_MonitoringProjectsNotificationChannelDescriptorsList_580262(
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
  var valid_580264 = path.getOrDefault("name")
  valid_580264 = validateParameter(valid_580264, JString, required = true,
                                 default = nil)
  if valid_580264 != nil:
    section.add "name", valid_580264
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
  var valid_580265 = query.getOrDefault("upload_protocol")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "upload_protocol", valid_580265
  var valid_580266 = query.getOrDefault("fields")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "fields", valid_580266
  var valid_580267 = query.getOrDefault("pageToken")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "pageToken", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("alt")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("json"))
  if valid_580269 != nil:
    section.add "alt", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("callback")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "callback", valid_580271
  var valid_580272 = query.getOrDefault("access_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "access_token", valid_580272
  var valid_580273 = query.getOrDefault("uploadType")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "uploadType", valid_580273
  var valid_580274 = query.getOrDefault("key")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "key", valid_580274
  var valid_580275 = query.getOrDefault("$.xgafv")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = newJString("1"))
  if valid_580275 != nil:
    section.add "$.xgafv", valid_580275
  var valid_580276 = query.getOrDefault("pageSize")
  valid_580276 = validateParameter(valid_580276, JInt, required = false, default = nil)
  if valid_580276 != nil:
    section.add "pageSize", valid_580276
  var valid_580277 = query.getOrDefault("prettyPrint")
  valid_580277 = validateParameter(valid_580277, JBool, required = false,
                                 default = newJBool(true))
  if valid_580277 != nil:
    section.add "prettyPrint", valid_580277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580278: Call_MonitoringProjectsNotificationChannelDescriptorsList_580261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ## 
  let valid = call_580278.validator(path, query, header, formData, body)
  let scheme = call_580278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580278.url(scheme.get, call_580278.host, call_580278.base,
                         call_580278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580278, url, valid)

proc call*(call_580279: Call_MonitoringProjectsNotificationChannelDescriptorsList_580261;
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
  var path_580280 = newJObject()
  var query_580281 = newJObject()
  add(query_580281, "upload_protocol", newJString(uploadProtocol))
  add(query_580281, "fields", newJString(fields))
  add(query_580281, "pageToken", newJString(pageToken))
  add(query_580281, "quotaUser", newJString(quotaUser))
  add(path_580280, "name", newJString(name))
  add(query_580281, "alt", newJString(alt))
  add(query_580281, "oauth_token", newJString(oauthToken))
  add(query_580281, "callback", newJString(callback))
  add(query_580281, "access_token", newJString(accessToken))
  add(query_580281, "uploadType", newJString(uploadType))
  add(query_580281, "key", newJString(key))
  add(query_580281, "$.xgafv", newJString(Xgafv))
  add(query_580281, "pageSize", newJInt(pageSize))
  add(query_580281, "prettyPrint", newJBool(prettyPrint))
  result = call_580279.call(path_580280, query_580281, nil, nil, nil)

var monitoringProjectsNotificationChannelDescriptorsList* = Call_MonitoringProjectsNotificationChannelDescriptorsList_580261(
    name: "monitoringProjectsNotificationChannelDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannelDescriptors",
    validator: validate_MonitoringProjectsNotificationChannelDescriptorsList_580262,
    base: "/", url: url_MonitoringProjectsNotificationChannelDescriptorsList_580263,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsCreate_580305 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsNotificationChannelsCreate_580307(protocol: Scheme;
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

proc validate_MonitoringProjectsNotificationChannelsCreate_580306(path: JsonNode;
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
  var valid_580308 = path.getOrDefault("name")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "name", valid_580308
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
  var valid_580309 = query.getOrDefault("upload_protocol")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "upload_protocol", valid_580309
  var valid_580310 = query.getOrDefault("fields")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "fields", valid_580310
  var valid_580311 = query.getOrDefault("quotaUser")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "quotaUser", valid_580311
  var valid_580312 = query.getOrDefault("alt")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = newJString("json"))
  if valid_580312 != nil:
    section.add "alt", valid_580312
  var valid_580313 = query.getOrDefault("oauth_token")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "oauth_token", valid_580313
  var valid_580314 = query.getOrDefault("callback")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "callback", valid_580314
  var valid_580315 = query.getOrDefault("access_token")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "access_token", valid_580315
  var valid_580316 = query.getOrDefault("uploadType")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "uploadType", valid_580316
  var valid_580317 = query.getOrDefault("key")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "key", valid_580317
  var valid_580318 = query.getOrDefault("$.xgafv")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = newJString("1"))
  if valid_580318 != nil:
    section.add "$.xgafv", valid_580318
  var valid_580319 = query.getOrDefault("prettyPrint")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "prettyPrint", valid_580319
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

proc call*(call_580321: Call_MonitoringProjectsNotificationChannelsCreate_580305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
  ## 
  let valid = call_580321.validator(path, query, header, formData, body)
  let scheme = call_580321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580321.url(scheme.get, call_580321.host, call_580321.base,
                         call_580321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580321, url, valid)

proc call*(call_580322: Call_MonitoringProjectsNotificationChannelsCreate_580305;
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
  var path_580323 = newJObject()
  var query_580324 = newJObject()
  var body_580325 = newJObject()
  add(query_580324, "upload_protocol", newJString(uploadProtocol))
  add(query_580324, "fields", newJString(fields))
  add(query_580324, "quotaUser", newJString(quotaUser))
  add(path_580323, "name", newJString(name))
  add(query_580324, "alt", newJString(alt))
  add(query_580324, "oauth_token", newJString(oauthToken))
  add(query_580324, "callback", newJString(callback))
  add(query_580324, "access_token", newJString(accessToken))
  add(query_580324, "uploadType", newJString(uploadType))
  add(query_580324, "key", newJString(key))
  add(query_580324, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580325 = body
  add(query_580324, "prettyPrint", newJBool(prettyPrint))
  result = call_580322.call(path_580323, query_580324, nil, nil, body_580325)

var monitoringProjectsNotificationChannelsCreate* = Call_MonitoringProjectsNotificationChannelsCreate_580305(
    name: "monitoringProjectsNotificationChannelsCreate",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsCreate_580306,
    base: "/", url: url_MonitoringProjectsNotificationChannelsCreate_580307,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsList_580282 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsNotificationChannelsList_580284(protocol: Scheme;
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

proc validate_MonitoringProjectsNotificationChannelsList_580283(path: JsonNode;
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
  var valid_580285 = path.getOrDefault("name")
  valid_580285 = validateParameter(valid_580285, JString, required = true,
                                 default = nil)
  if valid_580285 != nil:
    section.add "name", valid_580285
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
  var valid_580286 = query.getOrDefault("upload_protocol")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "upload_protocol", valid_580286
  var valid_580287 = query.getOrDefault("fields")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "fields", valid_580287
  var valid_580288 = query.getOrDefault("pageToken")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "pageToken", valid_580288
  var valid_580289 = query.getOrDefault("quotaUser")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "quotaUser", valid_580289
  var valid_580290 = query.getOrDefault("alt")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = newJString("json"))
  if valid_580290 != nil:
    section.add "alt", valid_580290
  var valid_580291 = query.getOrDefault("oauth_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "oauth_token", valid_580291
  var valid_580292 = query.getOrDefault("callback")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "callback", valid_580292
  var valid_580293 = query.getOrDefault("access_token")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "access_token", valid_580293
  var valid_580294 = query.getOrDefault("uploadType")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "uploadType", valid_580294
  var valid_580295 = query.getOrDefault("orderBy")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "orderBy", valid_580295
  var valid_580296 = query.getOrDefault("key")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "key", valid_580296
  var valid_580297 = query.getOrDefault("$.xgafv")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = newJString("1"))
  if valid_580297 != nil:
    section.add "$.xgafv", valid_580297
  var valid_580298 = query.getOrDefault("pageSize")
  valid_580298 = validateParameter(valid_580298, JInt, required = false, default = nil)
  if valid_580298 != nil:
    section.add "pageSize", valid_580298
  var valid_580299 = query.getOrDefault("prettyPrint")
  valid_580299 = validateParameter(valid_580299, JBool, required = false,
                                 default = newJBool(true))
  if valid_580299 != nil:
    section.add "prettyPrint", valid_580299
  var valid_580300 = query.getOrDefault("filter")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "filter", valid_580300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580301: Call_MonitoringProjectsNotificationChannelsList_580282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the notification channels that have been created for the project.
  ## 
  let valid = call_580301.validator(path, query, header, formData, body)
  let scheme = call_580301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580301.url(scheme.get, call_580301.host, call_580301.base,
                         call_580301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580301, url, valid)

proc call*(call_580302: Call_MonitoringProjectsNotificationChannelsList_580282;
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
  var path_580303 = newJObject()
  var query_580304 = newJObject()
  add(query_580304, "upload_protocol", newJString(uploadProtocol))
  add(query_580304, "fields", newJString(fields))
  add(query_580304, "pageToken", newJString(pageToken))
  add(query_580304, "quotaUser", newJString(quotaUser))
  add(path_580303, "name", newJString(name))
  add(query_580304, "alt", newJString(alt))
  add(query_580304, "oauth_token", newJString(oauthToken))
  add(query_580304, "callback", newJString(callback))
  add(query_580304, "access_token", newJString(accessToken))
  add(query_580304, "uploadType", newJString(uploadType))
  add(query_580304, "orderBy", newJString(orderBy))
  add(query_580304, "key", newJString(key))
  add(query_580304, "$.xgafv", newJString(Xgafv))
  add(query_580304, "pageSize", newJInt(pageSize))
  add(query_580304, "prettyPrint", newJBool(prettyPrint))
  add(query_580304, "filter", newJString(filter))
  result = call_580302.call(path_580303, query_580304, nil, nil, nil)

var monitoringProjectsNotificationChannelsList* = Call_MonitoringProjectsNotificationChannelsList_580282(
    name: "monitoringProjectsNotificationChannelsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsList_580283,
    base: "/", url: url_MonitoringProjectsNotificationChannelsList_580284,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesCreate_580356 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsTimeSeriesCreate_580358(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsTimeSeriesCreate_580357(path: JsonNode;
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
  var valid_580359 = path.getOrDefault("name")
  valid_580359 = validateParameter(valid_580359, JString, required = true,
                                 default = nil)
  if valid_580359 != nil:
    section.add "name", valid_580359
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
  var valid_580360 = query.getOrDefault("upload_protocol")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "upload_protocol", valid_580360
  var valid_580361 = query.getOrDefault("fields")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "fields", valid_580361
  var valid_580362 = query.getOrDefault("quotaUser")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "quotaUser", valid_580362
  var valid_580363 = query.getOrDefault("alt")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("json"))
  if valid_580363 != nil:
    section.add "alt", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("callback")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "callback", valid_580365
  var valid_580366 = query.getOrDefault("access_token")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "access_token", valid_580366
  var valid_580367 = query.getOrDefault("uploadType")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "uploadType", valid_580367
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("$.xgafv")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("1"))
  if valid_580369 != nil:
    section.add "$.xgafv", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
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

proc call*(call_580372: Call_MonitoringProjectsTimeSeriesCreate_580356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
  ## 
  let valid = call_580372.validator(path, query, header, formData, body)
  let scheme = call_580372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580372.url(scheme.get, call_580372.host, call_580372.base,
                         call_580372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580372, url, valid)

proc call*(call_580373: Call_MonitoringProjectsTimeSeriesCreate_580356;
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
  var path_580374 = newJObject()
  var query_580375 = newJObject()
  var body_580376 = newJObject()
  add(query_580375, "upload_protocol", newJString(uploadProtocol))
  add(query_580375, "fields", newJString(fields))
  add(query_580375, "quotaUser", newJString(quotaUser))
  add(path_580374, "name", newJString(name))
  add(query_580375, "alt", newJString(alt))
  add(query_580375, "oauth_token", newJString(oauthToken))
  add(query_580375, "callback", newJString(callback))
  add(query_580375, "access_token", newJString(accessToken))
  add(query_580375, "uploadType", newJString(uploadType))
  add(query_580375, "key", newJString(key))
  add(query_580375, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580376 = body
  add(query_580375, "prettyPrint", newJBool(prettyPrint))
  result = call_580373.call(path_580374, query_580375, nil, nil, body_580376)

var monitoringProjectsTimeSeriesCreate* = Call_MonitoringProjectsTimeSeriesCreate_580356(
    name: "monitoringProjectsTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesCreate_580357, base: "/",
    url: url_MonitoringProjectsTimeSeriesCreate_580358, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesList_580326 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsTimeSeriesList_580328(protocol: Scheme; host: string;
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

proc validate_MonitoringProjectsTimeSeriesList_580327(path: JsonNode;
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
  var valid_580329 = path.getOrDefault("name")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "name", valid_580329
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
  var valid_580330 = query.getOrDefault("upload_protocol")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "upload_protocol", valid_580330
  var valid_580331 = query.getOrDefault("fields")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "fields", valid_580331
  var valid_580332 = query.getOrDefault("pageToken")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "pageToken", valid_580332
  var valid_580333 = query.getOrDefault("quotaUser")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "quotaUser", valid_580333
  var valid_580334 = query.getOrDefault("view")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = newJString("FULL"))
  if valid_580334 != nil:
    section.add "view", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("aggregation.alignmentPeriod")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "aggregation.alignmentPeriod", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("callback")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "callback", valid_580338
  var valid_580339 = query.getOrDefault("access_token")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "access_token", valid_580339
  var valid_580340 = query.getOrDefault("uploadType")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "uploadType", valid_580340
  var valid_580341 = query.getOrDefault("aggregation.crossSeriesReducer")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = newJString("REDUCE_NONE"))
  if valid_580341 != nil:
    section.add "aggregation.crossSeriesReducer", valid_580341
  var valid_580342 = query.getOrDefault("interval.endTime")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "interval.endTime", valid_580342
  var valid_580343 = query.getOrDefault("orderBy")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "orderBy", valid_580343
  var valid_580344 = query.getOrDefault("key")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "key", valid_580344
  var valid_580345 = query.getOrDefault("$.xgafv")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = newJString("1"))
  if valid_580345 != nil:
    section.add "$.xgafv", valid_580345
  var valid_580346 = query.getOrDefault("pageSize")
  valid_580346 = validateParameter(valid_580346, JInt, required = false, default = nil)
  if valid_580346 != nil:
    section.add "pageSize", valid_580346
  var valid_580347 = query.getOrDefault("aggregation.perSeriesAligner")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = newJString("ALIGN_NONE"))
  if valid_580347 != nil:
    section.add "aggregation.perSeriesAligner", valid_580347
  var valid_580348 = query.getOrDefault("aggregation.groupByFields")
  valid_580348 = validateParameter(valid_580348, JArray, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "aggregation.groupByFields", valid_580348
  var valid_580349 = query.getOrDefault("prettyPrint")
  valid_580349 = validateParameter(valid_580349, JBool, required = false,
                                 default = newJBool(true))
  if valid_580349 != nil:
    section.add "prettyPrint", valid_580349
  var valid_580350 = query.getOrDefault("interval.startTime")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "interval.startTime", valid_580350
  var valid_580351 = query.getOrDefault("filter")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "filter", valid_580351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580352: Call_MonitoringProjectsTimeSeriesList_580326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_580352.validator(path, query, header, formData, body)
  let scheme = call_580352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580352.url(scheme.get, call_580352.host, call_580352.base,
                         call_580352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580352, url, valid)

proc call*(call_580353: Call_MonitoringProjectsTimeSeriesList_580326; name: string;
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
  var path_580354 = newJObject()
  var query_580355 = newJObject()
  add(query_580355, "upload_protocol", newJString(uploadProtocol))
  add(query_580355, "fields", newJString(fields))
  add(query_580355, "pageToken", newJString(pageToken))
  add(query_580355, "quotaUser", newJString(quotaUser))
  add(query_580355, "view", newJString(view))
  add(path_580354, "name", newJString(name))
  add(query_580355, "alt", newJString(alt))
  add(query_580355, "aggregation.alignmentPeriod",
      newJString(aggregationAlignmentPeriod))
  add(query_580355, "oauth_token", newJString(oauthToken))
  add(query_580355, "callback", newJString(callback))
  add(query_580355, "access_token", newJString(accessToken))
  add(query_580355, "uploadType", newJString(uploadType))
  add(query_580355, "aggregation.crossSeriesReducer",
      newJString(aggregationCrossSeriesReducer))
  add(query_580355, "interval.endTime", newJString(intervalEndTime))
  add(query_580355, "orderBy", newJString(orderBy))
  add(query_580355, "key", newJString(key))
  add(query_580355, "$.xgafv", newJString(Xgafv))
  add(query_580355, "pageSize", newJInt(pageSize))
  add(query_580355, "aggregation.perSeriesAligner",
      newJString(aggregationPerSeriesAligner))
  if aggregationGroupByFields != nil:
    query_580355.add "aggregation.groupByFields", aggregationGroupByFields
  add(query_580355, "prettyPrint", newJBool(prettyPrint))
  add(query_580355, "interval.startTime", newJString(intervalStartTime))
  add(query_580355, "filter", newJString(filter))
  result = call_580353.call(path_580354, query_580355, nil, nil, nil)

var monitoringProjectsTimeSeriesList* = Call_MonitoringProjectsTimeSeriesList_580326(
    name: "monitoringProjectsTimeSeriesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesList_580327, base: "/",
    url: url_MonitoringProjectsTimeSeriesList_580328, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580377 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsNotificationChannelsGetVerificationCode_580379(
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

proc validate_MonitoringProjectsNotificationChannelsGetVerificationCode_580378(
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
  var valid_580380 = path.getOrDefault("name")
  valid_580380 = validateParameter(valid_580380, JString, required = true,
                                 default = nil)
  if valid_580380 != nil:
    section.add "name", valid_580380
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
  var valid_580381 = query.getOrDefault("upload_protocol")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "upload_protocol", valid_580381
  var valid_580382 = query.getOrDefault("fields")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "fields", valid_580382
  var valid_580383 = query.getOrDefault("quotaUser")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "quotaUser", valid_580383
  var valid_580384 = query.getOrDefault("alt")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = newJString("json"))
  if valid_580384 != nil:
    section.add "alt", valid_580384
  var valid_580385 = query.getOrDefault("oauth_token")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "oauth_token", valid_580385
  var valid_580386 = query.getOrDefault("callback")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "callback", valid_580386
  var valid_580387 = query.getOrDefault("access_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "access_token", valid_580387
  var valid_580388 = query.getOrDefault("uploadType")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "uploadType", valid_580388
  var valid_580389 = query.getOrDefault("key")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "key", valid_580389
  var valid_580390 = query.getOrDefault("$.xgafv")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("1"))
  if valid_580390 != nil:
    section.add "$.xgafv", valid_580390
  var valid_580391 = query.getOrDefault("prettyPrint")
  valid_580391 = validateParameter(valid_580391, JBool, required = false,
                                 default = newJBool(true))
  if valid_580391 != nil:
    section.add "prettyPrint", valid_580391
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

proc call*(call_580393: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
  ## 
  let valid = call_580393.validator(path, query, header, formData, body)
  let scheme = call_580393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580393.url(scheme.get, call_580393.host, call_580393.base,
                         call_580393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580393, url, valid)

proc call*(call_580394: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580377;
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
  var path_580395 = newJObject()
  var query_580396 = newJObject()
  var body_580397 = newJObject()
  add(query_580396, "upload_protocol", newJString(uploadProtocol))
  add(query_580396, "fields", newJString(fields))
  add(query_580396, "quotaUser", newJString(quotaUser))
  add(path_580395, "name", newJString(name))
  add(query_580396, "alt", newJString(alt))
  add(query_580396, "oauth_token", newJString(oauthToken))
  add(query_580396, "callback", newJString(callback))
  add(query_580396, "access_token", newJString(accessToken))
  add(query_580396, "uploadType", newJString(uploadType))
  add(query_580396, "key", newJString(key))
  add(query_580396, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580397 = body
  add(query_580396, "prettyPrint", newJBool(prettyPrint))
  result = call_580394.call(path_580395, query_580396, nil, nil, body_580397)

var monitoringProjectsNotificationChannelsGetVerificationCode* = Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580377(
    name: "monitoringProjectsNotificationChannelsGetVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:getVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsGetVerificationCode_580378,
    base: "/", url: url_MonitoringProjectsNotificationChannelsGetVerificationCode_580379,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580398 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsNotificationChannelsSendVerificationCode_580400(
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

proc validate_MonitoringProjectsNotificationChannelsSendVerificationCode_580399(
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
  var valid_580401 = path.getOrDefault("name")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = nil)
  if valid_580401 != nil:
    section.add "name", valid_580401
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
  var valid_580402 = query.getOrDefault("upload_protocol")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "upload_protocol", valid_580402
  var valid_580403 = query.getOrDefault("fields")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "fields", valid_580403
  var valid_580404 = query.getOrDefault("quotaUser")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "quotaUser", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("oauth_token")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "oauth_token", valid_580406
  var valid_580407 = query.getOrDefault("callback")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "callback", valid_580407
  var valid_580408 = query.getOrDefault("access_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "access_token", valid_580408
  var valid_580409 = query.getOrDefault("uploadType")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "uploadType", valid_580409
  var valid_580410 = query.getOrDefault("key")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "key", valid_580410
  var valid_580411 = query.getOrDefault("$.xgafv")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = newJString("1"))
  if valid_580411 != nil:
    section.add "$.xgafv", valid_580411
  var valid_580412 = query.getOrDefault("prettyPrint")
  valid_580412 = validateParameter(valid_580412, JBool, required = false,
                                 default = newJBool(true))
  if valid_580412 != nil:
    section.add "prettyPrint", valid_580412
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

proc call*(call_580414: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
  ## 
  let valid = call_580414.validator(path, query, header, formData, body)
  let scheme = call_580414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580414.url(scheme.get, call_580414.host, call_580414.base,
                         call_580414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580414, url, valid)

proc call*(call_580415: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580398;
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
  var path_580416 = newJObject()
  var query_580417 = newJObject()
  var body_580418 = newJObject()
  add(query_580417, "upload_protocol", newJString(uploadProtocol))
  add(query_580417, "fields", newJString(fields))
  add(query_580417, "quotaUser", newJString(quotaUser))
  add(path_580416, "name", newJString(name))
  add(query_580417, "alt", newJString(alt))
  add(query_580417, "oauth_token", newJString(oauthToken))
  add(query_580417, "callback", newJString(callback))
  add(query_580417, "access_token", newJString(accessToken))
  add(query_580417, "uploadType", newJString(uploadType))
  add(query_580417, "key", newJString(key))
  add(query_580417, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580418 = body
  add(query_580417, "prettyPrint", newJBool(prettyPrint))
  result = call_580415.call(path_580416, query_580417, nil, nil, body_580418)

var monitoringProjectsNotificationChannelsSendVerificationCode* = Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580398(
    name: "monitoringProjectsNotificationChannelsSendVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:sendVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsSendVerificationCode_580399,
    base: "/",
    url: url_MonitoringProjectsNotificationChannelsSendVerificationCode_580400,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsVerify_580419 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsNotificationChannelsVerify_580421(protocol: Scheme;
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

proc validate_MonitoringProjectsNotificationChannelsVerify_580420(path: JsonNode;
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
  var valid_580422 = path.getOrDefault("name")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "name", valid_580422
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
  var valid_580423 = query.getOrDefault("upload_protocol")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "upload_protocol", valid_580423
  var valid_580424 = query.getOrDefault("fields")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "fields", valid_580424
  var valid_580425 = query.getOrDefault("quotaUser")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "quotaUser", valid_580425
  var valid_580426 = query.getOrDefault("alt")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("json"))
  if valid_580426 != nil:
    section.add "alt", valid_580426
  var valid_580427 = query.getOrDefault("oauth_token")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "oauth_token", valid_580427
  var valid_580428 = query.getOrDefault("callback")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "callback", valid_580428
  var valid_580429 = query.getOrDefault("access_token")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "access_token", valid_580429
  var valid_580430 = query.getOrDefault("uploadType")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "uploadType", valid_580430
  var valid_580431 = query.getOrDefault("key")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "key", valid_580431
  var valid_580432 = query.getOrDefault("$.xgafv")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = newJString("1"))
  if valid_580432 != nil:
    section.add "$.xgafv", valid_580432
  var valid_580433 = query.getOrDefault("prettyPrint")
  valid_580433 = validateParameter(valid_580433, JBool, required = false,
                                 default = newJBool(true))
  if valid_580433 != nil:
    section.add "prettyPrint", valid_580433
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

proc call*(call_580435: Call_MonitoringProjectsNotificationChannelsVerify_580419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
  ## 
  let valid = call_580435.validator(path, query, header, formData, body)
  let scheme = call_580435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580435.url(scheme.get, call_580435.host, call_580435.base,
                         call_580435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580435, url, valid)

proc call*(call_580436: Call_MonitoringProjectsNotificationChannelsVerify_580419;
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
  var path_580437 = newJObject()
  var query_580438 = newJObject()
  var body_580439 = newJObject()
  add(query_580438, "upload_protocol", newJString(uploadProtocol))
  add(query_580438, "fields", newJString(fields))
  add(query_580438, "quotaUser", newJString(quotaUser))
  add(path_580437, "name", newJString(name))
  add(query_580438, "alt", newJString(alt))
  add(query_580438, "oauth_token", newJString(oauthToken))
  add(query_580438, "callback", newJString(callback))
  add(query_580438, "access_token", newJString(accessToken))
  add(query_580438, "uploadType", newJString(uploadType))
  add(query_580438, "key", newJString(key))
  add(query_580438, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580439 = body
  add(query_580438, "prettyPrint", newJBool(prettyPrint))
  result = call_580436.call(path_580437, query_580438, nil, nil, body_580439)

var monitoringProjectsNotificationChannelsVerify* = Call_MonitoringProjectsNotificationChannelsVerify_580419(
    name: "monitoringProjectsNotificationChannelsVerify",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:verify",
    validator: validate_MonitoringProjectsNotificationChannelsVerify_580420,
    base: "/", url: url_MonitoringProjectsNotificationChannelsVerify_580421,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsCreate_580461 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsUptimeCheckConfigsCreate_580463(protocol: Scheme;
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

proc validate_MonitoringProjectsUptimeCheckConfigsCreate_580462(path: JsonNode;
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
  var valid_580464 = path.getOrDefault("parent")
  valid_580464 = validateParameter(valid_580464, JString, required = true,
                                 default = nil)
  if valid_580464 != nil:
    section.add "parent", valid_580464
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
  var valid_580465 = query.getOrDefault("upload_protocol")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "upload_protocol", valid_580465
  var valid_580466 = query.getOrDefault("fields")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "fields", valid_580466
  var valid_580467 = query.getOrDefault("quotaUser")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "quotaUser", valid_580467
  var valid_580468 = query.getOrDefault("alt")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = newJString("json"))
  if valid_580468 != nil:
    section.add "alt", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("callback")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "callback", valid_580470
  var valid_580471 = query.getOrDefault("access_token")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "access_token", valid_580471
  var valid_580472 = query.getOrDefault("uploadType")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "uploadType", valid_580472
  var valid_580473 = query.getOrDefault("key")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "key", valid_580473
  var valid_580474 = query.getOrDefault("$.xgafv")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = newJString("1"))
  if valid_580474 != nil:
    section.add "$.xgafv", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
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

proc call*(call_580477: Call_MonitoringProjectsUptimeCheckConfigsCreate_580461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Uptime check configuration.
  ## 
  let valid = call_580477.validator(path, query, header, formData, body)
  let scheme = call_580477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580477.url(scheme.get, call_580477.host, call_580477.base,
                         call_580477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580477, url, valid)

proc call*(call_580478: Call_MonitoringProjectsUptimeCheckConfigsCreate_580461;
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
  var path_580479 = newJObject()
  var query_580480 = newJObject()
  var body_580481 = newJObject()
  add(query_580480, "upload_protocol", newJString(uploadProtocol))
  add(query_580480, "fields", newJString(fields))
  add(query_580480, "quotaUser", newJString(quotaUser))
  add(query_580480, "alt", newJString(alt))
  add(query_580480, "oauth_token", newJString(oauthToken))
  add(query_580480, "callback", newJString(callback))
  add(query_580480, "access_token", newJString(accessToken))
  add(query_580480, "uploadType", newJString(uploadType))
  add(path_580479, "parent", newJString(parent))
  add(query_580480, "key", newJString(key))
  add(query_580480, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580481 = body
  add(query_580480, "prettyPrint", newJBool(prettyPrint))
  result = call_580478.call(path_580479, query_580480, nil, nil, body_580481)

var monitoringProjectsUptimeCheckConfigsCreate* = Call_MonitoringProjectsUptimeCheckConfigsCreate_580461(
    name: "monitoringProjectsUptimeCheckConfigsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsCreate_580462,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsCreate_580463,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsList_580440 = ref object of OpenApiRestCall_579421
proc url_MonitoringProjectsUptimeCheckConfigsList_580442(protocol: Scheme;
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

proc validate_MonitoringProjectsUptimeCheckConfigsList_580441(path: JsonNode;
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
  var valid_580443 = path.getOrDefault("parent")
  valid_580443 = validateParameter(valid_580443, JString, required = true,
                                 default = nil)
  if valid_580443 != nil:
    section.add "parent", valid_580443
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
  var valid_580444 = query.getOrDefault("upload_protocol")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = nil)
  if valid_580444 != nil:
    section.add "upload_protocol", valid_580444
  var valid_580445 = query.getOrDefault("fields")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "fields", valid_580445
  var valid_580446 = query.getOrDefault("pageToken")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "pageToken", valid_580446
  var valid_580447 = query.getOrDefault("quotaUser")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "quotaUser", valid_580447
  var valid_580448 = query.getOrDefault("alt")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = newJString("json"))
  if valid_580448 != nil:
    section.add "alt", valid_580448
  var valid_580449 = query.getOrDefault("oauth_token")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "oauth_token", valid_580449
  var valid_580450 = query.getOrDefault("callback")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "callback", valid_580450
  var valid_580451 = query.getOrDefault("access_token")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "access_token", valid_580451
  var valid_580452 = query.getOrDefault("uploadType")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "uploadType", valid_580452
  var valid_580453 = query.getOrDefault("key")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "key", valid_580453
  var valid_580454 = query.getOrDefault("$.xgafv")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = newJString("1"))
  if valid_580454 != nil:
    section.add "$.xgafv", valid_580454
  var valid_580455 = query.getOrDefault("pageSize")
  valid_580455 = validateParameter(valid_580455, JInt, required = false, default = nil)
  if valid_580455 != nil:
    section.add "pageSize", valid_580455
  var valid_580456 = query.getOrDefault("prettyPrint")
  valid_580456 = validateParameter(valid_580456, JBool, required = false,
                                 default = newJBool(true))
  if valid_580456 != nil:
    section.add "prettyPrint", valid_580456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580457: Call_MonitoringProjectsUptimeCheckConfigsList_580440;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ## 
  let valid = call_580457.validator(path, query, header, formData, body)
  let scheme = call_580457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580457.url(scheme.get, call_580457.host, call_580457.base,
                         call_580457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580457, url, valid)

proc call*(call_580458: Call_MonitoringProjectsUptimeCheckConfigsList_580440;
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
  var path_580459 = newJObject()
  var query_580460 = newJObject()
  add(query_580460, "upload_protocol", newJString(uploadProtocol))
  add(query_580460, "fields", newJString(fields))
  add(query_580460, "pageToken", newJString(pageToken))
  add(query_580460, "quotaUser", newJString(quotaUser))
  add(query_580460, "alt", newJString(alt))
  add(query_580460, "oauth_token", newJString(oauthToken))
  add(query_580460, "callback", newJString(callback))
  add(query_580460, "access_token", newJString(accessToken))
  add(query_580460, "uploadType", newJString(uploadType))
  add(path_580459, "parent", newJString(parent))
  add(query_580460, "key", newJString(key))
  add(query_580460, "$.xgafv", newJString(Xgafv))
  add(query_580460, "pageSize", newJInt(pageSize))
  add(query_580460, "prettyPrint", newJBool(prettyPrint))
  result = call_580458.call(path_580459, query_580460, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsList* = Call_MonitoringProjectsUptimeCheckConfigsList_580440(
    name: "monitoringProjectsUptimeCheckConfigsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsList_580441,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsList_580442,
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
