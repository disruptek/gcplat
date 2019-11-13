
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579373 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579373](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579373): Option[Scheme] {.used.} =
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
  Call_MonitoringUptimeCheckIpsList_579644 = ref object of OpenApiRestCall_579373
proc url_MonitoringUptimeCheckIpsList_579646(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_MonitoringUptimeCheckIpsList_579645(path: JsonNode; query: JsonNode;
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
  var valid_579758 = query.getOrDefault("key")
  valid_579758 = validateParameter(valid_579758, JString, required = false,
                                 default = nil)
  if valid_579758 != nil:
    section.add "key", valid_579758
  var valid_579772 = query.getOrDefault("prettyPrint")
  valid_579772 = validateParameter(valid_579772, JBool, required = false,
                                 default = newJBool(true))
  if valid_579772 != nil:
    section.add "prettyPrint", valid_579772
  var valid_579773 = query.getOrDefault("oauth_token")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "oauth_token", valid_579773
  var valid_579774 = query.getOrDefault("$.xgafv")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = newJString("1"))
  if valid_579774 != nil:
    section.add "$.xgafv", valid_579774
  var valid_579775 = query.getOrDefault("pageSize")
  valid_579775 = validateParameter(valid_579775, JInt, required = false, default = nil)
  if valid_579775 != nil:
    section.add "pageSize", valid_579775
  var valid_579776 = query.getOrDefault("alt")
  valid_579776 = validateParameter(valid_579776, JString, required = false,
                                 default = newJString("json"))
  if valid_579776 != nil:
    section.add "alt", valid_579776
  var valid_579777 = query.getOrDefault("uploadType")
  valid_579777 = validateParameter(valid_579777, JString, required = false,
                                 default = nil)
  if valid_579777 != nil:
    section.add "uploadType", valid_579777
  var valid_579778 = query.getOrDefault("quotaUser")
  valid_579778 = validateParameter(valid_579778, JString, required = false,
                                 default = nil)
  if valid_579778 != nil:
    section.add "quotaUser", valid_579778
  var valid_579779 = query.getOrDefault("pageToken")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "pageToken", valid_579779
  var valid_579780 = query.getOrDefault("callback")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = nil)
  if valid_579780 != nil:
    section.add "callback", valid_579780
  var valid_579781 = query.getOrDefault("fields")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = nil)
  if valid_579781 != nil:
    section.add "fields", valid_579781
  var valid_579782 = query.getOrDefault("access_token")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "access_token", valid_579782
  var valid_579783 = query.getOrDefault("upload_protocol")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "upload_protocol", valid_579783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579806: Call_MonitoringUptimeCheckIpsList_579644; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of IP addresses that checkers run from
  ## 
  let valid = call_579806.validator(path, query, header, formData, body)
  let scheme = call_579806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579806.url(scheme.get, call_579806.host, call_579806.base,
                         call_579806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579806, url, valid)

proc call*(call_579877: Call_MonitoringUptimeCheckIpsList_579644; key: string = "";
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
  var query_579878 = newJObject()
  add(query_579878, "key", newJString(key))
  add(query_579878, "prettyPrint", newJBool(prettyPrint))
  add(query_579878, "oauth_token", newJString(oauthToken))
  add(query_579878, "$.xgafv", newJString(Xgafv))
  add(query_579878, "pageSize", newJInt(pageSize))
  add(query_579878, "alt", newJString(alt))
  add(query_579878, "uploadType", newJString(uploadType))
  add(query_579878, "quotaUser", newJString(quotaUser))
  add(query_579878, "pageToken", newJString(pageToken))
  add(query_579878, "callback", newJString(callback))
  add(query_579878, "fields", newJString(fields))
  add(query_579878, "access_token", newJString(accessToken))
  add(query_579878, "upload_protocol", newJString(uploadProtocol))
  result = call_579877.call(nil, query_579878, nil, nil, nil)

var monitoringUptimeCheckIpsList* = Call_MonitoringUptimeCheckIpsList_579644(
    name: "monitoringUptimeCheckIpsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/uptimeCheckIps",
    validator: validate_MonitoringUptimeCheckIpsList_579645, base: "/",
    url: url_MonitoringUptimeCheckIpsList_579646, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsUpdate_579951 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsGroupsUpdate_579953(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsUpdate_579952(path: JsonNode;
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
  var valid_579954 = path.getOrDefault("name")
  valid_579954 = validateParameter(valid_579954, JString, required = true,
                                 default = nil)
  if valid_579954 != nil:
    section.add "name", valid_579954
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
  var valid_579955 = query.getOrDefault("key")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "key", valid_579955
  var valid_579956 = query.getOrDefault("prettyPrint")
  valid_579956 = validateParameter(valid_579956, JBool, required = false,
                                 default = newJBool(true))
  if valid_579956 != nil:
    section.add "prettyPrint", valid_579956
  var valid_579957 = query.getOrDefault("oauth_token")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "oauth_token", valid_579957
  var valid_579958 = query.getOrDefault("$.xgafv")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("1"))
  if valid_579958 != nil:
    section.add "$.xgafv", valid_579958
  var valid_579959 = query.getOrDefault("alt")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = newJString("json"))
  if valid_579959 != nil:
    section.add "alt", valid_579959
  var valid_579960 = query.getOrDefault("uploadType")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "uploadType", valid_579960
  var valid_579961 = query.getOrDefault("quotaUser")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "quotaUser", valid_579961
  var valid_579962 = query.getOrDefault("validateOnly")
  valid_579962 = validateParameter(valid_579962, JBool, required = false, default = nil)
  if valid_579962 != nil:
    section.add "validateOnly", valid_579962
  var valid_579963 = query.getOrDefault("callback")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "callback", valid_579963
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("access_token")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "access_token", valid_579965
  var valid_579966 = query.getOrDefault("upload_protocol")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "upload_protocol", valid_579966
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

proc call*(call_579968: Call_MonitoringProjectsGroupsUpdate_579951; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing group. You can change any group attributes except name.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_MonitoringProjectsGroupsUpdate_579951; name: string;
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
  var path_579970 = newJObject()
  var query_579971 = newJObject()
  var body_579972 = newJObject()
  add(query_579971, "key", newJString(key))
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(query_579971, "$.xgafv", newJString(Xgafv))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "uploadType", newJString(uploadType))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(path_579970, "name", newJString(name))
  add(query_579971, "validateOnly", newJBool(validateOnly))
  if body != nil:
    body_579972 = body
  add(query_579971, "callback", newJString(callback))
  add(query_579971, "fields", newJString(fields))
  add(query_579971, "access_token", newJString(accessToken))
  add(query_579971, "upload_protocol", newJString(uploadProtocol))
  result = call_579969.call(path_579970, query_579971, nil, nil, body_579972)

var monitoringProjectsGroupsUpdate* = Call_MonitoringProjectsGroupsUpdate_579951(
    name: "monitoringProjectsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsGroupsUpdate_579952, base: "/",
    url: url_MonitoringProjectsGroupsUpdate_579953, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMonitoredResourceDescriptorsGet_579918 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsMonitoredResourceDescriptorsGet_579920(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsMonitoredResourceDescriptorsGet_579919(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a single monitored resource descriptor. This method does not require a Stackdriver account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The monitored resource descriptor to get. The format is 
  ## "projects/{project_id_or_number}/monitoredResourceDescriptors/{resource_type}". The {resource_type} is a predefined type, such as cloudsql_database.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579935 = path.getOrDefault("name")
  valid_579935 = validateParameter(valid_579935, JString, required = true,
                                 default = nil)
  if valid_579935 != nil:
    section.add "name", valid_579935
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
  var valid_579936 = query.getOrDefault("key")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "key", valid_579936
  var valid_579937 = query.getOrDefault("prettyPrint")
  valid_579937 = validateParameter(valid_579937, JBool, required = false,
                                 default = newJBool(true))
  if valid_579937 != nil:
    section.add "prettyPrint", valid_579937
  var valid_579938 = query.getOrDefault("oauth_token")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "oauth_token", valid_579938
  var valid_579939 = query.getOrDefault("$.xgafv")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = newJString("1"))
  if valid_579939 != nil:
    section.add "$.xgafv", valid_579939
  var valid_579940 = query.getOrDefault("alt")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = newJString("json"))
  if valid_579940 != nil:
    section.add "alt", valid_579940
  var valid_579941 = query.getOrDefault("uploadType")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "uploadType", valid_579941
  var valid_579942 = query.getOrDefault("quotaUser")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = nil)
  if valid_579942 != nil:
    section.add "quotaUser", valid_579942
  var valid_579943 = query.getOrDefault("callback")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "callback", valid_579943
  var valid_579944 = query.getOrDefault("fields")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "fields", valid_579944
  var valid_579945 = query.getOrDefault("access_token")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "access_token", valid_579945
  var valid_579946 = query.getOrDefault("upload_protocol")
  valid_579946 = validateParameter(valid_579946, JString, required = false,
                                 default = nil)
  if valid_579946 != nil:
    section.add "upload_protocol", valid_579946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579947: Call_MonitoringProjectsMonitoredResourceDescriptorsGet_579918;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a single monitored resource descriptor. This method does not require a Stackdriver account.
  ## 
  let valid = call_579947.validator(path, query, header, formData, body)
  let scheme = call_579947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579947.url(scheme.get, call_579947.host, call_579947.base,
                         call_579947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579947, url, valid)

proc call*(call_579948: Call_MonitoringProjectsMonitoredResourceDescriptorsGet_579918;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## monitoringProjectsMonitoredResourceDescriptorsGet
  ## Gets a single monitored resource descriptor. This method does not require a Stackdriver account.
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
  ##       : The monitored resource descriptor to get. The format is 
  ## "projects/{project_id_or_number}/monitoredResourceDescriptors/{resource_type}". The {resource_type} is a predefined type, such as cloudsql_database.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579949 = newJObject()
  var query_579950 = newJObject()
  add(query_579950, "key", newJString(key))
  add(query_579950, "prettyPrint", newJBool(prettyPrint))
  add(query_579950, "oauth_token", newJString(oauthToken))
  add(query_579950, "$.xgafv", newJString(Xgafv))
  add(query_579950, "alt", newJString(alt))
  add(query_579950, "uploadType", newJString(uploadType))
  add(query_579950, "quotaUser", newJString(quotaUser))
  add(path_579949, "name", newJString(name))
  add(query_579950, "callback", newJString(callback))
  add(query_579950, "fields", newJString(fields))
  add(query_579950, "access_token", newJString(accessToken))
  add(query_579950, "upload_protocol", newJString(uploadProtocol))
  result = call_579948.call(path_579949, query_579950, nil, nil, nil)

var monitoringProjectsMonitoredResourceDescriptorsGet* = Call_MonitoringProjectsMonitoredResourceDescriptorsGet_579918(
    name: "monitoringProjectsMonitoredResourceDescriptorsGet",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}",
    validator: validate_MonitoringProjectsMonitoredResourceDescriptorsGet_579919,
    base: "/", url: url_MonitoringProjectsMonitoredResourceDescriptorsGet_579920,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsPatch_579993 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsUptimeCheckConfigsPatch_579995(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsPatch_579994(path: JsonNode;
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
  var valid_579996 = path.getOrDefault("name")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "name", valid_579996
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
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("$.xgafv")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("1"))
  if valid_580000 != nil:
    section.add "$.xgafv", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("uploadType")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "uploadType", valid_580002
  var valid_580003 = query.getOrDefault("quotaUser")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "quotaUser", valid_580003
  var valid_580004 = query.getOrDefault("updateMask")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "updateMask", valid_580004
  var valid_580005 = query.getOrDefault("callback")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "callback", valid_580005
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("access_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "access_token", valid_580007
  var valid_580008 = query.getOrDefault("upload_protocol")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "upload_protocol", valid_580008
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

proc call*(call_580010: Call_MonitoringProjectsUptimeCheckConfigsPatch_579993;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an Uptime check configuration. You can either replace the entire configuration with a new one or replace only certain fields in the current configuration by specifying the fields to be updated via updateMask. Returns the updated configuration.
  ## 
  let valid = call_580010.validator(path, query, header, formData, body)
  let scheme = call_580010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580010.url(scheme.get, call_580010.host, call_580010.base,
                         call_580010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580010, url, valid)

proc call*(call_580011: Call_MonitoringProjectsUptimeCheckConfigsPatch_579993;
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
  var path_580012 = newJObject()
  var query_580013 = newJObject()
  var body_580014 = newJObject()
  add(query_580013, "key", newJString(key))
  add(query_580013, "prettyPrint", newJBool(prettyPrint))
  add(query_580013, "oauth_token", newJString(oauthToken))
  add(query_580013, "$.xgafv", newJString(Xgafv))
  add(query_580013, "alt", newJString(alt))
  add(query_580013, "uploadType", newJString(uploadType))
  add(query_580013, "quotaUser", newJString(quotaUser))
  add(path_580012, "name", newJString(name))
  add(query_580013, "updateMask", newJString(updateMask))
  if body != nil:
    body_580014 = body
  add(query_580013, "callback", newJString(callback))
  add(query_580013, "fields", newJString(fields))
  add(query_580013, "access_token", newJString(accessToken))
  add(query_580013, "upload_protocol", newJString(uploadProtocol))
  result = call_580011.call(path_580012, query_580013, nil, nil, body_580014)

var monitoringProjectsUptimeCheckConfigsPatch* = Call_MonitoringProjectsUptimeCheckConfigsPatch_579993(
    name: "monitoringProjectsUptimeCheckConfigsPatch", meth: HttpMethod.HttpPatch,
    host: "monitoring.googleapis.com", route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsPatch_579994,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsPatch_579995,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsDelete_579973 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsUptimeCheckConfigsDelete_579975(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsDelete_579974(path: JsonNode;
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
  var valid_579976 = path.getOrDefault("name")
  valid_579976 = validateParameter(valid_579976, JString, required = true,
                                 default = nil)
  if valid_579976 != nil:
    section.add "name", valid_579976
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
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("prettyPrint")
  valid_579978 = validateParameter(valid_579978, JBool, required = false,
                                 default = newJBool(true))
  if valid_579978 != nil:
    section.add "prettyPrint", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("$.xgafv")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = newJString("1"))
  if valid_579980 != nil:
    section.add "$.xgafv", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("uploadType")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "uploadType", valid_579982
  var valid_579983 = query.getOrDefault("quotaUser")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "quotaUser", valid_579983
  var valid_579984 = query.getOrDefault("force")
  valid_579984 = validateParameter(valid_579984, JBool, required = false, default = nil)
  if valid_579984 != nil:
    section.add "force", valid_579984
  var valid_579985 = query.getOrDefault("callback")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "callback", valid_579985
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  var valid_579987 = query.getOrDefault("access_token")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "access_token", valid_579987
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579989: Call_MonitoringProjectsUptimeCheckConfigsDelete_579973;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an Uptime check configuration. Note that this method will fail if the Uptime check configuration is referenced by an alert policy or other dependent configs that would be rendered invalid by the deletion.
  ## 
  let valid = call_579989.validator(path, query, header, formData, body)
  let scheme = call_579989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579989.url(scheme.get, call_579989.host, call_579989.base,
                         call_579989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579989, url, valid)

proc call*(call_579990: Call_MonitoringProjectsUptimeCheckConfigsDelete_579973;
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
  var path_579991 = newJObject()
  var query_579992 = newJObject()
  add(query_579992, "key", newJString(key))
  add(query_579992, "prettyPrint", newJBool(prettyPrint))
  add(query_579992, "oauth_token", newJString(oauthToken))
  add(query_579992, "$.xgafv", newJString(Xgafv))
  add(query_579992, "alt", newJString(alt))
  add(query_579992, "uploadType", newJString(uploadType))
  add(query_579992, "quotaUser", newJString(quotaUser))
  add(path_579991, "name", newJString(name))
  add(query_579992, "force", newJBool(force))
  add(query_579992, "callback", newJString(callback))
  add(query_579992, "fields", newJString(fields))
  add(query_579992, "access_token", newJString(accessToken))
  add(query_579992, "upload_protocol", newJString(uploadProtocol))
  result = call_579990.call(path_579991, query_579992, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsDelete* = Call_MonitoringProjectsUptimeCheckConfigsDelete_579973(
    name: "monitoringProjectsUptimeCheckConfigsDelete",
    meth: HttpMethod.HttpDelete, host: "monitoring.googleapis.com",
    route: "/v3/{name}",
    validator: validate_MonitoringProjectsUptimeCheckConfigsDelete_579974,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsDelete_579975,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesCreate_580038 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsAlertPoliciesCreate_580040(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsAlertPoliciesCreate_580039(path: JsonNode;
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
  var valid_580041 = path.getOrDefault("name")
  valid_580041 = validateParameter(valid_580041, JString, required = true,
                                 default = nil)
  if valid_580041 != nil:
    section.add "name", valid_580041
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
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("prettyPrint")
  valid_580043 = validateParameter(valid_580043, JBool, required = false,
                                 default = newJBool(true))
  if valid_580043 != nil:
    section.add "prettyPrint", valid_580043
  var valid_580044 = query.getOrDefault("oauth_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "oauth_token", valid_580044
  var valid_580045 = query.getOrDefault("$.xgafv")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("1"))
  if valid_580045 != nil:
    section.add "$.xgafv", valid_580045
  var valid_580046 = query.getOrDefault("alt")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = newJString("json"))
  if valid_580046 != nil:
    section.add "alt", valid_580046
  var valid_580047 = query.getOrDefault("uploadType")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "uploadType", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("callback")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "callback", valid_580049
  var valid_580050 = query.getOrDefault("fields")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "fields", valid_580050
  var valid_580051 = query.getOrDefault("access_token")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "access_token", valid_580051
  var valid_580052 = query.getOrDefault("upload_protocol")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "upload_protocol", valid_580052
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

proc call*(call_580054: Call_MonitoringProjectsAlertPoliciesCreate_580038;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new alerting policy.
  ## 
  let valid = call_580054.validator(path, query, header, formData, body)
  let scheme = call_580054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580054.url(scheme.get, call_580054.host, call_580054.base,
                         call_580054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580054, url, valid)

proc call*(call_580055: Call_MonitoringProjectsAlertPoliciesCreate_580038;
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
  var path_580056 = newJObject()
  var query_580057 = newJObject()
  var body_580058 = newJObject()
  add(query_580057, "key", newJString(key))
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(query_580057, "$.xgafv", newJString(Xgafv))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "uploadType", newJString(uploadType))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(path_580056, "name", newJString(name))
  if body != nil:
    body_580058 = body
  add(query_580057, "callback", newJString(callback))
  add(query_580057, "fields", newJString(fields))
  add(query_580057, "access_token", newJString(accessToken))
  add(query_580057, "upload_protocol", newJString(uploadProtocol))
  result = call_580055.call(path_580056, query_580057, nil, nil, body_580058)

var monitoringProjectsAlertPoliciesCreate* = Call_MonitoringProjectsAlertPoliciesCreate_580038(
    name: "monitoringProjectsAlertPoliciesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesCreate_580039, base: "/",
    url: url_MonitoringProjectsAlertPoliciesCreate_580040, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsAlertPoliciesList_580015 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsAlertPoliciesList_580017(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsAlertPoliciesList_580016(path: JsonNode;
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
  var valid_580018 = path.getOrDefault("name")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "name", valid_580018
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
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("prettyPrint")
  valid_580020 = validateParameter(valid_580020, JBool, required = false,
                                 default = newJBool(true))
  if valid_580020 != nil:
    section.add "prettyPrint", valid_580020
  var valid_580021 = query.getOrDefault("oauth_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "oauth_token", valid_580021
  var valid_580022 = query.getOrDefault("$.xgafv")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = newJString("1"))
  if valid_580022 != nil:
    section.add "$.xgafv", valid_580022
  var valid_580023 = query.getOrDefault("pageSize")
  valid_580023 = validateParameter(valid_580023, JInt, required = false, default = nil)
  if valid_580023 != nil:
    section.add "pageSize", valid_580023
  var valid_580024 = query.getOrDefault("alt")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("json"))
  if valid_580024 != nil:
    section.add "alt", valid_580024
  var valid_580025 = query.getOrDefault("uploadType")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "uploadType", valid_580025
  var valid_580026 = query.getOrDefault("quotaUser")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "quotaUser", valid_580026
  var valid_580027 = query.getOrDefault("orderBy")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "orderBy", valid_580027
  var valid_580028 = query.getOrDefault("filter")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "filter", valid_580028
  var valid_580029 = query.getOrDefault("pageToken")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "pageToken", valid_580029
  var valid_580030 = query.getOrDefault("callback")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "callback", valid_580030
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("access_token")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "access_token", valid_580032
  var valid_580033 = query.getOrDefault("upload_protocol")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "upload_protocol", valid_580033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580034: Call_MonitoringProjectsAlertPoliciesList_580015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing alerting policies for the project.
  ## 
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_MonitoringProjectsAlertPoliciesList_580015;
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
  var path_580036 = newJObject()
  var query_580037 = newJObject()
  add(query_580037, "key", newJString(key))
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "$.xgafv", newJString(Xgafv))
  add(query_580037, "pageSize", newJInt(pageSize))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "uploadType", newJString(uploadType))
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(path_580036, "name", newJString(name))
  add(query_580037, "orderBy", newJString(orderBy))
  add(query_580037, "filter", newJString(filter))
  add(query_580037, "pageToken", newJString(pageToken))
  add(query_580037, "callback", newJString(callback))
  add(query_580037, "fields", newJString(fields))
  add(query_580037, "access_token", newJString(accessToken))
  add(query_580037, "upload_protocol", newJString(uploadProtocol))
  result = call_580035.call(path_580036, query_580037, nil, nil, nil)

var monitoringProjectsAlertPoliciesList* = Call_MonitoringProjectsAlertPoliciesList_580015(
    name: "monitoringProjectsAlertPoliciesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/alertPolicies",
    validator: validate_MonitoringProjectsAlertPoliciesList_580016, base: "/",
    url: url_MonitoringProjectsAlertPoliciesList_580017, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsCollectdTimeSeriesCreate_580059 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsCollectdTimeSeriesCreate_580061(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsCollectdTimeSeriesCreate_580060(path: JsonNode;
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
  var valid_580062 = path.getOrDefault("name")
  valid_580062 = validateParameter(valid_580062, JString, required = true,
                                 default = nil)
  if valid_580062 != nil:
    section.add "name", valid_580062
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
  var valid_580063 = query.getOrDefault("key")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "key", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  var valid_580065 = query.getOrDefault("oauth_token")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "oauth_token", valid_580065
  var valid_580066 = query.getOrDefault("$.xgafv")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("1"))
  if valid_580066 != nil:
    section.add "$.xgafv", valid_580066
  var valid_580067 = query.getOrDefault("alt")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("json"))
  if valid_580067 != nil:
    section.add "alt", valid_580067
  var valid_580068 = query.getOrDefault("uploadType")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "uploadType", valid_580068
  var valid_580069 = query.getOrDefault("quotaUser")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "quotaUser", valid_580069
  var valid_580070 = query.getOrDefault("callback")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "callback", valid_580070
  var valid_580071 = query.getOrDefault("fields")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "fields", valid_580071
  var valid_580072 = query.getOrDefault("access_token")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "access_token", valid_580072
  var valid_580073 = query.getOrDefault("upload_protocol")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "upload_protocol", valid_580073
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

proc call*(call_580075: Call_MonitoringProjectsCollectdTimeSeriesCreate_580059;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Stackdriver Monitoring Agent only: Creates a new time series.<aside class="caution">This method is only for use by the Stackdriver Monitoring Agent. Use projects.timeSeries.create instead.</aside>
  ## 
  let valid = call_580075.validator(path, query, header, formData, body)
  let scheme = call_580075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580075.url(scheme.get, call_580075.host, call_580075.base,
                         call_580075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580075, url, valid)

proc call*(call_580076: Call_MonitoringProjectsCollectdTimeSeriesCreate_580059;
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
  var path_580077 = newJObject()
  var query_580078 = newJObject()
  var body_580079 = newJObject()
  add(query_580078, "key", newJString(key))
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "$.xgafv", newJString(Xgafv))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "uploadType", newJString(uploadType))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(path_580077, "name", newJString(name))
  if body != nil:
    body_580079 = body
  add(query_580078, "callback", newJString(callback))
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "access_token", newJString(accessToken))
  add(query_580078, "upload_protocol", newJString(uploadProtocol))
  result = call_580076.call(path_580077, query_580078, nil, nil, body_580079)

var monitoringProjectsCollectdTimeSeriesCreate* = Call_MonitoringProjectsCollectdTimeSeriesCreate_580059(
    name: "monitoringProjectsCollectdTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/collectdTimeSeries",
    validator: validate_MonitoringProjectsCollectdTimeSeriesCreate_580060,
    base: "/", url: url_MonitoringProjectsCollectdTimeSeriesCreate_580061,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsCreate_580104 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsGroupsCreate_580106(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsCreate_580105(path: JsonNode;
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
  var valid_580107 = path.getOrDefault("name")
  valid_580107 = validateParameter(valid_580107, JString, required = true,
                                 default = nil)
  if valid_580107 != nil:
    section.add "name", valid_580107
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
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("$.xgafv")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("1"))
  if valid_580111 != nil:
    section.add "$.xgafv", valid_580111
  var valid_580112 = query.getOrDefault("alt")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("json"))
  if valid_580112 != nil:
    section.add "alt", valid_580112
  var valid_580113 = query.getOrDefault("uploadType")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "uploadType", valid_580113
  var valid_580114 = query.getOrDefault("quotaUser")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "quotaUser", valid_580114
  var valid_580115 = query.getOrDefault("validateOnly")
  valid_580115 = validateParameter(valid_580115, JBool, required = false, default = nil)
  if valid_580115 != nil:
    section.add "validateOnly", valid_580115
  var valid_580116 = query.getOrDefault("callback")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "callback", valid_580116
  var valid_580117 = query.getOrDefault("fields")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "fields", valid_580117
  var valid_580118 = query.getOrDefault("access_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "access_token", valid_580118
  var valid_580119 = query.getOrDefault("upload_protocol")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "upload_protocol", valid_580119
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

proc call*(call_580121: Call_MonitoringProjectsGroupsCreate_580104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new group.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_MonitoringProjectsGroupsCreate_580104; name: string;
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
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  var body_580125 = newJObject()
  add(query_580124, "key", newJString(key))
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "$.xgafv", newJString(Xgafv))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "uploadType", newJString(uploadType))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(path_580123, "name", newJString(name))
  add(query_580124, "validateOnly", newJBool(validateOnly))
  if body != nil:
    body_580125 = body
  add(query_580124, "callback", newJString(callback))
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "access_token", newJString(accessToken))
  add(query_580124, "upload_protocol", newJString(uploadProtocol))
  result = call_580122.call(path_580123, query_580124, nil, nil, body_580125)

var monitoringProjectsGroupsCreate* = Call_MonitoringProjectsGroupsCreate_580104(
    name: "monitoringProjectsGroupsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsCreate_580105, base: "/",
    url: url_MonitoringProjectsGroupsCreate_580106, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsList_580080 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsGroupsList_580082(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsList_580081(path: JsonNode; query: JsonNode;
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
  var valid_580083 = path.getOrDefault("name")
  valid_580083 = validateParameter(valid_580083, JString, required = true,
                                 default = nil)
  if valid_580083 != nil:
    section.add "name", valid_580083
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
  var valid_580084 = query.getOrDefault("key")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "key", valid_580084
  var valid_580085 = query.getOrDefault("prettyPrint")
  valid_580085 = validateParameter(valid_580085, JBool, required = false,
                                 default = newJBool(true))
  if valid_580085 != nil:
    section.add "prettyPrint", valid_580085
  var valid_580086 = query.getOrDefault("oauth_token")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "oauth_token", valid_580086
  var valid_580087 = query.getOrDefault("$.xgafv")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = newJString("1"))
  if valid_580087 != nil:
    section.add "$.xgafv", valid_580087
  var valid_580088 = query.getOrDefault("pageSize")
  valid_580088 = validateParameter(valid_580088, JInt, required = false, default = nil)
  if valid_580088 != nil:
    section.add "pageSize", valid_580088
  var valid_580089 = query.getOrDefault("descendantsOfGroup")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "descendantsOfGroup", valid_580089
  var valid_580090 = query.getOrDefault("alt")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = newJString("json"))
  if valid_580090 != nil:
    section.add "alt", valid_580090
  var valid_580091 = query.getOrDefault("uploadType")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "uploadType", valid_580091
  var valid_580092 = query.getOrDefault("quotaUser")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "quotaUser", valid_580092
  var valid_580093 = query.getOrDefault("pageToken")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "pageToken", valid_580093
  var valid_580094 = query.getOrDefault("childrenOfGroup")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "childrenOfGroup", valid_580094
  var valid_580095 = query.getOrDefault("callback")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "callback", valid_580095
  var valid_580096 = query.getOrDefault("fields")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "fields", valid_580096
  var valid_580097 = query.getOrDefault("access_token")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "access_token", valid_580097
  var valid_580098 = query.getOrDefault("upload_protocol")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "upload_protocol", valid_580098
  var valid_580099 = query.getOrDefault("ancestorsOfGroup")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "ancestorsOfGroup", valid_580099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580100: Call_MonitoringProjectsGroupsList_580080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the existing groups.
  ## 
  let valid = call_580100.validator(path, query, header, formData, body)
  let scheme = call_580100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580100.url(scheme.get, call_580100.host, call_580100.base,
                         call_580100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580100, url, valid)

proc call*(call_580101: Call_MonitoringProjectsGroupsList_580080; name: string;
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
  var path_580102 = newJObject()
  var query_580103 = newJObject()
  add(query_580103, "key", newJString(key))
  add(query_580103, "prettyPrint", newJBool(prettyPrint))
  add(query_580103, "oauth_token", newJString(oauthToken))
  add(query_580103, "$.xgafv", newJString(Xgafv))
  add(query_580103, "pageSize", newJInt(pageSize))
  add(query_580103, "descendantsOfGroup", newJString(descendantsOfGroup))
  add(query_580103, "alt", newJString(alt))
  add(query_580103, "uploadType", newJString(uploadType))
  add(query_580103, "quotaUser", newJString(quotaUser))
  add(path_580102, "name", newJString(name))
  add(query_580103, "pageToken", newJString(pageToken))
  add(query_580103, "childrenOfGroup", newJString(childrenOfGroup))
  add(query_580103, "callback", newJString(callback))
  add(query_580103, "fields", newJString(fields))
  add(query_580103, "access_token", newJString(accessToken))
  add(query_580103, "upload_protocol", newJString(uploadProtocol))
  add(query_580103, "ancestorsOfGroup", newJString(ancestorsOfGroup))
  result = call_580101.call(path_580102, query_580103, nil, nil, nil)

var monitoringProjectsGroupsList* = Call_MonitoringProjectsGroupsList_580080(
    name: "monitoringProjectsGroupsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/groups",
    validator: validate_MonitoringProjectsGroupsList_580081, base: "/",
    url: url_MonitoringProjectsGroupsList_580082, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsGroupsMembersList_580126 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsGroupsMembersList_580128(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsGroupsMembersList_580127(path: JsonNode;
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
  var valid_580129 = path.getOrDefault("name")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "name", valid_580129
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
  var valid_580130 = query.getOrDefault("key")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "key", valid_580130
  var valid_580131 = query.getOrDefault("prettyPrint")
  valid_580131 = validateParameter(valid_580131, JBool, required = false,
                                 default = newJBool(true))
  if valid_580131 != nil:
    section.add "prettyPrint", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("$.xgafv")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = newJString("1"))
  if valid_580133 != nil:
    section.add "$.xgafv", valid_580133
  var valid_580134 = query.getOrDefault("pageSize")
  valid_580134 = validateParameter(valid_580134, JInt, required = false, default = nil)
  if valid_580134 != nil:
    section.add "pageSize", valid_580134
  var valid_580135 = query.getOrDefault("interval.endTime")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "interval.endTime", valid_580135
  var valid_580136 = query.getOrDefault("alt")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = newJString("json"))
  if valid_580136 != nil:
    section.add "alt", valid_580136
  var valid_580137 = query.getOrDefault("uploadType")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "uploadType", valid_580137
  var valid_580138 = query.getOrDefault("quotaUser")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "quotaUser", valid_580138
  var valid_580139 = query.getOrDefault("filter")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "filter", valid_580139
  var valid_580140 = query.getOrDefault("pageToken")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = nil)
  if valid_580140 != nil:
    section.add "pageToken", valid_580140
  var valid_580141 = query.getOrDefault("callback")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "callback", valid_580141
  var valid_580142 = query.getOrDefault("fields")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "fields", valid_580142
  var valid_580143 = query.getOrDefault("access_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "access_token", valid_580143
  var valid_580144 = query.getOrDefault("upload_protocol")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "upload_protocol", valid_580144
  var valid_580145 = query.getOrDefault("interval.startTime")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "interval.startTime", valid_580145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580146: Call_MonitoringProjectsGroupsMembersList_580126;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the monitored resources that are members of a group.
  ## 
  let valid = call_580146.validator(path, query, header, formData, body)
  let scheme = call_580146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580146.url(scheme.get, call_580146.host, call_580146.base,
                         call_580146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580146, url, valid)

proc call*(call_580147: Call_MonitoringProjectsGroupsMembersList_580126;
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
  var path_580148 = newJObject()
  var query_580149 = newJObject()
  add(query_580149, "key", newJString(key))
  add(query_580149, "prettyPrint", newJBool(prettyPrint))
  add(query_580149, "oauth_token", newJString(oauthToken))
  add(query_580149, "$.xgafv", newJString(Xgafv))
  add(query_580149, "pageSize", newJInt(pageSize))
  add(query_580149, "interval.endTime", newJString(intervalEndTime))
  add(query_580149, "alt", newJString(alt))
  add(query_580149, "uploadType", newJString(uploadType))
  add(query_580149, "quotaUser", newJString(quotaUser))
  add(path_580148, "name", newJString(name))
  add(query_580149, "filter", newJString(filter))
  add(query_580149, "pageToken", newJString(pageToken))
  add(query_580149, "callback", newJString(callback))
  add(query_580149, "fields", newJString(fields))
  add(query_580149, "access_token", newJString(accessToken))
  add(query_580149, "upload_protocol", newJString(uploadProtocol))
  add(query_580149, "interval.startTime", newJString(intervalStartTime))
  result = call_580147.call(path_580148, query_580149, nil, nil, nil)

var monitoringProjectsGroupsMembersList* = Call_MonitoringProjectsGroupsMembersList_580126(
    name: "monitoringProjectsGroupsMembersList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/members",
    validator: validate_MonitoringProjectsGroupsMembersList_580127, base: "/",
    url: url_MonitoringProjectsGroupsMembersList_580128, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsCreate_580172 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsMetricDescriptorsCreate_580174(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsMetricDescriptorsCreate_580173(path: JsonNode;
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
  var valid_580175 = path.getOrDefault("name")
  valid_580175 = validateParameter(valid_580175, JString, required = true,
                                 default = nil)
  if valid_580175 != nil:
    section.add "name", valid_580175
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
  var valid_580176 = query.getOrDefault("key")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "key", valid_580176
  var valid_580177 = query.getOrDefault("prettyPrint")
  valid_580177 = validateParameter(valid_580177, JBool, required = false,
                                 default = newJBool(true))
  if valid_580177 != nil:
    section.add "prettyPrint", valid_580177
  var valid_580178 = query.getOrDefault("oauth_token")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "oauth_token", valid_580178
  var valid_580179 = query.getOrDefault("$.xgafv")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = newJString("1"))
  if valid_580179 != nil:
    section.add "$.xgafv", valid_580179
  var valid_580180 = query.getOrDefault("alt")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("json"))
  if valid_580180 != nil:
    section.add "alt", valid_580180
  var valid_580181 = query.getOrDefault("uploadType")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "uploadType", valid_580181
  var valid_580182 = query.getOrDefault("quotaUser")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "quotaUser", valid_580182
  var valid_580183 = query.getOrDefault("callback")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "callback", valid_580183
  var valid_580184 = query.getOrDefault("fields")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "fields", valid_580184
  var valid_580185 = query.getOrDefault("access_token")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "access_token", valid_580185
  var valid_580186 = query.getOrDefault("upload_protocol")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "upload_protocol", valid_580186
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

proc call*(call_580188: Call_MonitoringProjectsMetricDescriptorsCreate_580172;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new metric descriptor. User-created metric descriptors define custom metrics.
  ## 
  let valid = call_580188.validator(path, query, header, formData, body)
  let scheme = call_580188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580188.url(scheme.get, call_580188.host, call_580188.base,
                         call_580188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580188, url, valid)

proc call*(call_580189: Call_MonitoringProjectsMetricDescriptorsCreate_580172;
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
  var path_580190 = newJObject()
  var query_580191 = newJObject()
  var body_580192 = newJObject()
  add(query_580191, "key", newJString(key))
  add(query_580191, "prettyPrint", newJBool(prettyPrint))
  add(query_580191, "oauth_token", newJString(oauthToken))
  add(query_580191, "$.xgafv", newJString(Xgafv))
  add(query_580191, "alt", newJString(alt))
  add(query_580191, "uploadType", newJString(uploadType))
  add(query_580191, "quotaUser", newJString(quotaUser))
  add(path_580190, "name", newJString(name))
  if body != nil:
    body_580192 = body
  add(query_580191, "callback", newJString(callback))
  add(query_580191, "fields", newJString(fields))
  add(query_580191, "access_token", newJString(accessToken))
  add(query_580191, "upload_protocol", newJString(uploadProtocol))
  result = call_580189.call(path_580190, query_580191, nil, nil, body_580192)

var monitoringProjectsMetricDescriptorsCreate* = Call_MonitoringProjectsMetricDescriptorsCreate_580172(
    name: "monitoringProjectsMetricDescriptorsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsCreate_580173,
    base: "/", url: url_MonitoringProjectsMetricDescriptorsCreate_580174,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMetricDescriptorsList_580150 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsMetricDescriptorsList_580152(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsMetricDescriptorsList_580151(path: JsonNode;
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
  var valid_580153 = path.getOrDefault("name")
  valid_580153 = validateParameter(valid_580153, JString, required = true,
                                 default = nil)
  if valid_580153 != nil:
    section.add "name", valid_580153
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
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("prettyPrint")
  valid_580155 = validateParameter(valid_580155, JBool, required = false,
                                 default = newJBool(true))
  if valid_580155 != nil:
    section.add "prettyPrint", valid_580155
  var valid_580156 = query.getOrDefault("oauth_token")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "oauth_token", valid_580156
  var valid_580157 = query.getOrDefault("$.xgafv")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = newJString("1"))
  if valid_580157 != nil:
    section.add "$.xgafv", valid_580157
  var valid_580158 = query.getOrDefault("pageSize")
  valid_580158 = validateParameter(valid_580158, JInt, required = false, default = nil)
  if valid_580158 != nil:
    section.add "pageSize", valid_580158
  var valid_580159 = query.getOrDefault("alt")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("json"))
  if valid_580159 != nil:
    section.add "alt", valid_580159
  var valid_580160 = query.getOrDefault("uploadType")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "uploadType", valid_580160
  var valid_580161 = query.getOrDefault("quotaUser")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "quotaUser", valid_580161
  var valid_580162 = query.getOrDefault("filter")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "filter", valid_580162
  var valid_580163 = query.getOrDefault("pageToken")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "pageToken", valid_580163
  var valid_580164 = query.getOrDefault("callback")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "callback", valid_580164
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("access_token")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "access_token", valid_580166
  var valid_580167 = query.getOrDefault("upload_protocol")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "upload_protocol", valid_580167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580168: Call_MonitoringProjectsMetricDescriptorsList_580150;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists metric descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_580168.validator(path, query, header, formData, body)
  let scheme = call_580168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580168.url(scheme.get, call_580168.host, call_580168.base,
                         call_580168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580168, url, valid)

proc call*(call_580169: Call_MonitoringProjectsMetricDescriptorsList_580150;
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
  var path_580170 = newJObject()
  var query_580171 = newJObject()
  add(query_580171, "key", newJString(key))
  add(query_580171, "prettyPrint", newJBool(prettyPrint))
  add(query_580171, "oauth_token", newJString(oauthToken))
  add(query_580171, "$.xgafv", newJString(Xgafv))
  add(query_580171, "pageSize", newJInt(pageSize))
  add(query_580171, "alt", newJString(alt))
  add(query_580171, "uploadType", newJString(uploadType))
  add(query_580171, "quotaUser", newJString(quotaUser))
  add(path_580170, "name", newJString(name))
  add(query_580171, "filter", newJString(filter))
  add(query_580171, "pageToken", newJString(pageToken))
  add(query_580171, "callback", newJString(callback))
  add(query_580171, "fields", newJString(fields))
  add(query_580171, "access_token", newJString(accessToken))
  add(query_580171, "upload_protocol", newJString(uploadProtocol))
  result = call_580169.call(path_580170, query_580171, nil, nil, nil)

var monitoringProjectsMetricDescriptorsList* = Call_MonitoringProjectsMetricDescriptorsList_580150(
    name: "monitoringProjectsMetricDescriptorsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/metricDescriptors",
    validator: validate_MonitoringProjectsMetricDescriptorsList_580151, base: "/",
    url: url_MonitoringProjectsMetricDescriptorsList_580152,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsMonitoredResourceDescriptorsList_580193 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsMonitoredResourceDescriptorsList_580195(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsMonitoredResourceDescriptorsList_580194(
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
  var valid_580196 = path.getOrDefault("name")
  valid_580196 = validateParameter(valid_580196, JString, required = true,
                                 default = nil)
  if valid_580196 != nil:
    section.add "name", valid_580196
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
  var valid_580197 = query.getOrDefault("key")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "key", valid_580197
  var valid_580198 = query.getOrDefault("prettyPrint")
  valid_580198 = validateParameter(valid_580198, JBool, required = false,
                                 default = newJBool(true))
  if valid_580198 != nil:
    section.add "prettyPrint", valid_580198
  var valid_580199 = query.getOrDefault("oauth_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "oauth_token", valid_580199
  var valid_580200 = query.getOrDefault("$.xgafv")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = newJString("1"))
  if valid_580200 != nil:
    section.add "$.xgafv", valid_580200
  var valid_580201 = query.getOrDefault("pageSize")
  valid_580201 = validateParameter(valid_580201, JInt, required = false, default = nil)
  if valid_580201 != nil:
    section.add "pageSize", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("uploadType")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "uploadType", valid_580203
  var valid_580204 = query.getOrDefault("quotaUser")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "quotaUser", valid_580204
  var valid_580205 = query.getOrDefault("filter")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "filter", valid_580205
  var valid_580206 = query.getOrDefault("pageToken")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "pageToken", valid_580206
  var valid_580207 = query.getOrDefault("callback")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "callback", valid_580207
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  var valid_580209 = query.getOrDefault("access_token")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "access_token", valid_580209
  var valid_580210 = query.getOrDefault("upload_protocol")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "upload_protocol", valid_580210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580211: Call_MonitoringProjectsMonitoredResourceDescriptorsList_580193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists monitored resource descriptors that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_580211.validator(path, query, header, formData, body)
  let scheme = call_580211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580211.url(scheme.get, call_580211.host, call_580211.base,
                         call_580211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580211, url, valid)

proc call*(call_580212: Call_MonitoringProjectsMonitoredResourceDescriptorsList_580193;
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
  var path_580213 = newJObject()
  var query_580214 = newJObject()
  add(query_580214, "key", newJString(key))
  add(query_580214, "prettyPrint", newJBool(prettyPrint))
  add(query_580214, "oauth_token", newJString(oauthToken))
  add(query_580214, "$.xgafv", newJString(Xgafv))
  add(query_580214, "pageSize", newJInt(pageSize))
  add(query_580214, "alt", newJString(alt))
  add(query_580214, "uploadType", newJString(uploadType))
  add(query_580214, "quotaUser", newJString(quotaUser))
  add(path_580213, "name", newJString(name))
  add(query_580214, "filter", newJString(filter))
  add(query_580214, "pageToken", newJString(pageToken))
  add(query_580214, "callback", newJString(callback))
  add(query_580214, "fields", newJString(fields))
  add(query_580214, "access_token", newJString(accessToken))
  add(query_580214, "upload_protocol", newJString(uploadProtocol))
  result = call_580212.call(path_580213, query_580214, nil, nil, nil)

var monitoringProjectsMonitoredResourceDescriptorsList* = Call_MonitoringProjectsMonitoredResourceDescriptorsList_580193(
    name: "monitoringProjectsMonitoredResourceDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/monitoredResourceDescriptors",
    validator: validate_MonitoringProjectsMonitoredResourceDescriptorsList_580194,
    base: "/", url: url_MonitoringProjectsMonitoredResourceDescriptorsList_580195,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelDescriptorsList_580215 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsNotificationChannelDescriptorsList_580217(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelDescriptorsList_580216(
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
  var valid_580218 = path.getOrDefault("name")
  valid_580218 = validateParameter(valid_580218, JString, required = true,
                                 default = nil)
  if valid_580218 != nil:
    section.add "name", valid_580218
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
  var valid_580219 = query.getOrDefault("key")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "key", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("$.xgafv")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = newJString("1"))
  if valid_580222 != nil:
    section.add "$.xgafv", valid_580222
  var valid_580223 = query.getOrDefault("pageSize")
  valid_580223 = validateParameter(valid_580223, JInt, required = false, default = nil)
  if valid_580223 != nil:
    section.add "pageSize", valid_580223
  var valid_580224 = query.getOrDefault("alt")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("json"))
  if valid_580224 != nil:
    section.add "alt", valid_580224
  var valid_580225 = query.getOrDefault("uploadType")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "uploadType", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("pageToken")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "pageToken", valid_580227
  var valid_580228 = query.getOrDefault("callback")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "callback", valid_580228
  var valid_580229 = query.getOrDefault("fields")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "fields", valid_580229
  var valid_580230 = query.getOrDefault("access_token")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "access_token", valid_580230
  var valid_580231 = query.getOrDefault("upload_protocol")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "upload_protocol", valid_580231
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580232: Call_MonitoringProjectsNotificationChannelDescriptorsList_580215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the descriptors for supported channel types. The use of descriptors makes it possible for new channel types to be dynamically added.
  ## 
  let valid = call_580232.validator(path, query, header, formData, body)
  let scheme = call_580232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580232.url(scheme.get, call_580232.host, call_580232.base,
                         call_580232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580232, url, valid)

proc call*(call_580233: Call_MonitoringProjectsNotificationChannelDescriptorsList_580215;
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
  var path_580234 = newJObject()
  var query_580235 = newJObject()
  add(query_580235, "key", newJString(key))
  add(query_580235, "prettyPrint", newJBool(prettyPrint))
  add(query_580235, "oauth_token", newJString(oauthToken))
  add(query_580235, "$.xgafv", newJString(Xgafv))
  add(query_580235, "pageSize", newJInt(pageSize))
  add(query_580235, "alt", newJString(alt))
  add(query_580235, "uploadType", newJString(uploadType))
  add(query_580235, "quotaUser", newJString(quotaUser))
  add(path_580234, "name", newJString(name))
  add(query_580235, "pageToken", newJString(pageToken))
  add(query_580235, "callback", newJString(callback))
  add(query_580235, "fields", newJString(fields))
  add(query_580235, "access_token", newJString(accessToken))
  add(query_580235, "upload_protocol", newJString(uploadProtocol))
  result = call_580233.call(path_580234, query_580235, nil, nil, nil)

var monitoringProjectsNotificationChannelDescriptorsList* = Call_MonitoringProjectsNotificationChannelDescriptorsList_580215(
    name: "monitoringProjectsNotificationChannelDescriptorsList",
    meth: HttpMethod.HttpGet, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannelDescriptors",
    validator: validate_MonitoringProjectsNotificationChannelDescriptorsList_580216,
    base: "/", url: url_MonitoringProjectsNotificationChannelDescriptorsList_580217,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsCreate_580259 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsNotificationChannelsCreate_580261(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsCreate_580260(path: JsonNode;
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
  var valid_580262 = path.getOrDefault("name")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "name", valid_580262
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
  var valid_580263 = query.getOrDefault("key")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "key", valid_580263
  var valid_580264 = query.getOrDefault("prettyPrint")
  valid_580264 = validateParameter(valid_580264, JBool, required = false,
                                 default = newJBool(true))
  if valid_580264 != nil:
    section.add "prettyPrint", valid_580264
  var valid_580265 = query.getOrDefault("oauth_token")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "oauth_token", valid_580265
  var valid_580266 = query.getOrDefault("$.xgafv")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = newJString("1"))
  if valid_580266 != nil:
    section.add "$.xgafv", valid_580266
  var valid_580267 = query.getOrDefault("alt")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = newJString("json"))
  if valid_580267 != nil:
    section.add "alt", valid_580267
  var valid_580268 = query.getOrDefault("uploadType")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "uploadType", valid_580268
  var valid_580269 = query.getOrDefault("quotaUser")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "quotaUser", valid_580269
  var valid_580270 = query.getOrDefault("callback")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "callback", valid_580270
  var valid_580271 = query.getOrDefault("fields")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "fields", valid_580271
  var valid_580272 = query.getOrDefault("access_token")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "access_token", valid_580272
  var valid_580273 = query.getOrDefault("upload_protocol")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "upload_protocol", valid_580273
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

proc call*(call_580275: Call_MonitoringProjectsNotificationChannelsCreate_580259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new notification channel, representing a single notification endpoint such as an email address, SMS number, or PagerDuty service.
  ## 
  let valid = call_580275.validator(path, query, header, formData, body)
  let scheme = call_580275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580275.url(scheme.get, call_580275.host, call_580275.base,
                         call_580275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580275, url, valid)

proc call*(call_580276: Call_MonitoringProjectsNotificationChannelsCreate_580259;
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
  var path_580277 = newJObject()
  var query_580278 = newJObject()
  var body_580279 = newJObject()
  add(query_580278, "key", newJString(key))
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(query_580278, "$.xgafv", newJString(Xgafv))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "uploadType", newJString(uploadType))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(path_580277, "name", newJString(name))
  if body != nil:
    body_580279 = body
  add(query_580278, "callback", newJString(callback))
  add(query_580278, "fields", newJString(fields))
  add(query_580278, "access_token", newJString(accessToken))
  add(query_580278, "upload_protocol", newJString(uploadProtocol))
  result = call_580276.call(path_580277, query_580278, nil, nil, body_580279)

var monitoringProjectsNotificationChannelsCreate* = Call_MonitoringProjectsNotificationChannelsCreate_580259(
    name: "monitoringProjectsNotificationChannelsCreate",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsCreate_580260,
    base: "/", url: url_MonitoringProjectsNotificationChannelsCreate_580261,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsList_580236 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsNotificationChannelsList_580238(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsList_580237(path: JsonNode;
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
  var valid_580239 = path.getOrDefault("name")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "name", valid_580239
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
  var valid_580240 = query.getOrDefault("key")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "key", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
  var valid_580242 = query.getOrDefault("oauth_token")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "oauth_token", valid_580242
  var valid_580243 = query.getOrDefault("$.xgafv")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("1"))
  if valid_580243 != nil:
    section.add "$.xgafv", valid_580243
  var valid_580244 = query.getOrDefault("pageSize")
  valid_580244 = validateParameter(valid_580244, JInt, required = false, default = nil)
  if valid_580244 != nil:
    section.add "pageSize", valid_580244
  var valid_580245 = query.getOrDefault("alt")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("json"))
  if valid_580245 != nil:
    section.add "alt", valid_580245
  var valid_580246 = query.getOrDefault("uploadType")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "uploadType", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("orderBy")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "orderBy", valid_580248
  var valid_580249 = query.getOrDefault("filter")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "filter", valid_580249
  var valid_580250 = query.getOrDefault("pageToken")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "pageToken", valid_580250
  var valid_580251 = query.getOrDefault("callback")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "callback", valid_580251
  var valid_580252 = query.getOrDefault("fields")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "fields", valid_580252
  var valid_580253 = query.getOrDefault("access_token")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "access_token", valid_580253
  var valid_580254 = query.getOrDefault("upload_protocol")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "upload_protocol", valid_580254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580255: Call_MonitoringProjectsNotificationChannelsList_580236;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the notification channels that have been created for the project.
  ## 
  let valid = call_580255.validator(path, query, header, formData, body)
  let scheme = call_580255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580255.url(scheme.get, call_580255.host, call_580255.base,
                         call_580255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580255, url, valid)

proc call*(call_580256: Call_MonitoringProjectsNotificationChannelsList_580236;
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
  var path_580257 = newJObject()
  var query_580258 = newJObject()
  add(query_580258, "key", newJString(key))
  add(query_580258, "prettyPrint", newJBool(prettyPrint))
  add(query_580258, "oauth_token", newJString(oauthToken))
  add(query_580258, "$.xgafv", newJString(Xgafv))
  add(query_580258, "pageSize", newJInt(pageSize))
  add(query_580258, "alt", newJString(alt))
  add(query_580258, "uploadType", newJString(uploadType))
  add(query_580258, "quotaUser", newJString(quotaUser))
  add(path_580257, "name", newJString(name))
  add(query_580258, "orderBy", newJString(orderBy))
  add(query_580258, "filter", newJString(filter))
  add(query_580258, "pageToken", newJString(pageToken))
  add(query_580258, "callback", newJString(callback))
  add(query_580258, "fields", newJString(fields))
  add(query_580258, "access_token", newJString(accessToken))
  add(query_580258, "upload_protocol", newJString(uploadProtocol))
  result = call_580256.call(path_580257, query_580258, nil, nil, nil)

var monitoringProjectsNotificationChannelsList* = Call_MonitoringProjectsNotificationChannelsList_580236(
    name: "monitoringProjectsNotificationChannelsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/notificationChannels",
    validator: validate_MonitoringProjectsNotificationChannelsList_580237,
    base: "/", url: url_MonitoringProjectsNotificationChannelsList_580238,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesCreate_580310 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsTimeSeriesCreate_580312(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsTimeSeriesCreate_580311(path: JsonNode;
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
  var valid_580313 = path.getOrDefault("name")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "name", valid_580313
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
  var valid_580314 = query.getOrDefault("key")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "key", valid_580314
  var valid_580315 = query.getOrDefault("prettyPrint")
  valid_580315 = validateParameter(valid_580315, JBool, required = false,
                                 default = newJBool(true))
  if valid_580315 != nil:
    section.add "prettyPrint", valid_580315
  var valid_580316 = query.getOrDefault("oauth_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "oauth_token", valid_580316
  var valid_580317 = query.getOrDefault("$.xgafv")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = newJString("1"))
  if valid_580317 != nil:
    section.add "$.xgafv", valid_580317
  var valid_580318 = query.getOrDefault("alt")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = newJString("json"))
  if valid_580318 != nil:
    section.add "alt", valid_580318
  var valid_580319 = query.getOrDefault("uploadType")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "uploadType", valid_580319
  var valid_580320 = query.getOrDefault("quotaUser")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "quotaUser", valid_580320
  var valid_580321 = query.getOrDefault("callback")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "callback", valid_580321
  var valid_580322 = query.getOrDefault("fields")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "fields", valid_580322
  var valid_580323 = query.getOrDefault("access_token")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "access_token", valid_580323
  var valid_580324 = query.getOrDefault("upload_protocol")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "upload_protocol", valid_580324
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

proc call*(call_580326: Call_MonitoringProjectsTimeSeriesCreate_580310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or adds data to one or more time series. The response is empty if all time series in the request were written. If any time series could not be written, a corresponding failure message is included in the error response.
  ## 
  let valid = call_580326.validator(path, query, header, formData, body)
  let scheme = call_580326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580326.url(scheme.get, call_580326.host, call_580326.base,
                         call_580326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580326, url, valid)

proc call*(call_580327: Call_MonitoringProjectsTimeSeriesCreate_580310;
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
  var path_580328 = newJObject()
  var query_580329 = newJObject()
  var body_580330 = newJObject()
  add(query_580329, "key", newJString(key))
  add(query_580329, "prettyPrint", newJBool(prettyPrint))
  add(query_580329, "oauth_token", newJString(oauthToken))
  add(query_580329, "$.xgafv", newJString(Xgafv))
  add(query_580329, "alt", newJString(alt))
  add(query_580329, "uploadType", newJString(uploadType))
  add(query_580329, "quotaUser", newJString(quotaUser))
  add(path_580328, "name", newJString(name))
  if body != nil:
    body_580330 = body
  add(query_580329, "callback", newJString(callback))
  add(query_580329, "fields", newJString(fields))
  add(query_580329, "access_token", newJString(accessToken))
  add(query_580329, "upload_protocol", newJString(uploadProtocol))
  result = call_580327.call(path_580328, query_580329, nil, nil, body_580330)

var monitoringProjectsTimeSeriesCreate* = Call_MonitoringProjectsTimeSeriesCreate_580310(
    name: "monitoringProjectsTimeSeriesCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesCreate_580311, base: "/",
    url: url_MonitoringProjectsTimeSeriesCreate_580312, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsTimeSeriesList_580280 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsTimeSeriesList_580282(protocol: Scheme; host: string;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsTimeSeriesList_580281(path: JsonNode;
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
  var valid_580283 = path.getOrDefault("name")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "name", valid_580283
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
  ##          : Unsupported: must be left blank. The points in each time series are currently returned in reverse time order (most recent to oldest).
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
  var valid_580284 = query.getOrDefault("key")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "key", valid_580284
  var valid_580285 = query.getOrDefault("prettyPrint")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(true))
  if valid_580285 != nil:
    section.add "prettyPrint", valid_580285
  var valid_580286 = query.getOrDefault("oauth_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "oauth_token", valid_580286
  var valid_580287 = query.getOrDefault("aggregation.alignmentPeriod")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "aggregation.alignmentPeriod", valid_580287
  var valid_580288 = query.getOrDefault("$.xgafv")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = newJString("1"))
  if valid_580288 != nil:
    section.add "$.xgafv", valid_580288
  var valid_580289 = query.getOrDefault("pageSize")
  valid_580289 = validateParameter(valid_580289, JInt, required = false, default = nil)
  if valid_580289 != nil:
    section.add "pageSize", valid_580289
  var valid_580290 = query.getOrDefault("interval.endTime")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "interval.endTime", valid_580290
  var valid_580291 = query.getOrDefault("alt")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = newJString("json"))
  if valid_580291 != nil:
    section.add "alt", valid_580291
  var valid_580292 = query.getOrDefault("uploadType")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "uploadType", valid_580292
  var valid_580293 = query.getOrDefault("quotaUser")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "quotaUser", valid_580293
  var valid_580294 = query.getOrDefault("orderBy")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "orderBy", valid_580294
  var valid_580295 = query.getOrDefault("filter")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "filter", valid_580295
  var valid_580296 = query.getOrDefault("pageToken")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "pageToken", valid_580296
  var valid_580297 = query.getOrDefault("callback")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "callback", valid_580297
  var valid_580298 = query.getOrDefault("aggregation.crossSeriesReducer")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = newJString("REDUCE_NONE"))
  if valid_580298 != nil:
    section.add "aggregation.crossSeriesReducer", valid_580298
  var valid_580299 = query.getOrDefault("aggregation.perSeriesAligner")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = newJString("ALIGN_NONE"))
  if valid_580299 != nil:
    section.add "aggregation.perSeriesAligner", valid_580299
  var valid_580300 = query.getOrDefault("fields")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "fields", valid_580300
  var valid_580301 = query.getOrDefault("access_token")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "access_token", valid_580301
  var valid_580302 = query.getOrDefault("upload_protocol")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "upload_protocol", valid_580302
  var valid_580303 = query.getOrDefault("aggregation.groupByFields")
  valid_580303 = validateParameter(valid_580303, JArray, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "aggregation.groupByFields", valid_580303
  var valid_580304 = query.getOrDefault("interval.startTime")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "interval.startTime", valid_580304
  var valid_580305 = query.getOrDefault("view")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("FULL"))
  if valid_580305 != nil:
    section.add "view", valid_580305
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580306: Call_MonitoringProjectsTimeSeriesList_580280;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists time series that match a filter. This method does not require a Stackdriver account.
  ## 
  let valid = call_580306.validator(path, query, header, formData, body)
  let scheme = call_580306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580306.url(scheme.get, call_580306.host, call_580306.base,
                         call_580306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580306, url, valid)

proc call*(call_580307: Call_MonitoringProjectsTimeSeriesList_580280; name: string;
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
  ##          : Unsupported: must be left blank. The points in each time series are currently returned in reverse time order (most recent to oldest).
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
  var path_580308 = newJObject()
  var query_580309 = newJObject()
  add(query_580309, "key", newJString(key))
  add(query_580309, "prettyPrint", newJBool(prettyPrint))
  add(query_580309, "oauth_token", newJString(oauthToken))
  add(query_580309, "aggregation.alignmentPeriod",
      newJString(aggregationAlignmentPeriod))
  add(query_580309, "$.xgafv", newJString(Xgafv))
  add(query_580309, "pageSize", newJInt(pageSize))
  add(query_580309, "interval.endTime", newJString(intervalEndTime))
  add(query_580309, "alt", newJString(alt))
  add(query_580309, "uploadType", newJString(uploadType))
  add(query_580309, "quotaUser", newJString(quotaUser))
  add(path_580308, "name", newJString(name))
  add(query_580309, "orderBy", newJString(orderBy))
  add(query_580309, "filter", newJString(filter))
  add(query_580309, "pageToken", newJString(pageToken))
  add(query_580309, "callback", newJString(callback))
  add(query_580309, "aggregation.crossSeriesReducer",
      newJString(aggregationCrossSeriesReducer))
  add(query_580309, "aggregation.perSeriesAligner",
      newJString(aggregationPerSeriesAligner))
  add(query_580309, "fields", newJString(fields))
  add(query_580309, "access_token", newJString(accessToken))
  add(query_580309, "upload_protocol", newJString(uploadProtocol))
  if aggregationGroupByFields != nil:
    query_580309.add "aggregation.groupByFields", aggregationGroupByFields
  add(query_580309, "interval.startTime", newJString(intervalStartTime))
  add(query_580309, "view", newJString(view))
  result = call_580307.call(path_580308, query_580309, nil, nil, nil)

var monitoringProjectsTimeSeriesList* = Call_MonitoringProjectsTimeSeriesList_580280(
    name: "monitoringProjectsTimeSeriesList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{name}/timeSeries",
    validator: validate_MonitoringProjectsTimeSeriesList_580281, base: "/",
    url: url_MonitoringProjectsTimeSeriesList_580282, schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580331 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsNotificationChannelsGetVerificationCode_580333(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsGetVerificationCode_580332(
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
  var valid_580334 = path.getOrDefault("name")
  valid_580334 = validateParameter(valid_580334, JString, required = true,
                                 default = nil)
  if valid_580334 != nil:
    section.add "name", valid_580334
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
  var valid_580335 = query.getOrDefault("key")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "key", valid_580335
  var valid_580336 = query.getOrDefault("prettyPrint")
  valid_580336 = validateParameter(valid_580336, JBool, required = false,
                                 default = newJBool(true))
  if valid_580336 != nil:
    section.add "prettyPrint", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("$.xgafv")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("1"))
  if valid_580338 != nil:
    section.add "$.xgafv", valid_580338
  var valid_580339 = query.getOrDefault("alt")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = newJString("json"))
  if valid_580339 != nil:
    section.add "alt", valid_580339
  var valid_580340 = query.getOrDefault("uploadType")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "uploadType", valid_580340
  var valid_580341 = query.getOrDefault("quotaUser")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "quotaUser", valid_580341
  var valid_580342 = query.getOrDefault("callback")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "callback", valid_580342
  var valid_580343 = query.getOrDefault("fields")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "fields", valid_580343
  var valid_580344 = query.getOrDefault("access_token")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "access_token", valid_580344
  var valid_580345 = query.getOrDefault("upload_protocol")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "upload_protocol", valid_580345
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

proc call*(call_580347: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests a verification code for an already verified channel that can then be used in a call to VerifyNotificationChannel() on a different channel with an equivalent identity in the same or in a different project. This makes it possible to copy a channel between projects without requiring manual reverification of the channel. If the channel is not in the verified state, this method will fail (in other words, this may only be used if the SendNotificationChannelVerificationCode and VerifyNotificationChannel paths have already been used to put the given channel into the verified state).There is no guarantee that the verification codes returned by this method will be of a similar structure or form as the ones that are delivered to the channel via SendNotificationChannelVerificationCode; while VerifyNotificationChannel() will recognize both the codes delivered via SendNotificationChannelVerificationCode() and returned from GetNotificationChannelVerificationCode(), it is typically the case that the verification codes delivered via SendNotificationChannelVerificationCode() will be shorter and also have a shorter expiration (e.g. codes such as "G-123456") whereas GetVerificationCode() will typically return a much longer, websafe base 64 encoded string that has a longer expiration time.
  ## 
  let valid = call_580347.validator(path, query, header, formData, body)
  let scheme = call_580347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580347.url(scheme.get, call_580347.host, call_580347.base,
                         call_580347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580347, url, valid)

proc call*(call_580348: Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580331;
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
  var path_580349 = newJObject()
  var query_580350 = newJObject()
  var body_580351 = newJObject()
  add(query_580350, "key", newJString(key))
  add(query_580350, "prettyPrint", newJBool(prettyPrint))
  add(query_580350, "oauth_token", newJString(oauthToken))
  add(query_580350, "$.xgafv", newJString(Xgafv))
  add(query_580350, "alt", newJString(alt))
  add(query_580350, "uploadType", newJString(uploadType))
  add(query_580350, "quotaUser", newJString(quotaUser))
  add(path_580349, "name", newJString(name))
  if body != nil:
    body_580351 = body
  add(query_580350, "callback", newJString(callback))
  add(query_580350, "fields", newJString(fields))
  add(query_580350, "access_token", newJString(accessToken))
  add(query_580350, "upload_protocol", newJString(uploadProtocol))
  result = call_580348.call(path_580349, query_580350, nil, nil, body_580351)

var monitoringProjectsNotificationChannelsGetVerificationCode* = Call_MonitoringProjectsNotificationChannelsGetVerificationCode_580331(
    name: "monitoringProjectsNotificationChannelsGetVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:getVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsGetVerificationCode_580332,
    base: "/", url: url_MonitoringProjectsNotificationChannelsGetVerificationCode_580333,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580352 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsNotificationChannelsSendVerificationCode_580354(
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsSendVerificationCode_580353(
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
  var valid_580355 = path.getOrDefault("name")
  valid_580355 = validateParameter(valid_580355, JString, required = true,
                                 default = nil)
  if valid_580355 != nil:
    section.add "name", valid_580355
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
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  var valid_580357 = query.getOrDefault("prettyPrint")
  valid_580357 = validateParameter(valid_580357, JBool, required = false,
                                 default = newJBool(true))
  if valid_580357 != nil:
    section.add "prettyPrint", valid_580357
  var valid_580358 = query.getOrDefault("oauth_token")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = nil)
  if valid_580358 != nil:
    section.add "oauth_token", valid_580358
  var valid_580359 = query.getOrDefault("$.xgafv")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = newJString("1"))
  if valid_580359 != nil:
    section.add "$.xgafv", valid_580359
  var valid_580360 = query.getOrDefault("alt")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = newJString("json"))
  if valid_580360 != nil:
    section.add "alt", valid_580360
  var valid_580361 = query.getOrDefault("uploadType")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "uploadType", valid_580361
  var valid_580362 = query.getOrDefault("quotaUser")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "quotaUser", valid_580362
  var valid_580363 = query.getOrDefault("callback")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = nil)
  if valid_580363 != nil:
    section.add "callback", valid_580363
  var valid_580364 = query.getOrDefault("fields")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fields", valid_580364
  var valid_580365 = query.getOrDefault("access_token")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "access_token", valid_580365
  var valid_580366 = query.getOrDefault("upload_protocol")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "upload_protocol", valid_580366
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

proc call*(call_580368: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Causes a verification code to be delivered to the channel. The code can then be supplied in VerifyNotificationChannel to verify the channel.
  ## 
  let valid = call_580368.validator(path, query, header, formData, body)
  let scheme = call_580368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580368.url(scheme.get, call_580368.host, call_580368.base,
                         call_580368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580368, url, valid)

proc call*(call_580369: Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580352;
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
  var path_580370 = newJObject()
  var query_580371 = newJObject()
  var body_580372 = newJObject()
  add(query_580371, "key", newJString(key))
  add(query_580371, "prettyPrint", newJBool(prettyPrint))
  add(query_580371, "oauth_token", newJString(oauthToken))
  add(query_580371, "$.xgafv", newJString(Xgafv))
  add(query_580371, "alt", newJString(alt))
  add(query_580371, "uploadType", newJString(uploadType))
  add(query_580371, "quotaUser", newJString(quotaUser))
  add(path_580370, "name", newJString(name))
  if body != nil:
    body_580372 = body
  add(query_580371, "callback", newJString(callback))
  add(query_580371, "fields", newJString(fields))
  add(query_580371, "access_token", newJString(accessToken))
  add(query_580371, "upload_protocol", newJString(uploadProtocol))
  result = call_580369.call(path_580370, query_580371, nil, nil, body_580372)

var monitoringProjectsNotificationChannelsSendVerificationCode* = Call_MonitoringProjectsNotificationChannelsSendVerificationCode_580352(
    name: "monitoringProjectsNotificationChannelsSendVerificationCode",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:sendVerificationCode", validator: validate_MonitoringProjectsNotificationChannelsSendVerificationCode_580353,
    base: "/",
    url: url_MonitoringProjectsNotificationChannelsSendVerificationCode_580354,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsNotificationChannelsVerify_580373 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsNotificationChannelsVerify_580375(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsNotificationChannelsVerify_580374(path: JsonNode;
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
  var valid_580376 = path.getOrDefault("name")
  valid_580376 = validateParameter(valid_580376, JString, required = true,
                                 default = nil)
  if valid_580376 != nil:
    section.add "name", valid_580376
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
  var valid_580377 = query.getOrDefault("key")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "key", valid_580377
  var valid_580378 = query.getOrDefault("prettyPrint")
  valid_580378 = validateParameter(valid_580378, JBool, required = false,
                                 default = newJBool(true))
  if valid_580378 != nil:
    section.add "prettyPrint", valid_580378
  var valid_580379 = query.getOrDefault("oauth_token")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "oauth_token", valid_580379
  var valid_580380 = query.getOrDefault("$.xgafv")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = newJString("1"))
  if valid_580380 != nil:
    section.add "$.xgafv", valid_580380
  var valid_580381 = query.getOrDefault("alt")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = newJString("json"))
  if valid_580381 != nil:
    section.add "alt", valid_580381
  var valid_580382 = query.getOrDefault("uploadType")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "uploadType", valid_580382
  var valid_580383 = query.getOrDefault("quotaUser")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "quotaUser", valid_580383
  var valid_580384 = query.getOrDefault("callback")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "callback", valid_580384
  var valid_580385 = query.getOrDefault("fields")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "fields", valid_580385
  var valid_580386 = query.getOrDefault("access_token")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "access_token", valid_580386
  var valid_580387 = query.getOrDefault("upload_protocol")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "upload_protocol", valid_580387
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

proc call*(call_580389: Call_MonitoringProjectsNotificationChannelsVerify_580373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verifies a NotificationChannel by proving receipt of the code delivered to the channel as a result of calling SendNotificationChannelVerificationCode.
  ## 
  let valid = call_580389.validator(path, query, header, formData, body)
  let scheme = call_580389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580389.url(scheme.get, call_580389.host, call_580389.base,
                         call_580389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580389, url, valid)

proc call*(call_580390: Call_MonitoringProjectsNotificationChannelsVerify_580373;
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
  var path_580391 = newJObject()
  var query_580392 = newJObject()
  var body_580393 = newJObject()
  add(query_580392, "key", newJString(key))
  add(query_580392, "prettyPrint", newJBool(prettyPrint))
  add(query_580392, "oauth_token", newJString(oauthToken))
  add(query_580392, "$.xgafv", newJString(Xgafv))
  add(query_580392, "alt", newJString(alt))
  add(query_580392, "uploadType", newJString(uploadType))
  add(query_580392, "quotaUser", newJString(quotaUser))
  add(path_580391, "name", newJString(name))
  if body != nil:
    body_580393 = body
  add(query_580392, "callback", newJString(callback))
  add(query_580392, "fields", newJString(fields))
  add(query_580392, "access_token", newJString(accessToken))
  add(query_580392, "upload_protocol", newJString(uploadProtocol))
  result = call_580390.call(path_580391, query_580392, nil, nil, body_580393)

var monitoringProjectsNotificationChannelsVerify* = Call_MonitoringProjectsNotificationChannelsVerify_580373(
    name: "monitoringProjectsNotificationChannelsVerify",
    meth: HttpMethod.HttpPost, host: "monitoring.googleapis.com",
    route: "/v3/{name}:verify",
    validator: validate_MonitoringProjectsNotificationChannelsVerify_580374,
    base: "/", url: url_MonitoringProjectsNotificationChannelsVerify_580375,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsCreate_580415 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsUptimeCheckConfigsCreate_580417(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsCreate_580416(path: JsonNode;
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
  var valid_580418 = path.getOrDefault("parent")
  valid_580418 = validateParameter(valid_580418, JString, required = true,
                                 default = nil)
  if valid_580418 != nil:
    section.add "parent", valid_580418
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
  var valid_580419 = query.getOrDefault("key")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "key", valid_580419
  var valid_580420 = query.getOrDefault("prettyPrint")
  valid_580420 = validateParameter(valid_580420, JBool, required = false,
                                 default = newJBool(true))
  if valid_580420 != nil:
    section.add "prettyPrint", valid_580420
  var valid_580421 = query.getOrDefault("oauth_token")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "oauth_token", valid_580421
  var valid_580422 = query.getOrDefault("$.xgafv")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = newJString("1"))
  if valid_580422 != nil:
    section.add "$.xgafv", valid_580422
  var valid_580423 = query.getOrDefault("alt")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = newJString("json"))
  if valid_580423 != nil:
    section.add "alt", valid_580423
  var valid_580424 = query.getOrDefault("uploadType")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "uploadType", valid_580424
  var valid_580425 = query.getOrDefault("quotaUser")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "quotaUser", valid_580425
  var valid_580426 = query.getOrDefault("callback")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "callback", valid_580426
  var valid_580427 = query.getOrDefault("fields")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "fields", valid_580427
  var valid_580428 = query.getOrDefault("access_token")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "access_token", valid_580428
  var valid_580429 = query.getOrDefault("upload_protocol")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "upload_protocol", valid_580429
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

proc call*(call_580431: Call_MonitoringProjectsUptimeCheckConfigsCreate_580415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Uptime check configuration.
  ## 
  let valid = call_580431.validator(path, query, header, formData, body)
  let scheme = call_580431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580431.url(scheme.get, call_580431.host, call_580431.base,
                         call_580431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580431, url, valid)

proc call*(call_580432: Call_MonitoringProjectsUptimeCheckConfigsCreate_580415;
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
  var path_580433 = newJObject()
  var query_580434 = newJObject()
  var body_580435 = newJObject()
  add(query_580434, "key", newJString(key))
  add(query_580434, "prettyPrint", newJBool(prettyPrint))
  add(query_580434, "oauth_token", newJString(oauthToken))
  add(query_580434, "$.xgafv", newJString(Xgafv))
  add(query_580434, "alt", newJString(alt))
  add(query_580434, "uploadType", newJString(uploadType))
  add(query_580434, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580435 = body
  add(query_580434, "callback", newJString(callback))
  add(path_580433, "parent", newJString(parent))
  add(query_580434, "fields", newJString(fields))
  add(query_580434, "access_token", newJString(accessToken))
  add(query_580434, "upload_protocol", newJString(uploadProtocol))
  result = call_580432.call(path_580433, query_580434, nil, nil, body_580435)

var monitoringProjectsUptimeCheckConfigsCreate* = Call_MonitoringProjectsUptimeCheckConfigsCreate_580415(
    name: "monitoringProjectsUptimeCheckConfigsCreate", meth: HttpMethod.HttpPost,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsCreate_580416,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsCreate_580417,
    schemes: {Scheme.Https})
type
  Call_MonitoringProjectsUptimeCheckConfigsList_580394 = ref object of OpenApiRestCall_579373
proc url_MonitoringProjectsUptimeCheckConfigsList_580396(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_MonitoringProjectsUptimeCheckConfigsList_580395(path: JsonNode;
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
  var valid_580397 = path.getOrDefault("parent")
  valid_580397 = validateParameter(valid_580397, JString, required = true,
                                 default = nil)
  if valid_580397 != nil:
    section.add "parent", valid_580397
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
  var valid_580398 = query.getOrDefault("key")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "key", valid_580398
  var valid_580399 = query.getOrDefault("prettyPrint")
  valid_580399 = validateParameter(valid_580399, JBool, required = false,
                                 default = newJBool(true))
  if valid_580399 != nil:
    section.add "prettyPrint", valid_580399
  var valid_580400 = query.getOrDefault("oauth_token")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "oauth_token", valid_580400
  var valid_580401 = query.getOrDefault("$.xgafv")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = newJString("1"))
  if valid_580401 != nil:
    section.add "$.xgafv", valid_580401
  var valid_580402 = query.getOrDefault("pageSize")
  valid_580402 = validateParameter(valid_580402, JInt, required = false, default = nil)
  if valid_580402 != nil:
    section.add "pageSize", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("uploadType")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "uploadType", valid_580404
  var valid_580405 = query.getOrDefault("quotaUser")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "quotaUser", valid_580405
  var valid_580406 = query.getOrDefault("pageToken")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "pageToken", valid_580406
  var valid_580407 = query.getOrDefault("callback")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "callback", valid_580407
  var valid_580408 = query.getOrDefault("fields")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "fields", valid_580408
  var valid_580409 = query.getOrDefault("access_token")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "access_token", valid_580409
  var valid_580410 = query.getOrDefault("upload_protocol")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "upload_protocol", valid_580410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580411: Call_MonitoringProjectsUptimeCheckConfigsList_580394;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the existing valid Uptime check configurations for the project (leaving out any invalid configurations).
  ## 
  let valid = call_580411.validator(path, query, header, formData, body)
  let scheme = call_580411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580411.url(scheme.get, call_580411.host, call_580411.base,
                         call_580411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580411, url, valid)

proc call*(call_580412: Call_MonitoringProjectsUptimeCheckConfigsList_580394;
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
  var path_580413 = newJObject()
  var query_580414 = newJObject()
  add(query_580414, "key", newJString(key))
  add(query_580414, "prettyPrint", newJBool(prettyPrint))
  add(query_580414, "oauth_token", newJString(oauthToken))
  add(query_580414, "$.xgafv", newJString(Xgafv))
  add(query_580414, "pageSize", newJInt(pageSize))
  add(query_580414, "alt", newJString(alt))
  add(query_580414, "uploadType", newJString(uploadType))
  add(query_580414, "quotaUser", newJString(quotaUser))
  add(query_580414, "pageToken", newJString(pageToken))
  add(query_580414, "callback", newJString(callback))
  add(path_580413, "parent", newJString(parent))
  add(query_580414, "fields", newJString(fields))
  add(query_580414, "access_token", newJString(accessToken))
  add(query_580414, "upload_protocol", newJString(uploadProtocol))
  result = call_580412.call(path_580413, query_580414, nil, nil, nil)

var monitoringProjectsUptimeCheckConfigsList* = Call_MonitoringProjectsUptimeCheckConfigsList_580394(
    name: "monitoringProjectsUptimeCheckConfigsList", meth: HttpMethod.HttpGet,
    host: "monitoring.googleapis.com", route: "/v3/{parent}/uptimeCheckConfigs",
    validator: validate_MonitoringProjectsUptimeCheckConfigsList_580395,
    base: "/", url: url_MonitoringProjectsUptimeCheckConfigsList_580396,
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
