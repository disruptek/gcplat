
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_MonitoringUptimeCheckIpsList_593690 = ref object of OpenApiRestCall_593421
proc url_MonitoringUptimeCheckIpsList_593692(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_MonitoringUptimeCheckIpsList_593691(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("pageToken")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "pageToken", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("oauth_token")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "oauth_token", valid_593822
  var valid_593823 = query.getOrDefault("callback")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "callback", valid_593823
  var valid_593824 = query.getOrDefault("access_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "access_token", valid_593824
  var valid_593825 = query.getOrDefault("uploadType")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "uploadType", valid_593825
  var valid_593826 = query.getOrDefault("key")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "key", valid_593826
  var valid_593827 = query.getOrDefault("$.xgafv")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = newJString("1"))
  if valid_593827 != nil:
    section.add "$.xgafv", valid_593827
  var valid_593828 = query.getOrDefault("pageSize")
  valid_593828 = validateParameter(valid_593828, JInt, required = false, default = nil)
  if valid_593828 != nil:
    section.add "pageSize", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_MonitoringUptimeCheckIpsList_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of IP addresses that checkers run from
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_MonitoringUptimeCheckIpsList_593690;
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
  var query_593924 = newJObject()
  add(query_593924, "upload_protocol", newJString(uploadProtocol))
  add(query_593924, "fields", newJString(fields))
  add(query_593924, "pageToken", newJString(pageToken))
  add(query_593924, "quotaUser", newJString(quotaUser))
  add(query_593924, "alt", newJString(alt))
  add(query_593924, "oauth_token", newJString(oauthToken))
  add(query_593924, "callback", newJString(callback))
  add(query_593924, "access_token", newJString(accessToken))
  add(query_593924, "uploadType", newJString(uploadType))
  add(query_593924, "key", newJString(key))
  add(query_593924, "$.xgafv", newJString(Xgafv))
  add(query_593924, "pageSize", newJInt(pageSize))
  add(query_593924, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(nil, query_593924, nil, nil, nil)

var monitoringUptimeCheckIpsList* = Call_MonitoringUptimeCheckIpsList_593690(
    name: "monitoringUptimeCheckIpsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/uptimeCheckIps",
    validator: validate_MonitoringUptimeCheckIpsList_593691, base: "/",
    url: url_MonitoringUptimeCheckIpsList_593692, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsUpdate_593997 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsGroupsUpdate_593999(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsUpdate_593998(path: JsonNode;
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
  var valid_594000 = path.getOrDefault("name")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "name", valid_594000
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
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("callback")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "callback", valid_594006
  var valid_594007 = query.getOrDefault("access_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "access_token", valid_594007
  var valid_594008 = query.getOrDefault("uploadType")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "uploadType", valid_594008
  var valid_594009 = query.getOrDefault("validateOnly")
  valid_594009 = validateParameter(valid_594009, JBool, required = false, default = nil)
  if valid_594009 != nil:
    section.add "validateOnly", valid_594009
  var valid_594010 = query.getOrDefault("key")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "key", valid_594010
  var valid_594011 = query.getOrDefault("$.xgafv")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = newJString("1"))
  if valid_594011 != nil:
    section.add "$.xgafv", valid_594011
  var valid_594012 = query.getOrDefault("prettyPrint")
  valid_594012 = validateParameter(valid_594012, JBool, required = false,
                                 default = newJBool(true))
  if valid_594012 != nil:
    section.add "prettyPrint", valid_594012
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

proc call*(call_594014: Call_MonitoringProjectsGroupsUpdate_593997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing group. You can change any group attributes except name.
  ## 
  let valid = call_594014.validator(path, query, header, formData, body)
  let scheme = call_594014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594014.url(scheme.get, call_594014.host, call_594014.base,
                         call_594014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594014, url, valid)

proc call*(call_594015: Call_MonitoringProjectsGroupsUpdate_593997; name: string;
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
  var path_594016 = newJObject()
  var query_594017 = newJObject()
  var body_594018 = newJObject()
  add(query_594017, "upload_protocol", newJString(uploadProtocol))
  add(query_594017, "fields", newJString(fields))
  add(query_594017, "quotaUser", newJString(quotaUser))
  add(path_594016, "name", newJString(name))
  add(query_594017, "alt", newJString(alt))
  add(query_594017, "oauth_token", newJString(oauthToken))
  add(query_594017, "callback", newJString(callback))
  add(query_594017, "access_token", newJString(accessToken))
  add(query_594017, "uploadType", newJString(uploadType))
  add(query_594017, "validateOnly", newJBool(validateOnly))
  add(query_594017, "key", newJString(key))
  add(query_594017, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594018 = body
  add(query_594017, "prettyPrint", newJBool(prettyPrint))
  result = call_594015.call(path_594016, query_594017, nil, nil, body_594018)

var monitoringProjectsGroupsUpdate* = Call_MonitoringProjectsGroupsUpdate_593997(
    name: "monitoringProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsGroupsUpdate_593998, base: "/",
    url: url_MonitoringProjectsGroupsUpdate_593999, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsGet_593964 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsMetricDescriptorsGet_593966(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsMetricDescriptorsGet_593965(path: JsonNode;
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
  var valid_593981 = path.getOrDefault("name")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "name", valid_593981
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
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_MonitoringProjectsMetricDescriptorsGet_593964;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a single metric descriptor. This method does not require a Stackdriver account.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_MonitoringProjectsMetricDescriptorsGet_593964;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(path_593995, "name", newJString(name))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var monitoringProjectsMetricDescriptorsGet* = Call_MonitoringProjectsMetricDescriptorsGet_593964(
    name: "monitoringProjectsMetricDescriptorsGet", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsMetricDescriptorsGet_593965, base: "/",
    url: url_MonitoringProjectsMetricDescriptorsGet_593966,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesPatch_594039 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsAlertPoliciesPatch_594041(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsAlertPoliciesPatch_594040(path: JsonNode;
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
  var valid_594042 = path.getOrDefault("name")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "name", valid_594042
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
  var valid_594043 = query.getOrDefault("upload_protocol")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "upload_protocol", valid_594043
  var valid_594044 = query.getOrDefault("fields")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "fields", valid_594044
  var valid_594045 = query.getOrDefault("quotaUser")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "quotaUser", valid_594045
  var valid_594046 = query.getOrDefault("alt")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = newJString("json"))
  if valid_594046 != nil:
    section.add "alt", valid_594046
  var valid_594047 = query.getOrDefault("oauth_token")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "oauth_token", valid_594047
  var valid_594048 = query.getOrDefault("callback")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "callback", valid_594048
  var valid_594049 = query.getOrDefault("access_token")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "access_token", valid_594049
  var valid_594050 = query.getOrDefault("uploadType")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "uploadType", valid_594050
  var valid_594051 = query.getOrDefault("key")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "key", valid_594051
  var valid_594052 = query.getOrDefault("$.xgafv")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = newJString("1"))
  if valid_594052 != nil:
    section.add "$.xgafv", valid_594052
  var valid_594053 = query.getOrDefault("prettyPrint")
  valid_594053 = validateParameter(valid_594053, JBool, required = false,
                                 default = newJBool(true))
  if valid_594053 != nil:
    section.add "prettyPrint", valid_594053
  var valid_594054 = query.getOrDefault("updateMask")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "updateMask", valid_594054
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

proc call*(call_594056: Call_MonitoringProjectsAlertPoliciesPatch_594039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an alerting policy. You can either replace the entire policy with a new one or replace only certain fields in the current alerting policy by specifying the fields to be updated via updateMask. Returns the updated alerting policy.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_MonitoringProjectsAlertPoliciesPatch_594039;
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
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  var body_594060 = newJObject()
  add(query_594059, "upload_protocol", newJString(uploadProtocol))
  add(query_594059, "fields", newJString(fields))
  add(query_594059, "quotaUser", newJString(quotaUser))
  add(path_594058, "name", newJString(name))
  add(query_594059, "alt", newJString(alt))
  add(query_594059, "oauth_token", newJString(oauthToken))
  add(query_594059, "callback", newJString(callback))
  add(query_594059, "access_token", newJString(accessToken))
  add(query_594059, "uploadType", newJString(uploadType))
  add(query_594059, "key", newJString(key))
  add(query_594059, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594060 = body
  add(query_594059, "prettyPrint", newJBool(prettyPrint))
  add(query_594059, "updateMask", newJString(updateMask))
  result = call_594057.call(path_594058, query_594059, nil, nil, body_594060)

var monitoringProjectsAlertPoliciesPatch* = Call_MonitoringProjectsAlertPoliciesPatch_594039(
    name: "monitoringProjectsAlertPoliciesPatch", meth: HttpMethod.HttpPatch,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsAlertPoliciesPatch_594040, base: "/",
    url: url_MonitoringProjectsAlertPoliciesPatch_594041, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsDelete_594019 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsMetricDescriptorsDelete_594021(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v3/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitoringProjectsMetricDescriptorsDelete_594020(path: JsonNode;
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
  var valid_594022 = path.getOrDefault("name")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "name", valid_594022
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
  var valid_594023 = query.getOrDefault("upload_protocol")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "upload_protocol", valid_594023
  var valid_594024 = query.getOrDefault("fields")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "fields", valid_594024
  var valid_594025 = query.getOrDefault("force")
  valid_594025 = validateParameter(valid_594025, JBool, required = false, default = nil)
  if valid_594025 != nil:
    section.add "force", valid_594025
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

proc call*(call_594035: Call_MonitoringProjectsMetricDescriptorsDelete_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a metric descriptor. Only user-created custom metrics can be deleted.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_MonitoringProjectsMetricDescriptorsDelete_594019;
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
  var path_594037 = newJObject()
  var query_594038 = newJObject()
  add(query_594038, "upload_protocol", newJString(uploadProtocol))
  add(query_594038, "fields", newJString(fields))
  add(query_594038, "force", newJBool(force))
  add(query_594038, "quotaUser", newJString(quotaUser))
  add(path_594037, "name", newJString(name))
  add(query_594038, "alt", newJString(alt))
  add(query_594038, "oauth_token", newJString(oauthToken))
  add(query_594038, "callback", newJString(callback))
  add(query_594038, "access_token", newJString(accessToken))
  add(query_594038, "uploadType", newJString(uploadType))
  add(query_594038, "key", newJString(key))
  add(query_594038, "$.xgafv", newJString(Xgafv))
  add(query_594038, "prettyPrint", newJBool(prettyPrint))
  result = call_594036.call(path_594037, query_594038, nil, nil, nil)

var monitoringProjectsMetricDescriptorsDelete* = Call_MonitoringProjectsMetricDescriptorsDelete_594019(
    name: "monitoringProjectsMetricDescriptorsDelete",
    meth: HttpMethod.HttpDelete, host: "monitoring.googleapis.com",
    route: "/v3/{name}",
    validator: validate_MonitoringProjectsMetricDescriptorsDelete_594020,
    base: "/", url: url_MonitoringProjectsMetricDescriptorsDelete_594021,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesCreate_594084 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsAlertPoliciesCreate_594086(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsAlertPoliciesCreate_594085(path: JsonNode;
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
  var valid_594087 = path.getOrDefault("name")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "name", valid_594087
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
  var valid_594088 = query.getOrDefault("upload_protocol")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "upload_protocol", valid_594088
  var valid_594089 = query.getOrDefault("fields")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "fields", valid_594089
  var valid_594090 = query.getOrDefault("quotaUser")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "quotaUser", valid_594090
  var valid_594091 = query.getOrDefault("alt")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = newJString("json"))
  if valid_594091 != nil:
    section.add "alt", valid_594091
  var valid_594092 = query.getOrDefault("oauth_token")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "oauth_token", valid_594092
  var valid_594093 = query.getOrDefault("callback")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "callback", valid_594093
  var valid_594094 = query.getOrDefault("access_token")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "access_token", valid_594094
  var valid_594095 = query.getOrDefault("uploadType")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "uploadType", valid_594095
  var valid_594096 = query.getOrDefault("key")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "key", valid_594096
  var valid_594097 = query.getOrDefault("$.xgafv")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = newJString("1"))
  if valid_594097 != nil:
    section.add "$.xgafv", valid_594097
  var valid_594098 = query.getOrDefault("prettyPrint")
  valid_594098 = validateParameter(valid_594098, JBool, required = false,
                                 default = newJBool(true))
  if valid_594098 != nil:
    section.add "prettyPrint", valid_594098
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

proc call*(call_594100: Call_MonitoringProjectsAlertPoliciesCreate_594084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new alerting policy.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_MonitoringProjectsAlertPoliciesCreate_594084;
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
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  var body_594104 = newJObject()
  add(query_594103, "upload_protocol", newJString(uploadProtocol))
  add(query_594103, "fields", newJString(fields))
  add(query_594103, "quotaUser", newJString(quotaUser))
  add(path_594102, "name", newJString(name))
  add(query_594103, "alt", newJString(alt))
  add(query_594103, "oauth_token", newJString(oauthToken))
  add(query_594103, "callback", newJString(callback))
  add(query_594103, "access_token", newJString(accessToken))
  add(query_594103, "uploadType", newJString(uploadType))
  add(query_594103, "key", newJString(key))
  add(query_594103, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594104 = body
  add(query_594103, "prettyPrint", newJBool(prettyPrint))
  result = call_594101.call(path_594102, query_594103, nil, nil, body_594104)

var monitoringProjectsAlertPoliciesCreate* = Call_MonitoringProjectsAlertPoliciesCreate_594084(
    name: "monitoringProjectsAlertPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesCreate_594085, base: "/",
    url: url_MonitoringProjectsAlertPoliciesCreate_594086, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesList_594061 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsAlertPoliciesList_594063(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsAlertPoliciesList_594062(path: JsonNode;
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
  var valid_594064 = path.getOrDefault("name")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "name", valid_594064
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
  var valid_594065 = query.getOrDefault("upload_protocol")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "upload_protocol", valid_594065
  var valid_594066 = query.getOrDefault("fields")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "fields", valid_594066
  var valid_594067 = query.getOrDefault("pageToken")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "pageToken", valid_594067
  var valid_594068 = query.getOrDefault("quotaUser")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "quotaUser", valid_594068
  var valid_594069 = query.getOrDefault("alt")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = newJString("json"))
  if valid_594069 != nil:
    section.add "alt", valid_594069
  var valid_594070 = query.getOrDefault("oauth_token")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "oauth_token", valid_594070
  var valid_594071 = query.getOrDefault("callback")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "callback", valid_594071
  var valid_594072 = query.getOrDefault("access_token")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "access_token", valid_594072
  var valid_594073 = query.getOrDefault("uploadType")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "uploadType", valid_594073
  var valid_594074 = query.getOrDefault("orderBy")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "orderBy", valid_594074
  var valid_594075 = query.getOrDefault("key")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "key", valid_594075
  var valid_594076 = query.getOrDefault("$.xgafv")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = newJString("1"))
  if valid_594076 != nil:
    section.add "$.xgafv", valid_594076
  var valid_594077 = query.getOrDefault("pageSize")
  valid_594077 = validateParameter(valid_594077, JInt, required = false, default = nil)
  if valid_594077 != nil:
    section.add "pageSize", valid_594077
  var valid_594078 = query.getOrDefault("prettyPrint")
  valid_594078 = validateParameter(valid_594078, JBool, required = false,
                                 default = newJBool(true))
  if valid_594078 != nil:
    section.add "prettyPrint", valid_594078
  var valid_594079 = query.getOrDefault("filter")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "filter", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_MonitoringProjectsAlertPoliciesList_594061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing alerting policies for the project.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_MonitoringProjectsAlertPoliciesList_594061;
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
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(query_594083, "upload_protocol", newJString(uploadProtocol))
  add(query_594083, "fields", newJString(fields))
  add(query_594083, "pageToken", newJString(pageToken))
  add(query_594083, "quotaUser", newJString(quotaUser))
  add(path_594082, "name", newJString(name))
  add(query_594083, "alt", newJString(alt))
  add(query_594083, "oauth_token", newJString(oauthToken))
  add(query_594083, "callback", newJString(callback))
  add(query_594083, "access_token", newJString(accessToken))
  add(query_594083, "uploadType", newJString(uploadType))
  add(query_594083, "orderBy", newJString(orderBy))
  add(query_594083, "key", newJString(key))
  add(query_594083, "$.xgafv", newJString(Xgafv))
  add(query_594083, "pageSize", newJInt(pageSize))
  add(query_594083, "prettyPrint", newJBool(prettyPrint))
  add(query_594083, "filter", newJString(filter))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var monitoringProjectsAlertPoliciesList* = Call_MonitoringProjectsAlertPoliciesList_594061(
    name: "monitoringProjectsAlertPoliciesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesList_594062, base: "/",
    url: url_MonitoringProjectsAlertPoliciesList_594063, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsCollectdTimeSeriesCreate_594105 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsCollectdTimeSeriesCreate_594107(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsCollectdTimeSeriesCreate_594106(path: JsonNode;
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
  var valid_594108 = path.getOrDefault("name")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "name", valid_594108
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
  var valid_594109 = query.getOrDefault("upload_protocol")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "upload_protocol", valid_594109
  var valid_594110 = query.getOrDefault("fields")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "fields", valid_594110
  var valid_594111 = query.getOrDefault("quotaUser")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "quotaUser", valid_594111
  var valid_594112 = query.getOrDefault("alt")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("json"))
  if valid_594112 != nil:
    section.add "alt", valid_594112
  var valid_594113 = query.getOrDefault("oauth_token")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "oauth_token", valid_594113
  var valid_594114 = query.getOrDefault("callback")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "callback", valid_594114
  var valid_594115 = query.getOrDefault("access_token")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "access_token", valid_594115
  var valid_594116 = query.getOrDefault("uploadType")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "uploadType", valid_594116
  var valid_594117 = query.getOrDefault("key")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "key", valid_594117
  var valid_594118 = query.getOrDefault("$.xgafv")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = newJString("1"))
  if valid_594118 != nil:
    section.add "$.xgafv", valid_594118
  var valid_594119 = query.getOrDefault("prettyPrint")
  valid_594119 = validateParameter(valid_594119, JBool, required = false,
                                 default = newJBool(true))
  if valid_594119 != nil:
    section.add "prettyPrint", valid_594119
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

proc call*(call_594121: Call_MonitoringProjectsCollectdTimeSeriesCreate_594105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_MonitoringProjectsCollectdTimeSeriesCreate_594105;
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
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  var body_594125 = newJObject()
  add(query_594124, "upload_protocol", newJString(uploadProtocol))
  add(query_594124, "fields", newJString(fields))
  add(query_594124, "quotaUser", newJString(quotaUser))
  add(path_594123, "name", newJString(name))
  add(query_594124, "alt", newJString(alt))
  add(query_594124, "oauth_token", newJString(oauthToken))
  add(query_594124, "callback", newJString(callback))
  add(query_594124, "access_token", newJString(accessToken))
  add(query_594124, "uploadType", newJString(uploadType))
  add(query_594124, "key", newJString(key))
  add(query_594124, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594125 = body
  add(query_594124, "prettyPrint", newJBool(prettyPrint))
  result = call_594122.call(path_594123, query_594124, nil, nil, body_594125)

var monitoringProjectsCollectdTimeSeriesCreate* = Call_MonitoringProjectsCollectdTimeSeriesCreate_594105(
    name: "monitoringProjectsCollectdTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/collectdTimeSeries",
    validator: validate_MonitoringProjectsCollectdTimeSeriesCreate_594106,
    base: "/", url: url_MonitoringProjectsCollectdTimeSeriesCreate_594107,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsCreate_594150 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsGroupsCreate_594152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsGroupsCreate_594151(path: JsonNode;
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
  var valid_594153 = path.getOrDefault("name")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "name", valid_594153
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
  var valid_594154 = query.getOrDefault("upload_protocol")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "upload_protocol", valid_594154
  var valid_594155 = query.getOrDefault("fields")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "fields", valid_594155
  var valid_594156 = query.getOrDefault("quotaUser")
  valid_594156 = validateParameter(valid_594156, JString, required = false,
                                 default = nil)
  if valid_594156 != nil:
    section.add "quotaUser", valid_594156
  var valid_594157 = query.getOrDefault("alt")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = newJString("json"))
  if valid_594157 != nil:
    section.add "alt", valid_594157
  var valid_594158 = query.getOrDefault("oauth_token")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "oauth_token", valid_594158
  var valid_594159 = query.getOrDefault("callback")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "callback", valid_594159
  var valid_594160 = query.getOrDefault("access_token")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "access_token", valid_594160
  var valid_594161 = query.getOrDefault("uploadType")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "uploadType", valid_594161
  var valid_594162 = query.getOrDefault("validateOnly")
  valid_594162 = validateParameter(valid_594162, JBool, required = false, default = nil)
  if valid_594162 != nil:
    section.add "validateOnly", valid_594162
  var valid_594163 = query.getOrDefault("key")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "key", valid_594163
  var valid_594164 = query.getOrDefault("$.xgafv")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = newJString("1"))
  if valid_594164 != nil:
    section.add "$.xgafv", valid_594164
  var valid_594165 = query.getOrDefault("prettyPrint")
  valid_594165 = validateParameter(valid_594165, JBool, required = false,
                                 default = newJBool(true))
  if valid_594165 != nil:
    section.add "prettyPrint", valid_594165
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

proc call*(call_594167: Call_MonitoringProjectsGroupsCreate_594150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new group.
  ## 
  let valid = call_594167.validator(path, query, header, formData, body)
  let scheme = call_594167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594167.url(scheme.get, call_594167.host, call_594167.base,
                         call_594167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594167, url, valid)

proc call*(call_594168: Call_MonitoringProjectsGroupsCreate_594150; name: string;
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
  var path_594169 = newJObject()
  var query_594170 = newJObject()
  var body_594171 = newJObject()
  add(query_594170, "upload_protocol", newJString(uploadProtocol))
  add(query_594170, "fields", newJString(fields))
  add(query_594170, "quotaUser", newJString(quotaUser))
  add(path_594169, "name", newJString(name))
  add(query_594170, "alt", newJString(alt))
  add(query_594170, "oauth_token", newJString(oauthToken))
  add(query_594170, "callback", newJString(callback))
  add(query_594170, "access_token", newJString(accessToken))
  add(query_594170, "uploadType", newJString(uploadType))
  add(query_594170, "validateOnly", newJBool(validateOnly))
  add(query_594170, "key", newJString(key))
  add(query_594170, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594171 = body
  add(query_594170, "prettyPrint", newJBool(prettyPrint))
  result = call_594168.call(path_594169, query_594170, nil, nil, body_594171)

var monitoringProjectsGroupsCreate* = Call_MonitoringProjectsGroupsCreate_594150(
    name: "monitoringProjectsGroupsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsCreate_594151, base: "/",
    url: url_MonitoringProjectsGroupsCreate_594152, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsList_594126 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsGroupsList_594128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsGroupsList_594127(path: JsonNode; query: JsonNode;
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
  var valid_594129 = path.getOrDefault("name")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "name", valid_594129
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
  var valid_594130 = query.getOrDefault("upload_protocol")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "upload_protocol", valid_594130
  var valid_594131 = query.getOrDefault("fields")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "fields", valid_594131
  var valid_594132 = query.getOrDefault("pageToken")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "pageToken", valid_594132
  var valid_594133 = query.getOrDefault("quotaUser")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = nil)
  if valid_594133 != nil:
    section.add "quotaUser", valid_594133
  var valid_594134 = query.getOrDefault("alt")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = newJString("json"))
  if valid_594134 != nil:
    section.add "alt", valid_594134
  var valid_594135 = query.getOrDefault("childrenOfGroup")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "childrenOfGroup", valid_594135
  var valid_594136 = query.getOrDefault("oauth_token")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "oauth_token", valid_594136
  var valid_594137 = query.getOrDefault("callback")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "callback", valid_594137
  var valid_594138 = query.getOrDefault("access_token")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "access_token", valid_594138
  var valid_594139 = query.getOrDefault("uploadType")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "uploadType", valid_594139
  var valid_594140 = query.getOrDefault("descendantsOfGroup")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "descendantsOfGroup", valid_594140
  var valid_594141 = query.getOrDefault("key")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "key", valid_594141
  var valid_594142 = query.getOrDefault("$.xgafv")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = newJString("1"))
  if valid_594142 != nil:
    section.add "$.xgafv", valid_594142
  var valid_594143 = query.getOrDefault("pageSize")
  valid_594143 = validateParameter(valid_594143, JInt, required = false, default = nil)
  if valid_594143 != nil:
    section.add "pageSize", valid_594143
  var valid_594144 = query.getOrDefault("prettyPrint")
  valid_594144 = validateParameter(valid_594144, JBool, required = false,
                                 default = newJBool(true))
  if valid_594144 != nil:
    section.add "prettyPrint", valid_594144
  var valid_594145 = query.getOrDefault("ancestorsOfGroup")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "ancestorsOfGroup", valid_594145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594146: Call_MonitoringProjectsGroupsList_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing groups.
  ## 
  let valid = call_594146.validator(path, query, header, formData, body)
  let scheme = call_594146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594146.url(scheme.get, call_594146.host, call_594146.base,
                         call_594146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594146, url, valid)

proc call*(call_594147: Call_MonitoringProjectsGroupsList_594126; name: string;
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
  var path_594148 = newJObject()
  var query_594149 = newJObject()
  add(query_594149, "upload_protocol", newJString(uploadProtocol))
  add(query_594149, "fields", newJString(fields))
  add(query_594149, "pageToken", newJString(pageToken))
  add(query_594149, "quotaUser", newJString(quotaUser))
  add(path_594148, "name", newJString(name))
  add(query_594149, "alt", newJString(alt))
  add(query_594149, "childrenOfGroup", newJString(childrenOfGroup))
  add(query_594149, "oauth_token", newJString(oauthToken))
  add(query_594149, "callback", newJString(callback))
  add(query_594149, "access_token", newJString(accessToken))
  add(query_594149, "uploadType", newJString(uploadType))
  add(query_594149, "descendantsOfGroup", newJString(descendantsOfGroup))
  add(query_594149, "key", newJString(key))
  add(query_594149, "$.xgafv", newJString(Xgafv))
  add(query_594149, "pageSize", newJInt(pageSize))
  add(query_594149, "prettyPrint", newJBool(prettyPrint))
  add(query_594149, "ancestorsOfGroup", newJString(ancestorsOfGroup))
  result = call_594147.call(path_594148, query_594149, nil, nil, nil)

var monitoringProjectsGroupsList* = Call_MonitoringProjectsGroupsList_594126(
    name: "monitoringProjectsGroupsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsList_594127, base: "/",
    url: url_MonitoringProjectsGroupsList_594128, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsMembersList_594172 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsGroupsMembersList_594174(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsGroupsMembersList_594173(path: JsonNode;
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
  var valid_594175 = path.getOrDefault("name")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "name", valid_594175
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
  var valid_594176 = query.getOrDefault("upload_protocol")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "upload_protocol", valid_594176
  var valid_594177 = query.getOrDefault("fields")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "fields", valid_594177
  var valid_594178 = query.getOrDefault("pageToken")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "pageToken", valid_594178
  var valid_594179 = query.getOrDefault("quotaUser")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "quotaUser", valid_594179
  var valid_594180 = query.getOrDefault("alt")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = newJString("json"))
  if valid_594180 != nil:
    section.add "alt", valid_594180
  var valid_594181 = query.getOrDefault("oauth_token")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "oauth_token", valid_594181
  var valid_594182 = query.getOrDefault("callback")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "callback", valid_594182
  var valid_594183 = query.getOrDefault("access_token")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "access_token", valid_594183
  var valid_594184 = query.getOrDefault("uploadType")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "uploadType", valid_594184
  var valid_594185 = query.getOrDefault("interval.endTime")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "interval.endTime", valid_594185
  var valid_594186 = query.getOrDefault("key")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "key", valid_594186
  var valid_594187 = query.getOrDefault("$.xgafv")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = newJString("1"))
  if valid_594187 != nil:
    section.add "$.xgafv", valid_594187
  var valid_594188 = query.getOrDefault("pageSize")
  valid_594188 = validateParameter(valid_594188, JInt, required = false, default = nil)
  if valid_594188 != nil:
    section.add "pageSize", valid_594188
  var valid_594189 = query.getOrDefault("prettyPrint")
  valid_594189 = validateParameter(valid_594189, JBool, required = false,
                                 default = newJBool(true))
  if valid_594189 != nil:
    section.add "prettyPrint", valid_594189
  var valid_594190 = query.getOrDefault("interval.startTime")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "interval.startTime", valid_594190
  var valid_594191 = query.getOrDefault("filter")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "filter", valid_594191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594192: Call_MonitoringProjectsGroupsMembersList_594172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the monitored resources that are members of a group.
  ## 
  let valid = call_594192.validator(path, query, header, formData, body)
  let scheme = call_594192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594192.url(scheme.get, call_594192.host, call_594192.base,
                         call_594192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594192, url, valid)

proc call*(call_594193: Call_MonitoringProjectsGroupsMembersList_594172;
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
  var path_594194 = newJObject()
  var query_594195 = newJObject()
  add(query_594195, "upload_protocol", newJString(uploadProtocol))
  add(query_594195, "fields", newJString(fields))
  add(query_594195, "pageToken", newJString(pageToken))
  add(query_594195, "quotaUser", newJString(quotaUser))
  add(path_594194, "name", newJString(name))
  add(query_594195, "alt", newJString(alt))
  add(query_594195, "oauth_token", newJString(oauthToken))
  add(query_594195, "callback", newJString(callback))
  add(query_594195, "access_token", newJString(accessToken))
  add(query_594195, "uploadType", newJString(uploadType))
  add(query_594195, "interval.endTime", newJString(intervalEndTime))
  add(query_594195, "key", newJString(key))
  add(query_594195, "$.xgafv", newJString(Xgafv))
  add(query_594195, "pageSize", newJInt(pageSize))
  add(query_594195, "prettyPrint", newJBool(prettyPrint))
  add(query_594195, "interval.startTime", newJString(intervalStartTime))
  add(query_594195, "filter", newJString(filter))
  result = call_594193.call(path_594194, query_594195, nil, nil, nil)

var monitoringProjectsGroupsMembersList* = Call_MonitoringProjectsGroupsMembersList_594172(
    name: "monitoringProjectsGroupsMembersList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/members",
    validator: validate_MonitoringProjectsGroupsMembersList_594173, base: "/",
    url: url_MonitoringProjectsGroupsMembersList_594174, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsCreate_594218 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsMetricDescriptorsCreate_594220(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsMetricDescriptorsCreate_594219(path: JsonNode;
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
  var valid_594221 = path.getOrDefault("name")
  valid_594221 = validateParameter(valid_594221, JString, required = true,
                                 default = nil)
  if valid_594221 != nil:
    section.add "name", valid_594221
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
  var valid_594222 = query.getOrDefault("upload_protocol")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "upload_protocol", valid_594222
  var valid_594223 = query.getOrDefault("fields")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "fields", valid_594223
  var valid_594224 = query.getOrDefault("quotaUser")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "quotaUser", valid_594224
  var valid_594225 = query.getOrDefault("alt")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = newJString("json"))
  if valid_594225 != nil:
    section.add "alt", valid_594225
  var valid_594226 = query.getOrDefault("oauth_token")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "oauth_token", valid_594226
  var valid_594227 = query.getOrDefault("callback")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "callback", valid_594227
  var valid_594228 = query.getOrDefault("access_token")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "access_token", valid_594228
  var valid_594229 = query.getOrDefault("uploadType")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "uploadType", valid_594229
  var valid_594230 = query.getOrDefault("key")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "key", valid_594230
  var valid_594231 = query.getOrDefault("$.xgafv")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = newJString("1"))
  if valid_594231 != nil:
    section.add "$.xgafv", valid_594231
  var valid_594232 = query.getOrDefault("prettyPrint")
  valid_594232 = validateParameter(valid_594232, JBool, required = false,
                                 default = newJBool(true))
  if valid_594232 != nil:
    section.add "prettyPrint", valid_594232
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

proc call*(call_594234: Call_MonitoringProjectsMetricDescriptorsCreate_594218;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
  ## 
  let valid = call_594234.validator(path, query, header, formData, body)
  let scheme = call_594234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594234.url(scheme.get, call_594234.host, call_594234.base,
                         call_594234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594234, url, valid)

proc call*(call_594235: Call_MonitoringProjectsMetricDescriptorsCreate_594218;
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
  var path_594236 = newJObject()
  var query_594237 = newJObject()
  var body_594238 = newJObject()
  add(query_594237, "upload_protocol", newJString(uploadProtocol))
  add(query_594237, "fields", newJString(fields))
  add(query_594237, "quotaUser", newJString(quotaUser))
  add(path_594236, "name", newJString(name))
  add(query_594237, "alt", newJString(alt))
  add(query_594237, "oauth_token", newJString(oauthToken))
  add(query_594237, "callback", newJString(callback))
  add(query_594237, "access_token", newJString(accessToken))
  add(query_594237, "uploadType", newJString(uploadType))
  add(query_594237, "key", newJString(key))
  add(query_594237, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594238 = body
  add(query_594237, "prettyPrint", newJBool(prettyPrint))
  result = call_594235.call(path_594236, query_594237, nil, nil, body_594238)

var monitoringProjectsMetricDescriptorsCreate* = Call_MonitoringProjectsMetricDescriptorsCreate_594218(
    name: "monitoringProjectsMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsCreate_594219,
    base: "/", url: url_MonitoringProjectsMetricDescriptorsCreate_594220,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsList_594196 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsMetricDescriptorsList_594198(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsMetricDescriptorsList_594197(path: JsonNode;
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
  var valid_594199 = path.getOrDefault("name")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "name", valid_594199
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
  var valid_594200 = query.getOrDefault("upload_protocol")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "upload_protocol", valid_594200
  var valid_594201 = query.getOrDefault("fields")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "fields", valid_594201
  var valid_594202 = query.getOrDefault("pageToken")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "pageToken", valid_594202
  var valid_594203 = query.getOrDefault("quotaUser")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "quotaUser", valid_594203
  var valid_594204 = query.getOrDefault("alt")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = newJString("json"))
  if valid_594204 != nil:
    section.add "alt", valid_594204
  var valid_594205 = query.getOrDefault("oauth_token")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "oauth_token", valid_594205
  var valid_594206 = query.getOrDefault("callback")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "callback", valid_594206
  var valid_594207 = query.getOrDefault("access_token")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "access_token", valid_594207
  var valid_594208 = query.getOrDefault("uploadType")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "uploadType", valid_594208
  var valid_594209 = query.getOrDefault("key")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "key", valid_594209
  var valid_594210 = query.getOrDefault("$.xgafv")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = newJString("1"))
  if valid_594210 != nil:
    section.add "$.xgafv", valid_594210
  var valid_594211 = query.getOrDefault("pageSize")
  valid_594211 = validateParameter(valid_594211, JInt, required = false, default = nil)
  if valid_594211 != nil:
    section.add "pageSize", valid_594211
  var valid_594212 = query.getOrDefault("prettyPrint")
  valid_594212 = validateParameter(valid_594212, JBool, required = false,
                                 default = newJBool(true))
  if valid_594212 != nil:
    section.add "prettyPrint", valid_594212
  var valid_594213 = query.getOrDefault("filter")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "filter", valid_594213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594214: Call_MonitoringProjectsMetricDescriptorsList_594196;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_594214.validator(path, query, header, formData, body)
  let scheme = call_594214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594214.url(scheme.get, call_594214.host, call_594214.base,
                         call_594214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594214, url, valid)

proc call*(call_594215: Call_MonitoringProjectsMetricDescriptorsList_594196;
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
  var path_594216 = newJObject()
  var query_594217 = newJObject()
  add(query_594217, "upload_protocol", newJString(uploadProtocol))
  add(query_594217, "fields", newJString(fields))
  add(query_594217, "pageToken", newJString(pageToken))
  add(query_594217, "quotaUser", newJString(quotaUser))
  add(path_594216, "name", newJString(name))
  add(query_594217, "alt", newJString(alt))
  add(query_594217, "oauth_token", newJString(oauthToken))
  add(query_594217, "callback", newJString(callback))
  add(query_594217, "access_token", newJString(accessToken))
  add(query_594217, "uploadType", newJString(uploadType))
  add(query_594217, "key", newJString(key))
  add(query_594217, "$.xgafv", newJString(Xgafv))
  add(query_594217, "pageSize", newJInt(pageSize))
  add(query_594217, "prettyPrint", newJBool(prettyPrint))
  add(query_594217, "filter", newJString(filter))
  result = call_594215.call(path_594216, query_594217, nil, nil, nil)

var monitoringProjectsMetricDescriptorsList* = Call_MonitoringProjectsMetricDescriptorsList_594196(
    name: "monitoringProjectsMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsList_594197, base: "/",
    url: url_MonitoringProjectsMetricDescriptorsList_594198,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMonitoredResourceDescriptorsList_594239 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsMonitoredResourceDescriptorsList_594241(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsMonitoredResourceDescriptorsList_594240(
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
  var valid_594242 = path.getOrDefault("name")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "name", valid_594242
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
  var valid_594243 = query.getOrDefault("upload_protocol")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "upload_protocol", valid_594243
  var valid_594244 = query.getOrDefault("fields")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "fields", valid_594244
  var valid_594245 = query.getOrDefault("pageToken")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "pageToken", valid_594245
  var valid_594246 = query.getOrDefault("quotaUser")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "quotaUser", valid_594246
  var valid_594247 = query.getOrDefault("alt")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = newJString("json"))
  if valid_594247 != nil:
    section.add "alt", valid_594247
  var valid_594248 = query.getOrDefault("oauth_token")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "oauth_token", valid_594248
  var valid_594249 = query.getOrDefault("callback")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "callback", valid_594249
  var valid_594250 = query.getOrDefault("access_token")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "access_token", valid_594250
  var valid_594251 = query.getOrDefault("uploadType")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "uploadType", valid_594251
  var valid_594252 = query.getOrDefault("key")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "key", valid_594252
  var valid_594253 = query.getOrDefault("$.xgafv")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = newJString("1"))
  if valid_594253 != nil:
    section.add "$.xgafv", valid_594253
  var valid_594254 = query.getOrDefault("pageSize")
  valid_594254 = validateParameter(valid_594254, JInt, required = false, default = nil)
  if valid_594254 != nil:
    section.add "pageSize", valid_594254
  var valid_594255 = query.getOrDefault("prettyPrint")
  valid_594255 = validateParameter(valid_594255, JBool, required = false,
                                 default = newJBool(true))
  if valid_594255 != nil:
    section.add "prettyPrint", valid_594255
  var valid_594256 = query.getOrDefault("filter")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "filter", valid_594256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594257: Call_MonitoringProjectsMonitoredResourceDescriptorsList_594239;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_594257.validator(path, query, header, formData, body)
  let scheme = call_594257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594257.url(scheme.get, call_594257.host, call_594257.base,
                         call_594257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594257, url, valid)

proc call*(call_594258: Call_MonitoringProjectsMonitoredResourceDescriptorsList_594239;
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
  var path_594259 = newJObject()
  var query_594260 = newJObject()
  add(query_594260, "upload_protocol", newJString(uploadProtocol))
  add(query_594260, "fields", newJString(fields))
  add(query_594260, "pageToken", newJString(pageToken))
  add(query_594260, "quotaUser", newJString(quotaUser))
  add(path_594259, "name", newJString(name))
  add(query_594260, "alt", newJString(alt))
  add(query_594260, "oauth_token", newJString(oauthToken))
  add(query_594260, "callback", newJString(callback))
  add(query_594260, "access_token", newJString(accessToken))
  add(query_594260, "uploadType", newJString(uploadType))
  add(query_594260, "key", newJString(key))
  add(query_594260, "$.xgafv", newJString(Xgafv))
  add(query_594260, "pageSize", newJInt(pageSize))
  add(query_594260, "prettyPrint", newJBool(prettyPrint))
  add(query_594260, "filter", newJString(filter))
  result = call_594258.call(path_594259, query_594260, nil, nil, nil)

var monitoringProjectsMonitoredResourceDescriptorsList* = Call_MonitoringProjectsMonitoredResourceDescriptorsList_594239(
    name: "monitoringProjectsMonitoredResourceDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/monitoredResourceDescriptors",
    validator: validate_MonitoringProjectsMonitoredResourceDescriptorsList_594240,
    base: "/", url: url_MonitoringProjectsMonitoredResourceDescriptorsList_594241,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelDescriptorsList_594261 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsNotificationChannelDescriptorsList_594263(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsNotificationChannelDescriptorsList_594262(
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
  var valid_594264 = path.getOrDefault("name")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = nil)
  if valid_594264 != nil:
    section.add "name", valid_594264
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
  var valid_594265 = query.getOrDefault("upload_protocol")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "upload_protocol", valid_594265
  var valid_594266 = query.getOrDefault("fields")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "fields", valid_594266
  var valid_594267 = query.getOrDefault("pageToken")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "pageToken", valid_594267
  var valid_594268 = query.getOrDefault("quotaUser")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "quotaUser", valid_594268
  var valid_594269 = query.getOrDefault("alt")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = newJString("json"))
  if valid_594269 != nil:
    section.add "alt", valid_594269
  var valid_594270 = query.getOrDefault("oauth_token")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "oauth_token", valid_594270
  var valid_594271 = query.getOrDefault("callback")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "callback", valid_594271
  var valid_594272 = query.getOrDefault("access_token")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "access_token", valid_594272
  var valid_594273 = query.getOrDefault("uploadType")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = nil)
  if valid_594273 != nil:
    section.add "uploadType", valid_594273
  var valid_594274 = query.getOrDefault("key")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "key", valid_594274
  var valid_594275 = query.getOrDefault("$.xgafv")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = newJString("1"))
  if valid_594275 != nil:
    section.add "$.xgafv", valid_594275
  var valid_594276 = query.getOrDefault("pageSize")
  valid_594276 = validateParameter(valid_594276, JInt, required = false, default = nil)
  if valid_594276 != nil:
    section.add "pageSize", valid_594276
  var valid_594277 = query.getOrDefault("prettyPrint")
  valid_594277 = validateParameter(valid_594277, JBool, required = false,
                                 default = newJBool(true))
  if valid_594277 != nil:
    section.add "prettyPrint", valid_594277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594278: Call_MonitoringProjectsNotificationChannelDescriptorsList_594261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ## 
  let valid = call_594278.validator(path, query, header, formData, body)
  let scheme = call_594278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594278.url(scheme.get, call_594278.host, call_594278.base,
                         call_594278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594278, url, valid)

proc call*(call_594279: Call_MonitoringProjectsNotificationChannelDescriptorsList_594261;
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
  var path_594280 = newJObject()
  var query_594281 = newJObject()
  add(query_594281, "upload_protocol", newJString(uploadProtocol))
  add(query_594281, "fields", newJString(fields))
  add(query_594281, "pageToken", newJString(pageToken))
  add(query_594281, "quotaUser", newJString(quotaUser))
  add(path_594280, "name", newJString(name))
  add(query_594281, "alt", newJString(alt))
  add(query_594281, "oauth_token", newJString(oauthToken))
  add(query_594281, "callback", newJString(callback))
  add(query_594281, "access_token", newJString(accessToken))
  add(query_594281, "uploadType", newJString(uploadType))
  add(query_594281, "key", newJString(key))
  add(query_594281, "$.xgafv", newJString(Xgafv))
  add(query_594281, "pageSize", newJInt(pageSize))
  add(query_594281, "prettyPrint", newJBool(prettyPrint))
  result = call_594279.call(path_594280, query_594281, nil, nil, nil)

var monitoringProjectsNotificationChannelDescriptorsList* = Call_MonitoringProjectsNotificationChannelDescriptorsList_594261(
    name: "monitoringProjectsNotificationChannelDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannelDescriptors",
    validator: validate_MonitoringProjectsNotificationChannelDescriptorsList_594262,
    base: "/", url: url_MonitoringProjectsNotificationChannelDescriptorsList_594263,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsCreate_594305 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsNotificationChannelsCreate_594307(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsNotificationChannelsCreate_594306(path: JsonNode;
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
  var valid_594308 = path.getOrDefault("name")
  valid_594308 = validateParameter(valid_594308, JString, required = true,
                                 default = nil)
  if valid_594308 != nil:
    section.add "name", valid_594308
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
  var valid_594309 = query.getOrDefault("upload_protocol")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "upload_protocol", valid_594309
  var valid_594310 = query.getOrDefault("fields")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "fields", valid_594310
  var valid_594311 = query.getOrDefault("quotaUser")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "quotaUser", valid_594311
  var valid_594312 = query.getOrDefault("alt")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = newJString("json"))
  if valid_594312 != nil:
    section.add "alt", valid_594312
  var valid_594313 = query.getOrDefault("oauth_token")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "oauth_token", valid_594313
  var valid_594314 = query.getOrDefault("callback")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "callback", valid_594314
  var valid_594315 = query.getOrDefault("access_token")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "access_token", valid_594315
  var valid_594316 = query.getOrDefault("uploadType")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "uploadType", valid_594316
  var valid_594317 = query.getOrDefault("key")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "key", valid_594317
  var valid_594318 = query.getOrDefault("$.xgafv")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = newJString("1"))
  if valid_594318 != nil:
    section.add "$.xgafv", valid_594318
  var valid_594319 = query.getOrDefault("prettyPrint")
  valid_594319 = validateParameter(valid_594319, JBool, required = false,
                                 default = newJBool(true))
  if valid_594319 != nil:
    section.add "prettyPrint", valid_594319
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

proc call*(call_594321: Call_MonitoringProjectsNotificationChannelsCreate_594305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
  ## 
  let valid = call_594321.validator(path, query, header, formData, body)
  let scheme = call_594321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594321.url(scheme.get, call_594321.host, call_594321.base,
                         call_594321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594321, url, valid)

proc call*(call_594322: Call_MonitoringProjectsNotificationChannelsCreate_594305;
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
  var path_594323 = newJObject()
  var query_594324 = newJObject()
  var body_594325 = newJObject()
  add(query_594324, "upload_protocol", newJString(uploadProtocol))
  add(query_594324, "fields", newJString(fields))
  add(query_594324, "quotaUser", newJString(quotaUser))
  add(path_594323, "name", newJString(name))
  add(query_594324, "alt", newJString(alt))
  add(query_594324, "oauth_token", newJString(oauthToken))
  add(query_594324, "callback", newJString(callback))
  add(query_594324, "access_token", newJString(accessToken))
  add(query_594324, "uploadType", newJString(uploadType))
  add(query_594324, "key", newJString(key))
  add(query_594324, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594325 = body
  add(query_594324, "prettyPrint", newJBool(prettyPrint))
  result = call_594322.call(path_594323, query_594324, nil, nil, body_594325)

var monitoringProjectsNotificationChannelsCreate* = Call_MonitoringProjectsNotificationChannelsCreate_594305(
    name: "monitoringProjectsNotificationChannelsCreate",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsCreate_594306,
    base: "/", url: url_MonitoringProjectsNotificationChannelsCreate_594307,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsList_594282 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsNotificationChannelsList_594284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsNotificationChannelsList_594283(path: JsonNode;
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
  var valid_594285 = path.getOrDefault("name")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "name", valid_594285
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
  var valid_594286 = query.getOrDefault("upload_protocol")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "upload_protocol", valid_594286
  var valid_594287 = query.getOrDefault("fields")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "fields", valid_594287
  var valid_594288 = query.getOrDefault("pageToken")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "pageToken", valid_594288
  var valid_594289 = query.getOrDefault("quotaUser")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "quotaUser", valid_594289
  var valid_594290 = query.getOrDefault("alt")
  valid_594290 = validateParameter(valid_594290, JString, required = false,
                                 default = newJString("json"))
  if valid_594290 != nil:
    section.add "alt", valid_594290
  var valid_594291 = query.getOrDefault("oauth_token")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "oauth_token", valid_594291
  var valid_594292 = query.getOrDefault("callback")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "callback", valid_594292
  var valid_594293 = query.getOrDefault("access_token")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "access_token", valid_594293
  var valid_594294 = query.getOrDefault("uploadType")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = nil)
  if valid_594294 != nil:
    section.add "uploadType", valid_594294
  var valid_594295 = query.getOrDefault("orderBy")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "orderBy", valid_594295
  var valid_594296 = query.getOrDefault("key")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "key", valid_594296
  var valid_594297 = query.getOrDefault("$.xgafv")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = newJString("1"))
  if valid_594297 != nil:
    section.add "$.xgafv", valid_594297
  var valid_594298 = query.getOrDefault("pageSize")
  valid_594298 = validateParameter(valid_594298, JInt, required = false, default = nil)
  if valid_594298 != nil:
    section.add "pageSize", valid_594298
  var valid_594299 = query.getOrDefault("prettyPrint")
  valid_594299 = validateParameter(valid_594299, JBool, required = false,
                                 default = newJBool(true))
  if valid_594299 != nil:
    section.add "prettyPrint", valid_594299
  var valid_594300 = query.getOrDefault("filter")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "filter", valid_594300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594301: Call_MonitoringProjectsNotificationChannelsList_594282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the notification channels that have been created for the project.
  ## 
  let valid = call_594301.validator(path, query, header, formData, body)
  let scheme = call_594301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594301.url(scheme.get, call_594301.host, call_594301.base,
                         call_594301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594301, url, valid)

proc call*(call_594302: Call_MonitoringProjectsNotificationChannelsList_594282;
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
  var path_594303 = newJObject()
  var query_594304 = newJObject()
  add(query_594304, "upload_protocol", newJString(uploadProtocol))
  add(query_594304, "fields", newJString(fields))
  add(query_594304, "pageToken", newJString(pageToken))
  add(query_594304, "quotaUser", newJString(quotaUser))
  add(path_594303, "name", newJString(name))
  add(query_594304, "alt", newJString(alt))
  add(query_594304, "oauth_token", newJString(oauthToken))
  add(query_594304, "callback", newJString(callback))
  add(query_594304, "access_token", newJString(accessToken))
  add(query_594304, "uploadType", newJString(uploadType))
  add(query_594304, "orderBy", newJString(orderBy))
  add(query_594304, "key", newJString(key))
  add(query_594304, "$.xgafv", newJString(Xgafv))
  add(query_594304, "pageSize", newJInt(pageSize))
  add(query_594304, "prettyPrint", newJBool(prettyPrint))
  add(query_594304, "filter", newJString(filter))
  result = call_594302.call(path_594303, query_594304, nil, nil, nil)

var monitoringProjectsNotificationChannelsList* = Call_MonitoringProjectsNotificationChannelsList_594282(
    name: "monitoringProjectsNotificationChannelsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsList_594283,
    base: "/", url: url_MonitoringProjectsNotificationChannelsList_594284,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesCreate_594356 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsTimeSeriesCreate_594358(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsTimeSeriesCreate_594357(path: JsonNode;
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
  var valid_594359 = path.getOrDefault("name")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "name", valid_594359
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
  var valid_594360 = query.getOrDefault("upload_protocol")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "upload_protocol", valid_594360
  var valid_594361 = query.getOrDefault("fields")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "fields", valid_594361
  var valid_594362 = query.getOrDefault("quotaUser")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "quotaUser", valid_594362
  var valid_594363 = query.getOrDefault("alt")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = newJString("json"))
  if valid_594363 != nil:
    section.add "alt", valid_594363
  var valid_594364 = query.getOrDefault("oauth_token")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "oauth_token", valid_594364
  var valid_594365 = query.getOrDefault("callback")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "callback", valid_594365
  var valid_594366 = query.getOrDefault("access_token")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "access_token", valid_594366
  var valid_594367 = query.getOrDefault("uploadType")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "uploadType", valid_594367
  var valid_594368 = query.getOrDefault("key")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "key", valid_594368
  var valid_594369 = query.getOrDefault("$.xgafv")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = newJString("1"))
  if valid_594369 != nil:
    section.add "$.xgafv", valid_594369
  var valid_594370 = query.getOrDefault("prettyPrint")
  valid_594370 = validateParameter(valid_594370, JBool, required = false,
                                 default = newJBool(true))
  if valid_594370 != nil:
    section.add "prettyPrint", valid_594370
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

proc call*(call_594372: Call_MonitoringProjectsTimeSeriesCreate_594356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
  ## 
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_MonitoringProjectsTimeSeriesCreate_594356;
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
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  var body_594376 = newJObject()
  add(query_594375, "upload_protocol", newJString(uploadProtocol))
  add(query_594375, "fields", newJString(fields))
  add(query_594375, "quotaUser", newJString(quotaUser))
  add(path_594374, "name", newJString(name))
  add(query_594375, "alt", newJString(alt))
  add(query_594375, "oauth_token", newJString(oauthToken))
  add(query_594375, "callback", newJString(callback))
  add(query_594375, "access_token", newJString(accessToken))
  add(query_594375, "uploadType", newJString(uploadType))
  add(query_594375, "key", newJString(key))
  add(query_594375, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594376 = body
  add(query_594375, "prettyPrint", newJBool(prettyPrint))
  result = call_594373.call(path_594374, query_594375, nil, nil, body_594376)

var monitoringProjectsTimeSeriesCreate* = Call_MonitoringProjectsTimeSeriesCreate_594356(
    name: "monitoringProjectsTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesCreate_594357, base: "/",
    url: url_MonitoringProjectsTimeSeriesCreate_594358, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesList_594326 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsTimeSeriesList_594328(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsTimeSeriesList_594327(path: JsonNode;
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
  var valid_594329 = path.getOrDefault("name")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "name", valid_594329
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
  var valid_594330 = query.getOrDefault("upload_protocol")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "upload_protocol", valid_594330
  var valid_594331 = query.getOrDefault("fields")
  valid_594331 = validateParameter(valid_594331, JString, required = false,
                                 default = nil)
  if valid_594331 != nil:
    section.add "fields", valid_594331
  var valid_594332 = query.getOrDefault("pageToken")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "pageToken", valid_594332
  var valid_594333 = query.getOrDefault("quotaUser")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "quotaUser", valid_594333
  var valid_594334 = query.getOrDefault("view")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = newJString("FULL"))
  if valid_594334 != nil:
    section.add "view", valid_594334
  var valid_594335 = query.getOrDefault("alt")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = newJString("json"))
  if valid_594335 != nil:
    section.add "alt", valid_594335
  var valid_594336 = query.getOrDefault("aggregation.alignmentPeriod")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "aggregation.alignmentPeriod", valid_594336
  var valid_594337 = query.getOrDefault("oauth_token")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "oauth_token", valid_594337
  var valid_594338 = query.getOrDefault("callback")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "callback", valid_594338
  var valid_594339 = query.getOrDefault("access_token")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "access_token", valid_594339
  var valid_594340 = query.getOrDefault("uploadType")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "uploadType", valid_594340
  var valid_594341 = query.getOrDefault("aggregation.crossSeriesReducer")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = newJString("REDUCE_NONE"))
  if valid_594341 != nil:
    section.add "aggregation.crossSeriesReducer", valid_594341
  var valid_594342 = query.getOrDefault("interval.endTime")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "interval.endTime", valid_594342
  var valid_594343 = query.getOrDefault("orderBy")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "orderBy", valid_594343
  var valid_594344 = query.getOrDefault("key")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "key", valid_594344
  var valid_594345 = query.getOrDefault("$.xgafv")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = newJString("1"))
  if valid_594345 != nil:
    section.add "$.xgafv", valid_594345
  var valid_594346 = query.getOrDefault("pageSize")
  valid_594346 = validateParameter(valid_594346, JInt, required = false, default = nil)
  if valid_594346 != nil:
    section.add "pageSize", valid_594346
  var valid_594347 = query.getOrDefault("aggregation.perSeriesAligner")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = newJString("ALIGN_NONE"))
  if valid_594347 != nil:
    section.add "aggregation.perSeriesAligner", valid_594347
  var valid_594348 = query.getOrDefault("aggregation.groupByFields")
  valid_594348 = validateParameter(valid_594348, JArray, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "aggregation.groupByFields", valid_594348
  var valid_594349 = query.getOrDefault("prettyPrint")
  valid_594349 = validateParameter(valid_594349, JBool, required = false,
                                 default = newJBool(true))
  if valid_594349 != nil:
    section.add "prettyPrint", valid_594349
  var valid_594350 = query.getOrDefault("interval.startTime")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "interval.startTime", valid_594350
  var valid_594351 = query.getOrDefault("filter")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "filter", valid_594351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594352: Call_MonitoringProjectsTimeSeriesList_594326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_594352.validator(path, query, header, formData, body)
  let scheme = call_594352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594352.url(scheme.get, call_594352.host, call_594352.base,
                         call_594352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594352, url, valid)

proc call*(call_594353: Call_MonitoringProjectsTimeSeriesList_594326; name: string;
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
  var path_594354 = newJObject()
  var query_594355 = newJObject()
  add(query_594355, "upload_protocol", newJString(uploadProtocol))
  add(query_594355, "fields", newJString(fields))
  add(query_594355, "pageToken", newJString(pageToken))
  add(query_594355, "quotaUser", newJString(quotaUser))
  add(query_594355, "view", newJString(view))
  add(path_594354, "name", newJString(name))
  add(query_594355, "alt", newJString(alt))
  add(query_594355, "aggregation.alignmentPeriod",
      newJString(aggregationAlignmentPeriod))
  add(query_594355, "oauth_token", newJString(oauthToken))
  add(query_594355, "callback", newJString(callback))
  add(query_594355, "access_token", newJString(accessToken))
  add(query_594355, "uploadType", newJString(uploadType))
  add(query_594355, "aggregation.crossSeriesReducer",
      newJString(aggregationCrossSeriesReducer))
  add(query_594355, "interval.endTime", newJString(intervalEndTime))
  add(query_594355, "orderBy", newJString(orderBy))
  add(query_594355, "key", newJString(key))
  add(query_594355, "$.xgafv", newJString(Xgafv))
  add(query_594355, "pageSize", newJInt(pageSize))
  add(query_594355, "aggregation.perSeriesAligner",
      newJString(aggregationPerSeriesAligner))
  if aggregationGroupByFields != nil:
    query_594355.add "aggregation.groupByFields", aggregationGroupByFields
  add(query_594355, "prettyPrint", newJBool(prettyPrint))
  add(query_594355, "interval.startTime", newJString(intervalStartTime))
  add(query_594355, "filter", newJString(filter))
  result = call_594353.call(path_594354, query_594355, nil, nil, nil)

var monitoringProjectsTimeSeriesList* = Call_MonitoringProjectsTimeSeriesList_594326(
    name: "monitoringProjectsTimeSeriesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesList_594327, base: "/",
    url: url_MonitoringProjectsTimeSeriesList_594328, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsGetVerificationCode_594377 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsNotificationChannelsGetVerificationCode_594379(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsNotificationChannelsGetVerificationCode_594378(
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
  var valid_594380 = path.getOrDefault("name")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "name", valid_594380
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
  var valid_594381 = query.getOrDefault("upload_protocol")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "upload_protocol", valid_594381
  var valid_594382 = query.getOrDefault("fields")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "fields", valid_594382
  var valid_594383 = query.getOrDefault("quotaUser")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "quotaUser", valid_594383
  var valid_594384 = query.getOrDefault("alt")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = newJString("json"))
  if valid_594384 != nil:
    section.add "alt", valid_594384
  var valid_594385 = query.getOrDefault("oauth_token")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "oauth_token", valid_594385
  var valid_594386 = query.getOrDefault("callback")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "callback", valid_594386
  var valid_594387 = query.getOrDefault("access_token")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "access_token", valid_594387
  var valid_594388 = query.getOrDefault("uploadType")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "uploadType", valid_594388
  var valid_594389 = query.getOrDefault("key")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "key", valid_594389
  var valid_594390 = query.getOrDefault("$.xgafv")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = newJString("1"))
  if valid_594390 != nil:
    section.add "$.xgafv", valid_594390
  var valid_594391 = query.getOrDefault("prettyPrint")
  valid_594391 = validateParameter(valid_594391, JBool, required = false,
                                 default = newJBool(true))
  if valid_594391 != nil:
    section.add "prettyPrint", valid_594391
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

proc call*(call_594393: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_594377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
  ## 
  let valid = call_594393.validator(path, query, header, formData, body)
  let scheme = call_594393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594393.url(scheme.get, call_594393.host, call_594393.base,
                         call_594393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594393, url, valid)

proc call*(call_594394: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_594377;
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
  var path_594395 = newJObject()
  var query_594396 = newJObject()
  var body_594397 = newJObject()
  add(query_594396, "upload_protocol", newJString(uploadProtocol))
  add(query_594396, "fields", newJString(fields))
  add(query_594396, "quotaUser", newJString(quotaUser))
  add(path_594395, "name", newJString(name))
  add(query_594396, "alt", newJString(alt))
  add(query_594396, "oauth_token", newJString(oauthToken))
  add(query_594396, "callback", newJString(callback))
  add(query_594396, "access_token", newJString(accessToken))
  add(query_594396, "uploadType", newJString(uploadType))
  add(query_594396, "key", newJString(key))
  add(query_594396, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594397 = body
  add(query_594396, "prettyPrint", newJBool(prettyPrint))
  result = call_594394.call(path_594395, query_594396, nil, nil, body_594397)

var monitoringProjectsNotificationChannelsGetVerificationCode* = Call_MonitoringProjectsNotificationChannelsGetVerificationCode_594377(
    name: "monitoringProjectsNotificationChannelsGetVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:getVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsGetVerificationCode_594378,
    base: "/", url: url_MonitoringProjectsNotificationChannelsGetVerificationCode_594379,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsSendVerificationCode_594398 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsNotificationChannelsSendVerificationCode_594400(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsNotificationChannelsSendVerificationCode_594399(
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
  var valid_594401 = path.getOrDefault("name")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "name", valid_594401
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
  var valid_594402 = query.getOrDefault("upload_protocol")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "upload_protocol", valid_594402
  var valid_594403 = query.getOrDefault("fields")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "fields", valid_594403
  var valid_594404 = query.getOrDefault("quotaUser")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "quotaUser", valid_594404
  var valid_594405 = query.getOrDefault("alt")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = newJString("json"))
  if valid_594405 != nil:
    section.add "alt", valid_594405
  var valid_594406 = query.getOrDefault("oauth_token")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "oauth_token", valid_594406
  var valid_594407 = query.getOrDefault("callback")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "callback", valid_594407
  var valid_594408 = query.getOrDefault("access_token")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "access_token", valid_594408
  var valid_594409 = query.getOrDefault("uploadType")
  valid_594409 = validateParameter(valid_594409, JString, required = false,
                                 default = nil)
  if valid_594409 != nil:
    section.add "uploadType", valid_594409
  var valid_594410 = query.getOrDefault("key")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = nil)
  if valid_594410 != nil:
    section.add "key", valid_594410
  var valid_594411 = query.getOrDefault("$.xgafv")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = newJString("1"))
  if valid_594411 != nil:
    section.add "$.xgafv", valid_594411
  var valid_594412 = query.getOrDefault("prettyPrint")
  valid_594412 = validateParameter(valid_594412, JBool, required = false,
                                 default = newJBool(true))
  if valid_594412 != nil:
    section.add "prettyPrint", valid_594412
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

proc call*(call_594414: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_594398;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
  ## 
  let valid = call_594414.validator(path, query, header, formData, body)
  let scheme = call_594414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594414.url(scheme.get, call_594414.host, call_594414.base,
                         call_594414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594414, url, valid)

proc call*(call_594415: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_594398;
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
  var path_594416 = newJObject()
  var query_594417 = newJObject()
  var body_594418 = newJObject()
  add(query_594417, "upload_protocol", newJString(uploadProtocol))
  add(query_594417, "fields", newJString(fields))
  add(query_594417, "quotaUser", newJString(quotaUser))
  add(path_594416, "name", newJString(name))
  add(query_594417, "alt", newJString(alt))
  add(query_594417, "oauth_token", newJString(oauthToken))
  add(query_594417, "callback", newJString(callback))
  add(query_594417, "access_token", newJString(accessToken))
  add(query_594417, "uploadType", newJString(uploadType))
  add(query_594417, "key", newJString(key))
  add(query_594417, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594418 = body
  add(query_594417, "prettyPrint", newJBool(prettyPrint))
  result = call_594415.call(path_594416, query_594417, nil, nil, body_594418)

var monitoringProjectsNotificationChannelsSendVerificationCode* = Call_MonitoringProjectsNotificationChannelsSendVerificationCode_594398(
    name: "monitoringProjectsNotificationChannelsSendVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:sendVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsSendVerificationCode_594399,
    base: "/",
    url: url_MonitoringProjectsNotificationChannelsSendVerificationCode_594400,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsVerify_594419 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsNotificationChannelsVerify_594421(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsNotificationChannelsVerify_594420(path: JsonNode;
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
  var valid_594422 = path.getOrDefault("name")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "name", valid_594422
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
  var valid_594423 = query.getOrDefault("upload_protocol")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "upload_protocol", valid_594423
  var valid_594424 = query.getOrDefault("fields")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "fields", valid_594424
  var valid_594425 = query.getOrDefault("quotaUser")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "quotaUser", valid_594425
  var valid_594426 = query.getOrDefault("alt")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = newJString("json"))
  if valid_594426 != nil:
    section.add "alt", valid_594426
  var valid_594427 = query.getOrDefault("oauth_token")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = nil)
  if valid_594427 != nil:
    section.add "oauth_token", valid_594427
  var valid_594428 = query.getOrDefault("callback")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = nil)
  if valid_594428 != nil:
    section.add "callback", valid_594428
  var valid_594429 = query.getOrDefault("access_token")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = nil)
  if valid_594429 != nil:
    section.add "access_token", valid_594429
  var valid_594430 = query.getOrDefault("uploadType")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "uploadType", valid_594430
  var valid_594431 = query.getOrDefault("key")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "key", valid_594431
  var valid_594432 = query.getOrDefault("$.xgafv")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = newJString("1"))
  if valid_594432 != nil:
    section.add "$.xgafv", valid_594432
  var valid_594433 = query.getOrDefault("prettyPrint")
  valid_594433 = validateParameter(valid_594433, JBool, required = false,
                                 default = newJBool(true))
  if valid_594433 != nil:
    section.add "prettyPrint", valid_594433
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

proc call*(call_594435: Call_MonitoringProjectsNotificationChannelsVerify_594419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
  ## 
  let valid = call_594435.validator(path, query, header, formData, body)
  let scheme = call_594435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594435.url(scheme.get, call_594435.host, call_594435.base,
                         call_594435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594435, url, valid)

proc call*(call_594436: Call_MonitoringProjectsNotificationChannelsVerify_594419;
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
  var path_594437 = newJObject()
  var query_594438 = newJObject()
  var body_594439 = newJObject()
  add(query_594438, "upload_protocol", newJString(uploadProtocol))
  add(query_594438, "fields", newJString(fields))
  add(query_594438, "quotaUser", newJString(quotaUser))
  add(path_594437, "name", newJString(name))
  add(query_594438, "alt", newJString(alt))
  add(query_594438, "oauth_token", newJString(oauthToken))
  add(query_594438, "callback", newJString(callback))
  add(query_594438, "access_token", newJString(accessToken))
  add(query_594438, "uploadType", newJString(uploadType))
  add(query_594438, "key", newJString(key))
  add(query_594438, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594439 = body
  add(query_594438, "prettyPrint", newJBool(prettyPrint))
  result = call_594436.call(path_594437, query_594438, nil, nil, body_594439)

var monitoringProjectsNotificationChannelsVerify* = Call_MonitoringProjectsNotificationChannelsVerify_594419(
    name: "monitoringProjectsNotificationChannelsVerify",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:verify",
    validator: validate_MonitoringProjectsNotificationChannelsVerify_594420,
    base: "/", url: url_MonitoringProjectsNotificationChannelsVerify_594421,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsCreate_594461 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsUptimeCheckConfigsCreate_594463(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsUptimeCheckConfigsCreate_594462(path: JsonNode;
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
  var valid_594464 = path.getOrDefault("parent")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "parent", valid_594464
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
  var valid_594465 = query.getOrDefault("upload_protocol")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "upload_protocol", valid_594465
  var valid_594466 = query.getOrDefault("fields")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "fields", valid_594466
  var valid_594467 = query.getOrDefault("quotaUser")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "quotaUser", valid_594467
  var valid_594468 = query.getOrDefault("alt")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = newJString("json"))
  if valid_594468 != nil:
    section.add "alt", valid_594468
  var valid_594469 = query.getOrDefault("oauth_token")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = nil)
  if valid_594469 != nil:
    section.add "oauth_token", valid_594469
  var valid_594470 = query.getOrDefault("callback")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "callback", valid_594470
  var valid_594471 = query.getOrDefault("access_token")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = nil)
  if valid_594471 != nil:
    section.add "access_token", valid_594471
  var valid_594472 = query.getOrDefault("uploadType")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "uploadType", valid_594472
  var valid_594473 = query.getOrDefault("key")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "key", valid_594473
  var valid_594474 = query.getOrDefault("$.xgafv")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = newJString("1"))
  if valid_594474 != nil:
    section.add "$.xgafv", valid_594474
  var valid_594475 = query.getOrDefault("prettyPrint")
  valid_594475 = validateParameter(valid_594475, JBool, required = false,
                                 default = newJBool(true))
  if valid_594475 != nil:
    section.add "prettyPrint", valid_594475
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

proc call*(call_594477: Call_MonitoringProjectsUptimeCheckConfigsCreate_594461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Uptime check configuration.
  ## 
  let valid = call_594477.validator(path, query, header, formData, body)
  let scheme = call_594477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594477.url(scheme.get, call_594477.host, call_594477.base,
                         call_594477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594477, url, valid)

proc call*(call_594478: Call_MonitoringProjectsUptimeCheckConfigsCreate_594461;
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
  var path_594479 = newJObject()
  var query_594480 = newJObject()
  var body_594481 = newJObject()
  add(query_594480, "upload_protocol", newJString(uploadProtocol))
  add(query_594480, "fields", newJString(fields))
  add(query_594480, "quotaUser", newJString(quotaUser))
  add(query_594480, "alt", newJString(alt))
  add(query_594480, "oauth_token", newJString(oauthToken))
  add(query_594480, "callback", newJString(callback))
  add(query_594480, "access_token", newJString(accessToken))
  add(query_594480, "uploadType", newJString(uploadType))
  add(path_594479, "parent", newJString(parent))
  add(query_594480, "key", newJString(key))
  add(query_594480, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594481 = body
  add(query_594480, "prettyPrint", newJBool(prettyPrint))
  result = call_594478.call(path_594479, query_594480, nil, nil, body_594481)

var monitoringProjectsUptimeCheckConfigsCreate* = Call_MonitoringProjectsUptimeCheckConfigsCreate_594461(
    name: "monitoringProjectsUptimeCheckConfigsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsCreate_594462,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsCreate_594463,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsList_594440 = ref object of OpenApiRestCall_593421
proc url_MonitoringProjectsUptimeCheckConfigsList_594442(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_MonitoringProjectsUptimeCheckConfigsList_594441(path: JsonNode;
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
  var valid_594443 = path.getOrDefault("parent")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "parent", valid_594443
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
  var valid_594444 = query.getOrDefault("upload_protocol")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "upload_protocol", valid_594444
  var valid_594445 = query.getOrDefault("fields")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "fields", valid_594445
  var valid_594446 = query.getOrDefault("pageToken")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "pageToken", valid_594446
  var valid_594447 = query.getOrDefault("quotaUser")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = nil)
  if valid_594447 != nil:
    section.add "quotaUser", valid_594447
  var valid_594448 = query.getOrDefault("alt")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = newJString("json"))
  if valid_594448 != nil:
    section.add "alt", valid_594448
  var valid_594449 = query.getOrDefault("oauth_token")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "oauth_token", valid_594449
  var valid_594450 = query.getOrDefault("callback")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = nil)
  if valid_594450 != nil:
    section.add "callback", valid_594450
  var valid_594451 = query.getOrDefault("access_token")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "access_token", valid_594451
  var valid_594452 = query.getOrDefault("uploadType")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "uploadType", valid_594452
  var valid_594453 = query.getOrDefault("key")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "key", valid_594453
  var valid_594454 = query.getOrDefault("$.xgafv")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = newJString("1"))
  if valid_594454 != nil:
    section.add "$.xgafv", valid_594454
  var valid_594455 = query.getOrDefault("pageSize")
  valid_594455 = validateParameter(valid_594455, JInt, required = false, default = nil)
  if valid_594455 != nil:
    section.add "pageSize", valid_594455
  var valid_594456 = query.getOrDefault("prettyPrint")
  valid_594456 = validateParameter(valid_594456, JBool, required = false,
                                 default = newJBool(true))
  if valid_594456 != nil:
    section.add "prettyPrint", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_MonitoringProjectsUptimeCheckConfigsList_594440;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_MonitoringProjectsUptimeCheckConfigsList_594440;
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
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(query_594460, "upload_protocol", newJString(uploadProtocol))
  add(query_594460, "fields", newJString(fields))
  add(query_594460, "pageToken", newJString(pageToken))
  add(query_594460, "quotaUser", newJString(quotaUser))
  add(query_594460, "alt", newJString(alt))
  add(query_594460, "oauth_token", newJString(oauthToken))
  add(query_594460, "callback", newJString(callback))
  add(query_594460, "access_token", newJString(accessToken))
  add(query_594460, "uploadType", newJString(uploadType))
  add(path_594459, "parent", newJString(parent))
  add(query_594460, "key", newJString(key))
  add(query_594460, "$.xgafv", newJString(Xgafv))
  add(query_594460, "pageSize", newJInt(pageSize))
  add(query_594460, "prettyPrint", newJBool(prettyPrint))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsList* = Call_MonitoringProjectsUptimeCheckConfigsList_594440(
    name: "monitoringProjectsUptimeCheckConfigsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsList_594441,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsList_594442,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
